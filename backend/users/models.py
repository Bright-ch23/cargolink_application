from django.db import models
from django.contrib.auth.models import AbstractUser
from django.contrib.auth.models import BaseUserManager
from django.core.validators import MinValueValidator, MaxValueValidator


# --- A. USER MANAGEMENT ---

class User(AbstractUser):
    USER_TYPES = (
        ('Shipper', 'Shipper'),
        ('Carrier', 'Carrier'),
        ('Admin', 'Admin'),
    )
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=20, unique=True)
    user_type = models.CharField(max_length=10, choices=USER_TYPES)
    is_email_verified = models.BooleanField(default=False)
    average_rating = models.FloatField(default=0)
    total_ratings = models.IntegerField(default=0)


class Shipper(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    full_name = models.CharField(max_length=255)
    address = models.TextField(null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    state = models.CharField(max_length=100, null=True, blank=True)
    country = models.CharField(max_length=100, default='Cameroon')
    payment_method_id = models.CharField(max_length=255, null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


class Carrier(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    full_name = models.CharField(max_length=255)
    license_number = models.CharField(max_length=100, unique=True)
    is_verified = models.BooleanField(default=False)
    is_available = models.BooleanField(default=False)
    current_latitude = models.FloatField(null=True, blank=True)
    current_longitude = models.FloatField(null=True, blank=True)
    last_location_update = models.DateTimeField(null=True, blank=True)
    total_earnings = models.FloatField(default=0)
    completed_jobs = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)


class AdminProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True)
    admin_name = models.CharField(max_length=255)
    role = models.CharField(max_length=50, choices=(('Super_Admin', 'Super_Admin'), ('Moderator', 'Moderator'),
                                                    ('Support', 'Support')))
    created_at = models.DateTimeField(auto_now_add=True)


class CarrierProfile(models.Model):
    VEHICLE_TYPES = (('Bike', 'Bike'), ('Van', 'Van'), ('Pickup', 'Pickup'), ('Small_Truck', 'Small_Truck'),
                     ('Large_Truck', 'Large_Truck'))
    carrier = models.OneToOneField(Carrier, on_delete=models.CASCADE)
    vehicle_type = models.CharField(max_length=20, choices=VEHICLE_TYPES)
    vehicle_capacity_kg = models.FloatField()
    registration_no = models.CharField(max_length=50, unique=True)
    vehicle_make = models.CharField(max_length=100, null=True)
    vehicle_model = models.CharField(max_length=100, null=True)
    insurance_document = models.TextField(null=True)  # URL
    verified_by = models.ForeignKey(AdminProfile, on_delete=models.SET_NULL, null=True)

class UserManager(BaseUserManager):
        def create_user(self, email, password=None, **extra_fields):
            if not email:
                raise ValueError("Email is required")

            email = self.normalize_email(email)
            user = self.model(email=email, **extra_fields)
            user.set_password(password)
            user.save()
            return user

        def create_superuser(self, email, password):
            user = self.create_user(email=email, password=password)
            user.is_staff = True
            user.is_superuser = True
            user.save()
            return user


class Booking:
    pass


def payments():
    return None


def ratings():
    return None


class Transaction:
    pass


class Rating:
    pass


class LocationTracking:
    pass


class Dispute:
    pass