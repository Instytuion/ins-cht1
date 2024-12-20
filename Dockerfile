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











# # Use the official Python 3.8 slim image as the base image
FROM python:3.8-slim

# Set environment variables to avoid writing .pyc files and to ensure UTF-8 encoding
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install system dependencies and Python dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    libssl-dev \
    libffi-dev \
    libpq-dev

# Upgrade pip
RUN python -m pip install --upgrade pip

# Create and activate a virtual environment, and install the requirements
RUN python -m venv /opt/venv
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app/

# Expose the port the app will run on
EXPOSE 5005

# Set the entrypoint for the Rasa application
ENTRYPOINT ["/opt/venv/bin/rasa"]
CMD ["run", "--enable-api", "--cors", "*", "--port", "5005"]

# Use a lightweight Python image




# FROM python:3.8-slim

# # Set environment variables
# ENV PYTHONDONTWRITEBYTECODE=1
# ENV PYTHONUNBUFFERED=1

# # Set the working directory
# WORKDIR /app

# # Install system dependencies
# RUN apt-get update && apt-get install -y \
#     build-essential \
#     python3-dev \
#     libssl-dev \
#     libffi-dev \
#     libpq-dev \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # Copy requirements and install dependencies
# COPY requirements.txt /app/
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy project files
# COPY . /app/

# # Expose the Rasa server port
# EXPOSE 5005

# CMD ["rasa", "run", "--enable-api", "--cors", "*", "--port", "5005"]

