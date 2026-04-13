from django.db.models import Sum, Count
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from rest_framework.views import APIView
from .models import Booking, LocationTracking, Dispute, Shipment, Bid
from .serializers import BookingSerializer, ShipmentSerializer, BidSerializer
from django.shortcuts import get_object_or_404
from users.views import ensure_user_profile


class BookingViewSet(viewsets.ModelViewSet):
    """
    Handles Posting a Load (Booking), viewing history, and updating status.
    """
    queryset = Booking.objects.all().order_by('-created_at')
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        ensure_user_profile(user)
        if hasattr(user, 'shipper'):
            return Booking.objects.filter(shipper=user.shipper).order_by('-created_at')
        if hasattr(user, 'carrier'):
            return Booking.objects.filter(carrier=user.carrier).order_by('-created_at')
        return super().get_queryset()

    def perform_create(self, serializer):
        # Using the safety check we discussed
        ensure_user_profile(self.request.user)
        if hasattr(self.request.user, 'shipper'):
            serializer.save(shipper=self.request.user.shipper)
        else:
            raise ValidationError("Only users with a Shipper profile can post loads.")

    @action(detail=False, methods=['get'], url_path='available')
    def available(self, request):
        ensure_user_profile(request.user)
        if not hasattr(request.user, 'carrier'):
            raise ValidationError("Only users with a Carrier profile can view available loads.")

        queryset = Booking.objects.filter(status='Pending', carrier__isnull=True).order_by('-created_at')
        serializer = self.get_serializer(queryset, many=True)
        return Response(serializer.data)

    @action(detail=False, methods=['get'], url_path='summary')
    def summary(self, request):
        user = request.user
        ensure_user_profile(user)
        if hasattr(user, 'shipper'):
            return Response({
                "total_posted": Booking.objects.filter(shipper=user.shipper).count(),
                "active_loads": Booking.objects.filter(
                    shipper=user.shipper,
                    status__in=['Accepted', 'Picked_Up', 'In_Transit']
                ).count(),
                "completed": Booking.objects.filter(shipper=user.shipper, status='Delivered').count(),
                "total_spent": Booking.objects.filter(
                    shipper=user.shipper, status='Delivered'
                ).aggregate(Sum('fare_amount'))['fare_amount__sum'] or 0
            })
        elif hasattr(user, 'carrier'):
            return Response({
                "active_deliveries": Booking.objects.filter(carrier=user.carrier, status='In_Transit').count(),
                "completed_deliveries": Booking.objects.filter(carrier=user.carrier, status='Delivered').count(),
                "total_earnings": Booking.objects.filter(
                    carrier=user.carrier, status='Delivered'
                ).aggregate(Sum('fare_amount'))['fare_amount__sum'] or 0,
                "pending_offers": Booking.objects.filter(status='Pending').count()
            })
        return Response({"error": "User profile not found"}, status=status.HTTP_404_NOT_FOUND)

    # --- ADDED THIS FOR THE TRACKER SCREEN ---
    @action(detail=True, methods=['get'], url_path='track')
    def track_booking(self, request, pk=None):
        """
        Endpoint: GET /api/bookings/{id}/track/
        Returns the latest location of the driver for this specific booking.
        """
        booking = self.get_object()

        # Look for the most recent location update linked to this booking
        latest_location = LocationTracking.objects.filter(booking=booking).order_by('-timestamp').first()

        if not latest_location:
            return Response({"error": "No tracking data available for this shipment"}, status=404)

        return Response({
            "driver_name": booking.carrier.user.username if booking.carrier else "Waiting for Driver",
            "vehicle": "Freight Truck",
            "lat": latest_location.latitude,
            "lng": latest_location.longitude,
            "status": booking.status,
            "last_updated": latest_location.timestamp
        })

    @action(detail=True, methods=['get'], url_path='bids')
    def bids(self, request, pk=None):
        ensure_user_profile(request.user)
        booking = self.get_object()

        if hasattr(request.user, 'shipper') and booking.shipper != request.user.shipper:
            return Response({"error": "You do not have access to these bids."}, status=status.HTTP_403_FORBIDDEN)
        if hasattr(request.user, 'carrier'):
            return Response({"error": "Only shippers can view incoming bids for a load."}, status=status.HTTP_403_FORBIDDEN)

        serializer = BidSerializer(booking.bids.select_related('carrier__user'), many=True)
        return Response(serializer.data)


