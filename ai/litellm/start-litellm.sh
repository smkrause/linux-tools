#!/usr/bin/env bash
docker run -d \
-v $(pwd)/litellm_config.yaml:/app/config.yaml \
--env-file $(pwd)/.env \
-p 4000:4000 \
--name litellm-proxy \
--restart always \
ghcr.io/berriai/litellm:main-latest \
--config /app/config.yaml --detailed_debug