#!/bin/bash
# Generates static HTML documentation from Go code using godoc
# Output is placed in docs/ directory for GitHub Pages

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if godoc is installed
if ! command -v godoc &> /dev/null; then
    echo -e "${RED}Error: godoc is not installed${NC}"
    echo "Install with: go install golang.org/x/tools/cmd/godoc@latest"
    exit 1
fi

# Get the module name from go.mod
if [ ! -f "go.mod" ]; then
    echo -e "${RED}Error: go.mod not found. Run this script from the project root.${NC}"
    exit 1
fi

MODULE_NAME=$(grep -m1 '^module ' go.mod | awk '{print $2}')
if [ -z "$MODULE_NAME" ]; then
    echo -e "${RED}Error: Could not extract module name from go.mod${NC}"
    exit 1
fi

echo -e "${GREEN}Generating documentation for module: ${MODULE_NAME}${NC}"

# Create docs directory
mkdir -p docs

# Start godoc server in background
echo -e "${YELLOW}Starting godoc server...${NC}"
godoc -http=:6060 &
GODOC_PID=$!

# Wait for server to start
sleep 2

# Function to cleanup godoc process
cleanup() {
    echo -e "${YELLOW}Stopping godoc server...${NC}"
    kill $GODOC_PID 2>/dev/null || true
}
trap cleanup EXIT

# Download the package documentation
echo -e "${YELLOW}Downloading documentation...${NC}"

# Download main package page
wget -q -O docs/index.html "http://localhost:6060/pkg/${MODULE_NAME}/" || {
    echo -e "${RED}Error: Failed to download main package documentation${NC}"
    exit 1
}

# Download all subpackages
find . -name "*.go" -type f | grep -v vendor | sed 's|/[^/]*$||' | sort -u | while read -r dir; do
    if [ -f "$dir/go.mod" ] && [ "$dir" != "." ]; then
        continue
    fi

    pkg_path="${dir#./}"
    if [ -n "$pkg_path" ]; then
        pkg_url="${MODULE_NAME}/${pkg_path}"
        output_dir="docs/${pkg_path}"
        mkdir -p "$output_dir"

        echo -e "${YELLOW}  - ${pkg_url}${NC}"
        wget -q -O "${output_dir}/index.html" "http://localhost:6060/pkg/${pkg_url}/" 2>/dev/null || true
    fi
done

# Download static assets (CSS, JS)
mkdir -p docs/lib/godoc
wget -q -r -np -nH -nd -P docs/lib/godoc \
    -A "*.css,*.js" \
    "http://localhost:6060/lib/godoc/" 2>/dev/null || true

# Create .nojekyll file to prevent GitHub Pages from ignoring files starting with _
touch docs/.nojekyll

# Create a simple README for the docs directory
cat > docs/README.md << 'EOF'
# Documentation

This directory contains auto-generated Go documentation for GitHub Pages.

The documentation is generated using `godoc` and should not be edited manually.

To regenerate the documentation, run:
```bash
bash scripts/generate_docs.sh
```

Visit the documentation at: https://[username].github.io/[repository]/
EOF

echo -e "${GREEN}✅ Documentation generated successfully in docs/${NC}"
echo -e "${YELLOW}Note: You may need to configure GitHub Pages to serve from the docs/ directory${NC}"
echo -e "${YELLOW}Go to: Repository Settings > Pages > Source > Deploy from a branch > Select 'main' and '/docs'${NC}"
