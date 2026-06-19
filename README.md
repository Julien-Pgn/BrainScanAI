# BrainScanAI

A project to study how neural networks have to evolve to identify and classify brain tumors out of MRI scans. 

## Data
Brain Tumor MRI Dataset (Kaggle). 5,600 training images, balanced (1,400 per class). Resized to 224×224, split 80/20 for train/validation.

## Model
Fine-tuned `vit-small-patch16-224` (ViT-Small, ~22M params, pretrained on ImageNet). New 4-class head, 10 epochs, batch size 32, learning rate 1e-4.

**Why a ViT?** It uses self-attention, so every patch of the image can relate to every other one from the start — a CNN only sees local detail early on. That global view fits MRI, where context matters. ViTs also transfer well from pretraining and are easier to explain: we can show which patches drove each prediction (Captum — Integrated Gradients and Occlusion heatmaps).

## Run it
```bash
bash kaggle_data_download.sh          # download the data
docker build -t brain-tumor-detection .
./run_container.sh                    # GPU container, port 8888
```
Then open `notebooks/01_training.ipynb`.

MIT License.