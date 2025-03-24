import time
from google import genai
from google.genai import types

from media_analyzer.model.video_prompts import get_user_prompt,system_prompt
from media_analyzer.utils.constants import GEMINI_API_KEYS

class VideoAnalyzer:
    def __init__(self):
        self.Model_ID = "gemini-2.0-flash-exp"
        self.api_keys = GEMINI_API_KEYS
        self.current_key_index = 0
        self.client = None
        self.rotate_key()
        self.user_prompt = None
        self.system_prompt = system_prompt
        

    def rotate_key(self):
        """Rotates API keys and initializes a new client."""
        self.current_key_index = (self.current_key_index + 1) % len(self.api_keys)
        self.client = genai.Client(api_key=self.api_keys[self.current_key_index])

    def analyze(self, video_path,keyword = None):
        self.user_prompt = get_user_prompt(keyword)
        """Uploads and analyzes the video, extracting cooking details and a summary."""
        self.rotate_key()
        # print(self.api_keys[self.current_key_index])

        # Upload the video file correctly
        
        file_upload = self.client.files.upload(file=video_path)

        # Wait for processing
        while file_upload.state == "PROCESSING":
            print("Waiting for video to be processed...")
            time.sleep(10)
            file_upload = self.client.files.get(name=file_upload.name)

        if file_upload.state == "FAILED":
            raise ValueError(f"Video processing failed: {file_upload.state}")

        print(f"Video processing complete: {file_upload.uri}")

        # Define prompts
       

        # Generate content from Gemini
        response = self.client.models.generate_content(
            model=self.Model_ID,
            contents=[
                types.Content(
                    role="user",
                    parts=[
                        types.Part.from_uri(
                            file_uri=file_upload.uri,
                            mime_type=file_upload.mime_type,
                        ),
                    ],
                ),
                self.user_prompt,
            ],
            config=types.GenerateContentConfig(
                system_instruction=self.system_prompt,
                temperature=0.2,  # Lower temp for more factual results
            ),
        )

        return response.text if response and hasattr(response, "text") else "Failed to analyze video."


if __name__=="__main__":
# Example usage
    import os
    analyzer = VideoAnalyzer()
    sample_vid = "/Users/macbookpro/Desktop/gemini_hackathon/media_analyzer/media_analyzer/tests/caesar_salad.mp4"
    sample_vid2 = "/Users/macbookpro/Desktop/gemini_hackathon/media_analyzer/media_analyzer/tests/cheesecake.mp4"
    result = analyzer.analyze(sample_vid, )
    result3 = analyzer.analyze(sample_vid2)
    print(result)
    print(result3)
