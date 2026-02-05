# GitHub CLI (gh) Command Reference

Quick reference for common `gh` operations.

## Pull Requests

### List PRs
```bash
gh pr list                           # All open PRs
gh pr list --state all               # All PRs (open, closed, merged)
gh pr list --author @me              # Your PRs
gh pr list --label bug               # PRs with "bug" label
gh pr list --search "is:open draft"  # Open draft PRs
```

### View PR
```bash
gh pr view <number>                  # View PR details
gh pr view <number> --web            # Open in browser
gh pr diff <number>                  # View diff
gh pr checks <number>                # View CI/CD status
```

### Create PR
```bash
gh pr create                                    # Interactive
gh pr create --title "Title" --body "Body"     # Non-interactive
gh pr create --draft                            # Create as draft
gh pr create --base main --head feature/branch # Specify branches
gh pr create --assignee @me                     # Assign to yourself
gh pr create --label bug,urgent                 # Add labels
```

### Review PR
```bash
gh pr review <number>                # Interactive review
gh pr review <number> --approve      # Approve
gh pr review <number> --comment      # Comment only
gh pr review <number> --request-changes --body "Changes needed"
```

### Merge PR
```bash
gh pr merge <number>                 # Interactive (choose merge type)
gh pr merge <number> --squash        # Squash and merge
gh pr merge <number> --merge         # Create merge commit
gh pr merge <number> --rebase        # Rebase and merge
gh pr merge <number> --delete-branch # Delete branch after merge
```

### Update PR
```bash
gh pr edit <number> --title "New title"
gh pr edit <number> --add-label bug
gh pr edit <number> --remove-label wip
gh pr edit <number> --add-reviewer username
```

### PR Status
```bash
gh pr status                         # PRs related to current repo
gh pr checks                         # CI/CD checks for current branch
```

## Issues

### List Issues
```bash
gh issue list                        # All open issues
gh issue list --state all            # All issues
gh issue list --assignee @me         # Assigned to you
gh issue list --label bug            # Issues with "bug" label
gh issue list --author username      # Created by user
```

### View Issue
```bash
gh issue view <number>               # View issue details
gh issue view <number> --web         # Open in browser
gh issue view <number> --comments    # Include comments
```

### Create Issue
```bash
gh issue create                              # Interactive
gh issue create --title "Title" --body "Body"
gh issue create --label bug,high-priority
gh issue create --assignee @me
gh issue create --milestone v1.0
```

### Update Issue
```bash
gh issue edit <number> --title "New title"
gh issue edit <number> --add-label bug
gh issue edit <number> --add-assignee username
```

### Close/Reopen Issue
```bash
gh issue close <number>
gh issue close <number> --comment "Fixed in PR #123"
gh issue reopen <number>
```

## Workflows (CI/CD)

### List Workflow Runs
```bash
gh run list                          # Recent workflow runs
gh run list --workflow tests.yml     # Specific workflow
gh run list --branch main            # Runs on main branch
```

### View Workflow Run
```bash
gh run view <run-id>                 # View run details
gh run view <run-id> --log           # View logs
gh run view <run-id> --web           # Open in browser
```

### Re-run Workflow
```bash
gh run rerun <run-id>                # Re-run failed jobs
gh run rerun <run-id> --failed       # Re-run only failed
```

### Watch Workflow
```bash
gh run watch <run-id>                # Live updates
```

## Repository

### View Repo
```bash
gh repo view                         # Current repo
gh repo view owner/repo              # Specific repo
gh repo view --web                   # Open in browser
```

### Clone Repo
```bash
gh repo clone owner/repo
gh repo clone owner/repo target-dir
```

### Create Repo
```bash
gh repo create                       # Interactive
gh repo create my-repo --public
gh repo create my-repo --private
```

### Fork Repo
```bash
gh repo fork                         # Fork current repo
gh repo fork owner/repo              # Fork specific repo
gh repo fork --clone                 # Fork and clone
```

## Authentication

```bash
gh auth login                        # Login to GitHub
gh auth status                       # Check auth status
gh auth logout                       # Logout
```

## Useful Flags

### Global Flags
```bash
--repo owner/repo                    # Specify repo
--web                                # Open in browser
--json                               # JSON output
--jq <query>                         # Filter JSON with jq
```

### Examples with Flags
```bash
# Get PR titles as JSON
gh pr list --json number,title

# Get PR author with jq
gh pr view 123 --json author --jq '.author.login'

# Open specific repo's PRs in browser
gh pr list --repo owner/repo --web
```

## Linking Issues to PRs

### In PR Description
```markdown
Fixes #123
Closes #456
Resolves #789
```

### In Commit Message
```bash
git commit -m "fix: resolve memory leak

Fixes #123"
```

### Using gh CLI
```bash
# Create PR that closes issue
gh pr create --title "Fix bug" --body "Fixes #123"
```

## Tips

1. **Use aliases** - Create shell aliases for common commands:
   ```bash
   alias ghp='gh pr'
   alias ghi='gh issue'
   alias ghv='gh pr view'
   ```

2. **Set defaults** - Configure default base branch:
   ```bash
   gh config set editor vim
   gh config set git_protocol ssh
   ```

3. **Use templates** - Create PR/Issue templates in `.github/`:
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/ISSUE_TEMPLATE/bug_report.md`

4. **Search syntax** - Use GitHub search syntax:
   ```bash
   gh pr list --search "is:open label:bug author:@me"
   gh issue list --search "is:closed label:enhancement"
   ```
