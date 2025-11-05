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

### 1. Initialize Go Module

```bash
go mod init github.com/<your-username>/Real-Time-Page-View-Tracking-System
```

### 2. Run Locally (Coming Soon)

```bash
docker-compose up
```

### 3. Test the API (Coming Soon)

```bash
curl -X POST http://localhost:8080/api/v1/track \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "page_url": "/home",
    "timestamp": 1730814562
  }'
```

## Development Progress

- [x] Project initialization
- [ ] API Gateway implementation
- [ ] Processor Service implementation
- [ ] Docker setup
- [ ] Kubernetes deployment
- [ ] Cloud deployment

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

