#!/bin/bash

CONTAINER_NAME="brain-tumor-detection"

# Supprimer le container s'il existe déjà (arrêté ou en cours)
docker rm -f ${CONTAINER_NAME} 2>/dev/null

docker run --gpus all \
  --name ${CONTAINER_NAME} \
  --ipc=host \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  -d \
  -p 8888:8888 \
  -v $(pwd):/workspace \
  -w /workspace \
  brain-tumor-detection \
  sleep infinity
