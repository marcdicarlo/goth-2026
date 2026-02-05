#!/usr/bin/env python3
"""
conventional_commit.py - Generate conventional commit messages

Analyzes staged changes and generates a conventional commit message
following the format: <type>(<scope>): <description>

Usage: python conventional_commit.py
"""

import subprocess
import sys
import re
from typing import List, Tuple, Optional


COMMIT_TYPES = {
    "feat": "A new feature",
    "fix": "A bug fix",
    "docs": "Documentation only changes",
    "style": "Changes that don't affect code meaning (formatting, etc.)",
    "refactor": "Code change that neither fixes a bug nor adds a feature",
    "perf": "Performance improvement",
    "test": "Adding or updating tests",
    "build": "Changes to build system or dependencies",
    "ci": "Changes to CI configuration",
    "chore": "Other changes that don't modify src or test files",
}


def get_staged_files() -> List[str]:
    """Get list of staged files."""
    result = subprocess.run(
        ["git", "diff", "--cached", "--name-only"],
        capture_output=True,
        text=True,
    )
    return [f for f in result.stdout.strip().split("\n") if f]


def get_diff_stats() -> Tuple[int, int]:
    """Get number of insertions and deletions."""
    result = subprocess.run(
        ["git", "diff", "--cached", "--numstat"],
        capture_output=True,
        text=True,
    )
    insertions = deletions = 0
    for line in result.stdout.strip().split("\n"):
        if line:
            parts = line.split("\t")
            if len(parts) >= 2:
                try:
                    insertions += int(parts[0]) if parts[0] != "-" else 0
                    deletions += int(parts[1]) if parts[1] != "-" else 0
                except ValueError:
                    pass
    return insertions, deletions


def infer_scope(files: List[str]) -> Optional[str]:
    """Infer scope from changed files."""
    if not files:
        return None

    # Extract first directory or filename
    for f in files:
        parts = f.split("/")
        if len(parts) > 1:
            # Use first directory as scope
            return parts[0]
        # Use filename without extension
        return parts[0].split(".")[0]
    return None


def infer_type(files: List[str]) -> str:
    """Infer commit type from changed files."""
    # Check for test files
    if any("test" in f.lower() or "spec" in f.lower() for f in files):
        return "test"

    # Check for docs
    if any(f.endswith((".md", ".txt", ".rst")) for f in files):
        return "docs"

    # Check for CI/build files
    if any(f in files for f in [".github", "Makefile", "package.json", "go.mod"]):
        return "build"

    # Default to feat for new files, fix for modifications
    result = subprocess.run(
        ["git", "diff", "--cached", "--diff-filter=A", "--name-only"],
        capture_output=True,
        text=True,
    )
    new_files = result.stdout.strip().split("\n")

    if len(new_files) > len(files) / 2:
        return "feat"
    return "fix"


def main():
    # Check if there are staged changes
    staged_files = get_staged_files()
    if not staged_files:
        print("❌ No staged changes found. Stage changes with 'git add' first.")
        sys.exit(1)

    # Get diff stats
    insertions, deletions = get_diff_stats()

    # Infer type and scope
    commit_type = infer_type(staged_files)
    scope = infer_scope(staged_files)

    # Display analysis
    print("\n📊 Staged Changes Analysis:")
    print(f"   Files: {len(staged_files)}")
    print(f"   +{insertions} -{deletions}")
    print(f"\n   Changed files:")
    for f in staged_files[:10]:  # Show first 10
        print(f"   - {f}")
    if len(staged_files) > 10:
        print(f"   ... and {len(staged_files) - 10} more")

    print(f"\n💡 Suggested commit type: {commit_type}")
    if scope:
        print(f"   Suggested scope: {scope}")

    # Prompt for commit message
    print("\n📝 Commit Types:")
    for t, desc in COMMIT_TYPES.items():
        marker = "→" if t == commit_type else " "
        print(f"   {marker} {t}: {desc}")

    # Get user input
    print()
    selected_type = input(f"Type [{commit_type}]: ").strip() or commit_type

    if selected_type not in COMMIT_TYPES:
        print(f"❌ Invalid type: {selected_type}")
        sys.exit(1)

    selected_scope = input(f"Scope [{scope or 'none'}]: ").strip() or scope
    description = input("Description: ").strip()

    if not description:
        print("❌ Description is required")
        sys.exit(1)

    # Build commit message
    if selected_scope:
        message = f"{selected_type}({selected_scope}): {description}"
    else:
        message = f"{selected_type}: {description}"

    # Ask for confirmation
    print(f"\n✅ Commit message:")
    print(f"   {message}")
    confirm = input("\nProceed with commit? (y/n): ").strip().lower()

    if confirm == "y":
        subprocess.run(["git", "commit", "-m", message])
        print("✅ Committed successfully")
    else:
        print("❌ Commit cancelled")


if __name__ == "__main__":
    main()
