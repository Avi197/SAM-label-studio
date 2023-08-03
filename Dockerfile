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

#ENV PYTHONUNBUFFERED=True \
#    PORT=${PORT:-9090} \
#    PIP_CACHE_DIR=/.cache

RUN pip install -r requirements.txt
RUN pip install label_studio_ml
WORKDIR /app

COPY sam/_wsgi.py .
COPY sam/mmdetection.py .
COPY sam_vit_h_4b8939.pth .
EXPOSE 8003

ENV LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
ENV LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
ENV ML_TIMEOUT_SETUP=40

RUN LABEL_STUDIO_HOSTNAME=http://10.40.24.254:8080 label-studio-ml start sam --port 8003 --with   sam_config=vit_h   sam_checkpoint_file=./sam_vit_h_4b8939.pth   out_mask=False  out_poly=True   device=cuda:0
