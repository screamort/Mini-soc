#!/bin/bash

# Build Wazuh agent image
docker build -f Dockerfile.wazuh-agent -t mini-soc-wazuh-agent:latest .

echo "Wazuh agent image built successfully!"
echo "You can now add this service to docker-compose.yml"
