;;; -*- lexical-binding: t -*-
;;; ~/.doom.d/snippets/+sidebar.el

;;;
;;; Requires
;;;

(load! "+sidebar/sidebar-core.el")
(load! "+sidebar/sidebar-ibuffer.el")

;; TODO move somewhere better
(map! :leader :nvg "os" #'+ibuffer-sidebar-toggle)

(provide '+sidebar)
