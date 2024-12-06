#!/bin/bash

# Export environment variables from the .env file
export $(cat /app/.env | grep -v '^#' | xargs)

# Start Rasa Action Server
rasa run actions --debug --port 5055
