# docker

This is a Docker image for running "My App," a web application built with Python.

## Usage

You can build and run this Docker image using the following commands:

```bash
docker build -t myapp-image .
docker run -d -p 8000:8000 myapp-image