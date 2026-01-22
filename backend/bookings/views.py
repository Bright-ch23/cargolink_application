from django.db.models import Sum, Count
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.exceptions import ValidationError
from .models import Booking, LocationTracking, Dispute
from .serializers import BookingSerializer
from django.shortcuts import get_object_or_404


class BookingViewSet(viewsets.ModelViewSet):
    """
    Handles Posting a Load (Booking), viewing history, and updating status.
    """
    queryset = Booking.objects.all().order_by('-created_at')
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if hasattr(user, 'shipper'):
            return Booking.objects.filter(shipper=user.shipper)
        if hasattr(user, 'carrier'):
            return Booking.objects.filter(carrier=user.carrier)
        return super().get_queryset()

    def perform_create(self, serializer):
        # Using the safety check we discussed
        if hasattr(self.request.user, 'shipper'):
            serializer.save(shipper=self.request.user.shipper)
        else:
            raise ValidationError("Only users with a Shipper profile can post loads.")

    @action(detail=False, methods=['get'], url_path='summary')
    def summary(self, request):
        user = request.user
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