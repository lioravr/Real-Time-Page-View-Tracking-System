.PHONY: help up down build logs clean test health kafka-topics redis-cli

# Default target
help:
	@echo "Real-Time Page View Tracking System - Available Commands:"
	@echo ""
	@echo "  make up              - Start all services"
	@echo "  make down            - Stop all services"
	@echo "  make build           - Build all Docker images"
	@echo "  make logs            - View logs from all services"
	@echo "  make clean           - Remove all containers, volumes, and images"
	@echo "  make health          - Check health of all services"
	@echo "  make kafka-topics    - List Kafka topics"
	@echo "  make redis-cli       - Open Redis CLI"
	@echo "  make test            - Run end-to-end test"
	@echo ""

# Start all services
up:
	docker compose up -d
	@echo "Waiting for services to be ready..."
	@sleep 10
	@echo "Services are starting up!"
	@echo ""
	@echo "Access points:"
	@echo "  - API Gateway:    http://localhost:8080/health"
	@echo "  - Kafka UI:       http://localhost:8090"
	@echo "  - Redis:          localhost:6379"

# Stop all services
down:
	docker compose down

# Build all images
build:
	docker compose build

# View logs
logs:
	docker compose logs -f

# Clean everything
clean:
	docker compose down -v
	docker system prune -f

# Check service health
health:
	@echo "Checking API Gateway..."
	@curl -s http://localhost:8080/health | python3 -m json.tool || echo "API Gateway not responding"
	@echo ""
	@echo "Checking Redis..."
	@docker exec redis redis-cli ping || echo "Redis not responding"
	@echo ""
	@echo "Checking Kafka..."
	@docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list || echo "Kafka not responding"

# List Kafka topics
kafka-topics:
	docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list

# Create the views topic manually (optional, auto-created by default)
kafka-create-topic:
	docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 \
		--create --topic views --partitions 3 --replication-factor 1

# Open Redis CLI
redis-cli:
	docker exec -it redis redis-cli

# Run a simple end-to-end test
test:
	@echo "Testing API Gateway health endpoint..."
	@curl -s http://localhost:8080/health | python3 -m json.tool
	@echo ""
	@echo "Testing Redis connection..."
	@docker exec redis redis-cli ping
	@echo ""
	@echo "Testing Kafka topics..."
	@docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list

