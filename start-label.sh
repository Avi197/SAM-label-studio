#!/bin/bash
export LABEL_STUDIO_LOCAL_FILES_DOCUMENT_ROOT=/opt/data/
export LABEL_STUDIO_LOCAL_FILES_SERVING_ENABLED=true
export ML_TIMEOUT_SETUP=40
label-studio start --port 5000
