FROM nvcr.io/nvidia/pytorch:25.01-py3

LABEL project="brain-tumor-detection"
LABEL description="Détection de tumeurs cérébrales sur IRM - PyTorch"

WORKDIR /workspace

COPY requirements.txt .

# On installe dans cet ordre précis :
# 1. numpy épinglé EN PREMIER pour bloquer toute mise à jour
# 2. opencv épinglé EN SECOND pour la même raison
# 3. le reste du requirements.txt
RUN pip install --no-cache-dir "numpy==1.26.4" "opencv-python-headless==4.10.0.84" \
    && pip install --no-cache-dir -r requirements.txt

EXPOSE 8888

CMD ["/bin/bash"]