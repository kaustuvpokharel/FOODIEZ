from django.test import TestCase
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model
from .models import Post

User = get_user_model()


class PostAppTests(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(username="tester", password="testpass")
        self.client.force_authenticate(user=self.user)

    def test_create_post(self):
        response = self.client.post('/post/posts/', {"caption": "Delicious ramen!"})
        self.assertEqual(response.status_code, 201)
        self.assertEqual(Post.objects.count(), 1)

    def test_like_unlike_post(self):
        post = Post.objects.create(user=self.user, caption="Yummy pasta")
        slug = post.slug

        like_url = f"/post/{slug}/like/"
        unlike_url = f"/post/{slug}/unlike/"

        like_response = self.client.post(like_url)
        self.assertEqual(like_response.status_code, 200)
        self.assertEqual(like_response.data["status"], "liked")

        unlike_response = self.client.post(unlike_url)
        self.assertEqual(unlike_response.status_code, 200)
        self.assertEqual(unlike_response.data["status"], "unliked")

    def test_post_comments(self):
        post = Post.objects.create(user=self.user, caption="Burger time!")
        slug = post.slug

        # Add comment
        comment_response = self.client.post(f'/post/{slug}/comments/', {
            "content": "Looks tasty!"
        })
        self.assertEqual(comment_response.status_code, 201)
        comment_id = comment_response.data.get("id")

        # Optional debug
        if not comment_id:
            print("⚠️ Comment ID not returned in response:", comment_response.data)

        # Delete comment
        delete_response = self.client.delete(f'/post/{slug}/comments/{comment_id}/')
        if delete_response.status_code != 204:
            print("❌ DELETE failed:", delete_response.status_code, delete_response.json())

        self.assertEqual(delete_response.status_code, 204)
