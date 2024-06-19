;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; My user information.
(setq user-full-name "Andres Umana"
      user-mail-address "aumana@gmail.com")

;; Change the Mac modifiers to my liking. I also disable passing Control characters to the system, to avoid that C-M-space launches the Character viewer instead of running mark-sexp.
(cond (IS-MAC
       (setq mac-command-modifier       'meta
             mac-option-modifier        'alt
             mac-right-option-modifier  'alt
             mac-pass-control-to-system t)))

;; When at the beginning of the line, make Ctrl-K remove the whole line, instead of just emptying it.
(setq kill-whole-line t)

;; For some reason Doom disables auto-save and backup files by default. Let’s reenable them.
(setq auto-save-default t
      make-backup-files t)

;; Disable exit confirmation.
(setq confirm-kill-emacs nil)

;; Doom configures auth-sources by default to include the Keychain on macOS, but it puts it at the beginning of the list. This causes creation of auth items to fail because the macOS Keychain sources do not support creation yet. I reverse it to leave ~/.authinfo.gpg at the beginning.
(after! auth-source
  (setq auth-sources (nreverse auth-sources)))

;; Set base and variable-pitch fonts. I currently like Fira Code and Alegreya (another favorite and my previous choice: ET Book).
(setq doom-font (font-spec :family "Fira Code" :size 10)
      ;;doom-variable-pitch-font (font-spec :family "ETBembo" :size 18)
      doom-variable-pitch-font (font-spec :family "Alegreya" :size 10))


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one) ;; This theme is ok
;; (after! spacemacs-theme
;;  (setq doom-theme 'spacemacs-light)) ;; This theme is good currently selecrted

;; I love the spacemacs-light theme, but for some reason, the transparent dashboard images showed up with a light tint, which I eventually tracked to the fact that Doom by default uses the font-lock-comment-face for the dashboard banner image, and this this face has a background color in Spacemacs-light. I redefine the doom-dashboard-banner face to use the default face, which fixes the problem. Another way to fix it (commented out below) is to disable the background tint color in the theme. While we are at it, I also fix doom-dashboard-loaded, which suffers from the same problem.

;;(custom-set-faces!
;;  '(doom-dashboard-banner :inherit default)
;;  '(doom-dashboard-loaded :inherit default))
;;(setq spacemacs-theme-comment-bg nil)



;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; ;;
;; ;; General Org Configuration
;; ;;

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; Step 1: Configure faces for Org headlines and lists
;; My first step was to make org-mode much more readable by using different fonts for headings, hiding some of the markup, and improving list bullets. I took these settings originally from Howard Abrams' excellent Org as a Word Processor article, although I have tweaked them a bit.
;; First, we ask org-mode to hide the emphasis markup (e.g. /.../ for italics, *...* for bold, etc.):
  (setq org-hide-emphasis-markers t)

;; Then, we set up a font-lock substitution for list markers (I always use “-” for lists, but you can change this if you want) by replacing them with a centered-dot character:
(font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; The org-bullets package replaces all headline markers with different Unicode bullets:
(use-package org-bullets
    :config
    (add-hook 'org-mode-hooK (lambda () (org-bullets-mode 1))))

;; Finally, we set up a nice proportional font, in different sizes, for the headlines. The fonts listed will be tried in sequence, and the first one found will be used. My current favorite is ET Book, feel free to add your own:
  (let* ((variable-tuple
          (cond ((x-list-fonts "Alegreya Sans")         '(:font "Alegreya Sans"))
                ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
                ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
                ((x-list-fonts "Verdana")         '(:font "Verdana"))
                ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
                (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
         (base-font-color     (face-foreground 'default nil 'default))
         (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

    (custom-theme-set-faces
     'user
     `(org-level-8 ((t (,@headline ,@variable-tuple))))
     `(org-level-7 ((t (,@headline ,@variable-tuple))))
     `(org-level-6 ((t (,@headline ,@variable-tuple))))
     `(org-level-5 ((t (,@headline ,@variable-tuple))))
     `(org-level-4 ((t (,@headline  fs,@variable-tuple :height 1.1))))
     `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
     `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
     `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
     `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

;; Step 2: Setting up variable-pitch and fixed-pitch faces
;; My next realization was that Emacs already includes support for displaying proportional fonts with the variable-pitch-mode command. You can try it right now: type M-x variable-pitch-mode and your current buffer will be shown in a proportional font (you can disable it by running variable-pitch-mode again). On my Mac the default variable-pitch font is Helvetica. You can change the font used by configuring the variable-pitch face. You can do this interactively through the customize interface by typing M-x customize-face variable-pitch. At the moment I like Source Sans Pro ET Book.

;; As a counterpart to variable-pitch, you need to configure the fixed-pitch face for the text that needs to be shown in a monospaced font. My first instinct was to inherit this from my default face (I use Inconsolata Fira Code), but it seems that this gets remapped when variable-pitch-mode is active, so I had to configure it by hand with the same font as my default face.

;; What I would suggest is that you customize the fonts interactively, as you can see live how it looks on your text. You can make the configuration permanent from the customize screen as well. If you want to explicitly set them in your configuration file, you can do it with the custom-theme-set-faces function, like this:

  (custom-theme-set-faces
   'user
   '(variable-pitch ((t (:family "Alegreya" :height 180 :weight thin))))
   '(fixed-pitch ((t ( :family "Fira Code Retina" :height 160)))))

;; Tip #1: you can get the LISP expression for your chosen font (the part that looks like ((t (:family ... ))) from the customize-face screen - open the “State” button and choose the “Show Lisp Expression” menu item.
;; Tip #2: if you use a Mac, you can get the value to use for the :family attribute by looking at the “Family” attribute in the Font Book application for the font you want to use.
;; You can enable variable-pitch-mode automatically for org buffers by setting up a hook like this:
(add-hook 'org-mode-hook 'variable-pitch-mode)

;; Allow mixed fonts in a buffer. This is particularly useful for Org mode, so I can mix source and prose blocks in the same document. I also manually enable solaire-mode in Org mode as a workaround for font scaling not working properly.
(add-hook! 'org-mode-hook #'mixed-pitch-mode)
;; (add-hook! 'org-mode-hook #'solaire-mode)
(setq mixed-pitch-variable-pitch-cursor nil)

;; Step 3: Use long lines and visual-line-mode
;; One thing you will notice right away with proportional fonts is that filling paragraphs no longer makes sense. This is because fill-paragraph works based on the number of characters in a line, but with a proportional font, characters have different widths, so a filled paragraph looks strange:
;; Of course, you can still do it, but there’s a better way. With visual-line-mode enabled, long lines will flow and adjust to the width of the window. This is great for writing prose, because you can choose how wide your lines are by just resizing your window.
;; There is one habit you have to change for this to work: the instinct (at least for me) of pressing M-q every once in a while to readjust the current paragraph. I personally think it’s worth it.
;; You can enable visual-line-mode automatically for org buffers by setting up another hook:
(add-hook 'org-mode-hook 'visual-line-mode)

;; Step 4: Configure faces for specific Org elements
;; After all the changes above, you will have nice, proportional fonts in your Org buffers. However, there are some things for which you still want monospace fonts! Things like source blocks, examples, tags and some other markup elements still look better in a fixed-spacing font, in my opinion. Fortunately, org-mode has an extremely granular face selection, so you can easily customize them to have different elements shown in the correct font, color, and size.
;; Tip: you can use C-u C-x = (which runs the command what-cursor-position with a prefix argument) to show information about the character under the cursor, including the face which is being used for it. If you find a markup element which is not correctly configured, you can use this to know which face you have to customize.
;; You can configure specific faces any way you want, but if you simply want them to be rendered in monospace font, you can set them to inherit from the fixed-pitch face we configured before. You can also inherit from multiple faces to combine their attributes.
;; Here are the faces I have configured so far (there are probably many more to do, but I don’t use org-mode to its full capacity yet). I’m showing here the LISP expressions, but you can just as well configure them using customize-face.
  (custom-theme-set-faces
   'user
   '(org-block ((t (:inherit fixed-pitch))))
   '(org-code ((t (:inherit (shadow fixed-pitch)))))
   '(org-document-info ((t (:foreground "dark orange"))))
   '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
   '(org-indent ((t (:inherit (org-hide fixed-pitch)))))
   '(org-link ((t (:foreground "royal blue" :underline t))))
   '(org-meta-line ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-property-value ((t (:inherit fixed-pitch))) t)
   '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
   '(org-table ((t (:inherit fixed-pitch :foreground "#83a598"))))
   '(org-tag ((t (:inherit (shadow fixed-pitch) :weight bold :height 0.8))))
   '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))
;; Update (2019/10/24): updated the settings above based on my latest config. Update (2019/02/24): thanks to Ben for figuring out the fix to the vertical spacing issue noted below. The trick is to set the org-indent face (see above) to inherit from fixed-pitch as well.

;; Insert Org headings at point, not after the current subtree (this is enabled by default by Doom).
(after! org (setq org-insert-heading-respect-content nil))

;; Enable logging of done tasks, and log stuff into the LOGBOOK drawer by default
(after! org
   (setq org-log-done t)
   (setq org-log-into-drawer t))

;; Use the special C-a, C-e and C-k definitions for Org, which enable some special behavior in headings.
(after! org
  (setq org-special-ctrl-a/e t)
  (setq org-special-ctrl-k t))

;; Enable Speed Keys, which allows quick single-key commands when the cursor is placed on a heading. Usually the cursor needs to be at the beginning of a headline line, but defining it with this function makes them active on any of the asterisks at the beginning of the line.
(after! org
  (setq org-use-speed-commands
        (lambda ()
          (and (looking-at org-outline-regexp)
               (looking-back "^\**")))))

;; Disable electric-mode, which is now respected by Org and which creates some confusing indentation sometimes.
(add-hook! org-mode (electric-indent-local-mode -1))

;; I really dislike completion of words as I type prose (in code it’s OK), so I disable it in Org:

(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))
(add-hook! org-mode (zz/adjust-org-company-backends))

;;Org visual settings
;;Enable variable and visual line mode in Org mode by default.

(add-hook! org-mode :append
           #'visual-line-mode
           #'variable-pitch-mode)

;; Use org-appear to reveal emphasis markers when moving the cursor over them.
(add-hook! org-mode :append #'org-appear-mode)

;; Capturing and note taking
;; First, I define where all my Org-captured things can be found.
;; (after! org
;;   (setq org-agenda-files
;;         '("~/gtd" "~/Work/work.org.gpg" "~/org/")))

;; I define some global keybindings to open my frequently-used org files (original tip from Learn how to take notes more efficiently in Org Mode).
;; First, I define a helper function to define keybindings that open files. Note that this requires lexical binding to be enabled, so that the lambda creates a closure, otherwise the keybindings don’t work.
(defun zz/add-file-keybinding (key file &optional desc)
  (let ((key key)
        (file file)
        (desc desc))
    (map! :desc (or desc file)
          key
          (lambda () (interactive) (find-file file)))))

;;Now I define keybindings to access my commonly-used org files.
(zz/add-file-keybinding "C-c z w" "~/Work/work.org.gpg" "work.org")
(zz/add-file-keybinding "C-c z i" "~/org/ideas.org" "ideas.org")
(zz/add-file-keybinding "C-c z p" "~/org/projects.org" "projects.org")
(zz/add-file-keybinding "C-c z d" "~/org/diary.org" "diary.org")

;; I’m still trying out org-roam, although I have not figured out very well how it works for my setup.
;; (setq org-roam-directory "~/Dropbox/Personal/org-roam/")
;; (setq +org-roam-open-buffer-on-find-file t)

;; Configure attachments to be stored together with their Org document.
(setq org-attach-id-dir "attachments/")

;; Capturing images
;; Using org-download to make it easier to insert images into my org notes. I don’t like the configuration provided by Doom as part of the (org +dragndrop) module, so I install the package by hand and configure it to my liking. I also define a new keybinding to paste an image from the clipboard, asking for the filename first.
(defun zz/org-download-paste-clipboard (&optional use-default-filename)
  (interactive "P")
  (require 'org-download)
  (let ((file
         (if (not use-default-filename)
             (read-string (format "Filename [%s]: "
                                  org-download-screenshot-basename)
                          nil nil org-download-screenshot-basename)
           nil)))
    (org-download-clipboard file)))

(after! org
  (setq org-download-method 'directory)
  (setq org-download-image-dir "images")
  (setq org-download-heading-lvl nil)
  (setq org-download-timestamp "%Y%m%d-%H%M%S_")
  (setq org-image-actual-width 300)
  (map! :map org-mode-map
        "C-c l a y" #'zz/org-download-paste-clipboard
        "C-M-y" #'zz/org-download-paste-clipboard))

;; Capturing links
;; Capturing and creating internal Org links
;; I normally use counsel-org-link for linking between headings in an Org document. It shows me a searchable list of all the headings in the current document, and allows selecting one, automatically creating a link to it. Since it doesn’t have a keybinding by default, I give it one.
(map! :after counsel :map org-mode-map
      "C-c l l h" #'counsel-org-link)

;; I also configure counsel-outline-display-style so that only the headline title is inserted into the link, instead of its full path within the document.
(after! counsel
  (setq counsel-outline-display-style 'title))

;; counsel-org-link uses org-id as its backend which generates IDs using UUIDs, and it uses the ID property to store them. I prefer using human-readable IDs stored in the CUSTOM_ID property of each heading, so we need to make some changes.
;; First, configure org-id to use CUSTOM_ID if it exists. This affects the links generated by the org-store-link function.
;; (after! org-id
;;   ;; Do not create ID if a CUSTOM_ID exists
;;   (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))

;; Second, I override counsel-org-link-action, which is the function that actually generates and inserts the link, with a custom function that computes and inserts human-readable CUSTOM_ID links. This is supported by a few auxiliary functions for generating and storing the CUSTOM_ID.
(defun zz/make-id-for-title (title)
  "Return an ID based on TITLE."
  (let* ((new-id (replace-regexp-in-string "[^[:alnum:]]" "-" (downcase title))))
    new-id))

(defun zz/org-custom-id-create ()
  "Create and store CUSTOM_ID for current heading."
  (let* ((title (or (nth 4 (org-heading-components)) ""))
         (new-id (zz/make-id-for-title title)))
    (org-entry-put nil "CUSTOM_ID" new-id)
    (org-id-add-location new-id (buffer-file-name (buffer-base-buffer)))
    new-id))

(defun zz/org-custom-id-get-create (&optional where force)
  "Get or create CUSTOM_ID for heading at WHERE.

If FORCE is t, always recreate the property."
  (org-with-point-at where
    (let ((old-id (org-entry-get nil "CUSTOM_ID")))
      ;; If CUSTOM_ID exists and FORCE is false, return it
      (if (and (not force) old-id (stringp old-id))
          old-id
        ;; otherwise, create it
        (zz/org-custom-id-create)))))

;; Now override counsel-org-link-action
(after! counsel
  (defun counsel-org-link-action (x)
    "Insert a link to X.

X is expected to be a cons of the form (title . point), as passed
by `counsel-org-link'.

If X does not have a CUSTOM_ID, create it based on the headline
title."
    (let* ((id (zz/org-custom-id-get-create (cdr x))))
      (org-insert-link nil (concat "#" id) (car x)))))

;; Ta-da! Now using counsel-org-link inserts nice, human-readable links.

;; Capturing links to external applications
;; org-mac-link implements the ability to grab links from different Mac apps and insert them in the file. Bind C-c g to call org-mac-grab-link to choose an application and insert a link.

(when IS-MAC
  (use-package! org-mac-link
    :after org
    :config
    (setq org-mac-grab-Acrobat-app-p nil) ; Disable grabbing from Adobe Acrobat
    (setq org-mac-grab-devonthink-app-p nil) ; Disable grabbinb from DevonThink
    (map! :map org-mode-map
          "C-c g"  #'org-mac-grab-link)))

;; Tasks and agenda
;; Customize the agenda display to indent todo items by level to show nesting, and enable showing holidays in the Org agenda display.
(after! org-agenda
  ;; (setq org-agenda-prefix-format
  ;;       '((agenda . " %i %-12:c%?-12t% s")
  ;;         ;; Indent todo items by level to show nesting
  ;;         (todo . " %i %-12:c%l")
  ;;         (tags . " %i %-12:c")
  ;;        (search . " %i %-12:c")))
  (setq org-agenda-include-diary t))

;; ;;Install and load some custom local holiday lists I’m interested in.
(use-package! holidays
  :after org-agenda
  :config
  (require 'spanish-holidays)
  (require 'swiss-holidays)
  (setq swiss-holidays-zh-city-holidays
        '((holiday-float 4 1 3 "Sechseläuten")
          (holiday-float 9 1 3 "Knabenschiessen")))
  (setq calendar-holidays
        (append '((holiday-fixed 1 1 "New Year's Day")
                  (holiday-fixed 2 14 "Valentine's Day")
                  (holiday-fixed 4 1 "April Fools' Day")
                  (holiday-fixed 10 31 "Halloween")
                  (holiday-easter-etc)
                  (holiday-fixed 12 25 "Christmas")
                  (solar-equinoxes-solstices))
                swiss-holidays
                swiss-holidays-labour-day
                swiss-holidays-catholic
                swiss-holidays-zh-city-holidays
                spanish-holidays)))

;; org-super-agenda provides great grouping and customization features to make agenda mode easier to use.
(use-package! org-super-agenda
  :after org-agenda
  :config
  (setq org-super-agenda-groups '((:auto-dir-name t)))
  (org-super-agenda-mode))

;; I configure org-archive to archive completed TODOs by default to the archive.org file in the same directory as the source file, under the “date tree” corresponding to the task’s CLOSED date - this allows me to easily separate work from non-work stuff. Note that this can be overridden for specific files by specifying the desired value of org-archive-location in the #+archive: property at the top of the file.
(use-package! org-archive
  :after org
  :config
  (setq org-archive-location "archive.org::datetree/"))

;; I have started using org-clock to track time I spend on tasks. Often I restart Emacs for different reasons in the middle of a session, so I want to persist all the running clocks and their history.
(after! org-clock
  (setq org-clock-persist t)
  (org-clock-persistence-insinuate))

;; GTD
;; I am trying out Trevoke’s org-gtd. I haven’t figured out my perfect workflow for tracking GTD with Org yet, but this looks like a very promising approach.

(use-package! org-gtd
  :after org
  :config
  ;; where org-gtd will put its files. This value is also the default one.
  (setq org-gtd-directory "~/gtd/")
  ;; package: https://github.com/Malabarba/org-agenda-property
  ;; this is so you can see who an item was delegated to in the agenda
  (setq org-agenda-property-list '("DELEGATED_TO"))
  ;; I think this makes the agenda easier to read
  (setq org-agenda-property-position 'next-line)
  ;; package: https://www.nongnu.org/org-edna-el/
  ;; org-edna is used to make sure that when a project task gets DONE,
  ;; the next TODO is automatically changed to NEXT.
  (setq org-edna-use-inheritance t)
  (org-edna-load)
  :bind
  (("C-c d c" . org-gtd-capture) ;; add item to inbox
   ("C-c d a" . org-agenda-list) ;; see what's on your plate today
   ("C-c d p" . org-gtd-process-inbox) ;; process entire inbox
   ("C-c d n" . org-gtd-show-all-next) ;; see all NEXT items
   ;; see projects that don't have a NEXT item
   ("C-c d s" . org-gtd-show-stuck-projects)
   ;; the keybinding to hit when you're done editing an item in the
   ;; processing phase
   ("C-c d f" . org-gtd-clarify-finalize)))

;; Capture templates
;; We define the corresponding Org-GTD capture templates.
(after! (org-gtd org-capture)
  (add-to-list 'org-capture-templates
               '("i" "GTD item"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i"
                 :kill-buffer t))
  (add-to-list 'org-capture-templates
               '("l" "GTD item with link to where you are in emacs now"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i\n  %a"
                 :kill-buffer t))
  (add-to-list 'org-capture-templates
               '("m" "GTD item with link to current Outlook mail message"
                 entry
                 (file (lambda () (org-gtd--path org-gtd-inbox-file-basename)))
                 "* %?\n%U\n\n  %i\n  %(org-mac-outlook-message-get-links)"
                 :kill-buffer t)))

;; I set up an advice before org-capture to make sure org-gtd and org-capture are loaded, which triggers the setup of the templates above.
(defadvice! +zz/load-org-gtd-before-capture (&optional goto keys)
    :before #'org-capture
    (require 'org-capture)
    (require 'org-gtd))

;; Publishing to LeanPub
;; I use LeanPub for self-publishing my books. Fortunately, it is possible to export from org-mode to both LeanPub-flavored Markdown and Markua, so I can use Org for writing the text and simply export it in the correct format and structure needed by Leanpub.
;; When I decided to use org-mode to write my books, I looked around for existing modules and code. Here are some of the resources I found:
;; Description of ox-leanpub.el (GitHub repo) by Juan Reyero;
;; Publishing a book using org-mode by Lakshmi Narasimhan;
;; Publishing a Book with Leanpub and Org Mode by Jon Snader (from where I found the links to the above).
;; Building upon these, I developed a new ox-leanpub package which you can find in MELPA (source at https://github.com/zzamboni/ox-leanpub), and which I load and configure below.
;; The ox-leanpub module sets up Markua export automatically. I add the code for setting up the Markdown exporter too (I don’t use it, but just to keep an eye on any breakage):
(use-package! ox-leanpub
  :after org
  :config
  (require 'ox-leanpub-markdown)
  (org-leanpub-book-setup-menu-markdown))
;; I highly recommend using Markua rather than Markdown, as it is the format that Leanpub is guaranteed to support in the future, and where most of the new features are being developed.
;; With this setup, I can write my book in org-mode (I usually keep a single book.org file at the top of my repository), and then call the corresponding “Book” export commands. The manuscript directory, as well as the corresponding Book.txt and other necessary files are created and populated automatically.
;; If you are interested in learning more about publishing to Leanpub with Org-mode, check out my book Publishing with Emacs, Org-mode and Leanpub.

;; Blogging with Hugo
;; ox-hugo is an awesome way to blog from org-mode. It makes it possible for posts in org-mode format to be kept separate, and it generates the Markdown files for Hugo. Hugo supports org files, but using ox-hugo has multiple advantages:

;; Parsing is done by org-mode natively, not by an external library. Although goorgeous (used by Hugo) is very good, it still lacks in many areas, which leads to text being interpreted differently as by org-mode.
;; Hugo is left to parse a native Markdown file, which means that many of its features such as shortcodes, TOC generation, etc., can still be used on the generated file.
;; Doom Emacs includes and configures ox-hugo as part of its (:lang org +hugo) module, so all that’s left is to configure some parameters to my liking.

;; I set org-hugo-use-code-for-kbd so that I can apply a custom style to keyboard bindings in my blog.

(after! ox-hugo
  (setq org-hugo-use-code-for-kbd t))

;; Code for org-mode macros
;; Here I define functions which get used in some of my org-mode macros

;; The first is a support function which gets used in some of the following, to return a string (or an optional custom string) only if it is a non-zero, non-whitespace string, and nil otherwise.

(defun zz/org-if-str (str &optional desc)
  (when (org-string-nw-p str)
    (or (org-string-nw-p desc) str)))
;; This function receives three arguments, and returns the org-mode code for a link to the Hammerspoon API documentation for the link module, optionally to a specific function. If desc is passed, it is used as the display text, otherwise section.function is used.

(defun zz/org-macro-hsapi-code (module &optional func desc)
  (org-link-make-string
   (concat "https://www.hammerspoon.org/docs/"
           (concat module (zz/org-if-str func (concat "#" func))))
   (or (org-string-nw-p desc)
       (format "=%s="
               (concat module
                       (zz/org-if-str func (concat "." func)))))))

;;Split STR at spaces and wrap each element with the ~ char, separated by +. Zero-width spaces are inserted around the plus signs so that they get formatted correctly. Envisioned use is for formatting keybinding descriptions. There are two versions of this function: “outer” wraps each element in ~, the “inner” wraps the whole sequence in them.

(defun zz/org-macro-keys-code-outer (str)
  (mapconcat (lambda (s)
               (concat "~" s "~"))
             (split-string str)
             (concat (string ?\u200B) "+" (string ?\u200B))))
(defun zz/org-macro-keys-code-inner (str)
  (concat "~" (mapconcat (lambda (s)
                           (concat s))
                         (split-string str)
                         (concat (string ?\u200B) "-" (string ?\u200B)))
          "~"))
(defun zz/org-macro-keys-code (str)
  (zz/org-macro-keys-code-inner str))

;; ;; Links to a specific section/function of the Lua manual.

;; (defun zz/org-macro-luadoc-code (func &optional section desc)
;;   (org-link-make-string
;;    (concat "https://www.lua.org/manual/5.3/manual.html#"
;;            (zz/org-if-str func section))
;;    (zz/org-if-str func desc)))
;; (defun zz/org-macro-luafun-code (func &optional desc)
;;   (org-link-make-string
;;    (concat "https://www.lua.org/manual/5.3/manual.html#"
;;            (concat "pdf-" func))
;;    (zz/org-if-str (concat "=" func "()=") desc)))

;; Reformatting an Org buffer
;; I picked up this little gem in the org mailing list. A function that reformats the current buffer by regenerating the text from its internal parsed representation. Quite amazing.

(defun zz/org-reformat-buffer ()
  (interactive)
  (when (y-or-n-p "Really format current buffer? ")
    (let ((document (org-element-interpret-data (org-element-parse-buffer))))
      (erase-buffer)
      (insert document)
      (goto-char (point-min)))))

;; Avoiding non-Org mode files
;; org-pandoc-import is a mode that automates conversions to/from Org mode as much as possible.

(use-package org-pandoc-import)

;; Reveal.js presentations
;; I use org-re-reveal to make presentations. The functions below help me improve my workflow by automatically exporting the slides whenever I save the file, refreshing the presentation in my browser, and moving it to the slide where the cursor was when I saved the file. This helps keeping a “live” rendering of the presentation next to my Emacs window.

;; The first function is a modified version of the org-num--number-region function of the org-num package, but modified to only return the numbering of the innermost headline in which the cursor is currently placed.

(defun zz/org-current-headline-number ()
  "Get the numbering of the innermost headline which contains the
cursor. Returns nil if the cursor is above the first level-1
headline, or at the very end of the file. Does not count
headlines tagged with :noexport:"
  (require 'org-num)
  (let ((org-num--numbering nil)
        (original-point (point)))
    (save-mark-and-excursion
      (let ((new nil))
        (org-map-entries
         (lambda ()
           (when (org-at-heading-p)
             (let* ((level (nth 1 (org-heading-components)))
                    (numbering (org-num--current-numbering level nil)))
               (let* ((current-subtree (save-excursion (org-element-at-point)))
                      (point-in-subtree
                       (<= (org-element-property :begin current-subtree)
                           original-point
                           (1- (org-element-property :end current-subtree)))))
                 ;; Get numbering to current headline if the cursor is in it.
                 (when point-in-subtree (push numbering
                                              new))))))
         "-noexport")
        ;; New contains all the trees that contain the cursor (i.e. the
        ;; innermost and all its parents), so we only return the innermost one.
        ;; We reverse its order to make it more readable.
        (reverse (car new))))))

;; The zz/refresh-reveal-prez function makes use of the above to perform the presentation export, refresh and update. You can use it by adding an after-save hook like this (add at the end of the file):
;; * Local variables :ARCHIVE:noexport:
;; # Local variables:
;; # eval: (add-hook! after-save :append :local (zz/refresh-reveal-prez))
;; # end:
;; Note #1: This is specific to my OS (macOS) and the browser I use (Brave). I will make it more generic in the future, but for now feel free to change it to your needs.
;; Note #2: the presentation must be already open in the browser, so you must run “Export to reveal.js -> To file and browse” (C-c C-e v b) once by hand.
(defun zz/refresh-reveal-prez ()
  ;; Export the file
  (org-re-reveal-export-to-html)
  (let* ((slide-list (zz/org-current-headline-number))
         (slide-str (string-join (mapcar #'number-to-string slide-list) "-"))
         ;; Determine the filename to use
         (file (concat (file-name-directory (buffer-file-name))
                       (org-export-output-file-name ".html" nil)))
         ;; Final URL including the slide number
         (uri (concat "file://" file "#/slide-" slide-str))
         ;; Get the document title
         (title (cadar (org-collect-keywords '("TITLE"))))
         ;; Command to reload the browser and move to the correct slide
         (cmd (concat
"osascript -e \"tell application \\\"Brave\\\" to repeat with W in windows
set i to 0
repeat with T in (tabs in W)
set i to i + 1
if title of T is \\\"" title "\\\" then
  reload T
  delay 0.1
  set URL of T to \\\"" uri "\\\"
  set (active tab index of W) to i
end if
end repeat
end repeat\"")))
    ;; Short sleep seems necessary for the file changes to be noticed
    (sleep-for 0.2)
    (call-process-shell-command cmd)))

;; Other exporters
;; ox-jira to export in Jira markup format.
(use-package! ox-jira
  :after org)

;; org-jira for full Jira integration - manage issues from Org mode.
(make-directory "~/.org-jira" 'ignore-if-exists)
(setq jiralib-url "https://jira.swisscom.com/")

;; org-special-block-extras to enable additional special block types and their corresponding exports (disabled for now).
(use-package! org-special-block-extras
  :after org
  :hook (org-mode . org-special-block-extras-mode))

;; Other Org stuff
;; Testing org-ol-tree.
 ;; (use-package! org-ol-tree
 ;;   :after org)

;; Programming Org
;; Trying out org-ml for easier access to Org objects.
(use-package! org-ml
  :after org)

;; I’m also testing org-ql for structured queries on Org documents.
(use-package! org-ql
  :after org)

;; This function returns a list of all the headings in the given file which have the given tags.
(defun zz/headings-with-tags (file tags)
  (string-join
   (org-ql-select file
     `(tags-local ,@tags)
     :action '(let ((title (org-get-heading 'no-tags 'no-todo)))
                (concat "- "
                        (org-link-make-string
                         (format "file:%s::*%s" file title)
                         title))))
   "\n"))

;; This function returns a list of all the headings in the given file which match the tags of the current heading.
(defun zz/headings-with-current-tags (file)
  (let ((tags (s-split ":" (cl-sixth (org-heading-components)) t)))
    (zz/headings-with-tags file tags)))

;; Coding

;; Tangle-on-save has revolutionized my literate programming workflow. It automatically runs org-babel-tangle upon saving any org-mode buffer, which means the resulting files will be automatically kept up to date. For a while I did this by manually adding org-babel-tangle to the after-save hook in Org mode, but now I use the org-auto-tangle package, which does this asynchronously and selectively for each Org file where it is desired.
(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))


;; Some useful settings for LISP coding - smartparens-strict-mode to enforce parenthesis to match. I map M-( to enclose the next expression as in paredit using a custom function. Prefix argument can be used to indicate how many expressions to enclose instead of just 1. E.g. C-u 3 M-( will enclose the next 3 sexps.
(defun zz/sp-enclose-next-sexp (num)
  (interactive "p")
  (insert-parentheses (or num 1)))

(after! smartparens
  (add-hook! (clojure-mode
              emacs-lisp-mode
              lisp-mode
              cider-repl-mode
              racket-mode
              racket-repl-mode) :append #'smartparens-strict-mode)
  (add-hook! smartparens-mode :append #'sp-use-paredit-bindings)
  (map! :map (smartparens-mode-map smartparens-strict-mode-map)
        "M-(" #'zz/sp-enclose-next-sexp))


;; Adding keybindings for some useful functions:
;; find-function-at-point gets bound to C-c l g p (grouped together with other “go to” functions bound by Doom) and to C-c C-f (analog to the existing C-c f) for faster access.

(after! prog-mode
  (map! :map prog-mode-map "C-h C-f" #'find-function-at-point)
  (map! :map prog-mode-map
        :localleader
        :desc "Find function at point"
        "g p" #'find-function-at-point))


;; Some other languages I use.

;; CFEngine policy files. The cfengine3-mode package is included with Emacs, but I also install org-babel support.
(use-package! cfengine
  :defer t
  :commands cfengine3-mode
  :mode ("\\.cf\\'" . cfengine3-mode))

;; Graphviz for graph generation.
(use-package! graphviz-dot-mode)

;; I am learning Common LISP, which is well supported through the common-lisp Doom module, but I need to configure this in the ~/.slynkrc file for I/O in the Sly REPL to work fine (source).
(setf slynk:*use-dedicated-output-stream* nil)

;; Other tools
;; Miscellaneous packages

;; Dockerfile mode:
(add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode))
(put 'dockerfile-image-name 'safe-local-variable #'stringp)

;; This prevents the docker command from producing ANSI sequences during the image build process, which results in a more readable output in the compilation buffer. From https://emacs.stackexchange.com/a/55340/11843:
(defun plain-pipe-for-process () (setq-local process-connection-type nil))
(add-hook 'compilation-mode-hook 'plain-pipe-for-process)

;; Use Emacs Everywhere!
(use-package! emacs-everywhere
  :config
  (setq emacs-everywhere-major-mode-function #'org-mode))

;; Trying out Magit’s multi-repository abilities. This stays in sync with the git repo list used by my chain:summary-status Elvish shell function by reading the file every time magit-list-repositories is called, using defadvice!. I also customize the display to add the Status column.
(after! magit
  (setq zz/repolist
        "~/.elvish/package-data/elvish-themes/chain-summary-repos.json")
  (defadvice! +zz/load-magit-repositories ()
    :before #'magit-list-repositories
    (setq magit-repository-directories
          (seq-map (lambda (e) (cons e 0)) (json-read-file zz/repolist))))
  (setq magit-repolist-columns
        '(("Name" 25 magit-repolist-column-ident nil)
          ("Status" 7 magit-repolist-column-flag nil)
          ("B<U" 3 magit-repolist-column-unpulled-from-upstream
           ((:right-align t)
            (:help-echo "Upstream changes not in branch")))
          ("B>U" 3 magit-repolist-column-unpushed-to-upstream
           ((:right-align t)
            (:help-echo "Local changes not in upstream")))
          ("Path" 99 magit-repolist-column-path nil))))


;; I prefer to use the GPG graphical PIN entry utility. This is achieved by setting epg-pinentry-mode (epa-pinentry-mode before Emacs 27) to nil instead of the default 'loopback.
(after! epa
  (set 'epg-pinentry-mode nil)
  (setq epa-file-encrypt-to '("diego@zzamboni.org")))

;; I find iedit absolutely indispensable when coding. In short: when you hit Ctrl-;, all occurrences of the symbol under the cursor (or the current selection) are highlighted, and any changes you make on one of them will be automatically applied to all others. It’s great for renaming variables in code, but it needs to be used with care, as it has no idea of semantics, it’s a plain string replacement, so it can inadvertently modify unintended parts of the code.
(use-package! iedit
  :defer
  :config
  (set-face-background 'iedit-occurrence "Magenta")
  :bind
  ("C-;" . iedit-mode))

;; A useful macro (sometimes) for timing the execution of things. From StackOverflow.
(defmacro zz/measure-time (&rest body)
  "Measure the time it takes to evaluate BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))

;; I’m still not fully convinced of running a terminal inside Emacs, but vterm is much nicer than any of the previous terminal emulators, so I’m giving it a try. I configure it so that it runs my favorite shell. Vterm runs Elvish flawlessly!
(setq vterm-shell "/usr/local/bin/elvish")
;; Add “unfill” commands to parallel the “fill” ones, bind A-q to unfill-paragraph and rebind M-q to the unfill-toggle command, which fills/unfills paragraphs alternatively.
(use-package! unfill
  :defer t
  :bind
  ("M-q" . unfill-toggle)
  ("A-q" . unfill-paragraph))











;; ;;
;; ;;
;; ;;End of Org Config
;; ;;
;; ;;



;;
;;
;;
;; Maximize the window upon startup.

(setq initial-frame-alist '((top . 1) (left . 1) (width . 114) (height . 32)))
;;(add-to-list 'initial-frame-alist '(maximized))

;;I like ligatures, but some of the ones that get enabled by the (ligatures +extra) module don’t work in the font I use, or I don’t like them, so I disable them.

(plist-put! +ligatures-extra-symbols
  :and           nil
  :or            nil
  :for           nil
  :not           nil
  :true          nil
  :false         nil
  :int           nil
  :float         nil
  :str           nil
  :bool          nil
  :list          nil
)
(let ((ligatures-to-disable '(:true :false :int :float :str :bool :list :and :or :for :not)))
  (dolist (sym ligatures-to-disable)
    (plist-put! +ligatures-extra-symbols sym nil)))

;; Enable showing a word count in the modeline. This is only shown for the modes listed in doom-modeline-continuous-word-count-modes (Markdown, GFM and Org by default).

(setq doom-modeline-enable-word-count t)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
