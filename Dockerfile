# Use an official Python runtime as a parent image
FROM python:3.11-alpine

# Set the working directory in the container
WORKDIR /app
RUN apk add --no-cache git build-base

# Install project dependencies
RUN pip install --upgrade pip && \
    pip install torch==2.1.2 accelerate==1.6.0 transformers==4.51.3 \
    "git+https://github.com/vibevoice-community/VibeVoice" datasets==3.5.0 peft==0.11.1 \
    llvmlite>=0.40.0 numba>=0.57.0 diffusers==0.29.0 \
    tqdm numpy scipy librosa ml-collections absl-py gradio av aiortc

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