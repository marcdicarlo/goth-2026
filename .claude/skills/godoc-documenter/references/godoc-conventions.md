# Godoc Comment Conventions

Quick reference for writing effective godoc comments.

## Core Principles

1. **Comment directly precedes declaration** - No blank lines between comment and code
2. **Start with element name** - First sentence begins with the name being documented
3. **Use complete sentences** - Comments should be grammatically correct sentences
4. **No special syntax required** - Just write good, readable comments

## Package Comments

Place at the top of any file (commonly `doc.go` for large packages):

```go
// Package middleware provides HTTP middleware functions for the GOTH stack.
// It includes logging, authentication, and request handling utilities.
package middleware
```

**For large packages**, create a dedicated `doc.go`:

```go
// Package handlers implements HTTP request handlers for the GOTH web application.
//
// This package provides handlers that integrate with Templ components to render
// HTML responses. Each handler follows the pattern:
//   1. Parse request parameters
//   2. Invoke business logic
//   3. Render Templ component
//   4. Write HTTP response
//
// Example usage:
//
//     mux.HandleFunc("/", handlers.HelloHandler)
//     mux.HandleFunc("/users", handlers.UserListHandler)
package handlers
```

## Function Comments

Start with function name, describe what it does, parameters, and return values:

```go
// CreateStack chains multiple middleware functions into a single middleware.
// It applies middleware in reverse order, so the first middleware in the slice
// is executed first. Returns a combined Middleware function.
func CreateStack(xs ...Middleware) Middleware {
```

```go
// HelloHandler serves the hello page using the Hello Templ component.
// It renders the component directly to the HTTP response writer.
func HelloHandler(w http.ResponseWriter, r *http.Request) {
```

## Type Comments

Describe what the type represents:

```go
// Middleware wraps an http.Handler to add preprocessing or postprocessing logic.
// Middleware functions can be chained using CreateStack.
type Middleware func(http.Handler) http.Handler
```

```go
// User represents an authenticated user in the system.
type User struct {
    ID       int64  // Unique user identifier
    Username string // Display name
    Email    string // Contact email address
}
```

## Struct Field Comments

Add inline comments for clarity, especially for non-obvious fields:

```go
type Config struct {
    Port     string        // HTTP server port (default: "8080")
    Timeout  time.Duration // Request timeout duration
    LogLevel string        // Logging level: debug, info, warn, error
}
```

## Variable and Constant Comments

```go
// DefaultPort is the port used when PORT environment variable is not set.
const DefaultPort = "8080"

// ErrInvalidUser is returned when user validation fails.
var ErrInvalidUser = errors.New("invalid user")
```

## Formatting Rules

### Paragraphs

Separate paragraphs with blank comment lines:

```go
// LoadConfig reads configuration from environment variables and returns a Config.
//
// It checks for PORT, TIMEOUT, and LOG_LEVEL variables. If any are missing,
// default values are used.
//
// Returns an error if the configuration is invalid.
func LoadConfig() (*Config, error) {
```

### Code Examples

Indent code blocks relative to comment text:

```go
// Usage example:
//
//     stack := middleware.CreateStack(
//         middleware.LoggingMiddleware,
//         middleware.AuthMiddleware,
//     )
//     server.Handler = stack(mux)
```

### Lists

Use standard list formatting:

```go
// Supported operations:
//   - Create new resources
//   - Update existing resources
//   - Delete resources
//   - List all resources
```

### URLs

URLs are automatically converted to links:

```go
// See https://pkg.go.dev/golang.org/x/tools/cmd/godoc for more details.
```

## Special Annotations

### Deprecation

```go
// Deprecated: Use NewHandler instead. This function will be removed in v2.0.
func OldHandler() {
```

### Known Bugs

```go
// BUG(username): This function does not handle Unicode properly.
```

## Examples to Avoid

❌ **Don't** start with "This function..."
```go
// This function handles hello requests
func HelloHandler(w http.ResponseWriter, r *http.Request) {
```

✅ **Do** start with the function name
```go
// HelloHandler handles hello requests
func HelloHandler(w http.ResponseWriter, r *http.Request) {
```

❌ **Don't** add blank lines between comment and declaration
```go
// HelloHandler handles hello requests

func HelloHandler(w http.ResponseWriter, r *http.Request) {
```

✅ **Do** keep comment adjacent
```go
// HelloHandler handles hello requests
func HelloHandler(w http.ResponseWriter, r *http.Request) {
```

❌ **Don't** use vague descriptions
```go
// Handles stuff
func Process() {
```

✅ **Do** be specific
```go
// Process validates user input and updates the database
func Process() {
```
