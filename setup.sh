#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Current package names
CURRENT_PROJECT_NAME="python-uv-template"
CURRENT_PACKAGE_NAME="python_uv_template"

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to prompt user for yes/no
confirm() {
    local prompt="$1"
    local response
    while true; do
        read -p "$prompt (y/n): " response
        case $response in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) print_warning "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to rename project files
rename_project() {
    local new_project_name="$1"
    local new_package_name="${new_project_name//-/_}"

    print_info "Renaming project from '$CURRENT_PROJECT_NAME' to '$new_project_name'"
    print_info "Package name will be: '$new_package_name'"

    # Update pyproject.toml
    if [ -f "pyproject.toml" ]; then
        print_info "Updating pyproject.toml..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/name = \"$CURRENT_PROJECT_NAME\"/name = \"$new_project_name\"/g" pyproject.toml
        else
            sed -i "s/name = \"$CURRENT_PROJECT_NAME\"/name = \"$new_project_name\"/g" pyproject.toml
        fi
    fi

    # Rename package directory
    if [ -d "src/$CURRENT_PACKAGE_NAME" ]; then
        print_info "Renaming package directory..."
        mkdir -p "src/$new_package_name"
        cp -r "src/$CURRENT_PACKAGE_NAME"/* "src/$new_package_name"/ 2>/dev/null || true
        cp -r "src/$CURRENT_PACKAGE_NAME"/.[!.]* "src/$new_package_name"/ 2>/dev/null || true
        rm -rf "src/$CURRENT_PACKAGE_NAME"
    fi

    # Update imports in Python files
    print_info "Updating Python imports..."
    find . -type f -name "*.py" | xargs grep -l "$CURRENT_PACKAGE_NAME" 2>/dev/null | while read file; do
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/import $CURRENT_PACKAGE_NAME/import $new_package_name/g" "$file"
            sed -i '' "s/from $CURRENT_PACKAGE_NAME/from $new_package_name/g" "$file"
        else
            sed -i "s/import $CURRENT_PACKAGE_NAME/import $new_package_name/g" "$file"
            sed -i "s/from $CURRENT_PACKAGE_NAME/from $new_package_name/g" "$file"
        fi
    done

    # Update docker-compose.yml
    if [ -f "docker-compose.yml" ]; then
        print_info "Updating docker-compose.yml..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/$CURRENT_PROJECT_NAME/$new_project_name/g" docker-compose.yml
        else
            sed -i "s/$CURRENT_PROJECT_NAME/$new_project_name/g" docker-compose.yml
        fi
    fi

    # Update VSCode settings
    if [ -f ".vscode/settings.json" ]; then
        print_info "Updating VSCode settings..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/$CURRENT_PROJECT_NAME/$new_project_name/g" .vscode/settings.json
            sed -i '' "s/$CURRENT_PACKAGE_NAME/$new_package_name/g" .vscode/settings.json
        else
            sed -i "s/$CURRENT_PROJECT_NAME/$new_project_name/g" .vscode/settings.json
            sed -i "s/$CURRENT_PACKAGE_NAME/$new_package_name/g" .vscode/settings.json
        fi
    fi

    # Update Makefile
    if [ -f "Makefile" ]; then
        print_info "Updating Makefile..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/$CURRENT_PROJECT_NAME/$new_project_name/g" Makefile
        else
            sed -i "s/$CURRENT_PROJECT_NAME/$new_project_name/g" Makefile
        fi
    fi

    # Update justfile
    if [ -f "justfile" ]; then
        print_info "Updating justfile..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/$CURRENT_PROJECT_NAME/$new_project_name/g" justfile
        else
            sed -i "s/$CURRENT_PROJECT_NAME/$new_project_name/g" justfile
        fi
    fi

    # Update tests
    if [ -d "tests" ]; then
        print_info "Updating test files..."
        find ./tests -type f -name "*.py" | xargs grep -l "$CURRENT_PACKAGE_NAME" 2>/dev/null | while read file; do
            if [[ "$OSTYPE" == "darwin"* ]]; then
                sed -i '' "s/$CURRENT_PACKAGE_NAME/$new_package_name/g" "$file"
            else
                sed -i "s/$CURRENT_PACKAGE_NAME/$new_package_name/g" "$file"
            fi
        done
    fi
}

# Main setup process
main() {
    echo -e "${GREEN}==================================${NC}"
    echo -e "${GREEN}  Python UV Template Setup Script ${NC}"
    echo -e "${GREEN}==================================${NC}"
    echo

    # Get new package name
    if [ "$#" -ge 1 ]; then
        NEW_PROJECT_NAME="$1"
        print_info "Using provided project name: $NEW_PROJECT_NAME"
    else
        NEW_PROJECT_NAME=$(basename "$(pwd)")
        print_info "Using current directory name as project name: $NEW_PROJECT_NAME"
    fi

    # Rename project
    rename_project "$NEW_PROJECT_NAME"

    # Language selection
    echo
    print_info "Select your preferred language for documentation:"
    echo "  1) English"
    echo "  2) Japanese (日本語)"
    while true; do
        read -p "Enter your choice (1 or 2): " lang_choice
        case $lang_choice in
            1)
                SELECTED_LANG="en"
                print_success "English selected"
                break
                ;;
            2)
                SELECTED_LANG="ja"
                print_success "Japanese (日本語) selected"
                break
                ;;
            *)
                print_warning "Please enter 1 or 2"
                ;;
        esac
    done

    # Build tool selection
    echo
    print_info "Select your preferred build tool:"
    echo "  1) Make"
    echo "  2) Just"
    while true; do
        read -p "Enter your choice (1 or 2): " build_choice
        case $build_choice in
            1)
                SELECTED_BUILD="make"
                print_success "Make selected"
                break
                ;;
            2)
                SELECTED_BUILD="just"
                print_success "Just selected"
                break
                ;;
            *)
                print_warning "Please enter 1 or 2"
                ;;
        esac
    done

    # Cleanup confirmation
    echo
    print_warning "The following cleanup actions will be performed:"
    echo "  - Replace README files with a simple template"

    if [ "$SELECTED_LANG" = "en" ]; then
        echo "  - Remove Japanese documentation files (*.ja.md)"
    else
        echo "  - Remove English documentation files and rename Japanese files"
    fi

    if [ "$SELECTED_BUILD" = "make" ]; then
        echo "  - Remove justfile"
    else
        echo "  - Remove Makefile"
    fi

    echo "  - Remove setup scripts (setup.sh, Setup.ps1, rename.sh, Rename.ps1)"
    echo

    if ! confirm "Do you want to proceed with cleanup?"; then
        print_warning "Cleanup cancelled. Project has been renamed but no files were removed."
        exit 0
    fi

    # Perform cleanup
    print_info "Starting cleanup..."

    # Replace README files
    print_info "Replacing README files..."
    echo "# $NEW_PROJECT_NAME" > README.md
    rm -f README.ja.md

    # Language-specific cleanup
    if [ "$SELECTED_LANG" = "en" ]; then
        print_info "Removing Japanese documentation files..."
        find .github -name "*.ja.md" -type f -delete 2>/dev/null || true
    else
        print_info "Processing Japanese documentation files..."
        # Rename Japanese files to remove .ja suffix
        find .github -name "*.ja.md" -type f | while read file; do
            newfile="${file%.ja.md}.md"
            mv "$file" "$newfile"
        done
        # Remove original English files
        find .github -name "*.md" -type f ! -name "*.ja.md" | grep -E "(Bug_Report|Feature_Request|Task|PULL_REQUEST_TEMPLATE)\.md$" | xargs rm -f 2>/dev/null || true
    fi

    # Build tool cleanup
    if [ "$SELECTED_BUILD" = "make" ]; then
        print_info "Removing justfile..."
        rm -f justfile
    else
        print_info "Removing Makefile..."
        rm -f Makefile
    fi

    # Remove setup scripts
    print_info "Removing setup scripts..."
    rm -f rename.sh Rename.ps1 Setup.ps1

    # Final cleanup summary
    echo
    print_success "Setup completed successfully!"
    echo
    echo -e "${GREEN}Summary:${NC}"
    echo "  - Project renamed to: $NEW_PROJECT_NAME"
    echo "  - Documentation language: $([ "$SELECTED_LANG" = "en" ] && echo "English" || echo "Japanese")"
    echo "  - Build tool: $([ "$SELECTED_BUILD" = "make" ] && echo "Make" || echo "Just")"
    echo "  - README replaced with simple template"
    echo "  - Unnecessary files removed"
    echo
    print_info "Don't forget to:"
    echo "  - Run '$SELECTED_BUILD venv' to set up your virtual environment"
    echo "  - Update your README.md with project-specific information"
    echo "  - Commit these changes to your repository"

    # Self-delete
    print_info "Removing this setup script..."
    rm -f "$0"
}

# Run main function
main "$@"
