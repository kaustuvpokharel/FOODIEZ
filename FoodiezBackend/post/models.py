from django.db import models
from django.utils.text import slugify
from django.contrib.auth import get_user_model
from django.db.models import F

from common.models import BaseModel

User = get_user_model()


class Recipe(BaseModel):
    """Model for storing a recipe linked to a post."""

    post = models.OneToOneField("Post", on_delete=models.CASCADE, related_name="recipe")
    title = models.CharField(max_length=255, help_text="Title of the recipe.")

    def __str__(self):
        return f"Recipe for {self.post.user.username}'s post"


class RecipeStep(models.Model):
    """Step-wise instructions for a recipe with optional timers."""

    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE, related_name="steps")
    step_number = models.PositiveIntegerField(help_text="Step order number.")
    description = models.TextField(help_text="Instruction for the step.")
    timer_seconds = models.PositiveIntegerField(blank=True, null=True, help_text="Time in seconds (optional).")

    class Meta:
        ordering = ["step_number"]

    def __str__(self):
        return f"Step {self.step_number} for Recipe {self.recipe.title}"


class Post(BaseModel):
    """Model representing a food-related post by a user."""

    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="posts")
    caption = models.TextField(blank=True, null=True)

    # Explicit count fields (default to 0)
    like_count = models.PositiveIntegerField(default=0)
    comment_count = models.PositiveIntegerField(default=0)
    media_count = models.PositiveIntegerField(default=0)

    # Many-to-Many for likes
    likes = models.ManyToManyField(User, related_name="liked_posts", blank=True)

    # Slug for unique post URL
    slug = models.SlugField(unique=True, blank=True)

    def save(self, *args, **kwargs):
        """Generate a unique slug if not provided and create a recipe if a media file is uploaded."""
        if not self.slug:
            self.slug = slugify(f"{self.user.username}-{self.created_at.timestamp()}")

        super().save(*args, **kwargs)

        # Ensure a recipe is created if it doesn't exist
        if self.media_files.exists() and not hasattr(self, 'recipe'):
            Recipe.objects.create(post=self, title=f"Recipe by {self.user.username}")

    # ------------ LIKE SYSTEM ------------
    def add_like(self, user):
        """Adds a like to the post and updates like count."""
        if not self.likes.filter(id=user.id).exists():  # Prevent double likes
            self.likes.add(user)
            self.like_count = F('like_count') + 1  # Atomic update
            self.save(update_fields=['like_count'])

    def remove_like(self, user):
        """Removes a like from the post and updates like count."""
        if self.likes.filter(id=user.id).exists():  # Only unlike if already liked
            self.likes.remove(user)
            self.like_count = F('like_count') - 1  # Atomic update
            self.save(update_fields=['like_count'])

    # ------------ COMMENT SYSTEM ------------
    def increment_comment_count(self):
        """Increases comment count by 1."""
        self.comment_count = F('comment_count') + 1
        self.save(update_fields=['comment_count'])

    def decrement_comment_count(self):
        """Decreases comment count by 1."""
        if self.comment_count > 0:  # Prevent negative count
            self.comment_count = F('comment_count') - 1
            self.save(update_fields=['comment_count'])

    # ------------ MEDIA SYSTEM (IMAGES & VIDEOS) ------------
    def update_media_count(self):
        """Updates media count manually."""
        self.media_count = self.media_files.count()
        self.save(update_fields=['media_count'])

        # Create a recipe if media is uploaded and not already created
        if self.media_files.exists() and not hasattr(self, 'recipe'):
            Recipe.objects.create(post=self, title=f"Recipe by {self.user.username}")

    def __str__(self):
        return f"Post by {self.user.username} at {self.created_at.strftime('%Y-%m-%d %H:%M')}"


class PostMedia(BaseModel):
    """Model representing multiple images or videos for a post."""

    MEDIA_TYPE_CHOICES = [
        ('image', 'Image'),
        ('video', 'Video'),
    ]

    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="media_files")
    file = models.FileField(upload_to="post_media/")
    media_type = models.CharField(max_length=10, choices=MEDIA_TYPE_CHOICES)

    def save(self, *args, **kwargs):
        """Ensure media type is correctly determined and update post media count."""
        if self.file:
            file_extension = self.file.name.split('.')[-1].lower()
            if file_extension in ['jpg', 'jpeg', 'png', 'gif', 'webp']:
                self.media_type = 'image'
            elif file_extension in ['mp4', 'avi', 'mov', 'wmv', 'flv', 'mkv']:
                self.media_type = 'video'
            else:
                raise ValueError("Unsupported file type")

        super().save(*args, **kwargs)
        self.post.update_media_count()

    def delete(self, *args, **kwargs):
        """Update media count when a media file is removed."""
        super().delete(*args, **kwargs)
        self.post.update_media_count()

    def __str__(self):
        return f"{self.media_type.capitalize()} for Post {self.post.id}"


class Comment(BaseModel):
    """Model representing comments on a post."""

    post = models.ForeignKey(Post, on_delete=models.CASCADE, related_name="comments")
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        """Update comment count in the post when a new comment is added."""
        super().save(*args, **kwargs)
        self.post.increment_comment_count()

    def delete(self, *args, **kwargs):
        """Update comment count in the post when a comment is removed."""
        super().delete(*args, **kwargs)
        self.post.decrement_comment_count()

    def __str__(self):
        return f"Comment by {self.user.username} on {self.post.user.username}'s post"
