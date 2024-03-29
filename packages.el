;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here, run 'doom sync' on
;; the command line, then restart Emacs for the changes to take effect.
;; Alternatively, use M-x doom/reload.
;;
;; WARNING: Disabling core packages listed in ~/.emacs.d/core/packages.el may
;; have nasty side-effects and is not recommended.


;; All of Doom's packages are pinned to a specific commit, and updated from
;; release to release. To un-pin all packages and live on the edge, do:
;(unpin! t)

;; ...but to unpin a single package:
;(unpin! pinned-package)
;; Use it to unpin multiple packages
;(unpin! pinned-package another-pinned-package)


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a particular repo, you'll need to specify
;; a `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, for whatever reason,
;; you can do so here with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

(package! enh-ruby-mode)

;; (package! tree-sitter-langs :pin "e73eba6b2fbe")
(package! tree-sitter-langs)
(package! tree-sitter)

;; Org and Org Roam Dependencies
(package! vulpea)
(package! org-super-agenda)
(package! org-gcal)

;; Performace improvements
(package! hl-line+)
(package! benchmark-init)

;; Nano
(package! nano-modeline :recipe '(:type git :host github :repo "rougier/nano-modeline"))
(package! anzu :pin "bdb3da5028935a4aea55c40769bc191a81afb54e")
(when (modulep! :editor evil)
  (package! evil-anzu :pin "d3f6ed4773b48767bd5f4708c7f083336a8a8a86"))
(package! minibuffer-header :recipe '(:type git :host github :repo "rougier/minibuffer-header"))

;; Nano Minibuffer
;; (package! mini-frame :recipe '(:type git :host github :repo "muffinmad/emacs-mini-frame"))

;; Theme
(package! treemacs-all-the-icons)

;; Lang
(package! protobuf-mode)

;; Vertico
(package! vertico)
;; (package! vertico-posframe)
(package! orderless)
(package! marginalia)

;; mu4e
(package! mu4e-thread-folding :recipe '(:type git :host github :repo "rougier/mu4e-thread-folding"))
(package! mu4e-dashboard :recipe '(:type git :host github :repo "rougier/mu4e-dashboard"))
