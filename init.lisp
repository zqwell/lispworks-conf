;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

;; download http://beta.quicklisp.org/quicklisp.lisp and load it -
;; details at http://www.quicklisp.org/

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

#+(and (or :lispworks5 :lispworks6 :lispworks7) :win32)
(define-action "Initialize LispWorks Tools"
               "Dismiss Splash Screen Quickly"
               #'(lambda (screen)
                   (declare (ignore screen))
                   (w:dismiss-splash-screen t)))

#|
;; Change Background Color for Lispworks Editor.
(defun set-pane-background-colors (x)
  (typecase x
    (capi:echo-area-pane
     (setf (capi:simple-pane-background x) (color:make-rgb 1.0 .67 0.67)))
    (capi:collector-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .8 1.0 .8)))
    (capi:listener-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .8 .8 1.0)))
    (capi:editor-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .9 .9 .8)
;        (capi::simple-pane-foreground x) :black
         ))
    (capi:tab-layout
     (mapcar 'set-pane-background-colors (capi:tab-layout-panes x)))
;    (capi:output-pane
;     (setf (capi:simple-pane-background x) :black
;        (capi::simple-pane-foreground x) :white))
    ))

(let ((*HANDLE-WARN-ON-REDEFINITION* :warn)
      (*redefinition-action* :warn))
  (defmethod capi:interface-display :before ((self lw-tools:listener))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools::help-interface))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:editor))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:output-browser))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:shell))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:inspector))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  )
|#


#|
;; Change Background Color for Lispworks Editor.
(defun set-pane-background-colors (x)
  (typecase x
    (capi:echo-area-pane
     (setf (capi:simple-pane-background x) (color:make-rgb 1.0 .67 0.67)))
    (capi:collector-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .8 1.0 .8)))
    (capi:listener-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .8 .8 1.0)))
    (capi:editor-pane
     (setf (capi:simple-pane-background x) (color:make-rgb .9 .9 .8)
;        (capi::simple-pane-foreground x) :black
         ))
    (capi:tab-layout
     (mapcar 'set-pane-background-colors (capi:tab-layout-panes x)))
;    (capi:output-pane
;     (setf (capi:simple-pane-background x) :black
;           (capi::simple-pane-foreground x) :white))
    ))

(defun set-pane-fonts (x)
  (typecase x
    (capi:list-panel
     (setf (capi:titled-object-title-font x)
           (gp:find-best-font x (gp:make-font-description :stock :system-font :size 18))
           ;(capi:titled-object-message-font x)
           ;(gp:find-best-font x (gp:make-font-description :stock :system-font :size 18))
           (capi:simple-pane-font x)
           (gp:find-best-font x (gp:make-font-description :stock :system-font :size 18))))
    (capi:echo-area-pane
     )
    (capi:collector-pane
     )
    (capi:listener-pane
     )
    (capi:editor-pane
     )
    (capi:tab-layout
     (mapcar 'set-pane-fonts (capi:tab-layout-panes x)))
    (capi:switchable-layout
     (mapcar 'set-pane-fonts (capi:switchable-layout-switchable-children x)))
    ))

(let ((*HANDLE-WARN-ON-REDEFINITION* :warn)
      (*redefinition-action* :warn))
  (defmethod capi:interface-display :before ((self lw-tools:listener))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools::help-interface))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:editor))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :after ((self lw-tools:editor))
    (capi:map-pane-descendant-children
     self 'set-pane-fonts))
  (defmethod capi:interface-display :before ((self lw-tools:output-browser))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:shell))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  (defmethod capi:interface-display :before ((self lw-tools:inspector))
    (capi:map-pane-descendant-children
     self 'set-pane-background-colors))
  )
|#

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
  (asdf:oos 'asdf:load-op lib))

;; `canonical' indentation for IF
(editor:setup-indent "if" 2 2 4)

;; `canonical' indentation for DEFPARSER
(editor:setup-indent "defparser" 1)

;; file types for Lisp mode
(editor:define-file-type-hook 
    ("lispworks" "lisp" "lsp" "cl" "asd")
    (buffer type)
  (declare (ignore type))
  (setf (editor:buffer-major-mode buffer) "Lisp"))

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

(asdf :lw-add-ons)

;; if you use `lw-add-ons:start-swank-server', set up the `swank-loader.lisp' path the following.
(setf lw-add-ons:*swank-loader-pathname*
      (asdf:system-relative-pathname "swank" "swank-loader.lisp"))

;; select backup "strategy"
;; files are backup into `lw-add-ons:*backup-directory*'.
(setq lw-add-ons:*make-backup-filename-function*
      'lw-add-ons:make-backup-filename-using-backup-directory)

#+(and :win32 (not :console-image))
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
