;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

;; download http://beta.quicklisp.org/quicklisp.lisp and load it -
;; details at http://www.quicklisp.org/

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

(defmethod asdf:perform :around ((o asdf:load-op) (c asdf:cl-source-file))
  "When trying to load a Lisp source file with ASDF that has a wrong
FASL version recompiles it."
  ;; from Bill Clementson's blog
  (handler-case
    (call-next-method o c)
    (conditions:fasl-error ()
      (asdf:perform (make-instance 'asdf:compile-op) c)
      (call-next-method))))

(defun asdf (lib)
  "Shortcut for ASDF."
  #-quicklisp
  (asdf:oos 'asdf:load-op lib)
  #+quicklisp
  (ql:quickload lib))

;;;; sugar-project default setting
(asdf :sugar-project)
(setf sugar-project:*author* "zqwell"
      sugar-project:*email* "zqwell.ss@gmail.com"
      sugar-project:*license* "LLGPL")
(setf *skeleton-list*
      `(
        (:name :capi-standard
         :description "CAPI standard skeleton."
         :directory "~/cl-skeleton/capi/")
        (:name :cl-project-default
         :description "cl-project default skeleton."
         :directory ,cl-project:*skeleton-directory*)
        ))
