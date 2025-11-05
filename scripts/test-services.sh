#!/bin/bash
# Test all services in the Page View Tracking System

set -e

echo "🧪 Testing Real-Time Page View Tracking System"
echo "=============================================="
echo ""

# Test API Gateway
echo "1️⃣  Testing API Gateway..."
HEALTH_RESPONSE=$(curl -s http://localhost:8080/health)
if echo "$HEALTH_RESPONSE" | grep -q "ok"; then
    echo "   ✅ API Gateway is healthy"
    echo "   Response: $HEALTH_RESPONSE"
else
    echo "   ❌ API Gateway health check failed"
    exit 1
fi
echo ""

# Test Redis
echo "2️⃣  Testing Redis..."
REDIS_RESPONSE=$(docker exec redis redis-cli ping)
if [ "$REDIS_RESPONSE" = "PONG" ]; then
    echo "   ✅ Redis is responding"
else
    echo "   ❌ Redis is not responding"
    exit 1
fi
echo ""

# Test Kafka
echo "3️⃣  Testing Kafka..."
TOPICS=$(docker exec kafka kafka-topics.sh --bootstrap-server localhost:9092 --list 2>/dev/null)
if [ $? -eq 0 ]; then
    echo "   ✅ Kafka is responding"
    echo "   Topics: $TOPICS"
else
    echo "   ❌ Kafka is not responding"
    exit 1
fi
echo ""

# Test Zookeeper
echo "4️⃣  Testing Zookeeper..."
ZK_STATUS=$(docker exec zookeeper zkServer.sh status 2>&1 | grep Mode || echo "")
if [ -n "$ZK_STATUS" ]; then
    echo "   ✅ Zookeeper is running"
else
    echo "   ⚠️  Zookeeper status unknown (this is okay if Kafka works)"
fi
echo ""

echo "=============================================="
echo "✅ All services are healthy!"
echo ""
echo "Access points:"
echo "  - API Gateway:    http://localhost:8080/health"
echo "  - Kafka UI:       http://localhost:8090"
echo "  - Redis CLI:      make redis-cli"
echo "  - Kafka Topics:   make kafka-topics"

