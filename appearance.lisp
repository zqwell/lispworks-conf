;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

;;; Apply color theme.
(load-init-file "lw-editor-color-theme/editor-color-theme")
;; (editor-color-theme:color-theme "default")
;; (editor-color-theme:color-theme "emacs")
;; (editor-color-theme:color-theme "torte")
;; (editor-color-theme:color-theme "plain")
;; (editor-color-theme:color-theme "solarized-dark")
(editor-color-theme:color-theme "solarized-light")

;; file types for Lisp mode
(editor:define-file-type-hook 
    ("lispworks" "lisp" "lsp" "cl" "asd" "ros")
    (buffer type)
  (declare (ignore type))
  (setf (editor:buffer-major-mode buffer) "Lisp"))

;; `canonical' indentation for IF
(editor:setup-indent "if" 2 2 4)

;; `canonical' indentation for DEFPARSER
(editor:setup-indent "defparser" 1)

;; the following two forms make sure the "Find Source" command works
;; with the editor source
#-:lispworks-personal-edition
(load-logical-pathname-translations "EDITOR-SRC")

#-:lispworks-personal-edition
(setf dspec:*active-finders*
        (append dspec:*active-finders*
                (list "EDITOR-SRC:editor-tags-db")))

;; if I press ESC followed by < during a search operation I want to go
;; to the beginning of the buffer and /not/ insert the #\< character
(editor::set-logical-char= #\escape :exit nil
                           (editor::editor-input-style-logical-characters
                            editor::*emacs-input-style*))

;; Run GUI inspect when called from REPL
(setf *inspect-through-gui* t)

;; Jump to definition without highlight
(setf editor:*source-found-action* '(nil nil))
