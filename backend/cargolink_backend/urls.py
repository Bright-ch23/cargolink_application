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
    TokenObtainPairView,
    TokenRefreshView,
)
from users.views import RegisterView
from rest_framework.routers import DefaultRouter
from bookings.views import BookingViewSet  # Cleaned up double import

# 1. Setup Router for ViewSets
router = DefaultRouter()
# The 'bookings' string below defines the /api/bookings/ path
router.register(r'bookings', BookingViewSet, basename='booking')

urlpatterns = [
    # Admin Interface
    path('admin/', admin.site.urls),

    # API ViewSets (This will include /api/bookings/ and /api/bookings/summary/)
    path('api/', include(router.urls)),

    # Authentication Endpoints
    path('api/register/', RegisterView.as_view(), name='register'),
    # Note: Ensure your Flutter app uses 'Bearer' prefix for this login
    path('api/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]