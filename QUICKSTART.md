# Quick Start Guide - PR #2

This guide helps you test the API Gateway service with health check endpoint.

## Step 1: Install Go (if not done)

### macOS
```bash
brew install go
```

### Verify Installation
```bash
go version
# Should show: go version go1.21.x or higher
```

## Step 2: Install Dependencies

```bash
cd /Users/lior.a/Cursor/Real-Time-Page-View-Tracking-System
go mod tidy
```

This will download:
- Gin framework
- All dependencies

## Step 3: Run the API Gateway

```bash
go run cmd/api-gateway/main.go
```

You should see:
```
[GIN-debug] GET    /health                   --> main.healthCheck (3 handlers)
[GIN-debug] Listening and serving HTTP on :8080
API Gateway starting on port 8080
```

## Step 4: Test the Health Endpoint

Open a new terminal and run:

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

## Step 5: Test with Docker (Optional)

### Build the Docker image
```bash
docker build -t api-gateway -f cmd/api-gateway/Dockerfile .
```

### Run the container
```bash
docker run -p 8080:8080 api-gateway
```

### Test it
```bash
curl http://localhost:8080/health
```

## Understanding the Code

### main.go Structure (Coming from .NET)

```go
package main  // Like a namespace, but one per directory

import (
    "github.com/gin-gonic/gin"  // Like using statements
)

func main() {  // Entry point, like Main() in C#
    router := gin.Default()  // Similar to WebApplication.CreateBuilder()
    
    // Define route - similar to app.MapGet("/health", ...)
    router.GET("/health", healthCheck)
    
    // Start server - like app.Run()
    router.Run(":8080")
}

// Handler function - similar to Controller action
func healthCheck(c *gin.Context) {
    c.JSON(200, gin.H{
        "status": "ok"
    })
}
```

### Key Differences from .NET

| .NET ASP.NET Core | Go + Gin |
|-------------------|----------|
| `[HttpGet("/health")]` | `router.GET("/health", handler)` |
| `return Ok(new {...})` | `c.JSON(200, gin.H{...})` |
| Controller classes | Simple functions |
| Dependency Injection | Manual passing or globals |
| `async Task<IActionResult>` | Return values + error |

## Common Issues

### "command not found: go"
Install Go: `brew install go`

### "package github.com/gin-gonic/gin is not in GOROOT"
Run: `go mod tidy`

### Port already in use
Change port:
```bash
PORT=8081 go run cmd/api-gateway/main.go
```

## What's Next?

Once this works:
- ✅ You have a working HTTP server in Go!
- ✅ You understand basic routing
- ✅ You can test with curl/Postman

**Next PR (#3)**: Set up Docker Compose with Kafka and Redis
**After that**: Implement the actual `/track` endpoint

## Quick Go Syntax Reference for .NET Developers

### Variables
```go
// .NET: var name = "value";
name := "value"  // := declares and assigns

// .NET: string name;
var name string

// .NET: const int Port = 8080;
const Port = 8080
```

### Functions
```go
// .NET: public string GetName() { return "name"; }
func GetName() string {
    return "name"
}

// .NET: public void Log(string msg) { }
func Log(msg string) {
    // no return value
}
```

### Error Handling
```go
// .NET: try { DoSomething(); } catch (Exception ex) { }
result, err := DoSomething()
if err != nil {
    // handle error
}
```

### Structs (like classes)
```go
// .NET: public class User { public string Name; }
type User struct {
    Name string
}

// Create instance
user := User{Name: "John"}
```

## Success Criteria for PR #2

- [x] Gin framework added to project
- [x] API Gateway service created
- [x] Health check endpoint implemented
- [x] Dockerfile created
- [ ] Successfully run: `go run cmd/api-gateway/main.go`
- [ ] Successfully test: `curl http://localhost:8080/health`
- [ ] (Optional) Successfully build Docker image

You're ready to commit when you can curl the health endpoint! 🚀

