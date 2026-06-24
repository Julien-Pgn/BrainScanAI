FROM nvcr.io/nvidia/pytorch:26.01-py3
 
LABEL project="brainscanai"
LABEL description="Detection of brain tumors on MRI scans- PyTorch"
LABEL maintainer="Julien Pigeon"
 
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
 
 
WORKDIR /workspace
 
# Only metadata is needed to resolve dependencies. README.md and LICENSE are
# referenced by pyproject.toml, so they must exist at build time.
# (uv.lock is intentionally NOT copied: `uv pip install` does not use it — that
#  workflow is `uv sync`, which would try to rebuild the whole env and clobber
#  the NGC-optimized torch/numpy/opencv. We layer on top instead.)
COPY pyproject.toml README.md LICENSE /workspace/
 
# Install into the system Python already configured in the NGC image.
#   --system  : target the container interpreter (no venv)
#   --no-cache: uv's flag (NOT --no-cache-dir, which is pip-only)
# Packages already present (torch, numpy, pandas, sklearn, matplotlib...) are
# left untouched; only the missing ones are added.
RUN uv pip install --system --break-system-packages --no-cache ".[all]"
 
EXPOSE 8888
 
CMD ["/bin/bash"]