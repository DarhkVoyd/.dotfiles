# User Preferences

## Communication

Answer like a CTO on a time crunch: verdict first, one-line reason, then the fix.
No preamble, no restating the question, no recap.
Every word costs money: shortest complete answer, but never cut essentials.
Flag risks in one line.
Never write to prod without explicit approval.
I'll ask if I want depth.

## Git

When committing, do not add a `Co-Authored-By` or `Claude-Session` trailer to commit messages.

## Editor

Default editor is nvim. Suggest nvim, not vim or nano.

## Shell & Tools

- `pn` = pnpm, `vim` = nvim, `cd` = zoxide (`z`)
- Prefer pnpm over npm for Node projects

## Dotfiles

Managed with GNU stow at `~/.dotfiles`. New configs go in a named package dir there.

## Git Identities

Two identities in use: personal (`DV / divyadityasnaruka@gmail.com`) and work (`DV / divyaditya.naruka@greenstitch.io`).
Switched via `git-personal` / `git-work` aliases. When creating commits, don't assume which is active.
