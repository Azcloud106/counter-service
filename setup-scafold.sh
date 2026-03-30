#!/bin/bash

# Define the root directory
ROOT_DIR="counter-service"

# Create the directory structure
mkdir -p $ROOT_DIR/app
mkdir -p $ROOT_DIR/k8s

# Create the files
touch $ROOT_DIR/app/counter-service.py
touch $ROOT_DIR/app/requirements.txt

touch $ROOT_DIR/k8s/deployment.yaml
touch $ROOT_DIR/k8s/service.yaml
touch $ROOT_DIR/k8s/pvc.yaml

touch $ROOT_DIR/Dockerfile
touch $ROOT_DIR/.dockerignore
touch $ROOT_DIR/azure-pipelines.yml
touch $ROOT_DIR/README.md
touch $ROOT_DIR/.gitignore

echo "Project structure for '$ROOT_DIR' has been created successfully!"
ls -R $ROOT_DIR