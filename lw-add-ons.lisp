;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

(asdf :lw-add-ons)
(asdf :swank)

;; if you use `lw-add-ons:start-swank-server', set up the `swank-loader.lisp' path the following.
(setf lw-add-ons:*swank-loader-pathname*
      (asdf:system-relative-pathname "swank" "swank-loader.lisp"))

;; select backup "strategy"
;; files are backup into `lw-add-ons:*backup-directory*'.
(setq lw-add-ons:*make-backup-filename-function*
      'lw-add-ons:make-backup-filename-using-backup-directory)

#+(not :console-image)
(define-action "Initialize LispWorks Tools" "Open Editor And Tile Windows"
               'lw-add-ons::open-editor-and-tile-windows-vertically)

#+:lispworks7
(setq lw-add-ons:*use-abbreviated-complete-symbol* nil)

(setq lw-add-ons:*show-doc-string-when-showing-arglist* t)

;;; define functions for using slime with Emacs
(defun meta-documentation-for-slime (string)
  (let ((uri (and string (lw-add-ons::doc-entry string))))
    (when (and uri (plusp (length uri)))
      (hweb:browse uri))))

(defun all-doc-entries ()
  (let ((lw-add-ons::*doc-entries*
         (append (lw-add-ons::collect-hyperdoc-entries)
                 lw-add-ons::*doc-hash-entries*)))
    lw-add-ons::*doc-entries*))

(defun my-start-swank-server ()
  "start swank server"
  (ql:quickload :swank)
  (lw-add-ons:start-swank-server))
