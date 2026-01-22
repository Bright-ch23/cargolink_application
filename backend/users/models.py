from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.core.validators import MinValueValidator, MaxValueValidator

# --- 1. USER MANAGER ---
class UserManager(BaseUserManager):
    def create_user(self, username, email, password=None, **extra_fields):
        if not email:
            raise ValueError("Email is required")
        email = self.normalize_email(email)
        user = self.model(username=username, email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        extra_fields.setdefault('user_type', 'Admin')
        return self.create_user(username, email, password, **extra_fields)

# --- 2. USER MODEL ---
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

    objects = UserManager() # Link the manager

# --- 3. PROFILES ---

class Shipper(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, related_name='shipper')
    full_name = models.CharField(max_length=255)
    address = models.TextField(null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    country = models.CharField(max_length=100, default='Cameroon')
    created_at = models.DateTimeField(auto_now_add=True)

class Carrier(models.Model):
    VEHICLE_TYPES = (
        ('Bike', 'Bike'), ('Van', 'Van'), ('Pickup', 'Pickup'),
        ('Small_Truck', 'Small_Truck'), ('Large_Truck', 'Large_Truck')
    )
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='carrier')
    vehicle_type = models.CharField(max_length=50)  # This is the missing column!
    plate_number = models.CharField(max_length=20)
    is_verified = models.BooleanField(default=False)
    is_available = models.BooleanField(default=False)
    total_earnings = models.FloatField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)

# In D:\Cargolink_App\backend\users\models.py

class AdminProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, primary_key=True, related_name='admin_profile')
    admin_name = models.CharField(max_length=255)
    role = models.CharField(max_length=50, choices=(
        ('Super_Admin', 'Super_Admin'),
        ('Moderator', 'Moderator'),
        ('Support', 'Support')
    ))
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.admin_name