FROM python:3.11-alpine

# Set environment variables 
ENV PYTHONUNBUFFERED 1 
ENV PIP_NO_CACHE_DIR off 

# Install UV package manager 
RUN apk add uv
RUN apk add git

# Create app directory and set it as the working directory 
WORKDIR /app 

# Copy application files 
COPY . . 

# Install dependencies using UV 
RUN uv pip install -e .

# Expose application port (default for uvicorn is 8000) 
EXPOSE 8000 

# Command to run the application 
CMD ["uv", "run","python -m vibevoice_api.server --model_path vibevoice/VibeVoice-1.5B --port 8000"]