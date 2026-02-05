---
name: gitops
description: Intelligent git operations using git, gh CLI, and lazygit. Use for ANY git-related tasks including (1) branch management (create, switch, delete), (2) commits with conventional commit messages, (3) syncing branches (pull, push, rebase, merge), (4) pull request operations (create, review, merge, comment), (5) issue tracking (view, create, update, link to PRs), (6) conflict resolution, (7) interactive rebasing, or (8) any other git workflow. Always use this skill for git operations - it provides smart automation with user confirmation for destructive operations.
---

# GitOps Skill

Intelligent git operations combining `git`, `gh` CLI, and `lazygit` for streamlined development workflows.

## Overview

This skill provides an agent-based approach to git operations with smart automation and user confirmation for destructive operations. It uses:

- **git** - Core version control operations
- **gh CLI** - GitHub integration (PRs, issues, workflows)
- **lazygit** - Interactive TUI for complex operations
- **Helper scripts** - Smart automation for common workflows

## Agent Configuration

When using this skill, spawn an agent with:
- **Model**: Haiku (fast, cost-effective for git operations)
- **Tools**: Bash, Read, Grep, Glob (for analyzing repo state)
- **Behavior**: Smart automation with confirmation on destructive ops

Example agent invocation:
```
Task tool with:
- subagent_type: "general-purpose"
- model: "haiku"
- prompt: "Use the gitops skill to [user's git request]"
```

## Quick Decision Tree

```
User Request → Analyze → Choose Tool → Execute

Branch ops          → git commands
Simple commit       → scripts/conventional_commit.py
Sync branch         → scripts/sync_branch.sh
Create PR           → scripts/pr_template.sh
Review/merge PR     → gh pr commands
Manage issues       → gh issue commands
Complex conflicts   → lazygit
Interactive rebase  → lazygit
Visual staging      → lazygit
```

## Core Workflows

### 1. Branch Management

Create branch:
```bash
git checkout -b feature/branch-name
```

Switch branch:
```bash
git checkout branch-name
```

Delete branch:
```bash
git branch -d branch-name    # Safe delete
git branch -D branch-name    # Force delete (ask user first)
```

List branches:
```bash
git branch -a                # All branches
git branch -r                # Remote branches
```

### 2. Smart Commits

Use `scripts/conventional_commit.py` for commits:

```bash
# After staging files with git add
python3 scripts/conventional_commit.py
```

**Features:**
- Analyzes staged changes (files, insertions, deletions)
- Suggests commit type (feat, fix, docs, etc.)
- Infers scope from file paths
- Generates conventional commit message
- Interactive prompts for type, scope, description

**Example interaction:**
```
📊 Staged Changes Analysis:
   Files: 3
   +45 -12

   Changed files:
   - internal/handlers/auth.go
   - internal/middleware/jwt.go
   - go.mod

💡 Suggested commit type: feat
   Suggested scope: handlers

Type [feat]:
Scope [handlers]: auth
Description: add JWT authentication middleware

✅ Commit message:
   feat(auth): add JWT authentication middleware

Proceed with commit? (y/n):
```

### 3. Branch Synchronization

Use `scripts/sync_branch.sh` for intelligent syncing:

```bash
bash scripts/sync_branch.sh [branch-name]
```

**Behavior:**
- Fetches latest from remote
- Detects relationship: up-to-date, behind, ahead, or diverged
- For fast-forward: merges automatically
- For diverged branches: offers options:
  1. Rebase (recommended) - cleaner history
  2. Merge - creates merge commit
  3. Open lazygit - manual resolution

**Example:**
```
Syncing branch: feature/auth
⚠️  Branches have diverged
Options:
  1) Rebase local commits on top of remote (recommended)
  2) Merge remote into local
  3) Open lazygit to resolve manually
Choose (1/2/3):
```

### 4. Pull Requests

#### Create PR with Smart Defaults

Use `scripts/pr_template.sh`:

```bash
bash scripts/pr_template.sh [base-branch]
```

**Features:**
- Analyzes commit history
- Generates title from branch name or first commit
- Includes commit list in PR body
- Shows diff stats
- Interactive prompts

**Or use gh CLI directly:**
```bash
gh pr create --title "Title" --body "Description"
gh pr create --draft                    # Create draft PR
gh pr create --web                      # Open browser
```

#### Review PRs

```bash
gh pr list                              # List all PRs
gh pr view <number>                     # View PR details
gh pr diff <number>                     # View diff
gh pr checks <number>                   # CI/CD status

gh pr review <number> --approve
gh pr review <number> --comment --body "LGTM"
gh pr review <number> --request-changes --body "Please fix..."
```

#### Merge PRs

```bash
gh pr merge <number>                    # Interactive
gh pr merge <number> --squash           # Squash merge
gh pr merge <number> --merge            # Merge commit
gh pr merge <number> --rebase           # Rebase merge
gh pr merge <number> --delete-branch    # Delete after merge
```

### 5. Issue Management

```bash
# List issues
gh issue list
gh issue list --assignee @me
gh issue list --label bug

# View issue
gh issue view <number>

# Create issue
gh issue create --title "Title" --body "Description"
gh issue create --label bug,high-priority

# Update issue
gh issue edit <number> --add-label feature
gh issue edit <number> --add-assignee username

# Close issue
gh issue close <number>
gh issue close <number> --comment "Fixed in PR #123"
```

#### Link Issues to PRs

In PR description or commit message:
```
Fixes #123
Closes #456
Resolves #789
```

### 6. Complex Operations with Lazygit

