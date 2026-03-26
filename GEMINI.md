# Doom Emacs Configuration Context

This project contains the Doom Emacs configuration for **Andres Umana**. It is a highly customized environment optimized for Org-mode productivity, literate programming, and multi-language development.

## Core Principles
- **Org-mode as Centerpiece:** Used for GTD, blogging (Hugo), publishing (LeanPub/Pandoc), and literate programming.
- **Visual Polish:** Uses proportional fonts for prose (`variable-pitch-mode`) and fixed-pitch for code blocks.
- **Performance & Compatibility:** Rigorous TTY guards to disable GUI-only features (icons, childframes) when running in a terminal.
- **AI-Enhanced:** Integrated with `gptel` (local Ollama) and `agent-shell`.

## Key Components
- **Task Management:** `org-gtd`, `org-super-agenda`, and custom holiday lists (`spanish-holidays`, `swiss-holidays`).
- **Literate Programming:** `org-auto-tangle` enabled by default.
- **Development:** 
    - Clojure (`cider`, `lsp`, `shadow-cljs`).
    - Python (`pyright`, `poetry`).
    - Shells: `vterm` configured with `elvish`.
- **Custom Bindings:** Extensive use of `map!` for leader keys and `key-chord` (e.g., `jj`/`jk` for escape).

## Maintenance Notes
- **Doom Sync:** Always run `doom sync` after modifying `init.el` or `packages.el`.
- **Fonts:** Requires `JetBrainsMono Nerd Font` and `Alegreya Sans`.
- **Shells:** Depends on `elvish` being available at `/usr/local/bin/elvish` (on macOS) or standard paths.

## Ongoing Tasks
- [ ] Refine `org-gtd` workflow.
- [ ] Monitor `gptel` performance with local models.
- [ ] Maintain TTY compatibility as new UI packages are added.
