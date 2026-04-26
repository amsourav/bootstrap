# bootstrap

> Bootstrap a fresh Mac with one command.

A personal, opinionated, idempotent macOS setup. One `Brewfile` of software I want, one shell script that installs it. No frameworks, no DSLs — just `brew bundle` and a few guards.

## Quick start

On a fresh Mac:

```bash
git clone https://github.com/amsourav/bootstrap.git ~/bootstrap
cd ~/bootstrap
./bootstrap.sh
```

Enter your password once when prompted. The script handles the rest.

## What the script does

1. Asks for `sudo` upfront and keeps the timestamp alive in the background.
2. Installs **Xcode Command Line Tools** if missing (waits for the GUI dialog to finish).
3. Installs **Homebrew** if missing.
4. Runs `brew bundle` against the [`Brewfile`](./Brewfile).
5. Installs **Oh My Zsh** (without overwriting your `~/.zshrc` or changing your shell).
6. Installs the **latest Node.js** via Volta.

Each step is guarded — re-running the script is cheap and safe.

## What's in the Brewfile

The full list lives in [`Brewfile`](./Brewfile). Highlights:

- **Version managers:** `volta`, `asdf`
- **CLIs:** `gh`, `uv`
- **Browsers / utilities:** `google-chrome`, `1password`, `vibe-notch`
- **Editors / terminals:** `cursor`, `ghostty`
- **AI tools:** `claude`, `claude-code`, `codex`, `codex-app`, `chatgpt`, `conductor`
- **Data / containers:** `postgres-app`, `beekeeper-studio`, `rancher`, `testcontainers-desktop`

## Customizing

- **Add a CLI tool:** add `brew "name"` to the Brewfile.
- **Add a GUI app:** add `cask "name"`. Verify the cask name at <https://formulae.brew.sh/cask/>.
- **Third-party tap:** add `tap "owner/name"` at the top, then reference its casks/formulae normally.

After editing, re-run `./bootstrap.sh` or just `brew bundle --file=./Brewfile`.

## Notes

- `node` is **not** in the Brewfile on purpose — Volta owns Node so the two version managers don't fight.
- `rancher` conflicts with Docker Desktop. Pick one.
- macOS only, tested on Apple Silicon.
