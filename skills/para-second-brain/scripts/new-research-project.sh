#!/bin/bash
# Create new research project from template

VAULT_PATH="${OBSIDIAN_VAULT:-$HOME/Library/CloudStorage/GoogleDrive-mattaabar@gmail.com/My Drive/Obsidian/2brain}"
TEMPLATE_PATH="$VAULT_PATH/10_PROJECTS/_Templates/Research Project Template"
ACTIVE_PATH="$VAULT_PATH/10_PROJECTS/Active"

# Get project name
if [ -z "$1" ]; then
    echo "Usage: new-research-project.sh <project-name>"
    echo "Example: new-research-project.sh 'Buy Speakerphone'"
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_PATH="$ACTIVE_PATH/$PROJECT_NAME"

# Check if template exists
if [ ! -d "$TEMPLATE_PATH" ]; then
    echo "❌ Template not found at: $TEMPLATE_PATH"
    exit 1
fi

# Check if project already exists
if [ -d "$PROJECT_PATH" ]; then
    echo "❌ Project already exists: $PROJECT_PATH"
    exit 1
fi

# Copy template
echo "📋 Copying template..."
cp -R "$TEMPLATE_PATH" "$PROJECT_PATH"

# Update AGENTS.md with project name
sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" "$PROJECT_PATH/AGENTS.md"

# Set start date
TODAY=$(date +%Y-%m-%d)
sed -i '' "s/Start: YYYY-MM-DD/Start: $TODAY/g" "$PROJECT_PATH/AGENTS.md"

echo "✅ Research project created: $PROJECT_PATH"
echo ""
echo "Next steps:"
echo "1. Edit AGENTS.md to define research questions"
echo "2. Start gathering sources in _Sources/"
echo "3. Follow Tasks.md checklist"

# Open in Obsidian (if available)
if command -v open &> /dev/null; then
    open "obsidian://open?vault=2brain&file=10_PROJECTS/Active/$PROJECT_NAME/AGENTS.md"
fi
