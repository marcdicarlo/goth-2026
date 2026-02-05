---
name: godoc-documenter
description: Add godoc-compatible comments to Go code and generate static HTML documentation for GitHub Pages. Use when working with Go projects for (1) adding or improving code documentation comments, (2) generating godoc HTML output, (3) setting up documentation for GitHub Pages, or (4) ensuring code follows godoc conventions. Triggers on requests like "document this code", "add godoc comments", "generate docs", or "update documentation".
---

# Godoc Documenter

Add godoc-compatible documentation comments to Go code and generate static HTML documentation suitable for GitHub Pages.

## Workflow

### 1. Adding Documentation Comments

Use a Haiku subagent to add or improve godoc comments in Go code:

```
Task tool with subagent_type="general-purpose", model="haiku"
```

Provide the subagent with:
- File paths to document
- Reference to `references/godoc-conventions.md` for style guidance
- Instruction to add complete, idiomatic godoc comments

The subagent should:
1. Read the Go files
2. Read `references/godoc-conventions.md`
3. Add godoc comments following conventions:
   - Package comment in main package file or `doc.go`
   - Function comments starting with function name
   - Type and struct comments
   - Exported identifiers documented
4. Ensure comments are complete sentences
5. Verify no blank lines between comments and declarations

### 2. Generating HTML Documentation

After documentation comments are added, generate static HTML:

Run the documentation generator script:

```bash
bash .claude/skills/godoc-documenter/scripts/generate_docs.sh
```

This script:
1. Checks for `godoc` installation (installs if needed: `go install golang.org/x/tools/cmd/godoc@latest`)
2. Extracts module name from `go.mod`
3. Starts temporary godoc server
4. Downloads HTML documentation for all packages
5. Creates `docs/` directory with:
   - Package HTML files
   - Static assets (CSS, JS)
   - `.nojekyll` file for GitHub Pages
   - README with setup instructions

### 3. GitHub Pages Setup

After generation, instruct the user to configure GitHub Pages:

1. Go to repository Settings → Pages
2. Set Source to "Deploy from a branch"
3. Select branch: `main` (or primary branch)
4. Select folder: `/docs`
5. Save

Documentation will be available at: `https://[username].github.io/[repository]/`

## Quick Reference

For detailed godoc conventions, the subagent should read `references/godoc-conventions.md`.

**Key conventions:**
- Comment directly precedes declaration (no blank line)
- Start with element name: `// HelloHandler handles...`
- Use complete sentences
- Package comments at top of file or in `doc.go`
- Deprecation: `// Deprecated: Use NewFunc instead.`
- Bugs: `// BUG(username): Description of known issue.`

## Resources

- `scripts/generate_docs.sh` - Generates static HTML documentation from Go code
- `references/godoc-conventions.md` - Complete godoc commenting style guide
