def get_user_prompt(keyword=None):
    # Define the keyword or use an empty string if none is provided
    key_word = "" if not keyword else keyword

    # Adjust the preparation steps based on the keyword
    if key_word:
        preparation_steps = {
            "tangy": "Ensure the dish has a tangy flavor by incorporating citrus or vinegar-based ingredients.",
            "savory": "Focus on rich, umami flavors by using ingredients like soy sauce, mushrooms, or aged cheeses.",
            "healthy": "Use fresh, whole ingredients and avoid excessive oil, sugar, or processed foods.",
            "low calorie": "Opt for low-calorie ingredients and cooking methods like steaming or grilling.",
            "bulking": "Include high-calorie, protein-rich ingredients to support muscle growth and bulking goals.",
        }.get(key_word, "Follow standard preparation steps for the dish.")
    else:
        preparation_steps = "Follow standard preparation steps for the dish."

    # Construct the user prompt
    user_prompt = (
        f"Analyze the provided cooking video and extract detailed information about the recipe being prepared. "
        f"Provide a structured summary in the following JSON format: "
        f"""
        {{
            "Recipe": {{
                "name": "Name of the Dish",
                "description": "A brief description of the dish and its cultural or culinary significance.",
                "ingredients": {{
                    "main_ingredients": [],
                    "seasonings_and_spices": [],
                    "optional_ingredients": []
                }},
                "preparationSteps": {{
                    "step_1": "Detailed description of the first step. {preparation_steps}",
                    "step_2": "Detailed description of the second step.",
                    "step_3": "Detailed description of the third step."
                }},
                "cooking_methods": [],
                "flavors": [],
                "moods": [],
                "cultural_context": []
            }}
        }}
        """
        f"Ensure the following: "
        f"1. **Ingredients**: Categorize ingredients into 'main_ingredients', 'seasonings_and_spices', and 'optional_ingredients'. "
        f"2. **Preparation Steps**: Break down the steps into clear, actionable instructions. {preparation_steps} "
        f"3. **Flavors**: Identify the dominant flavors (e.g., sweet, spicy, sour, umami). "
        f"4. **Moods**: Describe the mood or vibe of the dish (e.g., comforting, festive, refreshing). "
        f"5. **Cultural Context**: Mention the cuisine type or cultural origin of the dish (e.g., Italian, Indian, Mexican). "
        f"6. **Cooking Methods**: List the primary cooking techniques used (e.g., frying, baking, steaming)."
    )

    return user_prompt


system_prompt = (
    "You are a culinary expert and video analysis assistant. When given a cooking video, carefully analyze the content to extract: "
    "1. **Recipe Details**: Identify the dish being prepared, its ingredients, and the step-by-step preparation process. "
    "2. **Flavors and Moods**: Analyze the flavors and moods associated with the dish based on the ingredients, cooking methods, and presentation. "
    "3. **Cultural Context**: Determine the cultural or regional origin of the dish. "
    "4. **Cooking Methods**: Identify the primary cooking techniques used in the recipe. "
    "If spoken instructions are present in the video, use them to enhance the accuracy of your analysis. "
    "Provide the output in a structured JSON format as requested by the user."
)