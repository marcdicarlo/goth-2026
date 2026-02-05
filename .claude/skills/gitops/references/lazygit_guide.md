# Lazygit Usage Guide

When and how to use lazygit for complex git operations.

## When to Launch Lazygit

Launch `lazygit` when the user needs:

1. **Interactive Rebase**
   - Reorder commits
   - Squash multiple commits
   - Edit commit messages
   - Drop commits

2. **Complex Conflict Resolution**
   - Side-by-side diff view
   - Multiple conflicting files
   - Visual merge conflict resolution

3. **Selective Staging**
   - Stage specific hunks
   - Stage individual lines
   - Review changes visually before staging

4. **Visual History Navigation**
   - Browse commit graph
   - Compare branches visually
   - View file history

5. **Stash Management**
   - View stash contents
   - Apply/pop stashes selectively
   - Create named stashes

## How to Launch Lazygit

```bash
# Launch in current directory
lazygit

# Launch and focus on a specific screen
lazygit --filter=<branch-name>
```

## Key Bindings (Quick Reference)

### Navigation
- `1-5` - Switch panels (Status, Files, Branches, Commits, Stash)
- `[` / `]` - Previous/next tab
- `j/k` or `↓/↑` - Navigate list
- `h/l` or `←/→` - Navigate panes
- `q` - Quit/close panel
- `esc` - Cancel/back

### Files Panel
- `space` - Stage/unstage file
- `a` - Stage/unstage all
- `d` - View discard options
- `e` - Edit file
- `o` - Open file
- `c` - Commit changes
- `enter` - View file diff

### Commits Panel
- `enter` - View commit files
- `space` - Checkout commit
- `c` - Checkout commit
- `g` - Reset to commit
- `n` - Create new branch from commit
- `r` - Reword commit message
- `d` - Delete commit
- `e` - Edit commit (rebase)
- `p` - Pick commit (cherry-pick)
- `s` - Squash commit (interactive rebase)

### Branches Panel
- `space` - Checkout branch
- `n` - New branch
- `r` - Rebase branch
- `M` - Merge into current branch
- `d` - Delete branch
- `u` - Set upstream
- `enter` - View commits

### Stash Panel
- `space` - Apply stash
- `g` - Pop stash
- `d` - Drop stash
- `n` - New stash
- `enter` - View stash contents

### General
- `P` - Push
- `p` - Pull
- `f` - Fetch
- `R` - Refresh
- `x` - Open command menu
- `?` - Help/keybindings

## Common Workflows in Lazygit

### Interactive Rebase

1. Navigate to **Commits** panel (`2`)
2. Highlight the commit BEFORE the ones you want to modify
3. Press `e` to start interactive rebase
4. For each commit:
   - `s` - Squash with previous
   - `r` - Reword message
   - `d` - Drop commit
   - `↓/↑` - Reorder (move commit up/down)
5. Press `enter` to continue
6. Resolve any conflicts in **Files** panel
7. Press `enter` to continue rebase

### Conflict Resolution

1. Pull/merge/rebase shows conflicts in **Files** panel
2. Select conflicted file and press `enter`
3. Choose merge tool or edit manually:
   - `space` - Pick left/right side for whole file
   - `e` - Edit file manually
   - In editor: resolve conflicts, save, and exit
4. Stage resolved file with `space`
5. Press `c` to commit merge/continue rebase

### Selective Staging

1. Navigate to **Files** panel (`1`)
2. Select unstaged file
3. Press `enter` to view diff
4. Navigate to hunk or line
5. Press `space` to stage hunk
6. Or press `a` to stage all hunks
7. Press `tab` to toggle between staged/unstaged view
8. When ready, press `c` to commit

### Stash Workflow

1. Navigate to **Files** panel
2. Press `s` to stash changes
3. Enter stash message
4. Later: Navigate to **Stash** panel (`5`)
5. Select stash
6. Press `space` to apply (keep stash) or `g` to pop (apply and delete)

## Integration with Scripts

The gitops skill uses lazygit as an escape hatch for complex operations:

```bash
# In sync_branch.sh, when branches diverge:
echo "Options:"
echo "  3) Open lazygit to resolve manually"
read choice
case $choice in
    3) lazygit ;;
esac
```

## Tips

1. **Use command log** - Press `x` to see recent commands (learn what lazygit does)

2. **Custom config** - Create `~/.config/lazygit/config.yml` for customization:
   ```yaml
   gui:
     theme:
       lightTheme: false
     showFileTree: true
   ```

3. **Mouse support** - Click to navigate (if terminal supports it)

4. **Copy commit hash** - Navigate to commit and press `y` to copy SHA

5. **Filter commits** - Press `/` in commits panel to search

6. **Undo** - Press `z` to undo last action

## When NOT to Use Lazygit

Avoid lazygit for:
- ❌ Simple staging and commits (use `git add` and `scripts/conventional_commit.py`)
- ❌ Pushing/pulling without conflicts (use `git push/pull` or `scripts/sync_branch.sh`)
- ❌ Creating PRs (use `scripts/pr_template.sh` or `gh pr create`)
- ❌ Reviewing PRs (use `gh pr view` and `gh pr review`)
- ❌ Managing issues (use `gh issue` commands)
- ❌ Scripted/automated operations (use git commands)

Lazygit is for **interactive visualization and manipulation**, not for routine operations.
