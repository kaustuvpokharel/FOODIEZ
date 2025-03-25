from rest_framework import serializers
from .models import Post, PostMedia, Recipe, RecipeStep, Comment


class PostMediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = PostMedia
        fields = ['id', 'file', 'media_type']


class RecipeStepSerializer(serializers.ModelSerializer):
    class Meta:
        model = RecipeStep
        fields = ['id', 'step_number', 'description', 'timer_seconds']


class RecipeSerializer(serializers.ModelSerializer):
    steps = RecipeStepSerializer(many=True, read_only=True)

    class Meta:
        model = Recipe
        fields = ['id', 'title', 'steps']


class CommentSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)

    class Meta:
        model = Comment
        fields = ['id', 'user', 'content', 'created_at']


class PostSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)
    media_files = PostMediaSerializer(many=True, read_only=True)
    recipe = RecipeSerializer(read_only=True)
    comments = CommentSerializer(many=True, read_only=True)

    class Meta:
        model = Post
        fields = ['id', 'user', 'caption', 'slug', 'like_count', 'comment_count', 'media_count',
                  'media_files', 'recipe', 'comments', 'created_at']
