from rest_framework import serializers
from django.contrib.auth import get_user_model
from django.db import transaction
from .models import Carrier  # Ensure Carrier is defined in your models.py

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'phone', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    # Preserving your phone validation logic
    def validate_phone(self, value):
        if User.objects.filter(phone=value).exists():
            raise serializers.ValidationError("A user with this phone number already exists.")
        return value

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class CarrierRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    # Adding Carrier-specific fields that are not in the User model
    license_number = serializers.CharField(required=True)
    vehicle_type = serializers.CharField(required=True)

    class Meta:
        model = User
        # Combined fields for both User and Carrier profile
        fields = ['username', 'email', 'phone', 'password', 'first_name', 'last_name', 'license_number', 'vehicle_type']
        extra_kwargs = {'password': {'write_only': True}}

    # Inherit the phone validation from the logic above
    def validate_phone(self, value):
        if User.objects.filter(phone=value).exists():
            raise serializers.ValidationError("A user with this phone number already exists.")
        return value

    def create(self, validated_data):
        # 1. Extract the Carrier-specific fields
        license_number = validated_data.pop('license_number')
        vehicle_type = validated_data.pop('vehicle_type')

        # 2. Use an atomic transaction to ensure both User and Carrier are created together
        with transaction.atomic():
            # Create the User account
            user = User.objects.create_user(
                username=validated_data['username'],
                email=validated_data.get('email', ''),
                phone=validated_data.get('phone', ''),
                password=validated_data['password'],
                first_name=validated_data.get('first_name', ''),
                last_name=validated_data.get('last_name', ''),
            )

            # Create the Carrier profile linked to that User
            Carrier.objects.create(
                user=user,
                license_number=license_number,
                vehicle_type=vehicle_type
            )

        return user