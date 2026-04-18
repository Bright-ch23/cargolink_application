"""
URL configuration for cargolink_backend project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/6.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""


from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import (
    TokenRefreshView,
)
from users.views import RegisterView, LoginView
from rest_framework.routers import DefaultRouter
from bookings.views import BookingViewSet, ShipmentViewSet, BookingSummaryView, BidViewSet  # Cleaned up double import

# 1. Setup Router for ViewSets
router = DefaultRouter()
# The 'bookings' string below defines the /api/bookings/ path
router.register(r'bookings', BookingViewSet, basename='booking')
router.register(r'shipments', ShipmentViewSet, basename='shipment')
router.register(r'bids', BidViewSet, basename='bid')

urlpatterns = [
    # Admin Interface
    path('admin/', admin.site.urls),

    path('api/bookings/summary/', BookingSummaryView.as_view(), name='booking-summary'),

    # API ViewSets (This will include /api/bookings/ and /api/bookings/summary/)
    path('api/', include(router.urls)),

    # Authentication Endpoints
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
