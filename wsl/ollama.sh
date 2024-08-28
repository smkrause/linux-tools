# Start the Ollama container
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# Pull the latest Ollama 3.1 model
docker exec -it ollama ollama pull llama3.1