class ShipmentViewSet(viewsets.ModelViewSet):
    serializer_class = ShipmentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        ensure_user_profile(self.request.user)
        if hasattr(self.request.user, 'shipper'):
            return Shipment.objects.filter(shipper=self.request.user.shipper).order_by('-created_at')
        return Shipment.objects.none()

    def perform_create(self, serializer):
        ensure_user_profile(self.request.user)
        if hasattr(self.request.user, 'shipper'):
            serializer.save(shipper=self.request.user.shipper)
        else:
            raise ValidationError("Only users with a Shipper profile can create shipments.")


class BidViewSet(viewsets.ModelViewSet):
    serializer_class = BidSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        ensure_user_profile(self.request.user)
        if hasattr(self.request.user, 'carrier'):
            return Bid.objects.filter(carrier=self.request.user.carrier).select_related('booking', 'carrier__user')
        if hasattr(self.request.user, 'shipper'):
            return Bid.objects.filter(booking__shipper=self.request.user.shipper).select_related('booking', 'carrier__user')
        return Bid.objects.none()

    def perform_create(self, serializer):
        ensure_user_profile(self.request.user)
        if not hasattr(self.request.user, 'carrier'):
            raise ValidationError("Only users with a Carrier profile can place bids.")

        booking = serializer.validated_data['booking']
        if booking.status != 'Pending' or booking.carrier_id is not None:
            raise ValidationError("Bids can only be placed on pending, unassigned loads.")

        serializer.save(carrier=self.request.user.carrier)

    @action(detail=True, methods=['patch'], url_path='respond')
    def respond(self, request, pk=None):
        ensure_user_profile(request.user)
        bid = self.get_object()

        if not hasattr(request.user, 'shipper') or bid.booking.shipper != request.user.shipper:
            return Response({"error": "Only the shipper who posted this load can respond to bids."}, status=status.HTTP_403_FORBIDDEN)

        action_type = request.data.get('action')
        if action_type not in {'accept', 'decline'}:
            raise ValidationError("action must be 'accept' or 'decline'.")

        if action_type == 'accept':
            bid.status = 'Accepted'
            bid.save(update_fields=['status'])
            bid.booking.carrier = bid.carrier
            bid.booking.status = 'Accepted'
            bid.booking.save(update_fields=['carrier', 'status'])
            Bid.objects.filter(booking=bid.booking).exclude(pk=bid.pk).update(status='Declined')
        else:
            bid.status = 'Declined'
            bid.save(update_fields=['status'])

        return Response(BidSerializer(bid).data)


class BookingSummaryView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        user = request.user
        ensure_user_profile(user)

        if hasattr(user, 'shipper'):
            return Response({
                "total_posted": Booking.objects.filter(shipper=user.shipper).count(),
                "active_loads": Booking.objects.filter(
                    shipper=user.shipper,
                    status__in=['Accepted', 'Picked_Up', 'In_Transit']
                ).count(),
                "completed": Booking.objects.filter(shipper=user.shipper, status='Delivered').count(),
                "total_spent": Booking.objects.filter(
                    shipper=user.shipper, status='Delivered'
                ).aggregate(Sum('fare_amount'))['fare_amount__sum'] or 0
            })

        if hasattr(user, 'carrier'):
            return Response({
                "active_deliveries": Booking.objects.filter(carrier=user.carrier, status='In_Transit').count(),
                "completed_deliveries": Booking.objects.filter(carrier=user.carrier, status='Delivered').count(),
                "total_earnings": Booking.objects.filter(
                    carrier=user.carrier, status='Delivered'
                ).aggregate(Sum('fare_amount'))['fare_amount__sum'] or 0,
                "pending_offers": Booking.objects.filter(status='Pending').count()
            })

        return Response({"error": "User profile not found"}, status=status.HTTP_404_NOT_FOUND)


class LocationTrackingViewSet(viewsets.ModelViewSet):
    queryset = LocationTracking.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        # Automatically link the tracking update to the carrier's profile
        serializer.save(carrier=self.request.user.carrier)


class DisputeViewSet(viewsets.ModelViewSet):
    queryset = Dispute.objects.all()
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(raised_by=self.request.user)
