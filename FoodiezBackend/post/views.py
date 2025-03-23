from django.shortcuts import get_object_or_404
from rest_framework import viewsets, status
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .serializers import *


class PostViewSet(viewsets.ModelViewSet):
    lookup_field = 'slug'
    serializer_class = PostSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Post.objects.all().select_related('user').prefetch_related('media_files', 'comments')
        username = self.request.query_params.get('user')
        if username:
            queryset = queryset.filter(user__username=username)
        return queryset

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

    @action(detail=True, methods=['post'])
    def like(self, request, slug=None):
        post = get_object_or_404(Post, slug=slug)
        post.add_like(request.user)
        return Response({'status': 'liked'})

    @action(detail=True, methods=['post'])
    def unlike(self, request, slug=None):
        post = get_object_or_404(Post, slug=slug)
        post.remove_like(request.user)
        return Response({'status': 'unliked'})


class CommentViewSet(viewsets.ModelViewSet):
    serializer_class = CommentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        post = get_object_or_404(Post, slug=self.kwargs['post_slug'])
        return Comment.objects.filter(post=post)

    def perform_create(self, serializer):
        post = get_object_or_404(Post, slug=self.kwargs['post_slug'])
        serializer.save(user=self.request.user, post=post)

    def destroy(self, request, post_slug=None, pk=None):
        post = get_object_or_404(Post, slug=post_slug)
        comment = get_object_or_404(Comment, pk=pk, post=post)

        if comment.user != request.user:
            return Response({"detail": "Unauthorized"}, status=403)

        comment.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class RecipeViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = RecipeSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        queryset = Recipe.objects.all().prefetch_related('steps')
        title = self.request.query_params.get('title')
        if title:
            queryset = queryset.filter(title__icontains=title)
        return queryset


class RecipeStepViewSet(viewsets.ModelViewSet):
    serializer_class = RecipeStepSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return RecipeStep.objects.filter(recipe_id=self.kwargs['recipe_id'])

    def perform_create(self, serializer):
        recipe = get_object_or_404(Recipe, pk=self.kwargs['recipe_id'])
        serializer.save(recipe=recipe)


class PostMediaViewSet(viewsets.ModelViewSet):
    serializer_class = PostMediaSerializer
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser]

    def get_queryset(self):
        return PostMedia.objects.filter(post__user=self.request.user)

    def create(self, request, *args, **kwargs):
        post_id = request.data.get('post')
        files = request.FILES.getlist('files')
        post = get_object_or_404(Post, id=post_id, user=request.user)

        created = []
        for file in files:
            media = PostMedia.objects.create(post=post, file=file)
            created.append(PostMediaSerializer(media).data)

        return Response(created, status=status.HTTP_201_CREATED)


class PostLikeView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, post_slug):
        post = get_object_or_404(Post, slug=post_slug)
        post.add_like(request.user)
        return Response({"status": "liked"})


class PostUnlikeView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request, post_slug):
        post = get_object_or_404(Post, slug=post_slug)
        post.remove_like(request.user)
        return Response({"status": "unliked"})
