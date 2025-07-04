# AUR Package Setup

This directory contains the template for the `starcraft-cli` AUR package.

## Initial Setup

1. **Generate SSH key for AUR**:
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/aur_key -C "AUR package maintainer"
   ```

2. **Add public key to your AUR account**:
   - Go to https://aur.archlinux.org/account
   - Add the contents of `~/.ssh/aur_key.pub` to your SSH Public Keys

3. **Add private key to GitHub secrets**:
   - Go to your repository settings
   - Add a new secret named `AUR_SSH_PRIVATE_KEY`
   - Paste the contents of `~/.ssh/aur_key`

4. **Create the initial AUR package** (one-time):
   ```bash
   git clone ssh://aur@aur.archlinux.org/starcraft-cli.git
   cd starcraft-cli
   cp ../aur/starcraft-cli/PKGBUILD .
   makepkg --printsrcinfo > .SRCINFO
   git add PKGBUILD .SRCINFO
   git commit -m "Initial commit"
   git push
   ```

## Automatic Updates

The release workflow will automatically update the AUR package when you create a new release:
- Updates version in PKGBUILD
- Updates SHA256 checksum
- Regenerates .SRCINFO
- Commits and pushes to AUR

## Manual Installation from AUR

Users can install with:
```bash
# Using an AUR helper
yay -S starcraft-cli
# or
paru -S starcraft-cli

# Manual installation
git clone https://aur.archlinux.org/starcraft-cli.git
cd starcraft-cli
makepkg -si
```