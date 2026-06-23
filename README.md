# BrainScanAI

A comparative study on how neural networks have to evolve to identify and classify brain tumors from MRI scans.  

## Data
Brain Tumor MRI Dataset (Kaggle). 5,600 training images, balanced (1,400 per class). Resized to 224×224, split 80/20 for train/validation.

## Models

### ResNet50
Published by He et al., 2015, ResNets are residual CNN using skip connections to solve vanishing gradients in deep neural networks.

### ViT-Small
Published by Dosovitskiy et al., 2020, ViTs are visual transformers using attention mechanisms for image recognition, efficient to learn global and contextual dependancies. CNN only sees local detail early on. That global view fits MRI, where context matters. ViTs also transfer well from pretraining and are easier to explain: we can show which patches drove each prediction (Captum — Integrated Gradients and Occlusion heatmaps).
In this project, I used the fine-tuned `vit-small-patch16-224` (ViT-Small, ~22M params, pretrained on ImageNet). New 4-class head, 10 epochs, batch size 32, learning rate 1e-4.

### DINOv2
Published by Oquab et al., 2023 it is a self supervised learning vision transformer based foundation model trained on natural images for generalibility. MOstly used for tumor segmentations, it can also predcit tumor types and requires very few annotated images for training. 

### BiomedCLIP
Published by Zhang et al., 2023 it is a multimodal biomedical foundation model pretrained on 15 millions of scientific images-text pairs. 

## Run it
```bash
bash kaggle_data_download.sh          # download the data
docker build -t brain-tumor-detection .
./run_container.sh                    # GPU container, port 8888
```
Then open `notebooks/01_training.ipynb`.

MIT License.