Launch `lazygit` for:
- Interactive rebase (reorder, squash, edit commits)
- Complex conflict resolution (side-by-side diff)
- Selective staging (stage hunks or lines)
- Stash management (view, apply, pop)

```bash
lazygit
```

See [references/lazygit_guide.md](references/lazygit_guide.md) for detailed usage.

## Reference Files

Load these files as needed:

- **[workflows.md](references/workflows.md)** - Detailed workflows and decision trees
  - Daily development workflow
  - Review and merge workflow
  - Conflict resolution strategies
  - Hotfix workflow
  - Conventional commit format
  - Branch naming conventions

- **[gh_commands.md](references/gh_commands.md)** - Complete gh CLI reference
  - All PR commands with flags
  - Issue management commands
  - Workflow/CI commands
  - Search syntax and tips

- **[lazygit_guide.md](references/lazygit_guide.md)** - When and how to use lazygit
  - Key bindings quick reference
  - Interactive rebase workflow
  - Conflict resolution steps
  - Selective staging guide
  - When NOT to use lazygit

## Example User Requests

**"Create a new feature branch for user authentication"**
```bash
git checkout -b feature/user-authentication
```

**"Commit my changes with a proper commit message"**
```bash
# Agent checks staged files
git status

# If nothing staged, ask user to stage
git add <files>

# Then run conventional commit
python3 scripts/conventional_commit.py
```

**"Sync my branch with main"**
```bash
bash scripts/sync_branch.sh main
# Agent handles conflicts if needed
```

**"Create a pull request"**
```bash
bash scripts/pr_template.sh main
# Or for quick PR:
gh pr create --title "feat: add user auth" --body "Implements JWT authentication"
```

**"Review pull request #42"**
```bash
gh pr view 42
gh pr diff 42
gh pr checks 42
# After review:
gh pr review 42 --approve --body "Looks good!"
```

**"I have merge conflicts, help me resolve them"**
```bash
# Check conflict details
git status
git diff

# For complex conflicts, offer lazygit
echo "Conflicts detected. Options:"
echo "1) Resolve manually (edit files)"
echo "2) Open lazygit for visual resolution"
read choice

if [ "$choice" = "2" ]; then
    lazygit
fi
```

**"Squash my last 3 commits"**
```bash
# Launch lazygit for interactive rebase
lazygit
# Agent explains: Navigate to Commits panel, select commit before the 3,
# press 'e' for interactive rebase, then 's' to squash
```

**"List all open issues assigned to me"**
```bash
gh issue list --assignee @me --state open
```

**"Close issue #123 and link it to this PR"**
```bash
# In PR creation or commit message
gh pr create --body "Fixes #123"
# Or close directly
gh issue close 123 --comment "Fixed in PR #<number>"
```

## Best Practices

1. **Always fetch before operations**
   ```bash
   git fetch origin
   ```

2. **Check status frequently**
   ```bash
   git status
   git log --oneline -5
   ```

3. **Use conventional commits** - Helps with changelog generation and semantic versioning

4. **Prefer rebase over merge** - For cleaner history (but ask user for preference)

5. **Review before pushing**
   ```bash
   git diff origin/main...HEAD
   ```

6. **Use draft PRs** - For work in progress
   ```bash
   gh pr create --draft
   ```

7. **Link issues to PRs** - Better tracking and automatic closure

8. **Delete merged branches**
   ```bash
   gh pr merge <number> --delete-branch
   ```

## Safety Checks

Before destructive operations, always:

1. **Confirm with user** for:
   - Force push (`git push --force`)
   - Force delete branch (`git branch -D`)
   - Hard reset (`git reset --hard`)
   - Rewriting history on shared branches

2. **Check for uncommitted changes**
   ```bash
   if ! git diff-index --quiet HEAD --; then
       echo "⚠️  You have uncommitted changes"
   fi
   ```

3. **Verify branch name** before deleting
   ```bash
   current=$(git branch --show-current)
   if [ "$current" = "main" ]; then
       echo "❌ Cannot delete main branch"
   fi
   ```

## Troubleshooting

**"Port already in use" or similar git errors:**
- Check for background git processes
- Ensure git lock files aren't stuck: `rm -f .git/index.lock`

**"gh: command not found":**
- Install gh CLI: `brew install gh` or `apt install gh`
- Authenticate: `gh auth login`

**"lazygit: command not found":**
- Install: `brew install lazygit` or `apt install lazygit`

**"Failed to push - rejected":**
- Branch is behind: run `scripts/sync_branch.sh`
- Protected branch: create PR instead

**"Merge conflicts":**
- Use `scripts/sync_branch.sh` which offers conflict resolution options
- Or use `lazygit` for visual resolution

## Agent Workflow Pattern

When an agent uses this skill:

1. **Understand request** - Parse what user wants to accomplish
2. **Check repo state** - Run `git status`, `git branch`, etc.
3. **Choose appropriate tool**:
   - Simple operations → direct git commands
   - Smart commits → `conventional_commit.py`
   - Sync operations → `sync_branch.sh`
   - PRs → `pr_template.sh` or `gh pr`
   - Issues → `gh issue`
   - Complex ops → `lazygit`
4. **Execute with confirmation** - Ask before destructive operations
5. **Verify result** - Check status after operation
6. **Report back** - Summarize what was done

Example agent flow for "sync and create PR":
```bash
# 1. Check current state
git status
git branch --show-current

# 2. Sync branch
bash scripts/sync_branch.sh main

# 3. Push if needed
git push -u origin feature/branch

# 4. Create PR
bash scripts/pr_template.sh main

# 5. Report
echo "✅ Branch synced and PR created: [URL]"
```
