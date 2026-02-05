// Package handlers provides HTTP request handlers for the application.
//
// Handlers are responsible for processing HTTP requests and generating
// responses using Templ components for HTML rendering.
package handlers

import (
	"net/http"

	"goth/internal/components"
)

// HelloHandler serves the hello page using the Hello Templ component.
//
// This handler demonstrates the basic pattern used throughout the application:
//  1. Create a Templ component
//  2. Render it to the response writer using the request context
//
// The handler responds to all HTTP methods at the root path (/).
func HelloHandler(w http.ResponseWriter, r *http.Request) {
	component := components.Hello()
	component.Render(r.Context(), w)
}
