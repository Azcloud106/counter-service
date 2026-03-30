# Counter Service

Simple Flask-based microservice with:

- GET / → returns current counter
- POST / → increments counter
- GET /health → health check
- GET /metrics → Prometheus metrics

## Run locally

pip install -r app/requirements.txt
python app/counter-service.py

## Docker

docker build -t counter-service .
docker run -p 8080:8080 counter-service

## Kubernetes

kubectl apply -f k8s/

## CI/CD

Azure DevOps pipeline builds and deploys automatically on push to main.