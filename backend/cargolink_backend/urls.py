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
from rest_framework.routers import DefaultRouter

# Import your ViewSets
from bookings.views import BookingViewSet

# Import your merged User Views
from users.views import (
    RegisterView,
    CarrierRegisterView,
    LoginView
)

# Import SimpleJWT views for token refreshing
from rest_framework_simplejwt.views import TokenRefreshView

# 1. Setup Router for ViewSets (Bookings, Tracking, etc.)
router = DefaultRouter()
router.register(r'', BookingViewSet, basename='booking')

urlpatterns = [
    # --- Admin Interface ---
    path('admin/', admin.site.urls),

    # --- API ViewSets ---
    # This covers /api/bookings/ and /api/bookings/summary/
    path('api/', include(router.urls)),

    # --- Authentication & User Management ---

    # Standard/Shipper Registration: /api/register/
    path('api/register/', RegisterView.as_view(), name='register'),

    # Carrier Specific Registration: /api/register/carrier/
    path('api/register/carrier/', CarrierRegisterView.as_view(), name='carrier_register'),

    # Unified Login: /api/login/
    # This now uses your custom LoginView which returns the user 'role'
    path('api/login/', LoginView.as_view(), name='login'),

    # JWT Token Refresh: /api/token/refresh/
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]