# API Gateway Service

The API Gateway service accepts HTTP requests for tracking page view events and publishes them to Kafka.

## Features

- **Health Check**: `GET /health` - Returns service health status
- **Event Tracking**: `POST /api/v1/track` (Coming in PR #4)

## Running Locally

### Prerequisites
- Go 1.21+
- Docker (for containerized deployment)

### Using Go

```bash
# From project root
go run cmd/api-gateway/main.go
```

### Using Docker

```bash
# Build
docker build -t api-gateway -f cmd/api-gateway/Dockerfile .

# Run
docker run -p 8080:8080 api-gateway
```

## Testing

### Health Check

```bash
curl http://localhost:8080/health
```

Expected response:
```json
{
  "status": "ok",
  "service": "api-gateway",
  "message": "API Gateway is running"
}
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| PORT | Server port | 8080 |
| GIN_MODE | Gin mode (debug/release) | debug |

## API Endpoints

### GET /health
Returns the health status of the service.

**Response:**
```json
{
  "status": "ok",
  "service": "api-gateway",
  "message": "API Gateway is running"
}
```

**Status Codes:**
- `200 OK`: Service is healthy

## Architecture Notes

### Why Gin?
- Lightweight and fast HTTP router
- Similar to Express.js (Node) or Sinatra (Ruby)
- Middleware support for logging, auth, etc.
- Great for building RESTful APIs

### Design Decisions
- **Port Configuration**: Uses environment variable for flexibility
- **Health Check**: Essential for Kubernetes liveness/readiness probes
- **Structured Logging**: Uses Go's standard log package
- **Graceful Error Handling**: Logs errors and provides meaningful HTTP responses

## Coming Next (PR #4)

- POST /api/v1/track endpoint
- Request validation
- Kafka producer integration
- Event publishing to `views` topic

