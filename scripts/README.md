# Release Scripts

## Complete Release Process

To release a new version, simply run:

```bash
./scripts/release.sh 2.1.0
```

This will:
1. Create and push a git tag
2. Wait for GitHub to create the release
3. Update the AUR package automatically
4. Push all changes

## Manual AUR Update

If you need to update just the AUR package:

```bash
./scripts/update-aur.sh 2.1.0
```

## Release Workflow

1. Make your code changes
2. Commit and push to master
3. Run `./scripts/release.sh X.Y.Z`
4. Done! Users can update with `yay -Syu starcraft-cli`