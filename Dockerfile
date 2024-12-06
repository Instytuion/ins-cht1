# # Use official Python 3.9 slim image
# FROM python:3.9-slim

# # Set working directory
# WORKDIR /app

# # Install system dependencies required by psycopg2
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libpq-dev \
#     && apt-get clean

# # Install dependencies for Rasa and actions
# COPY requirements.txt /app/
# RUN pip install --no-cache-dir --default-timeout=100 -r requirements.txt

# # Install dependencies for actions (additional ones for rasa-sdk)
# COPY requirements-actions.txt /app/
# RUN pip install --no-cache-dir --default-timeout=100 -r requirements-actions.txt

# # Copy the entrypoint script into the container
# COPY entrypoint.sh /app/entrypoint.sh
# RUN chmod +x /app/entrypoint.sh

# # Copy your project files (e.g., chat_bot and actions)
# COPY ./chat_bot /app/chat_bot
# COPY ./actions /app/actions

# # Copy the .env file to the container
# COPY .env /app/.env

# # Set the default command to run the action server
# ENTRYPOINT ["/app/entrypoint.sh"]
# Use the official Rasa base image



FROM python:3.8-slim

# Set the working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libssl-dev \
    libffi-dev \
    libpq-dev

# Install pip and upgrade it
RUN python -m pip install --upgrade pip

# Copy your requirements.txt and install dependencies
COPY requirements.txt .

# Ensure correct permissions
RUN chown -R root:root /opt/venv /usr/local/lib/python3.8

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port the app will run on
EXPOSE 5005

# Command to run the application
CMD ["rasa", "run", "--enable-api"]
