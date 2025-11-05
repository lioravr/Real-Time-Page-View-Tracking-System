# Setup Instructions

This guide will help you set up your development environment for the Real-Time Page View Tracking System.

## Day 1 Setup Checklist

### Step 1: Install Go

#### macOS (using Homebrew)
```bash
brew install go
```

#### Manual Installation
1. Download Go from https://go.dev/dl/
2. Install the package
3. Verify installation:
```bash
go version
# Should show: go version go1.21.x or higher
```

### Step 2: Configure Go Environment

Add to your `~/.zshrc` (macOS/Linux):
```bash
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
```

Then reload:
```bash
source ~/.zshrc
```

### Step 3: Install Docker Desktop

1. Download from https://www.docker.com/products/docker-desktop
2. Install and start Docker Desktop
3. Verify:
```bash
docker --version
docker-compose --version
```

### Step 4: Install VS Code Extensions

Install these extensions in VS Code:
- **Go** (by Go Team at Google) - Essential for Go development
- **Docker** (by Microsoft) - For Dockerfile syntax
- **Kubernetes** (by Microsoft) - For K8s YAML files

### Step 5: Verify Go Installation

Navigate to the project directory and run:
```bash
cd /Users/lior.a/Cursor/Real-Time-Page-View-Tracking-System
go version
go mod tidy
go run main.go
```

You should see:
```
Real-Time Page View Tracking System
Project initialized successfully!
...
```

## Go Learning Resources (Quick Start)

### Essential Concepts (1-2 hours)
1. **A Tour of Go**: https://go.dev/tour/
   - Focus on: Basics, Flow control, Structs, Methods
   - Skip: Concurrency (for now), Advanced topics

### Go vs .NET Quick Reference

| .NET Concept | Go Equivalent |
|--------------|---------------|
| `namespace` | `package` |
| `class` | `struct` + methods |
| `interface` | `interface` (similar!) |
| `async/await` | `goroutines` + `channels` |
| `try/catch` | explicit error returns |
| `null` | `nil` |
| `var x = new Type()` | `x := Type{}` |

### Key Differences Coming from .NET

1. **No classes, use structs**:
```go
// .NET style (conceptually)
class User {
    public string Name;
}

// Go style
type User struct {
    Name string
}
```

2. **Error handling - no exceptions**:
```go
// Go returns errors explicitly
result, err := SomeFunction()
if err != nil {
    // Handle error
    return err
}
// Use result
```

3. **Package system**:
```go
// One package per directory
package main  // executable
package models // library

// Import from go.mod path
import "github.com/lior-a/project/internal/models"
```

4. **Interfaces are implicit**:
```go
// Define interface
type Reader interface {
    Read() string
}

// Any type with Read() method implements it automatically
// No explicit "implements" keyword needed!
```

## Next Steps

Once setup is complete:
1. ✅ PR #1 is done (project skeleton)
2. 📝 Move to PR #2 (basic HTTP server with Gin)

## Troubleshooting

### "command not found: go"
- Make sure Go is installed: `brew install go`
- Check PATH includes Go: `echo $PATH`

### "cannot find module"
- Run: `go mod tidy`
- This downloads dependencies

### Docker issues
- Ensure Docker Desktop is running
- Try: `docker ps` to verify

## Time Estimate

- **Installation**: 30-45 minutes
- **Go basics learning**: 1-2 hours
- **Verification**: 15 minutes

**Total**: ~2-3 hours for Day 1 setup

---

Need help? Check:
- Go documentation: https://go.dev/doc/
- Gin framework: https://gin-gonic.com/docs/
- Your .NET knowledge translates well to Go!

