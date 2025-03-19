from django.contrib import admin
from .models import Post, PostMedia, Comment


class PostMediaInline(admin.TabularInline):
    """Allows adding multiple images/videos directly in the Post admin panel."""
    model = PostMedia
    extra = 1  # Provides an empty slot for adding new media


@admin.register(Post)
class PostAdmin(admin.ModelAdmin):
    list_display = ("user", "caption", "like_count", "comment_count", "media_count", "created_at")
    search_fields = ("user__username", "caption")
    list_filter = ("created_at",)
    prepopulated_fields = {"slug": ("caption",)}
    inlines = [PostMediaInline]  # Enables adding media inside the Post admin panel
    readonly_fields = ("like_count", "comment_count", "media_count", "created_at", "updated_at")


@admin.register(PostMedia)
class PostMediaAdmin(admin.ModelAdmin):
    list_display = ("post", "media_type", "file", "created_at")
    search_fields = ("post__caption",)
    list_filter = ("media_type",)


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ("user", "post", "content", "created_at")
    search_fields = ("user__username", "post__caption", "content")
    list_filter = ("created_at",)
