# !/usr/bin/env sh

extension_config_notes()  {
    mkdir -p "$HOME/Documents/notes"
}

setup_vscode() {
    SCRIPT_DIR="$1"
    DOTFILES_VSCODE_USER_SETTINGS_FILE="$SCRIPT_DIR/vscode/settings.json"
    VSCODE_USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
    VSCODE_USER_SETTINGS_FILE="$VSCODE_USER_SETTINGS_DIR/settings.json"

    printf "Setting up Visual Studio Code: "
    if ! test -e "$DOTFILES_VSCODE_USER_SETTINGS_FILE"; then
        echo "🟠 Skipped for $DOTFILES_VSCODE_USER_SETTINGS_FILE not exists"
        return
    fi

    SUBSTITUTED_JSON_FILE="$(mktemp)".json
    jq  --arg \
        home "$HOME" \
        'walk(if type == "string" then gsub("\\$\\{HOME\\}"; $home) else . end)'\
        $DOTFILES_VSCODE_USER_SETTINGS_FILE > $SUBSTITUTED_JSON_FILE
    MERGED_JSON_FILE="$(mktemp)".json
    jq -s '.[0] * .[1]' "$VSCODE_USER_SETTINGS_FILE" "$SUBSTITUTED_JSON_FILE" > $MERGED_JSON_FILE
    cp "$MERGED_JSON_FILE" "$VSCODE_USER_SETTINGS_FILE"

    # Don't forget to cleanup the temporary files!
    rm "$SUBSTITUTED_JSON_FILE"
    rm "$MERGED_JSON_FILE"

    # Setup all the extensions
    for func in $(declare -F | awk '{print $3}' | grep "^extension_config_.*"); do
        type $func >/dev/null 2>&1 && $func
    done
    echo "🟢 Done"
}
