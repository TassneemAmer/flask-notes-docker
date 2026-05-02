# Use a slim Python image
FROM python:3.10-slim

RUN apt-get update && apt-get install -y curl

# Create a non-root user
RUN useradd -m appuser

# Set working directory
WORKDIR /app

# Copy dependency list first (better caching)
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/ ./app/

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Expose Flask port
EXPOSE 5000

# Run the Flask app
CMD ["python", "app/app.py"]
