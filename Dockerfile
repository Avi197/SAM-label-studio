ARG PYTORCH="1.13.0"
ARG CUDA="11.6"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-devel

# To fix GPG key error when running apt-get update
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# Install system dependencies for opencv-python
RUN apt-get update && apt-get install -y libgl1 libglib2.0-0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y git


WORKDIR /tmp
COPY requirements.txt .

ENV PYTHONUNBUFFERED=True \
    PORT=${PORT:-8003} \
    PIP_CACHE_DIR=/.cache

RUN --mount=type=cache,target=$PIP_CACHE_DIR \
    pip install -r requirements.txt
RUN pip install label_studio_ml
WORKDIR /app

COPY sam/_wsgi.py .
COPY sam/mmdetection.py .
COPY sam/sam_vit_h_4b8939.pth .
EXPOSE 8003

#ENV LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
ENV LABEL_STUDIO_USE_REDIS=true
#ENV LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
#ENV LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
ENV ML_TIMEOUT_SETUP=40
ENV HOSTNAME=https://labeling-tool-uat.vndirect.com.vn
ENV API_KEY=b57ae587bb4d1e51ff99a15f52d4d9b835d955b3


CMD exec gunicorn --preload --bind :$PORT --workers 1 --threads 1 --timeout 0 _wsgi:app