# Go Documentation Hooks

Automatic Go code formatting and documentation checking when .go files are edited.

## What It Does

When you edit or write a `.go` file, the hook automatically:

1. **Auto-formats** the file using `gofmt`
2. **Checks** for missing godoc comments on exported identifiers
3. **Prompts** you to add documentation if missing comments are detected

## How It Works

### Hook Configuration

Location: `.claude/settings.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/go-doc-update.sh"
          }
        ]
      }
    ]
  }
}
```

### Hook Script

Location: `.claude/hooks/go-doc-update.sh`

The script:
- Receives tool usage data as JSON input
- Filters for `.go` files (excludes `_templ.go` generated files)
- Runs `gofmt` automatically to format code
- Scans for exported functions/types without godoc comments
- Outputs a prompt if missing documentation is found
- Rate-limited to once per minute to avoid spam

## Usage

### Automatic Behavior

When you edit a Go file:

```go
func HelloHandler(w http.ResponseWriter, r *http.Request) {
    // ...
}
```

You'll see:

```
📝 Documentation check: internal/handlers/hello.go

Missing godoc comments detected. To add documentation:
  /godoc-documenter

(This will spawn a Haiku agent to add proper godoc comments)
```

### Adding Documentation

When prompted, use the skill:

```
/godoc-documenter
```

This spawns a Haiku agent that:
1. Reads the godoc conventions guide
2. Adds proper documentation comments
3. Follows official Go documentation standards

## Features

### Auto-Formatting

Every Go file edit is automatically formatted with `gofmt`, ensuring consistent style.

### Smart Detection

The hook detects missing comments on:
- Exported functions (starting with capital letter)
- Exported types and structs
- Package declarations (separate check)

### Rate Limiting

To avoid overwhelming you with prompts, the hook only checks once per minute across all file edits.

### Recursion Protection

The hook skips generated files (`*_templ.go`) to avoid false positives.

## Limitations

### Why Not Fully Automatic?

Claude Code hooks run as shell scripts and cannot directly spawn Claude agents. The hook:
- ✅ Can run shell commands (gofmt, grep, etc.)
- ✅ Can output prompts to the conversation
- ❌ Cannot automatically spawn Haiku agents

This means you'll need to manually trigger `/godoc-documenter` when prompted, rather than having it run automatically.

### Alternative: Fully Manual

If you prefer no prompts, you can:
1. Remove the hook configuration
2. Run `/godoc-documenter` manually when you want to update documentation
3. Use `make build` which runs `templ generate` and compiles code

## Customization

### Adjust Rate Limiting

Edit `.claude/hooks/go-doc-update.sh` and change the timeout:

```bash
# Skip if less than 60 seconds since last check
if [ "$TIME_DIFF" -lt 60 ]; then
```

Change `60` to your preferred seconds.

### Disable Auto-Format

Comment out the gofmt line:

```bash
# Auto-format the Go file
# if command -v gofmt &> /dev/null; then
#   gofmt -w "$FILE_PATH" 2>/dev/null || true
# fi
```

### Add More Checks

You can extend the script to run:
- `go vet` for code issues
- `golint` for style issues
- `staticcheck` for static analysis

## Viewing Hook Activity

Use Claude Code's `/hooks` command to:
- View configured hooks
- See hook execution history
- Manage hook settings

## Troubleshooting

### Hook Not Running

Check that:
1. Script is executable: `chmod +x .claude/hooks/go-doc-update.sh`
2. Settings file is valid JSON: `.claude/settings.json`
3. Hook matcher pattern is correct: `"Edit|Write"`

### Too Many Prompts

The rate limiter should prevent spam, but if you're still getting too many prompts:
1. Increase the rate limit timeout (see Customization above)
2. Or disable the hook and run `/godoc-documenter` manually

### Hook Not Detecting Missing Docs

The detection uses simplified regex patterns. It may miss:
- Comments that don't start with `//` (/* */ style)
- Docs that exist but don't follow godoc conventions
- More complex export patterns

For comprehensive checking, use Go linters like `golint` or `staticcheck`.
