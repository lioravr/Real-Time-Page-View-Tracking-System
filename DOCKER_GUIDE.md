# Docker Compose Guide

This guide explains how to run the entire Real-Time Page View Tracking System using Docker Compose.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- At least 4GB RAM allocated to Docker

## Quick Start

### 1. Start All Services

```bash
# Using Makefile (recommended)
make up

# Or using docker-compose directly
docker-compose up -d
```

This starts:
- **Zookeeper** (port 2181) - Kafka coordinator
- **Kafka** (ports 9092, 9093) - Message broker
- **Redis** (port 6379) - Real-time data store
- **API Gateway** (port 8080) - HTTP API
- **Kafka UI** (port 8090) - Web UI for Kafka

### 2. Check Service Health

```bash
make health

# Or manually
curl http://localhost:8080/health
```

### 3. View Logs

```bash
# All services
make logs

# Specific service
docker-compose logs -f api-gateway
docker-compose logs -f kafka
docker-compose logs -f redis
```

### 4. Stop Services

```bash
make down
```

## Service Details

### API Gateway (Port 8080)

**Health Check:**
```bash
curl http://localhost:8080/health
```

**Expected Response:**
```json
{
  "status": "ok",
  "service": "api-gateway",
  "message": "API Gateway is running"
}
```

### Kafka (Ports 9092/9093)

**List Topics:**
```bash
make kafka-topics

# Or directly
docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list
```

**Create Views Topic (auto-created by default):**
```bash
make kafka-create-topic
```

**Describe Topic:**
```bash
docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 \
  --describe --topic views
```

**Consume Messages (for testing):**
```bash
docker exec kafka kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic views \
  --from-beginning
```

### Redis (Port 6379)

**Open Redis CLI:**
```bash
make redis-cli

# Or directly
docker exec -it redis redis-cli
```

**Common Redis Commands:**
```bash
# Check if Redis is running
PING

# View all page view counts
HGETALL page_views

# Get count for specific page
HGET page_views "/home"

# View all keys
KEYS *
```

### Kafka UI (Port 8090)

**Access Web Interface:**
```
http://localhost:8090
```

Features:
- View topics and messages
- Monitor consumer groups
- Inspect topic configurations
- Debug message flow

## Architecture Overview

```
Client → API Gateway (8080) → Kafka (9092) → Processor → Redis (6379)
                                    ↓
                               Kafka UI (8090)
```

## Common Tasks

### View Running Containers

```bash
docker-compose ps
```

### Restart a Service

```bash
docker-compose restart api-gateway
```

### Rebuild After Code Changes

```bash
docker-compose build api-gateway
docker-compose up -d api-gateway
```

### View Resource Usage

```bash
docker stats
```

### Clean Everything

```bash
# Remove containers and volumes
make clean

# Or manually
docker-compose down -v
docker system prune -f
```

## Troubleshooting

### Port Already in Use

If you see `port is already allocated`:

```bash
# Find what's using the port (e.g., 8080)
lsof -i :8080

# Kill the process
kill -9 <PID>

# Or change the port in docker-compose.yml
```

### Kafka Won't Start

**Issue**: Kafka stuck in restart loop

**Solution**:
```bash
# Clean Kafka data
docker-compose down -v
docker volume rm real-time-page-view-tracking-system_kafka_data
docker-compose up -d
```

### API Gateway Can't Connect to Kafka

**Check**: Ensure Kafka is healthy
```bash
docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list
```

If this fails, restart Kafka:
```bash
docker-compose restart kafka
sleep 10
docker-compose restart api-gateway
```

### Redis Connection Issues

```bash
# Check Redis is running
docker exec redis redis-cli ping

# View Redis logs
docker-compose logs redis
```

## Performance Tuning

### Kafka Configuration

Edit `docker-compose.yml` to add:

```yaml
environment:
  - KAFKA_CFG_NUM_PARTITIONS=3
  - KAFKA_CFG_DEFAULT_REPLICATION_FACTOR=1
  - KAFKA_CFG_LOG_RETENTION_HOURS=168
```

### Redis Configuration

```yaml
command: redis-server --maxmemory 256mb --maxmemory-policy allkeys-lru
```

## Development Workflow

### 1. Make Code Changes

Edit files in `cmd/api-gateway/` or `cmd/processor-service/`

### 2. Rebuild & Restart

```bash
docker-compose build api-gateway
docker-compose up -d api-gateway
```

### 3. View Logs

```bash
docker-compose logs -f api-gateway
```

### 4. Test

```bash
curl http://localhost:8080/health
```

## Network Details

All services run on a custom bridge network: `page-view-network`

**Internal Service Communication:**
- Services use container names as hostnames
- `api-gateway` connects to `kafka:9092`
- `processor` connects to `kafka:9092` and `redis:6379`

**External Access:**
- API Gateway: `localhost:8080`
- Kafka: `localhost:9093` (external listener)
- Redis: `localhost:6379`
- Kafka UI: `localhost:8090`

## Data Persistence

Volumes are created for data persistence:
- `zookeeper_data` - Zookeeper state
- `kafka_data` - Kafka topics and logs
- `redis_data` - Redis snapshots

**To reset all data:**
```bash
docker-compose down -v
```

## Next Steps

Once Docker Compose is working:
1. Test the health endpoint
2. Verify Kafka topics are created
3. Check Redis connection
4. Move to PR #4: Implement `/track` endpoint
5. Build the Processor service (PR #5)

## Useful Commands Reference

```bash
# Start
make up

# Stop
make down

# Health check
make health

# View logs
make logs

# Clean up
make clean

# Redis CLI
make redis-cli

# Kafka topics
make kafka-topics

# Full test
make test
```

## Interview Talking Points

**Why Docker Compose?**
- Reproducible environment
- Easy local development
- Simulates production architecture
- Quick setup for new developers

**Service Dependencies:**
- Health checks ensure proper startup order
- Kafka waits for Zookeeper
- API Gateway waits for Kafka and Redis

**Networking:**
- Custom bridge network for service isolation
- Internal DNS resolution (container names)
- Port mapping for external access

Good luck! 🚀

