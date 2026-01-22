from django.contrib.auth.models import User
from django.core.validators import MinValueValidator, MaxValueValidator
from django.db import models

from bookings.models import Booking
from cargolink_backend import settings


class Rating(models.Model):
    booking = models.ForeignKey(Booking, on_delete=models.CASCADE)

    class Rating(models.Model):
        # Change from 'User' to settings.AUTH_USER_MODEL
        from_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='ratings_given')
        to_user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='ratings_received')
    score = models.IntegerField(validators=[MinValueValidator(1), MaxValueValidator(5)])
    review_text = models.TextField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)


def ratings():
    return None


def payments():
    return None


class Carrier:
    pass


class Shipper:
    pass