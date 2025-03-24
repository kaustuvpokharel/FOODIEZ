import torch
import torchvision.transforms as transforms
import os
from PIL import Image
import requests
from io import BytesIO
from media_analysis.utils.recipes import idx_to_class
from media_analysis.models.food_101_classifier import Food101Classifier



class FrameAnalyzer:
    """
    Classifies the frame using our food101_model
    """
    def __init__(self,):
        """
        Parameters:
        -----------
        frame_path: a url or a file path
        """
        self.model_ = f"{os.path.dirname(os.path.abspath(__file__))}/food101_model_new.pt"
        self.idx_to_class = idx_to_class
        self.model = Food101Classifier(lr=3e-4)


        # Load the model weights from the .pt file
        self.model.load_state_dict(torch.load(self.model_))

        # If you're using the model with PyTorch Lightning, you might also want to call model.eval() to set it to evaluation mode:
        self.model.eval()

    def preprocess_image(self, frame_path: str):
        """
        Preprocesses an image from a local path or URL for Food101 classification.
        
        Args:
            frame_path (str): Path to a local image or an image URL.
            
        Returns:
            torch.Tensor: Preprocessed image tensor ready for model inference.
        """
        transform = transforms.Compose([
            transforms.Resize((384, 384)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.5, 0.5, 0.5], std=[0.5, 0.5, 0.5])
        ])

        # Check if input is a URL or local path
        if frame_path.startswith("http"):
            headers = {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
            response = requests.get(frame_path, headers=headers)
            
            # Ensure the image is valid and non-empty
            if response.status_code != 200:
                raise ValueError(f"Failed to retrieve image from {frame_path}, status code: {response.status_code}")
            
            if len(response.content) == 0:
                raise ValueError(f"Empty image data received from {frame_path}")

            # Open the image content as a BytesIO stream
            try:
                image = Image.open(BytesIO(response.content)).convert("RGB")
            except Exception as e:
                raise ValueError(f"Unable to open image from {frame_path}. Error: {str(e)}")
        
        image = transform(image).unsqueeze(0)  # Add batch dimension
        return image

        

    def make_prediction(self,frame_path: str):
        """
        Parameter:
        -----------
        framepath: frame path is the path to the image file
        can be either a string or a manual file
        """
        image = self.preprocess_image(frame_path)


        # Perform inference
        with torch.no_grad():
            output = self.model(image)
            predicted_class = output.argmax(dim=1).item()
        
        # Get the predicted label
        predicted_label = self.idx_to_class(predicted_class)
        return predicted_label

if __name__ == "__main__":
    analyzer = FrameAnalyzer()
    cheese_cake = "https://www.onceuponachef.com/images/2017/12/cheesecake-1200x1393.jpg"
    print(analyzer.make_prediction(cheese_cake) == "cheesecake")