FROM nvcr.io/nvidia/pytorch:25.01-py3

LABEL project="brain-tumor-detection"
LABEL description="Détection de tumeurs cérébrales sur IRM - PyTorch"
LABEL maintainer="Julien Pigeon"

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /workspace

COPY pyproject.toml uv.lock LICENSE README.md /workspace/


RUN uv pip install --system --break-system-packages --no-cache-dir -e ".[all]"


EXPOSE 8888

CMD ["/bin/bash"]