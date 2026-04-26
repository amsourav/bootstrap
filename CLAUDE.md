# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A personal Mac bootstrap. Two files do everything:

- `Brewfile` — declarative list of taps, formulae, and casks consumed by `brew bundle`.
- `bootstrap.sh` — driver script. Installs Xcode CLT → Homebrew → `brew bundle` → Oh My Zsh → latest Node via Volta. Idempotent; safe to re-run.

## Common operations

- Run end-to-end on a fresh machine: `./bootstrap.sh`
- Apply Brewfile changes on an already-bootstrapped machine: `brew bundle --file=./Brewfile`
- See what `brew bundle` would change without applying: `brew bundle check --file=./Brewfile --verbose`
- Confirm a cask name before adding it: check `https://formulae.brew.sh/cask/<name>` (404 means it's not in core; it likely lives in a third-party tap and needs a `tap "..."` line).

There is no build, lint, or test suite — this is a shell script plus a manifest.

## Non-obvious architecture notes

- **`node` is intentionally not in the `Brewfile`.** It's installed via `volta install node@latest` at the end of `bootstrap.sh`. Installing node through brew alongside Volta would cause the two version managers to fight. If a future package depends on node, prefer `volta install <pkg>` over `brew install node`.
- **Two version managers coexist on purpose:** Volta owns Node; asdf is available for everything else.
- **Sudo handling.** `bootstrap.sh` calls `sudo -v` upfront and runs a background keepalive loop because `NONINTERACTIVE=1` is passed to the Homebrew installer, which suppresses brew's own sudo prompt. Don't remove the upfront `sudo -v` block without also removing `NONINTERACTIVE=1`, or the install will silently stall.
- **`rancher` cask conflicts with `docker` / `docker-desktop`.** Don't add Docker Desktop alongside it.
- **`testcontainers-desktop` lives in `atomicjar/tap`.** That tap is declared at the top of the Brewfile; without it, `brew bundle` fails on that line.
- **Idempotency guards** exist for each long-running step (`xcode-select -p`, `command -v brew`, `[[ ! -d ~/.oh-my-zsh ]]`). When adding new steps, follow the same pattern so re-running the script stays cheap.
- **`xcode-select --install` is async** — it opens a GUI dialog. The script polls `xcode-select -p` until the user finishes that dialog before continuing.

## Adding software

- CLI tool: add `brew "name"` under the `# CLI tools` section.
- GUI app: add `cask "name"` under the `# GUI apps` section. Verify the cask exists at `formulae.brew.sh/cask/<name>` first — names often differ from the app's marketing name (e.g. Beekeeper Studio → `beekeeper-studio`, Postgres.app → `postgres-app`).
- Third-party tap: add a `tap "owner/name"` line at the top before referencing its casks/formulae.
