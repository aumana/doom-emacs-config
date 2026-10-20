# Mermaid support in Doom Emacs — plan

## Findings (2026-10-20, Ubuntu laptop)
- Already in `packages.el`: `ob-mermaid`, `markdown-mermaid` (both cloned in straight).
- `mmdc` 12.0.0 at `/home/linuxbrew/.linuxbrew/bin/mmdc`; test render `graph TD; A-->B` -> PNG OK.
- Bug: `config.el:939` hardcodes macOS path `/Users/aua/.nvm/.../mmdc`, overriding `"mmdc"` set at `config.el:397`. Babel mermaid blocks fail on Linux.
- `init.el` `+mermaid` flags on `markdown` and `org` are no-ops (Doom modules have no such flag).
- No `mermaid-mode`: `.mmd` files get no highlighting / compile command.
- Side note (not in scope): `init.el` `+draganddrop` is a typo; Doom flag is `+dragndrop`.

## Steps
- [x] 1. `config.el`: delete hardcoded macOS line 939; keep single `(setq ob-mermaid-cli-path "mmdc")` (PATH-resolved, works macOS + Linux).
      verify: `doom doctor` clean; `C-c C-c` on `#+begin_src mermaid :file /tmp/t.png` produces image.
- [x] 2. `packages.el`: add `(package! mermaid-mode)`; `config.el`: `(use-package! mermaid-mode :mode "\\.mmd\\'")`.
      verify: open `t.mmd`, mode line shows Mermaid, `C-c C-c` compiles.
- [x] 3. `init.el`: drop dead `+mermaid` flags (cosmetic, avoids confusion).
- [x] 4. `doom sync`, restart Emacs.
- [x] 5. Check markdown preview: `SPC m m` (`markdown-mermaid-preview`) in a `.md` with a ```mermaid fence.
- [x] 6. Commit in doom repo (branch + PR per workflow, or direct commit if you prefer for dotfiles).

## Optional (ask)
- Mermaid in org HTML/pandoc export (inline SVG via `:results file` already works for most exports).
- Make `emacs-everywhere`-style live preview — skipped, not requested.

## Review
- Markdown preview was broken by mmdc 12 (dropped `--width/--height`; markdown-mermaid passes them and shows empty PNG on failure). Fix: `npm i -g @mermaid-js/mermaid-cli@11` (11.17.0). Re-break risk on `npm update -g`.
- Verified in running daemon: org babel block -> PNG; `markdown-mermaid-preview` -> 1.5 KB PNG; `.mmd` opens in mermaid-mode, `mermaid-compile` -> PNG.
- Wrap region: select, `SPC m i C`, type `mermaid` (`markdown-insert-gfm-code-block`). `markdown-spaces-after-code-fence 0` gives ```mermaid.
