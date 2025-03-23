from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import serializers

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'bio', 'profile_picture', 'location', 'website', 'slug']


from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.contrib.auth import authenticate
from rest_framework import serializers


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    username_field = 'username'  # Still required by parent class

    def validate(self, attrs):
        username_or_email = attrs.get('username')
        password = attrs.get('password')

        user: User = authenticate(username=username_or_email, password=password)

        if user is None:
            raise serializers.ValidationError('Invalid credentials')

        data = super().validate({
            'username': user.username,  # NOQA
            'password': password
        })

        data['user'] = {  # NOQA
            'id': user.id,
            'username': user.username,  # NOQA
            'email': user.email,  # NOQA
            'is_verified': user.is_verified  # NOQA
        }

        return data


class RegisterUserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'bio', 'location', 'website', 'profile_picture']

    def create(self, validated_data):
        profile_picture = validated_data.get('profile_picture')
        if not profile_picture:
            validated_data['profile_picture'] = settings.DEFAULT_PROFILE_PICTURE

        user = User.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            bio=validated_data.get('bio', ''),
            location=validated_data.get('location', ''),
            website=validated_data.get('website', ''),
            profile_picture=validated_data['profile_picture'],
        )
        return user
