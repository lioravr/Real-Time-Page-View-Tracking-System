# Real-Time Page View Tracking System

A distributed, real-time event processing system designed to track and aggregate page view events at scale.

## Architecture

```
Client/Browser → API Gateway (Go + Gin) → Kafka → Processor Service → Redis
                                                   ↓
                                                   S3 (Optional)
```

## Components

- **API Gateway**: HTTP API that accepts page view events and publishes to Kafka
- **Processor Service**: Consumes events from Kafka and updates Redis counters
- **Kafka**: Message broker for event streaming
- **Redis**: Real-time aggregation store for page view counts
- **S3**: Optional archival storage for raw events

## Tech Stack

- **Language**: Go 1.21+
- **Web Framework**: Gin
- **Message Broker**: Apache Kafka
- **Cache/Store**: Redis
- **Containerization**: Docker
- **Orchestration**: Kubernetes

## Prerequisites

- Go 1.21 or higher
- Docker & Docker Compose
- kubectl (for Kubernetes deployment)
- Minikube or access to a Kubernetes cluster

## Project Structure

```
.
├── cmd/
│   ├── api-gateway/          # API Gateway service
│   └── processor-service/    # Event processor service
├── internal/
│   ├── models/               # Shared data models
│   ├── kafka/                # Kafka producer/consumer logic
│   └── redis/                # Redis client logic
├── k8s/                      # Kubernetes manifests
├── docker-compose.yml        # Local development setup
├── SPEC.md                   # Detailed specification
└── README.md                 # This file
```

## Quick Start

### 1. Start All Services with Docker Compose

```bash
# Start all services (Kafka, Redis, API Gateway, etc.)
make up

# Or using docker-compose directly
docker-compose up -d
```

### 2. Check Service Health

```bash
# Check all services
make health

# Test API Gateway
curl http://localhost:8080/health
```

### 3. Access Web UIs

- **API Gateway**: http://localhost:8080/health
- **Kafka UI**: http://localhost:8090 (browse topics, messages)

### 4. Run Without Docker (Local Development)

```bash
# Install dependencies
go mod tidy

# Run API Gateway
go run cmd/api-gateway/main.go
```

### 5. Stop Services

```bash
make down
```

For detailed Docker instructions, see [DOCKER_GUIDE.md](DOCKER_GUIDE.md)

## Development Progress

- [x] Project initialization (PR #1)
- [x] API Gateway with health check (PR #2)
- [x] Docker Compose setup (PR #3)
- [ ] Track endpoint with Kafka producer (PR #4)
- [ ] Processor Service implementation (PR #5-6)
- [ ] Kubernetes deployment (PR #8-9)
- [ ] Cloud deployment (PR #11 - Optional)

## License

See LICENSE file for details.

## Interview Focus Areas

This project demonstrates:
- **Event-driven architecture** with Kafka
- **Horizontal scalability** patterns
- **Microservices** design
- **Real-time data processing**
- **Cloud-native** deployment (Docker + Kubernetes)

For detailed architecture and design decisions, see [SPEC.md](SPEC.md).

