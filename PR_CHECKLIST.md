# Pull Request Checklist

Track your development progress through focused, incremental PRs.

## ✅ PR #1: Initial Project Skeleton
**Status**: COMPLETED ✓  
**Branch**: `main` → `feat/project-init`

- [x] Create `.gitignore` with Go-specific patterns
- [x] Initialize `go.mod` 
- [x] Add `SPEC.md` (project specification)
- [x] Create `README.md` with architecture overview
- [x] Create `SETUP.md` with installation instructions
- [x] Create project directory structure:
  - [x] `cmd/` - Service entry points
  - [x] `internal/` - Internal packages
  - [x] `k8s/` - Kubernetes manifests
- [x] Create placeholder `main.go`

**Commit Message**: `feat: initialize project structure with Go modules and documentation`

---

## 🔄 PR #2: Add Gin Framework & Health Check
**Status**: PENDING  
**Branch**: `main` → `feat/api-gateway-health`  
**Estimated Time**: 2-3 hours

**Tasks**:
- [ ] Install Gin framework: `go get -u github.com/gin-gonic/gin`
- [ ] Create `cmd/api-gateway/main.go`
- [ ] Implement `GET /health` endpoint
- [ ] Add basic logging
- [ ] Test endpoint with curl
- [ ] Create `Dockerfile` for api-gateway
- [ ] Test Docker build: `docker build -t api-gateway .`

**Success Criteria**:
```bash
curl http://localhost:8080/health
# Response: {"status": "ok"}
```

**Commit Message**: `feat(api-gateway): add Gin framework and health check endpoint`

---

## 📋 PR #3: Docker Compose Setup
**Status**: PENDING  
**Branch**: `main` → `feat/docker-compose`  
**Estimated Time**: 2 hours

**Tasks**:
- [ ] Create `docker-compose.yml`
- [ ] Add Kafka service (Bitnami image)
- [ ] Add Zookeeper service (required for Kafka)
- [ ] Add Redis service
- [ ] Add api-gateway service
- [ ] Test: `docker-compose up`
- [ ] Verify all services healthy

**Success Criteria**:
```bash
docker-compose ps
# All services show "Up"
```

**Commit Message**: `feat: add docker-compose for local development`

---

## 🚀 PR #4: Implement /track Endpoint
**Status**: PENDING  
**Branch**: `main` → `feat/track-endpoint`  
**Estimated Time**: 3-4 hours

**Tasks**:
- [ ] Create `internal/models/event.go` (TrackRequest struct)
- [ ] Add request validation
- [ ] Install Kafka client: `go get github.com/confluentinc/confluent-kafka-go/kafka`
- [ ] Create `internal/kafka/producer.go`
- [ ] Implement `POST /api/v1/track` endpoint
- [ ] Publish events to Kafka topic `views`
- [ ] Add error handling
- [ ] Test with Postman/curl

**Success Criteria**:
```bash
curl -X POST http://localhost:8080/api/v1/track \
  -H "Content-Type: application/json" \
  -d '{"user_id":"user123","page_url":"/home","timestamp":1730814562}'
# Response: {"status": "accepted"}
```

**Commit Message**: `feat(api-gateway): implement track endpoint with Kafka producer`

---

## 🔧 PR #5: Processor Service - Kafka Consumer
**Status**: PENDING  
**Branch**: `main` → `feat/processor-consumer`  
**Estimated Time**: 3 hours

**Tasks**:
- [ ] Create `cmd/processor-service/main.go`
- [ ] Implement Kafka consumer
- [ ] Subscribe to `views` topic
- [ ] Parse JSON events
- [ ] Add logging for received events
- [ ] Add graceful shutdown
- [ ] Create `Dockerfile` for processor

**Success Criteria**:
- Processor logs show received events
- No crashes or panics

**Commit Message**: `feat(processor): implement Kafka consumer service`

---

## 📊 PR #6: Redis Integration
**Status**: PENDING  
**Branch**: `main` → `feat/redis-integration`  
**Estimated Time**: 2-3 hours

**Tasks**:
- [ ] Install Redis client: `go get github.com/redis/go-redis/v9`
- [ ] Create `internal/redis/client.go`
- [ ] Implement `HINCRBY page_views <page_url> 1`
- [ ] Integrate with processor service
- [ ] Test end-to-end pipeline
- [ ] Verify counts in Redis: `redis-cli HGETALL page_views`

**Success Criteria**:
```bash
# Send event via API
curl -X POST http://localhost:8080/api/v1/track -d '...'

# Check Redis
redis-cli
> HGETALL page_views
# Shows: /home -> 1 (or incremented count)
```

