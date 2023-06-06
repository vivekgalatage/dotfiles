# !/usr/bin/env sh

git_config() {
  # if test -e "$HOME"/.gitconfig; then
  #   echo "Config exists"
  # fi
}

setup_git() {
  SCRIPT_DIR="$1"
  printf "Setting up git: "
  # Setup all the git
  for func in $(declare -F | awk '{print $3}' | grep "^git_.*"); do
      type $func >/dev/null 2>&1 && $func "$SCRIPT_DIR"
  done
  echo "🟢 Done"
}
