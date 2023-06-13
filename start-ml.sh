#!/bin/bash

export LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
export LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
export ML_TIMEOUT_SETUP=40

label-studio-ml start sam --port 8003 --with   sam_config=vit_h   sam_checkpoint_file=./sam_vit_h_4b8939.pth   out_mask=False  out_poly=True   device=cuda:0
