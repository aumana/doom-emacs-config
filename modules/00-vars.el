;;; modules/00-vars.el -*- lexical-binding: t; -*-

;; --- PATH ABSTRACTION -------------------------------------------------------
(defvar zz/dropbox-root
  (expand-file-name (if (eq system-type 'darwin) "~/Dropbox/" "~/Dropbox/"))
  "The root of the Dropbox folder, adjusted for OS.")

(defvar zz/obsidian-vault-path
  (concat zz/dropbox-root "Personal/obsidian/")
  "Path to the Obsidian vault.")

(setq org-directory (concat zz/dropbox-root "org/"))

;; Binary discovery (avoids hardcoded Mac paths)
(setq ob-mermaid-cli-path (executable-find "mmdc"))

;; --- OS SPECIFIC MODIFIERS -------------------------------------------------
;; Change the Mac modifiers to my liking.
(cond ((eq system-type 'darwin)
       (setq mac-command-modifier       'meta
             mac-option-modifier        'alt
             mac-right-option-modifier  nil
             mac-pass-control-to-system t)))

(when (and (eq system-type 'darwin) (display-graphic-p))
  ;; Cocoa/NS Emacs (Emacs.app)
  (when (boundp 'ns-alternate-modifier)        (setq ns-alternate-modifier 'meta))
  (when (boundp 'ns-right-alternate-modifier)  (setq ns-right-alternate-modifier 'none))

  ;; Yamamoto emacs-mac port (if you ever switch builds)
  (when (boundp 'mac-option-modifier)          (setq mac-option-modifier 'meta))
  (when (boundp 'mac-right-option-modifier)    (setq mac-right-option-modifier 'none))
)

;; --- macOS ENV IMPORT ------------------------------------------------------
(when (and (eq system-type 'darwin) (display-graphic-p))
  ;; Note: requires (exec-path-from-shell) in init.el/packages.el
  (after! exec-path-from-shell
    (setq exec-path-from-shell-variables '("PATH" "MANPATH" "LANG" "LC_ALL" "GOPATH" "PYENV_ROOT" "GPG_TTY"))
    (exec-path-from-shell-initialize)))
