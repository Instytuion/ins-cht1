# Use the official Rasa base image
FROM rasa/rasa:3.0.0-full

# Set the working directory in the container
WORKDIR /app

# Copy your Rasa project files into the container
COPY . .

# Install Rasa and initialize the project (optional if you already have the project initialized)
RUN rasa init --no-prompt

# Generate a fresh requirements.txt with the installed dependencies
RUN pip freeze > requirements.txt

# Expose the port that Rasa will run on (default is 5005)
EXPOSE 5005

# Command to run the Rasa server
CMD ["rasa", "run", "--enable-api", "--cors", "*", "--port", "5005"]
