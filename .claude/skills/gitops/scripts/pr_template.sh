#!/usr/bin/env bash
# pr_template.sh - Create pull request with smart defaults
#
# Usage: pr_template.sh [base_branch]
# Default base branch: main

set -e

BASE_BRANCH="${1:-main}"
CURRENT_BRANCH=$(git branch --show-current)

if [ "$CURRENT_BRANCH" = "$BASE_BRANCH" ]; then
    echo "❌ Cannot create PR from $BASE_BRANCH to itself"
    exit 1
fi

echo "Creating PR: $CURRENT_BRANCH → $BASE_BRANCH"

# Get commit history for this branch
COMMITS=$(git log "$BASE_BRANCH..$CURRENT_BRANCH" --oneline)
COMMIT_COUNT=$(echo "$COMMITS" | wc -l | tr -d ' ')

echo -e "\n📊 Changes in this branch:"
echo "   Commits: $COMMIT_COUNT"
echo "$COMMITS" | head -5

# Get diff stats
STATS=$(git diff "$BASE_BRANCH"..."$CURRENT_BRANCH" --shortstat)
echo "   $STATS"

# Generate title from branch name or first commit
TITLE=$(echo "$CURRENT_BRANCH" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
FIRST_COMMIT=$(git log "$BASE_BRANCH..$CURRENT_BRANCH" --format=%s -1)

echo -e "\n💡 Suggested title: $TITLE"
echo "   From first commit: $FIRST_COMMIT"

# Generate body from commit messages
BODY=$(git log "$BASE_BRANCH..$CURRENT_BRANCH" --format="- %s" | head -10)

echo -e "\n📝 Pull Request Details:"
read -p "Title [$TITLE]: " INPUT_TITLE
TITLE="${INPUT_TITLE:-$TITLE}"

echo -e "\nSummary (press Ctrl+D when done):"
SUMMARY=$(cat)

# Combine summary and commits
FULL_BODY="## Summary
${SUMMARY}

## Changes
${BODY}"

# Create PR
echo -e "\n🚀 Creating pull request..."
gh pr create \
    --base "$BASE_BRANCH" \
    --head "$CURRENT_BRANCH" \
    --title "$TITLE" \
    --body "$FULL_BODY"

echo "✅ Pull request created successfully"
