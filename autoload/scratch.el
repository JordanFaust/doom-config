;;; ~/.config/doom/autoload/scratch.el -*- lexical-binding: t; -*-

;;
;;; Scratch frame

(defvar +scratch--scratch-frame nil)

(defun cleanup-scratch-frame (frame)
  (when (eq frame +scratch--scratch-frame)
    (with-selected-frame frame
      (setq doom-fallback-buffer-name (frame-parameter frame 'old-fallback-buffer))
      (remove-hook 'delete-frame-functions #'cleanup-scratch-frame))))

(define-minor-mode +scratch-mode
  "Tweak the current buffer to provide some useful keybinds in the scratch buffer."
  :init-value nil
  :keymap `((,(kbd "C-c C-k") . evil-quit))
  (display-line-numbers-mode -1))

;;;###autoload
(defun open-scratch-frame (&optional fn)
  "Opens the org-capture window in a floating frame that cleans itself up once
you're done. This can be called from an external shell script."
  (interactive)
  (let* ((frame-title-format "")
         (preframe (cl-loop for frame in (frame-list)
                            if (equal (frame-parameter frame 'name) "scratch")
                            return frame))
         (frame (unless preframe
                  (make-frame `((name . "scratch")
                                (min-width . 1) (width . 120)
                                (min-height . 1) (height . 24)
                                (transient . t)
                                (internal-border-width . 32)
                                (left-fringe . 0)
                                (right-fringe . 0)
                                (undecorated . t)
                                ,(if IS-LINUX '(display . ":0"))))))
         (scratch-frame (or frame preframe)))
    (setq +scratch--scratch-frame scratch-frame)
    (select-frame-set-input-focus +scratch--scratch-frame)
    (when scratch-frame
      (with-selected-frame scratch-frame
        (if fn
            (call-interactively fn)
          ;; The buffer *can't* be called '*scratch*'. A rule causes issues with that buffer
          (with-current-buffer (switch-to-buffer "*emacs-scratch*")
            (when (eq major-mode 'funamental-mode)
              (emacs-lisp-mode))
            ;; (text-scale-set 2)
            (+scratch-mode))
          (redisplay)
          (set-frame-parameter scratch-frame 'old-fallback-buffer doom-fallback-buffer-name)
          (setq doom-fallback-buffer-name "*scratch*")
          (add-hook 'delete-frame-functions #'cleanup-scratch-frame))))))
