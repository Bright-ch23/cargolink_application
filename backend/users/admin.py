from django.contrib import admin
from .models import User, Shipper, Carrier

admin.site.register(User)
admin.site.register(Shipper)
admin.site.register(Carrier)

