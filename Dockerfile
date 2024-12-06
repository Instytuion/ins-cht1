# Use the official Rasa base image
FROM rasa/rasa:3.0.0-full

# Set the working directory in the container
WORKDIR /app

# Copy your project files into the container
COPY . .

# Install dependencies (make sure requirements.txt exists with necessary dependencies)
RUN pip install --no-cache-dir -r requirements.txt

# Expose the Rasa server port (default is 5005)
EXPOSE 5005

# Command to run the Rasa server
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--port", "5005", "--model", "models/"]
