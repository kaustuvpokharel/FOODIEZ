from django.test import TestCase
from django.urls import reverse
from django.conf import settings
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model
from rest_framework import status
import os

User = get_user_model()


class UserAuthTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.register_url = reverse('user-register')
        self.login_url = reverse('token_obtain_pair')
        self.refresh_url = reverse('token_refresh')
        self.profile_url = reverse('user_profile')

        self.user_data = {
            "username": "testuser",
            "email": "testuser@example.com",
            "password": "TestPass123",
            "bio": "Just a foodie!",
            "location": "Toronto",
            "website": "https://testsite.com"
        }

        self.user = User.objects.create_user(
            username=self.user_data["username"],
            email=self.user_data["email"],
            password=self.user_data["password"]
        )

    def test_register_user_without_profile_picture(self):
        data = self.user_data.copy()
        data["username"] = "newuser"
        data["email"] = "newuser@example.com"
        response = self.client.post(self.register_url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn("user", response.data)
        self.assertEqual(response.data["user"]["username"], "newuser")

    def test_login_with_username(self):
        response = self.client.post(self.login_url, {
            "username": self.user_data["username"],
            "password": self.user_data["password"]
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("access", response.data)
        self.access_token = response.data["access"]

    def test_login_with_email(self):
        response = self.client.post(self.login_url, {
            "username": self.user_data["email"],
            "password": self.user_data["password"]
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("access", response.data)
        self.access_token = response.data["access"]

    def test_token_refresh(self):
        login_response = self.client.post(self.login_url, {
            "username": self.user_data["email"],
            "password": self.user_data["password"]
        }, format='json')
        refresh_token = login_response.data["refresh"]

        response = self.client.post(self.refresh_url, {
            "refresh": refresh_token
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("access", response.data)

    def test_access_user_profile(self):
        login_response = self.client.post(self.login_url, {
            "username": self.user_data["username"],
            "password": self.user_data["password"]
        }, format='json')
        access_token = login_response.data["access"]

        self.client.credentials(HTTP_AUTHORIZATION=f'Bearer {access_token}')
        response = self.client.get(self.profile_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data["username"], self.user_data["username"])
