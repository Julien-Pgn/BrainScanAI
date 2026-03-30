#!/bin/bash

# Télécharger le dataset Kaggle (API)
curl -L -o ~/Téléchargements/brain-tumor-mri-dataset.zip \
  "https://www.kaggle.com/api/v1/datasets/download/masoudnickparvar/brain-tumor-mri-dataset" \
  -H "Authorization: Bearer $(cat ~/.kaggle/kaggle.json | jq -r '.key')"

# Décompresser dans data/
unzip -q ~/Téléchargements/brain-tumor-mri-dataset.zip -d ~/Documents/VScode/BrainScanAI/data

# Nettoyer (supprimer le .zip)
rm ~/Téléchargements/brain-tumor-mri-dataset.zip

echo "✅ Dataset placé dans BrainScanAI/data/ avec la structure définie par l'auteur."
