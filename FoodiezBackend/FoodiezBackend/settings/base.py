import os
from datetime import timedelta
from pathlib import Path

import environ

# Load environment variables from .env file
env = environ.Env(
    DEVELOPMENT=(bool, False)  # Default DEVELOPMENT to False
)

# Read .env file
environ.Env.read_env(os.path.join(Path(__file__).resolve().parent.parent.parent, ".env"))

# Base directory
BASE_DIR = Path(__file__).resolve().parent.parent.parent

# Development mode flag
DEVELOPMENT = env("DEVELOPMENT")
# Secret key
SECRET_KEY = env("SECRET_KEY")

# Allowed hosts
ALLOWED_HOSTS = env.list("ALLOWED_HOSTS", default=["localhost", "127.0.0.1"])

# Installed apps
INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    'rest_framework',
    'rest_framework_simplejwt',
    'rest_framework_simplejwt.token_blacklist',
    "corsheaders",
    "channels"

    "user",
    "post",
]

MIDDLEWARE = [
    "django.middleware.security.SecurityMiddleware",
    "django.contrib.sessions.middleware.SessionMiddleware",
    "django.middleware.common.CommonMiddleware",
    "django.middleware.csrf.CsrfViewMiddleware",
    "django.contrib.auth.middleware.AuthenticationMiddleware",
    "django.contrib.messages.middleware.MessageMiddleware",
    "django.middleware.clickjacking.XFrameOptionsMiddleware",
]

ROOT_URLCONF = "FoodiezBackend.urls"
WSGI_APPLICATION = "FoodiezBackend.wsgi.application"

ASGI_APPLICATION = 'FoodiezBackend.asgi.application'

TEMPLATES = [
    {
        "BACKEND": "django.template.backends.django.DjangoTemplates",
        "DIRS": [],
        "APP_DIRS": True,
        "OPTIONS": {
            "context_processors": [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

AUTHENTICATION_BACKENDS = [
    'user.authentication.UsernameOrEmailBackend',
    'django.contrib.auth.backends.ModelBackend',
]

# Media setup (ensure this exists)
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

# Default profile picture path
DEFAULT_PROFILE_PICTURE = 'profile_pics/default.png'

STATIC_URL = "/static/"

AUTH_USER_MODEL = "user.User"

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
}

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=30),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    # 'ROTATE_REFRESH_TOKENS': True,
    # 'BLACKLIST_AFTER_ROTATION': True,
    'AUTH_HEADER_TYPES': ('Bearer',),
}
