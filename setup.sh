# !/usr/bin/env sh

SCRIPT_PATH=$(dirname "$0")
SCRIPT_DIR=$(realpath "$SCRIPT_PATH")

source "$SCRIPT_DIR/vscode/setup.sh"

# Run all functions with name "foo"
for func in $(declare -F | awk '{print $3}' | grep "^setup_.*"); do
    type $func >/dev/null 2>&1 && $func "$SCRIPT_DIR"
done
