# !/usr/bin/env sh

SCRIPT_PATH=$(dirname "$0")
SCRIPT_DIR=$(realpath "$SCRIPT_PATH")

# Use glob to find all setup.sh files in subdirectories
setup_files=( "$SCRIPT_DIR"/**/setup.sh )

# Loop through each setup.sh file and source it
for file in "${setup_files[@]}"; do
  source "$file"
done

# Run all functions with prefix "setup_": e.g. setup_vscode, setup_git, etc.
for func in $(declare -F | awk '{print $3}' | grep "^setup_.*"); do
    type $func >/dev/null 2>&1 && $func "$SCRIPT_DIR"
done
