from django.urls import path
from rest_framework.routers import DefaultRouter
from .views import (
    PostViewSet,
    PostMediaViewSet,
    RecipeViewSet,
    RecipeStepViewSet,
    CommentViewSet, PostLikeView, PostUnlikeView
)

router = DefaultRouter()
router.register(r'posts', PostViewSet, basename='posts')
router.register(r'media', PostMediaViewSet, basename='media')
router.register(r'recipes', RecipeViewSet, basename='recipes')

urlpatterns = router.urls + [

    # Slug-based comment endpoints
    path('<slug:post_slug>/comments/', CommentViewSet.as_view({
        'get': 'list',
        'post': 'create'
    }), name='post-comments'),

    path('<slug:post_slug>/comments/<int:pk>/', CommentViewSet.as_view({
        'delete': 'destroy'
    }), name='post-comment-detail'),

    # Recipe steps endpoints
    path('recipes/<int:recipe_id>/steps/', RecipeStepViewSet.as_view({
        'get': 'list',
        'post': 'create'
    }), name='recipe-steps'),

    path('recipes/<int:recipe_id>/steps/<int:pk>/', RecipeStepViewSet.as_view({
        'put': 'update',
        'delete': 'destroy'
    }), name='recipe-step-detail'),
    path('<slug:post_slug>/like/', PostLikeView.as_view(), name='post-like'),
    path('<slug:post_slug>/unlike/', PostUnlikeView.as_view(), name='post-unlike'),
]
