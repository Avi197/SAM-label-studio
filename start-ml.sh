#!/bin/bash

#export LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
#export LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
#export ML_TIMEOUT_SETUP=40
#LABEL_STUDIO_HOSTNAME=https://labeling-tool-uat.vndirect.com.vn/ label-studio-ml start sam --port 8003 --with   sam_config=vit_h   sam_checkpoint_file=./sam_vit_h_4b8939.pth   out_mask=False  out_poly=True   device=cuda:0
#--port 8003 --with sam_config=vit_h sam_checkpoint_file=./sam_vit_h_4b8939.pth out_mask=False out_poly=True device=cuda:0 --kwargs hostname=http://labeling-tool-uat.vndirect.com.vn access_token=b57ae587bb4d1e51ff99a15f52d4d9b835d955b3


export LABEL_STUDIO_USE_REDIS=true
export ML_TIMEOUT_SETUP=40
export HOSTNAME=https://labeling-tool-uat.vndirect.com.vn
export API_KEY=b57ae587bb4d1e51ff99a15f52d4d9b835d955b3


exec gunicorn --preload --bind :$PORT --workers 1 --threads 8 --timeout 0 _wsgi:app