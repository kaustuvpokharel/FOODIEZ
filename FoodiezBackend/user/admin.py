from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Cuisine, Dish, DietaryPreference


@admin.register(User)
class CustomUserAdmin(UserAdmin):
    model = User
    list_display = ("username", "email", "is_verified", "post_count", "created_at")
    fieldsets = UserAdmin.fieldsets + (
        ("Additional Info", {
            "fields": ("bio", "profile_picture", "location", "website",
                       "favorite_cuisines", "favorite_dishes", "dietary_preferences", "followers", "is_verified")
        }),
    )


@admin.register(Cuisine)
class CuisineAdmin(admin.ModelAdmin):
    list_display = ("name",)
    search_fields = ("name",)


@admin.register(Dish)
class DishAdmin(admin.ModelAdmin):
    list_display = ("name", "cuisine")
    search_fields = ("name",)
    list_filter = ("cuisine",)


@admin.register(DietaryPreference)
class DietaryPreferenceAdmin(admin.ModelAdmin):
    list_display = ("name",)
    search_fields = ("name",)
