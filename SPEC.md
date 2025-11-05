# Real-Time Page View Tracking System

## Overview
This project implements a distributed, real-time event processing system designed to track and aggregate page view events at scale. The system receives page view events through an HTTP API, publishes them to a Kafka topic for decoupled and reliable processing, and consumes these events to update aggregated view counters stored in Redis. Optionally, raw events can be archived to Amazon S3 for long-term analytics or machine learning pipelines.

The architectural focus is on **scalability**, **loose coupling**, and **clear separation of responsibilities** between services.

## High-Level Architecture

Client / Browser
       |
       v
HTTP API Gateway (Go + Gin)
       |
       v
Kafka Topic: `views`
       |
       v
Processor Service (Go)
       |
       +--> Redis (HINCRBY page_views <page_url> +1)
       |
       +--> (Optional) S3 Archival of raw events

## Components

### 1. API Gateway (`api-gateway`)
Responsible for accepting external HTTP traffic and publishing validated events to Kafka.

- Exposes `POST /api/v1/track`
- Validates request payload
- Serializes event as JSON
- Produces event to Kafka topic `views`
- Implemented in Go using the `Gin` web framework
- Packaged and deployed as a container

#### Example Request Payload:
```json
{
  "user_id": "abc123",
  "page_url": "/products/item-42",
  "timestamp": 1730814562
}
```

### 2. Kafka (Message Broker)
Provides a reliable, scalable event streaming pipeline.

- Topic: `views`
- Ensures event ordering, durability, and horizontal scalability
- Decouples ingestion from processing
- Allows multiple consumers for future analytics, ML, or monitoring services

### 3. Processor Service (`processor-service`)
Consumes events from Kafka and applies business logic.

- Deserializes event JSON
- Extracts `page_url`
- Updates Redis counter:
  ```
  HINCRBY page_views <page_url> 1
  ```
- Optionally writes raw event payload to S3 for archival
- Implemented in Go
- Designed to scale horizontally by increasing consumer group instances

### 4. Redis (Real-Time Aggregation Store)
Maintains real-time page view counters.

- Data Model:
  ```
  Hash Key: page_views
    /home          -> 120
    /products/42   -> 57
    /about         -> 14
  ```
- Chosen for low-latency read/write and in-memory performance

### 5. Optional: Amazon S3 Archival
Long-term event storage for offline analytics.

- Events stored as raw JSON objects
- Allows later analysis with Athena, BigQuery, Pandas, Spark, etc.

## API Specification

### Endpoint
```
POST /api/v1/track
```

### Request Body
| Field      | Type   | Required | Description                 |
|-----------|--------|----------|-----------------------------|
| user_id   | string | yes      | Unique identifier of user   |
| page_url  | string | yes      | URL of the viewed page      |
| timestamp | int    | yes      | Unix timestamp of the event |

### Example cURL
```bash
curl -X POST http://<host>/api/v1/track   -H "Content-Type: application/json"   -d '{"user_id":"user123","page_url":"/home","timestamp":1730814562}'
```

## Deployment

| Environment | Deployment Method | Notes |
|------------|------------------|-------|
| Local Dev   | Docker + Minikube / Kubernetes | Used for iterative development |
| Cloud       | GKE / EKS / AKS (Kubernetes)   | Images stored in container registry |

All infrastructure and configuration are managed with Kubernetes manifests under `k8s/`.

## Scaling Considerations

| Component         | Scaling Strategy                 |
|------------------|----------------------------------|
| API Gateway       | Horizontal Pod Autoscaling       |
| Kafka             | Add partitions / brokers         |
| Processor Service | Increase consumer group members  |
| Redis             | Use Redis Cluster / Sharding     |

## Summary
This system demonstrates a clean, production-style architecture for real-time event processing, using industry-standard technologies (Go, Kafka, Redis, Kubernetes). The result is a scalable, fault-tolerant, and easily extensible system suitable for real-world workloads and a strong demonstration in technical interviews.

