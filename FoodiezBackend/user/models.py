from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils.text import slugify


class Cuisine(models.Model):
    """Represents a type of cuisine (e.g., Italian, Japanese, Indian)."""
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class Dish(models.Model):
    """Represents a dish that users can mark as their favorite."""
    name = models.CharField(max_length=100, unique=True)
    cuisine = models.ForeignKey(Cuisine, on_delete=models.CASCADE, related_name="dishes")

    def __str__(self):
        return self.name


class DietaryPreference(models.Model):
    """Represents a dietary preference (e.g., Vegan, Halal, Keto)."""
    name = models.CharField(max_length=50, unique=True)

    def __str__(self):
        return self.name


class User(AbstractUser):
    """Custom User model for the Foodie Social Media App."""

    # Additional User fields
    bio = models.TextField(blank=True, null=True, help_text="Short bio about the user.")
    profile_picture = models.ImageField(upload_to="profile_pics/", blank=True, null=True)
    location = models.CharField(max_length=255, blank=True, null=True)
    website = models.URLField(blank=True, null=True, help_text="Link to personal blog or social media.")

    # Followers system
    followers = models.ManyToManyField("self", symmetrical=False, related_name="following", blank=True)

    # Many-to-Many relations
    favorite_cuisines = models.ManyToManyField(Cuisine, blank=True, related_name="users")
    favorite_dishes = models.ManyToManyField(Dish, blank=True, related_name="users")
    dietary_preferences = models.ManyToManyField(DietaryPreference, blank=True, related_name="users")

    # User verification (optional)
    is_verified = models.BooleanField(default=False)

    # Slug for profile URL
    slug = models.SlugField(unique=True, blank=True)

    # Timestamp fields
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        """Generate a unique slug if not provided."""
        if not self.slug:
            self.slug = slugify(self.username)
            
        super().save(*args, **kwargs)

    def post_count(self):
        """Returns the number of posts created by the user (if Post model exists)."""
        return self.posts.count() if hasattr(self, 'posts') else 0

    def __str__(self):
        return self.username

