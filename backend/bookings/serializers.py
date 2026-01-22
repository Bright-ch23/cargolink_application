from rest_framework import serializers
from .models import Booking

class BookingSerializer(serializers.ModelSerializer):
    shipper_name = serializers.ReadOnlyField(source='shipper.user.username')
    carrier_name = serializers.ReadOnlyField(source='carrier.user.username')

    class Meta:
        model = Booking
        fields = '__all__'
        # These are set automatically by the backend
        read_only_fields = ('shipper', 'carrier', 'status', 'created_at')