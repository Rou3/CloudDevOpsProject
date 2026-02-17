# Use a Python base image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy all files from current folder into /app in container
COPY . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the port your app uses (adjust if not 5000)
EXPOSE 5000

# Command to run your app
CMD ["python", "app.py"]
