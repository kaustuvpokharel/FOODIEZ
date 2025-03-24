user_prompt = (
    "Analyze the provided cooking video and extract detailed information about the recipe being prepared. "
    "Provide a structured summary in the following JSON format: "
    """
    {
        "Recipe": {
            "name": "Name of the Dish",
            "description": "A brief description of the dish and its cultural or culinary significance.",
            "ingredients": {
                "main_ingredients": [],
                "seasonings_and_spices": [],
                "optional_ingredients": []
            },
            "preparationSteps": {
                "step_1": "Detailed description of the first step.",
                "step_2": "Detailed description of the second step.",
                "step_3": "Detailed description of the third step."
            },
            "cooking_methods": [],
            "flavors": [],
            "moods": [],
            "cultural_context": []
        }
    }
    """
    "Ensure the following: "
    "1. **Ingredients**: Categorize ingredients into 'main_ingredients', 'seasonings_and_spices', and 'optional_ingredients'. "
    "2. **Preparation Steps**: Break down the steps into clear, actionable instructions. "
    "3. **Flavors**: Identify the dominant flavors (e.g., sweet, spicy, sour, umami). "
    "4. **Moods**: Describe the mood or vibe of the dish (e.g., comforting, festive, refreshing). "
    "5. **Cultural Context**: Mention the cuisine type or cultural origin of the dish (e.g., Italian, Indian, Mexican). "
    "6. **Cooking Methods**: List the primary cooking techniques used (e.g., frying, baking, steaming)."
)

system_prompt = (
    "You are a culinary expert and video analysis assistant. When given a cooking video, carefully analyze the content to extract: "
    "1. **Recipe Details**: Identify the dish being prepared, its ingredients, and the step-by-step preparation process. "
    "2. **Flavors and Moods**: Analyze the flavors and moods associated with the dish based on the ingredients, cooking methods, and presentation. "
    "3. **Cultural Context**: Determine the cultural or regional origin of the dish. "
    "4. **Cooking Methods**: Identify the primary cooking techniques used in the recipe. "
    "If spoken instructions are present in the video, use them to enhance the accuracy of your analysis. "
    "Provide the output in a structured JSON format as requested by the user."
)