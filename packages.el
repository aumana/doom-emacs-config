;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)
;;
;; Set the theme to use. I like the Spacemacs-Light, which does not come with Doom, so we need to install it from package.el:

;; (package! spacemacs-theme)
;; org download
(package! org-download)
;; bank holidays packages
(package! spanish-holidays)
(package! swiss-holidays)
;; super agenda package
(package! org-super-agenda)
;; org gtd package
(package! org-gtd)
;; appear package
(package! org-appear
  :recipe (:host github
           :repo "awth13/org-appear"))
;; Pandoc package
(package! org-pandoc-import
  :recipe (:host github
           :repo "tecosaur/org-pandoc-import"
           :files ("*.el" "filters" "preprocessors")))
;; ox leanpub pakcage
(package! ox-leanpub
  :recipe (:local-repo "~/Dropbox/Personal/devel/emacs/ox-leanpub"))
;; ;; The annotate package is nice - allows adding annotations to files without modifying the file itself.
(package! annotate)
;; ;; gift-mode for editing quizzes in GIFT format.
(package! gift-mode)
;; ;; Add “unfill” commands to parallel the “fill” ones, bind A-q to unfill-paragraph and rebind M-q to the unfill-toggle command, which fills/unfills paragraphs alternatively.
(package! unfill)
;; ;; I find iedit absolutely indispensable when coding. In short: when you hit Ctrl-;, all occurrences of the symbol under the cursor (or the current selection) are highlighted, and any changes you make on one of them will be automatically applied to all others. It’s great for renaming variables in code, but it needs to be used with care, as it has no idea of semantics, it’s a plain string replacement, so it can inadvertently modify unintended parts of the code.
(package! iedit)
;; ;; Use Emacs Everywhere!
(package! emacs-everywhere :pin nil)
;; Dockerfile mode:
(package! dockerfile-mode)
;; package-lint for checking MELPA packages.
(package! package-lint)
;; Graphviz for graph generation.
(package! graphviz-dot-mode)
;; CFEngine policy files. The cfengine3-mode package is included with Emacs, but I also install org-babel support.
(package! ob-cfengine3)
;; Fish shell.
(package! fish-mode)
;; Elvish shell, with support for org-babel.
(package! elvish-mode)
(package! ob-elvish)
;; Tangle-on-save has revolutionized my literate programming workflow. It automatically runs org-babel-tangle upon saving any org-mode buffer, which means the resulting files will be automatically kept up to date. For a while I did this by manually adding org-babel-tangle to the after-save hook in Org mode, but now I use the org-auto-tangle package, which does this asynchronously and selectively for each Org file where it is desired.
(package! org-auto-tangle)
;; I’m also testing org-ql for structured queries on Org documents.
(package! org-ql)
;; Trying out org-ml for easier access to Org objects.
(package! org-ml)
;; Testing org-ol-tree.
;; (package! org-ol-tree
;;   :recipe (:host github
;;            :repo "Townk/org-ol-tree"))
;; org-special-block-extras to enable additional special block types and their corresponding exports (disabled for now).
(package! org-special-block-extras)
;; org-jira for full Jira integration - manage issues from Org mode.
(package! org-jira)
;; ox-jira to export in Jira markup format.
(package! ox-jira)
;; Org Bullets package
(package! org-bullets)
