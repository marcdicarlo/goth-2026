// Package middleware provides HTTP middleware components for the application.
//
// This package includes common middleware functions for request/response
// processing and a utility to compose multiple middleware into a stack.
package middleware

import (
	"log"
	"net/http"
	"time"
)

// Middleware is a function that wraps an http.Handler to add additional functionality.
//
// Middleware functions follow the standard pattern of taking an http.Handler
// and returning a new http.Handler that can perform operations before and/or
// after calling the wrapped handler.
type Middleware func(http.Handler) http.Handler

// LoggingMiddleware logs HTTP request details including method, path, and duration.
//
// For each request, it logs:
//   - HTTP method (GET, POST, etc.)
//   - Request URL path
//   - Total request duration
//
// Example output: "GET /api/users 15.2ms"
func LoggingMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		next.ServeHTTP(w, r)
		log.Println(r.Method, r.URL.Path, time.Since(start))
	})
}

// CreateStack composes multiple middleware functions into a single middleware.
//
// Middleware are applied in the order provided. For example:
//
//	stack := CreateStack(
//	    LoggingMiddleware,
//	    AuthMiddleware,
//	)
//
// This will apply LoggingMiddleware first, then AuthMiddleware, then the final handler.
// The request flows through middleware in order, and responses flow back in reverse order.
func CreateStack(xs ...Middleware) Middleware {
	return func(next http.Handler) http.Handler {
		for i := len(xs) - 1; i >= 0; i-- {
			next = xs[i](next)
		}
		return next
	}
}
