# Use an official Python runtime as a parent image
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Copy the necessary files for dependency installation
COPY pyproject.toml ./

# Install the project and its dependencies using pip
# This ensures that dependencies are installed based on pyproject.toml,
# and respects any build-time requirements for NVIDIA GPU support if specified.
RUN pip install --upgrade pip && \
    pip install .

# Copy the rest of the application code into the container
COPY . .

# Expose the port the application listens on
EXPOSE 8000

# Set environment variables if needed for CUDA/GPU, e.g., for PyTorch.
# You might need to configure these based on your specific NVIDIA driver and CUDA toolkit versions.
# ENV CUDA_VISIBLE_DEVICES=0
# ENV NVIDIA_VISIBLE_DEVICES=0

# Define the command to run the application
# The model path 'vibevoice/VibeVoice-7B' is specified as requested.
CMD ["python", "-m", "vibevoice_api.server", "--model_path", "vibevoice/VibeVoice-7B", "--port", "8000"]