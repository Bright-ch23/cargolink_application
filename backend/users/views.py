from django.contrib.auth import authenticate, get_user_model
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from .serializers import UserSerializer, CarrierRegistrationSerializer

User = get_user_model()

# --- CARRIER REGISTRATION ---
class CarrierRegisterView(APIView):
    """
    Handles Carrier registration by creating both a User and a Carrier profile.
    """
    # Fix: Disable authentication checks so new users can access without a token
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = CarrierRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            return Response({
                "message": "Carrier registered successfully",
                "refresh": str(refresh),
                "access": str(refresh.access_token),
                "user": {
                    "username": user.username,
                    "role": "carrier"
                }
            }, status=status.HTTP_201_CREATED)

        print(f"Carrier Registration Errors: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# --- GENERAL/SHIPPER REGISTRATION ---
class RegisterView(APIView):
    """
    Handles standard user (Shipper) registration using the UserSerializer.
    """
    # Fix: Disable authentication checks
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            refresh = RefreshToken.for_user(user)
            return Response({
                "message": "User registered successfully",
                "refresh": str(refresh),
                "access": str(refresh.access_token),
                "user": {
                    "username": user.username,
                    "email": user.email,
                }
            }, status=status.HTTP_201_CREATED)

        print(f"Shipper Registration Errors: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# --- LOGIN VIEW ---
class LoginView(APIView):
    """
    Handles login for all users and returns their role.
    """
    # Fix: Disable authentication checks
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        user = authenticate(username=username, password=password)

        if user:
            refresh = RefreshToken.for_user(user)
            # Determine role for Flutter routing
            role = 'carrier' if hasattr(user, 'carrier') else 'shipper'

            return Response({
                "refresh": str(refresh),
                "access": str(refresh.access_token),
                "user_id": user.pk,
                "username": user.username,
                "role": role
            }, status=status.HTTP_200_OK)

        return Response({"error": "Invalid Credentials"}, status=status.HTTP_401_UNAUTHORIZED)