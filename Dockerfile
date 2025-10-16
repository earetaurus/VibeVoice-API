FROM python:3.9-slim 

# Set environment variables 
ENV PYTHONUNBUFFERED 1 
ENV PIP_NO_CACHE_DIR off 

# Install UV package manager 
RUN pip install uv 

# Create app directory and set it as the working directory 
WORKDIR /app 

# Copy application files 
COPY . . 

# Install dependencies using UV 
RUN uv install 

# Expose application port (default for uvicorn is 8000) 
EXPOSE 8000 

# Command to run the application 
CMD ["uv", "start"]