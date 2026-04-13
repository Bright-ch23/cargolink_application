from rest_framework import serializers
from .models import Booking, Shipment, Bid

class BookingSerializer(serializers.ModelSerializer):
    shipper_name = serializers.ReadOnlyField(source='shipper.user.username')
    carrier_name = serializers.ReadOnlyField(source='carrier.user.username')

    class Meta:
        model = Booking
        fields = '__all__'
        # These are set automatically by the backend
        read_only_fields = ('shipper', 'carrier', 'status', 'created_at')


class ShipmentSerializer(serializers.ModelSerializer):
    shipper = serializers.ReadOnlyField(source='shipper.user.username')

    class Meta:
        model = Shipment
        fields = ['id', 'shipper', 'origin', 'destination', 'cargo_type', 'weight', 'status', 'created_at']


class BidSerializer(serializers.ModelSerializer):
    carrier_name = serializers.ReadOnlyField(source='carrier.user.username')
    booking_id = serializers.ReadOnlyField(source='booking.id')

    class Meta:
        model = Bid
        fields = ['id', 'booking', 'booking_id', 'carrier', 'carrier_name', 'amount', 'message', 'status', 'created_at']
        read_only_fields = ('carrier', 'status', 'created_at')
