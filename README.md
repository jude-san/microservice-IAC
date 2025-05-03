# Microservices Architecture, Pipeline, and Deployment Documentation

## Overview
This document describes the architecture, CI/CD pipeline, deployment strategy, and inter-service communication design for a microservices-based application built with Go, Python (Flask), and Ruby on Rails.

---

## Microservices Architecture

### Services Description

1. **Go Service**
   - Language: Go
   - Endpoint: `/health`
   - Purpose: Core backend component for processing or data aggregation

2. **Python Service**
   - Language: Python (Flask)
   - Endpoints: `/health`, `/chain`
   - Purpose: API gateway or intermediary, capable of calling the Go service

3. **Ruby on Rails Service**
   - Language: Ruby (Rails)
   - Endpoints: `/health`, `/chain`
   - Purpose: User-facing API or business logic layer, communicates with the Python service

### Service Relationships
- Rails → Python → Go
- Each service exposes `/health` for monitoring
- Each service supports a `/chain` endpoint to demonstrate inter-service communication

### Communication Flow
```text
[Client] → [Rails /chain] → [Python /chain] → [Go /health]
```

---

## Containerization
Each microservice is containerized using Docker. Below are common steps used across services:

- `Dockerfile` defined per service with appropriate runtime (Go, Python, Ruby)
- `EXPOSE` set to service port
- Docker image tagged and pushed to container registry (e.g., Docker Hub)

---

## Kubernetes Deployment with Helm

### Helm Chart Structure
```
helm-chart/
├── Chart.yaml
├── templates/
│   ├── deployment.yaml
│   └── service.yaml
├── values-go.yaml
├── values-python.yaml
└── values-rails.yaml
```

### Helm Values Files
Each service uses its own values YAML file to override:
- `image.repository`
- `image.tag`
- `service.port`

### Helm Deployment Commands
```bash
helm upgrade --install go-service ./helm-chart -f values-go.yaml
helm upgrade --install python-service ./helm-chart -f values-python.yaml
helm upgrade --install rails-service ./helm-chart -f values-rails.yaml
```

---

## Jenkins CI/CD Pipeline

### Pipeline Overview
1. Checkout code
2. Build Docker image
3. Push image to Docker registry
4. Deploy to Kubernetes using Helm


---

## Sample Requests and Responses

### Go Service
```bash
curl http://go-service/health
```
**Response:**
```json
{"status": "ok", "service": "go"}
```

### Python Service
```bash
curl http://python-service/chain
```
**Response:**
```json
{"python": "ok", "go_response": {"status": "ok", "service": "go"}}
```

### Rails Service
```bash
curl http://rails-service/chain
```
**Response:**
```json
{"rails": "ok", "python_response": {"python": "ok", "go_response": {"status": "ok", "service": "go"}}}
```
