#!/usr/bin/env bash
# sync_branch.sh - Smart branch synchronization with remote
#
# Usage: sync_branch.sh [branch_name]
# If no branch provided, syncs current branch

set -e

BRANCH="${1:-$(git branch --show-current)}"
REMOTE="origin"

echo "Syncing branch: $BRANCH"

# Fetch latest from remote
git fetch "$REMOTE" "$BRANCH"

# Check if remote branch exists
if ! git rev-parse "$REMOTE/$BRANCH" >/dev/null 2>&1; then
    echo "Remote branch $REMOTE/$BRANCH does not exist."
    echo "Push current branch to create it? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git push -u "$REMOTE" "$BRANCH"
        echo "✅ Branch pushed to remote"
    fi
    exit 0
fi

# Check if local is behind remote
LOCAL=$(git rev-parse @)
REMOTE_REV=$(git rev-parse "$REMOTE/$BRANCH")
BASE=$(git merge-base @ "$REMOTE/$BRANCH")

if [ "$LOCAL" = "$REMOTE_REV" ]; then
    echo "✅ Already up to date"
elif [ "$LOCAL" = "$BASE" ]; then
    echo "Local is behind remote. Fast-forward merge..."
    git merge --ff-only "$REMOTE/$BRANCH"
    echo "✅ Fast-forwarded to $REMOTE/$BRANCH"
elif [ "$REMOTE_REV" = "$BASE" ]; then
    echo "✅ Local is ahead of remote (ready to push)"
else
    echo "⚠️  Branches have diverged"
    echo "Options:"
    echo "  1) Rebase local commits on top of remote (recommended)"
    echo "  2) Merge remote into local"
    echo "  3) Open lazygit to resolve manually"
    read -r -p "Choose (1/2/3): " choice

    case $choice in
        1)
            git rebase "$REMOTE/$BRANCH"
            echo "✅ Rebased on $REMOTE/$BRANCH"
            ;;
        2)
            git merge "$REMOTE/$BRANCH"
            echo "✅ Merged $REMOTE/$BRANCH"
            ;;
        3)
            lazygit
            ;;
        *)
            echo "Invalid choice. Exiting."
            exit 1
            ;;
    esac
fi
