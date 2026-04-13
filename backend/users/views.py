from django.contrib.auth import authenticate, get_user_model
from django.db import transaction
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework.permissions import AllowAny
from rest_framework_simplejwt.tokens import RefreshToken
from .models import Shipper, Carrier, AdminProfile

User = get_user_model()


def ensure_user_profile(user):
    if not user.user_type:
        user.user_type = 'Shipper'
        user.save(update_fields=['user_type'])

    if user.user_type == 'Shipper':
        Shipper.objects.get_or_create(
            user=user,
            defaults={'full_name': user.username},
        )
    elif user.user_type == 'Carrier':
        Carrier.objects.get_or_create(
            user=user,
            defaults={
                'full_name': user.username,
                'license_number': f"LIC-{user.username}-{user.pk}",
            },
        )
    elif user.user_type == 'Admin':
        AdminProfile.objects.get_or_create(
            user=user,
            defaults={
                'admin_name': user.username,
                'role': 'Support',
            },
        )


class RegisterView(APIView):
    permission_classes = [AllowAny]  # FIX: allow unauthenticated access (was causing 401)

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email')
        phone = request.data.get('phone')
        user_type = request.data.get('user_type', 'Shipper')

        if not username or not password or not email or not phone:
            return Response(
                {"error": "Username, password, email, and phone are required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        if User.objects.filter(username=username).exists():
            return Response(
                {"error": "Username already exists"},
                status=status.HTTP_400_BAD_REQUEST
            )

        if User.objects.filter(email=email).exists():
            return Response(
                {"error": "Email already exists"},
                status=status.HTTP_400_BAD_REQUEST
            )

        if User.objects.filter(phone=phone).exists():
            return Response(
                {"error": "Phone number already exists"},
                status=status.HTTP_400_BAD_REQUEST
            )

        valid_user_types = {choice[0] for choice in User.USER_TYPES}
        if user_type not in valid_user_types:
            return Response(
                {"error": f"user_type must be one of: {', '.join(valid_user_types)}"},
                status=status.HTTP_400_BAD_REQUEST
            )

        with transaction.atomic():
            user = User.objects.create_user(
                username=username,
                email=email,
                password=password,
                phone=phone,
                user_type=user_type,
            )

            ensure_user_profile(user)

        refresh = RefreshToken.for_user(user)
        access_token = str(refresh.access_token)

        return Response({
            "message": "User registered successfully",
            "refresh": str(refresh),
            "access": access_token,
            "token": access_token,
            "username": user.username,
            "user_id": user.pk,
            "user": {
                "username": user.username,
                "email": user.email,
                "user_type": user.user_type,
            }
        }, status=status.HTTP_201_CREATED)


class LoginView(APIView):
    permission_classes = [AllowAny]  # FIX: allow unauthenticated access (was causing 400)

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        if not username or not password:  # FIX: guard against missing fields early
            return Response(
                {"error": "Username and password required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        user = authenticate(username=username, password=password)

        if user:
            ensure_user_profile(user)
            refresh = RefreshToken.for_user(user)
            access_token = str(refresh.access_token)
            return Response({
                "refresh": str(refresh),
                "access": access_token,
                "token": access_token,
                "user_id": user.pk,
                "username": user.username,
                "user_type": user.user_type,
            }, status=status.HTTP_200_OK)
        else:
            return Response(
                {"error": "Invalid credentials"},
                status=status.HTTP_401_UNAUTHORIZED
            )
            # NOTE: removed dead code that existed after this return statement