**Commit Message**: `feat(processor): add Redis integration for page view counters`

---

## 📦 PR #7: S3 Archival (OPTIONAL)
**Status**: PENDING (Low Priority)  
**Branch**: `main` → `feat/s3-archival`  
**Estimated Time**: 2-3 hours

**Tasks**:
- [ ] Install AWS SDK: `go get github.com/aws/aws-sdk-go/aws`
- [ ] Create `internal/storage/s3.go`
- [ ] Upload raw events to S3
- [ ] Make it configurable (env variable)
- [ ] Test with LocalStack or real S3 bucket

**Note**: Skip if running behind schedule. Can explain conceptually in interview.

**Commit Message**: `feat(processor): add optional S3 archival for raw events`

---

## 🐳 PR #8: Dockerize Services
**Status**: PENDING  
**Branch**: `main` → `feat/dockerfiles`  
**Estimated Time**: 2-3 hours

**Tasks**:
- [ ] Create `cmd/api-gateway/Dockerfile`
- [ ] Create `cmd/processor-service/Dockerfile`
- [ ] Use multi-stage builds (optimization)
- [ ] Update `docker-compose.yml` to use local images
- [ ] Test: `docker-compose build && docker-compose up`

**Success Criteria**:
- Both services run as containers
- Full pipeline works in Docker

**Commit Message**: `build: add Dockerfiles for api-gateway and processor services`

---

## ☸️ PR #9: Kubernetes Manifests
**Status**: PENDING  
**Branch**: `main` → `feat/kubernetes`  
**Estimated Time**: 4-5 hours

**Tasks**:
- [ ] Install Minikube/kind
- [ ] Create `k8s/redis-deployment.yaml`
- [ ] Create `k8s/kafka-deployment.yaml` (or use Helm)
- [ ] Create `k8s/api-gateway-deployment.yaml`
- [ ] Create `k8s/api-gateway-service.yaml`
- [ ] Create `k8s/processor-deployment.yaml`
- [ ] Create `k8s/configmap.yaml`
- [ ] Deploy: `kubectl apply -f k8s/`
- [ ] Test with port-forward

**Success Criteria**:
```bash
kubectl get pods
# All pods running

kubectl port-forward svc/api-gateway 8080:8080
# Can access API via localhost:8080
```

**Commit Message**: `feat(k8s): add Kubernetes manifests for all services`

---

## 📝 PR #10: Documentation & Polish
**Status**: PENDING  
**Branch**: `main` → `feat/documentation`  
**Estimated Time**: 2-3 hours

**Tasks**:
- [ ] Update `README.md` with complete instructions
- [ ] Add architecture diagram (draw.io/Excalidraw)
- [ ] Document environment variables
- [ ] Add troubleshooting section
- [ ] Create `INTERVIEW_PREP.md` with talking points
- [ ] Add example API requests
- [ ] Final testing & screenshots

**Commit Message**: `docs: comprehensive documentation and interview preparation guide`

---

## 🌐 PR #11: Cloud Deployment (OPTIONAL)
**Status**: PENDING (Low Priority)  
**Branch**: `main` → `feat/cloud-deploy`  
**Estimated Time**: 3-4 hours

**Tasks**:
- [ ] Choose cloud provider (GKE/EKS/AKS)
- [ ] Push images to container registry
- [ ] Create cloud cluster
- [ ] Deploy manifests
- [ ] Test with external IP
- [ ] Document deployment steps

**Note**: Only if local K8s works perfectly and you have time.

**Commit Message**: `feat(cloud): deploy to GKE/EKS with external access`

---

## Progress Overview

**Completed**: 1/11 PRs  
**Current Phase**: Day 1 - Setup & Foundation  
**Next Up**: Install Go, then start PR #2  

## Daily Goals Tracker

### Day 1 (Wednesday) - Target: PR #1 ✅, PR #2 ⬜
- [x] Environment setup
- [x] PR #1: Project skeleton
- [ ] PR #2: Health check endpoint

### Day 2 (Thursday) - Target: PR #3, PR #4
- [ ] Docker Compose setup
- [ ] Implement /track endpoint

### Day 3 (Friday) - Target: PR #5, PR #6
- [ ] Processor service with Kafka consumer
- [ ] Redis integration

### Day 4 (Saturday) - Target: PR #8, PR #9
- [ ] Dockerize services
- [ ] Kubernetes deployment

### Day 5 (Sunday) - Target: PR #10
- [ ] Documentation
- [ ] Interview preparation
- [ ] Final polish

---

**Remember**: Quality over quantity. A working, well-explained subset is better than a broken complete system!

