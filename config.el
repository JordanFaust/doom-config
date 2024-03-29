;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jordan Faust"
      user-mail-address "jfaust47@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 16 :weight 'bold))
;; (setq doom-font (font-spec :family "JetBrainsMonoMedium Nerd Font" :size 16 :weight 'medium))
;; (setq doom-font (font-spec :family "JetBrains Mono SemiBold" :size 16))
;; (setq doom-font (font-spec :family "FiraCode Nerd Font Mono" :size 16 :weight 'medium))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-vilebloom)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/roam/todos")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(setq-hook! 'org-mode-hook display-line-numbers nil)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;;
;; Startup Optimizations
;;

;; Lots of packages depend on these libraries so load them as soon as we can
(use-package! dash :defer t)
(use-package! s :defer t)
(use-package! f :defer t)
(use-package! cl-lib :defer t)
(use-package! ts :defer t)

;; Use the doom-incremental-package loading to load these packaged
(dolist (package '(org-roam ts dash cl-lib s f))
  (push package doom-incremental-packages))

;; Update Load Path
(add-load-path! "snippets")
(add-load-path! "themes")

;;
;; UI Settings
;;

(use-package frame
  :config
  ;; Set floating look to frames and the modeline
  (setq default-frame-alist
        (append (list
                 '(min-height . 1)  '(height . 50)
                 '(min-width  . 1)  '(width  . 130)
                 '(vertical-scroll-bars . nil)
                 '(internal-border-width . 32)
                 '(left-fringe . 0)
                 '(right-fringe . 0)
                 '(tool-bar-lines . 0)
                 '(menu-bar-lines . 0))))

  ;; Turn off truncation indicators within the fringe. This provides a more conistent look and
  ;; feel particularly within the mini-frame drop downs.
  (setq-default fringe-indicator-alist (assq-delete-all 'truncation fringe-indicator-alist))

  ;; Add window dividers for keeping floating headline when using virtical splits
  (setq window-divider-default-right-width 32)
  (setq window-divider-default-places 'right-only)

  ;; Turn off the mode line
  (setq mode-line-format nil)

  (add-hook! 'doom-init-ui-hook
    ;; Remove the header and mode line from the initial splash screen
    (defun +doom-reset-modelines-h ()
      (setq header-line-format nil)
      (setq mode-line-format nil)))

  ;; Define custom face for nano modeline visual bell
  (defface nano-modeline-visual-bell '((t :inherit error))
    "Face to use for the mode-line when `+nano-modeline-visual-bell-config' is used."
    :group 'nano-modeline)

  ;; Bar cursor
  (setq-default cursor-type '(hbar . 2))
  (setq evil-normal-state-cursor '(hbar . 2)))

(after! doom-themes
  (setq doom-themes-treemacs-theme "doom-colors")
  ;; (setq doom-themes-treemacs-theme "all-the-icons")
  ;; (treemacs-load-theme doom-themes-treemacs-theme)
  (doom-themes-treemacs-config)
  ;; (treemacs-load-theme 'treemacs-theme)
  (doom-themes-org-config))

  ;; Fix specific hex code issues with all-the-icons fonts
  ;;(setq all-the-icons-data/octicons-alist (delq (assoc "file-directory" all-the-icons-data/octicons-alist) all-the-icons-data/octicons-alist))
  ;;(setf (alist-get "file-directory" all-the-icons-data/octicons-alist) "\xf114"))




;;
;; LSP Configuration
;;

(after! lsp-mode
  :config
  ;; Limit the width of the completion tooltip to allow room for function documentation
  (setq company-tooltip-maximum-width 70)
  ;; Performance tuning for LSP mode until it doesn't cause issues with company/emacs
  (setq lsp-idle-delay 0.500)
  ;; (setq lsp-lens-enable nil)
  ;; (setq lsp-ui-sideline-enable nil)

  ;; This causes significant performance impacts when using rls for rust. This may
  ;; be less of an issue once using emacs 28 with better json serialization support
  ;; (setq lsp-modeline-code-actions-enable nil)
  ;; (setq lsp-keep-workspace-alive nil)

  (setq lsp-ui-doc-enable t)
  ;; TODO set this to true when webkit issues is fixed
  (setq lsp-ui-doc-use-webkit nil)

  ;; Turn off showing signature details in the modeline. This causes significant
  ;; performance problems when attempting to navigate a buffer. This is particularly
  ;; a problem within buffers for rust projects
  ;; (setq lsp-signature-auto-activate nil)
  ;; (setq lsp-signature-render-documentation nil)
  ;; (setq lsp-eldoc-hook nil)

  ;; Enable LSP UI minor modes
  (lsp-ui-mode 1)

  ;; Enable yas global mode for LSP completions
  (yas-global-mode 1))

;; Attempt to improve performance in rustic mode
;;   set to nil if performance becomes an issues again
;; https://github.com/hlissner/doom-emacs/issues/4153#issuecomment-718405849
(setq-hook! 'rustic-mode-hook company-idle-delay 0.2)
;; Increase the time in look ups when writing in org mode
(setq-hook! 'org-mode-hook company-idle-delay 0.8)

;;
;; Company Configuration
;;
(after! company-box
  :config
  ;; Disable scrollbar. The default-frame-alist settings are messing with the
  ;; display of the scrollbar and the right margin
  (setq company-box-scrollbar nil))

;;
;; Git Fringe
;;
(after! git-gutter-fringe
  :config
  (fringe-mode '12)
  ;; places the git gutter outside the margins.
  (setq-default fringes-outside-margins t)
  ;; thin fringe bitmaps
  (define-fringe-bitmap 'git-gutter-fr:added [224]
    nil 12 '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224]
    nil 12 '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240]
   nil 12 'bottom))

;;
;; Project Configuration
;;

(after! (f projectile)
  :config
  ;; Prevent projects within the following directory from becoming projectile projects
  ;; * ~/ws/go/pkg/ - Go project dependencies (code navigation jumps)
  ;; * ~/.rustup/ - Rust project dependencies (code navigation jumps)
  ;; * ~/.gems/ - Ruby project dependencies (code navigation jumps)
  ;; * ~/.emacs.d/.local
  (setq projectile-ignored-projects
        '("/tmp"
          "~/.rustup/"
          "~/.cargo/registry/"
          "~/.gem/"
          "~/ws/go/pkg/"
          "~/.m2/"
          "~/.emacs.d/.local/"
          "~/notes/roam"))
  (defun projectile-ignored-project-regexp-function (project-root)
    (cl-loop for project in projectile-ignored-projects
             ;; Ignore the home directory
             when (and (f-descendant-of? project-root (expand-file-name project))
                       (string-match (getenv "HOME") (expand-file-name project)))
             return 't))
  (setq projectile-ignored-project-function #'projectile-ignored-project-regexp-function)
  ;; Ignore the following directories when doing project searches
  ;; * .bundle - Ignore local dependency files in project search and don't cache opened buffers
  (add-to-list 'projectile-globally-ignored-directories ".bundle")
  (add-to-list 'projectile-globally-ignored-directories ".yardoc"))

(after! counsel
  ;; Fix improper handling of error codes from ripgrep on Linux
  (setq counsel-rg-base-command "rg -M 240 --with-filename --no-heading --line-number --color never %s || true"))

;;;
;;; Tree Sitter Configuration
;;;

(use-package! tree-sitter-langs
  :defer t)

(use-package! tree-sitter
  :defer-incrementally (tree-sitter-langs)
  :config
  (global-tree-sitter-mode)
  (setq tree-sitter-hl-use-font-lock-keywords nil)
  (pushnew! tree-sitter-major-mode-language-alist '(enh-ruby-mode . ruby))
  (pushnew! tree-sitter-major-mode-language-alist '(terraform-mode . hcl))
  (pushnew! tree-sitter-major-mode-language-alist '(hcl-mode . hcl))
  ;; Add terraform specific highlights
  (tree-sitter-hl-add-patterns 'hcl
    [
     ;; Mark function calls as a call
     (function_call (identifier) @function.call)
     ;; Mark use of var, data, and local as keywords
     ((identifier) @keyword
      (.match? @keyword "^(var|data|local)$"))])
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package! terraform-mode
  :defer t
  :config
  (add-hook 'terraform-mode-hook #'tree-sitter-mode))

(use-package! enh-ruby-mode
  :defer t
  :config
  (setq enh-ruby-font-lock-keywords nil)
  (setq enh-ruby-font-names nil)
  (setq ruby-font-lock-keywords nil))

(use-package! treemacs
  :defer t
  :config
  ;; (setq treemacs-user-header-line-format header-line-format)
  ;; (setq treemacs-window-background-color `(,(doom-color 'fg) . ,(doom-color 'base0)))

  (treemacs-fringe-indicator-mode 'always)
  (treemacs-follow-mode t))

;;;
;;; Notifications
;;;

;; (use-package! alert
;;   :config
;;   (defun alert-osx-notifier-notify (info)
;;     (message "%s" info)
;;     (mac-do-applescript (format "display notification %S with title %S sound name \"Bubble\""
;;                                 (alert-encode-string (plist-get info :message))
;;                                 (alert-encode-string (plist-get info :title))))
;;     (alert-message-notify info))

;;   (setq alert-default-style 'osx-notifier))

;;;
;;; Ligature Modifications
;;;

(setq +ligatures-composition-alist (cl-remove ?. +ligatures-composition-alist :test 'eq :key 'car))

;;;
;;; Better Lisp Editing
;;;

(setq lisp-indent-function 'common-lisp-indent-function)
(setq parinfer-rust-auto-download 't)
(after! parinfer-rust-mode
 (setq parinfer-rust-preferred-mode "smart"))

(after! elisp-mode
  (setq tab-width 2))

;;; :app everywhere
(after! emacs-everywhere
  ;; Easier to match with a bspwm rule:
  ;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
  (setq emacs-everywhere-frame-name-format "emacs-everywhere")

  ;; The modeline is not useful to me in the popup window. It looks much nicer
  ;; to hide it.
  ;; (remove-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)

  ;; Semi-center it over the target window, rather than at the cursor position
  ;; (which could be anywhere).
  (defadvice! center-emacs-everywhere-in-origin-window ()
    :override #'emacs-everywhere-set-frame-position
    (cl-destructuring-bind (x y width height)
        (emacs-everywhere-app-geometry emacs-everywhere-current-app)
      (let ((centered-x (+ x (/ width 2) (- (/ width 4))))
            (centered-y (+ y (/ height 2) (- (/ height 8)))))
        (set-frame-position (selected-frame) centered-x centered-y)))))

;; (use-package! minibuffer-header
;;   :config
;;   (minibuffer-header-mode))

;;
;; Clojure
;;
(after! cider
  (set-popup-rule! "^\\*cider-repl" :height 0.25 :side 'bottom))

;;
;; Protobuf/Graphql
;;
(use-package! protobuf-mode)

;; ;;;
;; ;;; Extensions
;; ;;;

(load! "snippets/+nano-modeline")
(load! "snippets/+ruby")
(load! "snippets/+bindings")
(load! "snippets/+org")
(load! "snippets/+sidebar")
(load! "snippets/+nano-vertico-buffer")
(load! "snippets/+mu4e")
