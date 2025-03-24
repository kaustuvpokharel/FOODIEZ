import torch
import torchvision.transforms as transforms
import os
from PIL import Image
import requests
from io import BytesIO
import timm
import pytorch_lightning as pl
from media_analysis.utils.recipes import idx_to_class


class Food101Classifier(pl.LightningModule):
    def __init__(self, lr=3e-4):
        super().__init__()
        self.model = timm.create_model("hf_hub:timm/vit_base_patch16_384.augreg_in1k", pretrained=False, num_classes=101)
        self.criterion = torch.nn.CrossEntropyLoss()
        self.lr = lr

    def forward(self, x):
        return self.model(x)
    


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
    
    def preprocess_image(self,frame_path:str):
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
            response = requests.get(frame_path)
            image = Image.open(BytesIO(response.content)).convert("RGB")
        else:
            image = Image.open(frame_path).convert("RGB")
        
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

