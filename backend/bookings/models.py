from django.db import models
from django.conf import settings


# Note: We use string references (e.g., 'users.Shipper') to avoid circular imports.

class Booking(models.Model):
    STATUS_CHOICES = (
        ('Pending', 'Pending'),
        ('Accepted', 'Accepted'),
        ('Picked_Up', 'Picked_Up'),
        ('In_Transit', 'In_Transit'),
        ('Delivered', 'Delivered'),
        ('Cancelled', 'Cancelled')
    )
    CARGO_TYPES = (
        ('Documents', 'Documents'),
        ('Electronics', 'Electronics'),
        ('Furniture', 'Furniture'),
        ('Food', 'Food'),
        ('Others', 'Others')
    )

    # The User who is posting the load
    shipper = models.ForeignKey('users.Shipper', on_delete=models.CASCADE)
    # The Carrier (Driver) who accepts the load
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE, null=True, blank=True)

    pickup_location = models.CharField(max_length=255)
    pickup_latitude = models.FloatField()
    pickup_longitude = models.FloatField()

    dropoff_location = models.CharField(max_length=255)
    dropoff_latitude = models.FloatField()
    dropoff_longitude = models.FloatField()

    cargo_type = models.CharField(max_length=20, choices=CARGO_TYPES)
    cargo_weight_kg = models.FloatField()

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    fare_amount = models.FloatField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Booking {self.id} - {self.cargo_type} ({self.status})"


class Shipment(models.Model):
    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('IN_TRANSIT', 'In Transit'),
        ('COMPLETED', 'Completed'),
    ]

    shipper = models.ForeignKey('users.Shipper', on_delete=models.CASCADE, related_name='shipments')
    origin = models.CharField(max_length=255)
    destination = models.CharField(max_length=255)
    cargo_type = models.CharField(max_length=100)
    weight = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='PENDING')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.cargo_type} from {self.origin} to {self.destination}"


class Bid(models.Model):
    STATUS_CHOICES = (
        ('Pending', 'Pending'),
        ('Accepted', 'Accepted'),
        ('Declined', 'Declined'),
    )

    booking = models.ForeignKey('Booking', on_delete=models.CASCADE, related_name='bids')
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE, related_name='bids')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    message = models.CharField(max_length=255, blank=True)
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='Pending')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']
        unique_together = ('booking', 'carrier')

    def __str__(self):
        return f"Bid {self.id} on booking {self.booking_id} by {self.carrier_id}"


class LocationTracking(models.Model):
    booking = models.ForeignKey('Booking', on_delete=models.CASCADE)
    carrier = models.ForeignKey('users.Carrier', on_delete=models.CASCADE)
    latitude = models.FloatField()
    longitude = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)


class Dispute(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)
    # We use settings.AUTH_USER_MODEL for the general User reference
    raised_by = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='disputes_raised')
    dispute_status = models.CharField(max_length=20, default='Open')
    resolved_by = models.ForeignKey('users.AdminProfile', on_delete=models.SET_NULL, null=True)
