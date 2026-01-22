from django.db import models
from django.conf import settings


class Booking(models.Model):
    STATUS_CHOICES = (
        ('Pending', 'Pending'),
        ('Accepted', 'Accepted'),
        ('Picked_Up', 'Picked_Up'),
        ('In_Transit', 'In_Transit'),
        ('Delivered', 'Delivered'),
        ('Cancelled', 'Cancelled'),
    )

    # Relationships
    shipper = models.ForeignKey('users.Shipper', on_delete=models.CASCADE, related_name='bookings_as_shipper')
    carrier = models.ForeignKey('users.Carrier', on_delete=models.SET_NULL, null=True, blank=True,
                                related_name='trips_as_carrier')

    # Core Data Fields (Required by your Views and Flutter Screens)
    pickup_location = models.CharField(max_length=255)
    dropoff_location = models.CharField(max_length=255)
    description = models.TextField(null=True, blank=True)
    weight_kg = models.FloatField(default=0.0)

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    fare_amount = models.FloatField(default=0.0)

    # Timestamp (Required for ordering in BookingViewSet)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"Load {self.id} - {self.shipper.full_name if self.shipper else 'Unknown'}"


class LocationTracking(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='tracking_logs')
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE, related_name='location_updates')
    latitude = models.FloatField()
    longitude = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Location Tracking"


# In D:\Cargolink_App\backend\bookings\models.py

class Dispute(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE, related_name='booking_disputes')
    raised_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='disputes_raised')
    reason = models.TextField()
    is_resolved = models.BooleanField(default=False)

    # Use this exact string format to resolve the E300/E307 error
    resolved_by = models.ForeignKey(
        'users.AdminProfile',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='resolved_disputes'
    )
    created_at = models.DateTimeField(auto_now_add=True)