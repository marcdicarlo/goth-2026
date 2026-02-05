# Git Workflows Reference

Common git workflows and decision trees for the gitops skill.

## Workflow Decision Tree

```
User Request
│
├─ Branch Operations
│  ├─ Create → git checkout -b <name>
│  ├─ Switch → git checkout <name>
│  ├─ Delete → git branch -d <name> (or -D for force)
│  └─ List → git branch -a
│
├─ Commit Operations
│  ├─ Stage changes → git add <files>
│  ├─ Smart commit → scripts/conventional_commit.py
│  └─ Amend → git commit --amend
│
├─ Sync Operations
│  ├─ Pull latest → scripts/sync_branch.sh
│  ├─ Push → git push (or git push -u origin <branch>)
│  └─ Sync with conflicts → scripts/sync_branch.sh (offers rebase/merge/lazygit)
│
├─ Pull Request Operations
│  ├─ Create PR → scripts/pr_template.sh or gh pr create
│  ├─ View PRs → gh pr list
│  ├─ Review PR → gh pr view <number> (then gh pr review)
│  ├─ Merge PR → gh pr merge <number>
│  └─ Check status → gh pr status
│
└─ Issue Operations
   ├─ List issues → gh issue list
   ├─ View issue → gh issue view <number>
   ├─ Create issue → gh issue create
   ├─ Close issue → gh issue close <number>
   └─ Link to PR → mention #<issue> in PR description
```

## Standard Workflows

### Daily Development Workflow

1. **Start work on feature**
   ```bash
   git checkout main
   scripts/sync_branch.sh main
   git checkout -b feature/new-feature
   ```

2. **Make changes and commit**
   ```bash
   git add <files>
   scripts/conventional_commit.py
   ```

3. **Push and create PR**
   ```bash
   git push -u origin feature/new-feature
   scripts/pr_template.sh main
   ```

### Review and Merge Workflow

1. **Review PR**
   ```bash
   gh pr list
   gh pr view <number>
   gh pr diff <number>
   gh pr checks <number>
   ```

2. **Provide feedback**
   ```bash
   gh pr review <number> --comment
   # or
   gh pr review <number> --approve
   # or
   gh pr review <number> --request-changes
   ```

3. **Merge PR**
   ```bash
   gh pr merge <number> --squash  # or --merge or --rebase
   ```

### Conflict Resolution Workflow

When `sync_branch.sh` detects conflicts:

1. **Option 1: Rebase (recommended)**
   - Replays local commits on top of remote
   - Cleaner history
   - May require resolving conflicts per commit

2. **Option 2: Merge**
   - Creates merge commit
   - Preserves all history
   - Single conflict resolution

3. **Option 3: Use lazygit**
   - Visual interface for complex conflicts
   - Interactive staging/unstaging
   - Better for reviewing large diffs

### Hotfix Workflow

```bash
# Create hotfix branch from main
git checkout main
scripts/sync_branch.sh main
git checkout -b hotfix/critical-bug

# Make fix and commit
git add <files>
scripts/conventional_commit.py

# Push and create urgent PR
git push -u origin hotfix/critical-bug
gh pr create --base main --title "Hotfix: Critical bug" --label urgent
```

## When to Use Lazygit

Use `lazygit` for:
- ✅ **Interactive rebase** - Reorder, squash, edit commits visually
- ✅ **Complex conflict resolution** - Side-by-side diff view
- ✅ **Selective staging** - Stage hunks or individual lines
- ✅ **Browsing history** - Visual commit graph
- ✅ **Stash management** - View, apply, drop stashes interactively

Use `git` commands for:
- ✅ **Scripted operations** - Automation and CI/CD
- ✅ **Simple operations** - Checkout, add, commit, push
- ✅ **Remote operations** - Fetch, pull with specific options

Use `gh` CLI for:
- ✅ **PR operations** - Create, review, merge PRs
- ✅ **Issue management** - Track and organize issues
- ✅ **CI/CD checks** - View workflow runs and status
- ✅ **Repo management** - Create repos, manage settings

## Conventional Commit Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `style` - Formatting
- `refactor` - Code restructuring
- `test` - Tests
- `chore` - Maintenance

**Examples:**
```
feat(auth): add OAuth2 login support
fix(api): handle null response from user endpoint
docs(readme): update installation instructions
refactor(middleware): simplify error handling
```

## Branch Naming Conventions

```
feature/<description>  - New features
fix/<description>      - Bug fixes
hotfix/<description>   - Urgent production fixes
docs/<description>     - Documentation updates
refactor/<description> - Code refactoring
test/<description>     - Test additions/updates
```

Examples:
- `feature/user-authentication`
- `fix/memory-leak-in-parser`
- `hotfix/critical-security-patch`
- `docs/api-endpoint-guide`
