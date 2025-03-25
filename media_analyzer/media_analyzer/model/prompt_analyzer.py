from google import genai
from google.genai import types

from media_analyzer.utils.constants import GEMINI_API_KEYS
from media_analyzer.model.prompt_analyzer_prompt import system_prompt

class PromptAnalyzer:
    def __init__(self):
        self.Model_ID = "gemini-2.0-flash-exp"  # Corrected model ID (assuming it's a typo)
        self.api_keys = GEMINI_API_KEYS
        self.current_key_index = 0
        self.client = None
        self.rotate_key()
        self.system_prompt = system_prompt

    def rotate_key(self):
        """Rotates API keys and initializes a new client."""
        self.current_key_index = (self.current_key_index + 1) % len(self.api_keys)
        self.client = genai.Client(api_key=self.api_keys[self.current_key_index])

    def analyze(self, user_prompt):
        """Analyzes the user-provided prompt and recommends keywords."""
        self.rotate_key()
        print(f"Using API key: {self.api_keys[self.current_key_index]}")

        # Combine the system prompt and user prompt into a single user message
        combined_prompt = f"{self.system_prompt}\n\n{user_prompt}"

        # Generate content from Gemini
        response = self.client.models.generate_content(
            model=self.Model_ID,
            contents=[
                types.Content(
                    role="user",
                    parts=[
                        types.Part.from_text(text=combined_prompt),
                    ],
                ),
            ],
            config=types.GenerateContentConfig(
                temperature=0.2,  # Lower temp for more factual results
            ),
        )

        return response.text if response and hasattr(response, "text") else "Failed to analyze prompt."

# Example usage
if __name__ == "__main__":
    analyzer = PromptAnalyzer()
    prompt = (
        "This dish is a classic Italian pasta made with spaghetti, eggs, Pecorino Romano cheese, and pancetta. "
        "It has a rich, creamy texture and a savory, salty flavor."
    )
    result = analyzer.analyze(prompt)
    print(result)