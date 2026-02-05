.PHONY: dev css watch-css build clean stop

# Development mode with proper process management
dev:
	@chmod +x dev.sh
	@./dev.sh

# Watch CSS only (for separate terminal)
watch-css:
	@echo "Watching CSS changes..."
	./tailwindcss-linux-x64 -i ./static/input.css -o ./static/output.css --minify --watch

# Build CSS once
css:
	@echo "Building CSS..."
	./tailwindcss-linux-x64 -i ./static/input.css -o ./static/output.css --minify

# Build production binary
build:
	@echo "Building application..."
	templ generate
	go build -o ./tmp/main .

# Clean build artifacts
clean:
	@echo "Cleaning up..."
	rm -rf tmp/
	rm -f static/output.css

# Stop any orphaned processes (emergency cleanup)
stop:
	@echo "Stopping orphaned processes..."
	@pkill -f "air" || true
	@pkill -f "tailwindcss-linux-x64" || true
	@pkill -f "tmp/main" || true
	@echo "All processes stopped." 