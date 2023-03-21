# !/usr/bin/env sh

VSCODE_USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"

extension_config_notes()  {
    mkdir -p "$HOME/Documents/notes"
}

vscode_config_snippets() {
    echo "├─ Setting up VS Code snippets..."
    SCRIPT_DIR="$1"
    VSCODE_SNIPPETS_DIR="$VSCODE_USER_SETTINGS_DIR/snippets"
    DOTFILES_VSCODE_SNIPPETS_DIR="$SCRIPT_DIR/vscode/snippets"
    if ! [ -d "$VSCODE_SNIPPETS_DIR" ]; then
        mkdir -p "$VSCODE_SNIPPETS_DIR"
    fi
    SNIPPET_FILES=( "$DOTFILES_VSCODE_SNIPPETS_DIR"/*.json )
    for FILE in "${SNIPPET_FILES[@]}"; do
        FILENAME="$(basename $FILE)"
        if [[ "$FILENAME" == *_internal.json ]]; then
            continue
        fi

        FILENAME_WITH_NO_EXTENSION="$(basename $FILE .json)"
        FILEDIR="$(dirname $FILE)"
        INTERNAL_FILE="$FILEDIR/$FILENAME_WITH_NO_EXTENSION"_internal.json
        if test -e "$INTERNAL_FILE"; then
            MERGED_INTERNAL_FILE="$(mktemp)".json
            jq -s '.[0] * .[1]' "$INTERNAL_FILE" "$FILE" > "$MERGED_INTERNAL_FILE"
        else
            MERGED_INTERNAL_FILE="$FILE"
        fi

        EXISTING_FILE="$VSCODE_SNIPPETS_DIR/$FILENAME"
        if test -e "$EXISTING_FILE"; then
            MERGED_JSON_FILE="$(mktemp)".json
            jq -s '.[0] * .[1]' "$EXISTING_FILE" "$MERGED_INTERNAL_FILE" > "$MERGED_JSON_FILE"
            diff -u "$EXISTING_FILE" "$MERGED_JSON_FILE" > /dev/null 2>&1
            if [ $? -eq 1 ]; then
                printf "%s" "│  ├─ The "$EXISTING_FILE" will be overwritten.  Review the changes? (y/n): "
                read answer
                answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')
                if [ "$answer" = "y" ]; then
                    diff -u "$EXISTING_FILE" "$MERGED_JSON_FILE" | diff-so-fancy | less -R
                fi
                printf "│  ├─ Overwrite the changes? (y/n): "
                read overwrite
                overwrite=$(echo "$overwrite" | tr '[:upper:]' '[:lower:]')
                if [ "$overwrite" = "y" ]; then
                    mv "$MERGED_JSON_FILE" "$EXISTING_FILE"
                fi
            else
                mv "$MERGED_JSON_FILE" "$EXISTING_FILE"
            fi
        else
            cp "$MERGED_INTERNAL_FILE" "$EXISTING_FILE"
        fi
    done
    echo "│  └─ Status: 🟢 Completed"
}

setup_vscode() {
    SCRIPT_DIR="$1"
    DOTFILES_VSCODE_USER_SETTINGS_FILE="$SCRIPT_DIR/vscode/settings.json"
    VSCODE_USER_SETTINGS_FILE="$VSCODE_USER_SETTINGS_DIR/settings.json"

    echo "Setting up Visual Studio Code... "
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

    # Setup all vscode subcomponents like snippets etc.
    for func in $(declare -F | awk '{print $3}' | grep "^vscode_config_.*"); do
        type $func >/dev/null 2>&1 && $func "$SCRIPT_DIR"
    done

    # Setup all the extensions
    for func in $(declare -F | awk '{print $3}' | grep "^extension_config_.*"); do
        type $func >/dev/null 2>&1 && $func
    done
    echo "└─ Status: 🟢 Completed"
}
