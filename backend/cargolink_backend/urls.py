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

from bookings.views import BookingViewSet
from users.views import CarrierRegisterView, LoginView, RegisterView
from rest_framework_simplejwt.views import TokenRefreshView

router = DefaultRouter()
# I changed the prefix to 'bookings' to avoid confusion with the main 'api/' path
router.register(r'bookings', BookingViewSet, basename='booking')

urlpatterns = [
    path('admin/', admin.site.urls),

    # --- 1. PUBLIC ENDPOINTS (Check these first) ---
    path('api/register/', RegisterView.as_view(), name='register'),
    path('api/register/carrier/', CarrierRegisterView.as_view(), name='carrier_register'),
    path('api/login/', LoginView.as_view(), name='login'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # --- 2. PRIVATE/ROUTED ENDPOINTS ---
    # This will now serve endpoints at /api/bookings/
    path('api/', include(router.urls)),
]