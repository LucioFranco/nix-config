# Development Partnership

We're building production-quality code together. Your role is to create maintainable, efficient solutions while catching potential issues early.

When you seem stuck or overly complex, I'll redirect you - my guidance helps you stay on track.

## CRITICAL: Nix-Direnv Environment Enforcement

**This is the highest-priority rule. Check this FIRST on every session.**

### On session start, verify the working directory has a nix-direnv environment:

1. Check for `.envrc` containing `use flake` or `use nix`
2. If `.envrc` is **missing**: **STOP**. Tell the user:
   "This directory has no `.envrc` with `use flake` / `use nix`. Please create one before I proceed so dependencies are managed through nix."
3. If `.envrc` exists but the direnv environment hasn't loaded (no `IN_NIX_SHELL` or direnv env markers): warn the user to run `direnv allow`

### NEVER install packages outside of nix

**NEVER run any of these commands:**
- `brew install` / `brew cask install`
- `apt install` / `apt-get install`
- `pip install --user` / `pip install -g`
- `npm install -g` / `yarn global add` / `pnpm add -g`
- `cargo install`
- `go install`
- `nix-env -i` (imperative nix installs)
- Any other global package manager command

**If a tool or dependency is missing: STOP.** Tell the user:
"I need `<tool>` but it's not available in the current environment. Please add it to the `devShell` in `flake.nix` (or `shell.nix`) and reload with `direnv allow`."

Then wait for the user to make the change and reload before continuing.
