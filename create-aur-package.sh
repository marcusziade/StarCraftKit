#!/bin/bash
# Script to create initial AUR package

set -e

echo "Creating initial AUR package for starcraft-cli..."

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Initialize empty git repo for AUR
git init
git remote add origin ssh://aur@aur.archlinux.org/starcraft-cli.git

# Copy PKGBUILD from your repo
cp ~/Dev/swift/StarCraftKit/aur/starcraft-cli/PKGBUILD .
cp ~/Dev/swift/StarCraftKit/aur/starcraft-cli/.SRCINFO .

# Add files and commit
git add PKGBUILD .SRCINFO
git commit -m "Initial commit"

# Push to create the package
git push -u origin master

echo "✅ AUR package created successfully!"
echo "Check https://aur.archlinux.org/packages/starcraft-cli"

# Clean up
cd -
rm -rf "$TEMP_DIR"