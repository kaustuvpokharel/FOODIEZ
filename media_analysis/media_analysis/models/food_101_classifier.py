import timm
import torch
import pytorch_lightning as pl

class Food101Classifier(pl.LightningModule):
    def __init__(self, lr=3e-4):
        super().__init__()
        self.model = timm.create_model("hf_hub:timm/vit_base_patch16_384.augreg_in1k", pretrained=False, num_classes=101)
        self.criterion = torch.nn.CrossEntropyLoss()
        self.lr = lr

    def forward(self, x):
        return self.model(x)
    