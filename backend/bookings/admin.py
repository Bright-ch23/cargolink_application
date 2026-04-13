from django.contrib import admin
from .models import Booking, LocationTracking, Shipment, Bid

admin.site.register(Booking)
admin.site.register(LocationTracking)
admin.site.register(Shipment)
admin.site.register(Bid)
