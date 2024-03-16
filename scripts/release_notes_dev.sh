#!/bin/bash
# This script generates changelog based on commits since provided commit

#Generate release note based on environment
generate_release_note_spiel() {
  local env="$1"
  local version="$2"
  local actualReleaseNotes="$3"

  printf "[%s]PASA\nEnv: %s\nVersion: %s\nRelease Notes: %s" "$env" "$env" "$version" "$actualReleaseNotes"
}

if [ -z "$1" ]; then
  echo "No previous commit provided, will use latest commit"
  changeLog=$(git log --pretty=format:'%B' HEAD^1..HEAD)
  # Write to a file
  generate_release_note_spiel "DEV" "$2.$3" "$changeLog" >> dev_notes.txt
  exit 0
fi

# Get the commit list between the last successful build and the current build, remove empty lines
changeLog=$(git log --pretty=format:'%B' "$1"..HEAD | sed '/^\s*$/d')

# Trim to avoid Firebase App Distribution length limit
trimmed=$(echo "$changeLog" | cut -c 1-16000)

# Write to a file
generate_release_note_spiel "DEV" "$2.$3" "$trimmed" >> dev_notes.txt
