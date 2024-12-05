# Use the official Rasa image
FROM rasa/rasa:3.6.20

# Set the working directory
WORKDIR /app

# Copy the Rasa project files into the container
COPY . .

# Install any dependencies
RUN pip install -r requirements.txt

# Install supervisord to manage both processes
RUN apt-get update && apt-get install -y supervisor

# Copy the supervisor configuration file
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose the ports for the Rasa server (5005) and action server (5055)
EXPOSE 5005 5055

# Command to start supervisord which will run both services
CMD ["/usr/bin/supervisord"]
