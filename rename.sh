#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Current package names
CURRENT_PROJECT_NAME="python-uv-template"
CURRENT_PACKAGE_NAME="python_uv_template"

# Get new package name (from argument or current directory name)
if [ "$#" -ge 1 ]; then
    NEW_PROJECT_NAME="$1"
else
    NEW_PROJECT_NAME=$(basename "$(pwd)")
fi

# Convert project name to package name (replace hyphens with underscores)
NEW_PACKAGE_NAME="${NEW_PROJECT_NAME//-/_}"

echo "Starting package rename:"
echo "Project name: $CURRENT_PROJECT_NAME → $NEW_PROJECT_NAME"
echo "Package name: $CURRENT_PACKAGE_NAME → $NEW_PACKAGE_NAME"

# Determine sed command based on OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS needs an empty string after -i
    SED_CMD="sed -i ''"
else
    # Linux version
    SED_CMD="sed -i"
fi

# Update pyproject.toml
if [ -f "pyproject.toml" ]; then
    echo "Updating pyproject.toml..."
    $SED_CMD "s/name = \"$CURRENT_PROJECT_NAME\"/name = \"$NEW_PROJECT_NAME\"/g" pyproject.toml
fi

# Rename package directory
if [ -d "src/$CURRENT_PACKAGE_NAME" ]; then
    echo "Renaming package directory..."
    mkdir -p "src/$NEW_PACKAGE_NAME"
    # Copy files (including hidden ones)
    cp -r "src/$CURRENT_PACKAGE_NAME"/* "src/$NEW_PACKAGE_NAME"/ 2>/dev/null || true
    cp -r "src/$CURRENT_PACKAGE_NAME"/.[!.]* "src/$NEW_PACKAGE_NAME"/ 2>/dev/null || true
    rm -rf "src/$CURRENT_PACKAGE_NAME"
fi

# Update imports in Python files
echo "Updating Python imports..."
find . -type f -name "*.py" | xargs grep -l "$CURRENT_PACKAGE_NAME" | xargs -I{} $SED_CMD "s/import $CURRENT_PACKAGE_NAME/import $NEW_PACKAGE_NAME/g" {}
find . -type f -name "*.py" | xargs grep -l "$CURRENT_PACKAGE_NAME" | xargs -I{} $SED_CMD "s/from $CURRENT_PACKAGE_NAME/from $NEW_PACKAGE_NAME/g" {}

# Update references in other files
echo "Updating references in documentation..."
find . -type f -name "*.md" | xargs grep -l "$CURRENT_PROJECT_NAME\|$CURRENT_PACKAGE_NAME" | xargs -I{} $SED_CMD "s/$CURRENT_PROJECT_NAME/$NEW_PROJECT_NAME/g" {}
find . -type f -name "*.md" | xargs grep -l "$CURRENT_PROJECT_NAME\|$CURRENT_PACKAGE_NAME" | xargs -I{} $SED_CMD "s/$CURRENT_PACKAGE_NAME/$NEW_PACKAGE_NAME/g" {}

# Update devcontainer settings
if [ -f ".devcontainer/devcontainer.json" ]; then
    echo "Updating devcontainer settings..."
    $SED_CMD "s/\"name\": \"$CURRENT_PROJECT_NAME\"/\"name\": \"$NEW_PROJECT_NAME\"/g" .devcontainer/devcontainer.json
fi

# Update VSCode settings
if [ -f ".vscode/settings.json" ]; then
    echo "Updating VSCode settings..."
    $SED_CMD "s/$CURRENT_PROJECT_NAME/$NEW_PROJECT_NAME/g" .vscode/settings.json
    $SED_CMD "s/$CURRENT_PACKAGE_NAME/$NEW_PACKAGE_NAME/g" .vscode/settings.json
fi

# Update tests
if [ -d "tests" ]; then
    echo "Updating test files..."
    find ./tests -type f -name "*.py" | xargs grep -l "$CURRENT_PACKAGE_NAME" | xargs -I{} $SED_CMD "s/$CURRENT_PACKAGE_NAME/$NEW_PACKAGE_NAME/g" {}
fi

echo "Package rename completed successfully!"
echo "New project name: $NEW_PROJECT_NAME"
echo "New package name: $NEW_PACKAGE_NAME"
