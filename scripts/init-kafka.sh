#!/bin/bash
# Initialize Kafka topics for the Page View Tracking System

set -e

echo "Waiting for Kafka to be ready..."
sleep 10

echo "Creating 'views' topic..."
docker exec kafka kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --create \
  --if-not-exists \
  --topic views \
  --partitions 3 \
  --replication-factor 1

echo "Listing all topics..."
docker exec kafka kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --list

echo "Describing 'views' topic..."
docker exec kafka kafka-topics.sh \
  --bootstrap-server localhost:9092 \
  --describe \
  --topic views

echo ""
echo "✅ Kafka topics initialized successfully!"

