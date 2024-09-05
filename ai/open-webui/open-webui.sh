#!/usr/bin/env bash

# Check if container exists
CONTAINER_EXISTS=$(docker ps -q -f name=open-webui)

if [ -n "$CONTAINER_EXISTS" ]; then
  # If container exists, run watchtower command
  docker run --rm --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once open-webui
else
  # If container does not exist, create it with the desired settings - NOTE - Requires CUDA
  docker run -d -p 3000:8080 --gpus all --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:cuda
fi