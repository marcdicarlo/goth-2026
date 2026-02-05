# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a "GOTH stack" web application boilerplate combining:

- **Go** (v1.24.2+) - Backend server using stdlib `net/http`
- **Templ** - Type-safe HTML templating that compiles to Go code
- **TailwindCSS** (v4.1.18) - Styling via standalone CLI binary (no npm)
- **HTMX** - Dynamic HTML interactions loaded via CDN

The stack also includes Basecoat (component library) loaded via CDN for Tailwind-native components.

## **Always do**

- when generating output to .md files for user review place them in tmp/
- ask for permission for destructive commands such as deleting files even with bypass permissions on
- group tasks into logical small stories and use the gitops skill to create a new branch to work in
- use the gitops skill to commit all changes when the story is complete

## **Never do**

- download or install npm or node packages. this project is meant to me technologies in the project overview
- `rm -rf` command without permission

## Architecture

### Request Flow

1. HTTP request → `main.go` server → middleware stack → mux router
2. Handler in `internal/handlers/` invokes a Templ component from `internal/components/`
3. Templ component renders HTML with TailwindCSS classes
4. Response served with static assets from `/static/`

### Directory Structure

- `main.go` - HTTP server setup with graceful shutdown, static file serving, and middleware stack
- `internal/handlers/` - HTTP handlers (take request, invoke component, write response)
- `internal/components/` - Templ components (`.templ` files compile to `_templ.go` files)
- `internal/middleware/` - Middleware stack pattern with chainable middleware functions
- `static/` - Static assets (`input.css` → compiled to `output.css` by Tailwind)

### Key Patterns

- **Middleware**: Uses functional middleware pattern via `CreateStack()` in `middleware.go:19-26`
- **Templ Components**: `.templ` files generate `_templ.go` files. Components have a `Render(ctx, w)` method
- **Base Layout**: `components.Base()` provides the HTML shell with CDN includes for HTMX and Basecoat

## Development Commands

### Initial Setup

```sh
# Download TailwindCSS standalone binary (only needed once)
#check before downloading
wget https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.6/tailwindcss-linux-x64
chmod +x tailwindcss-linux-x64
```

### Development Workflow

```sh
# Start dev server with hot reload (Air) + CSS watch
make dev

# Or run separately:
air                    # Hot reload Go server on .go/.templ changes
make watch-css         # Watch and rebuild CSS on changes
```

### Building

```sh
# Generate Templ components and build binary
make build

# Just compile CSS (without watch)
make css

# Generate Templ files only
templ generate
```

### Cleaning

```sh
make clean  # Remove tmp/ and compiled CSS
```

## Important Notes

### Templ Workflow

- Edit `.templ` files, NOT `_templ.go` files (auto-generated)
- Run `templ generate` or `make build` to compile templates to Go code
- Air watches `.templ` files and auto-generates on change

### TailwindCSS

- Uses standalone binary (`tailwindcss-linux-x64`), not npm/node
- Input: `static/input.css` → Output: `static/output.css`
- The binary must be present in project root (gitignored)

### Environment Variables

- `PORT` - Server port (defaults to 8080)
- Uses `godotenv/autoload` - automatically loads `.env` if present

### Static Files

- Served at `/static/` path from `static/` directory
- Include compiled CSS as `/static/output.css` in templates

### CDN Dependencies

Currently using CDN for:

- HTMX - Dynamic HTML interactions
- Basecoat - Tailwind-native component library (framework-agnostic, HTMX-compatible)

Local TailwindCSS v4 output is also included for custom styling.
