;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-
;;; $Header: /usr/local/cvsrep/lw-add-ons/.lispworks,v 1.31 2010-11-09 19:51:21 edi Exp $

(in-package :cl-user)

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


#+(and (or :lispworks5 :lispworks6) :win32)
(define-action "Initialize LispWorks Tools"
               "Dismiss Splash Screen Quickly"
               #'(lambda (screen)
                   (declare (ignore screen))
                   (w:dismiss-splash-screen t)))

;; `canonical' indentation for IF
;; (editor:setup-indent "if" 1 2 4)

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

(change-directory (user-homedir-pathname))

;;; The following lines added by ql:add-to-init-file:
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp\\setup.lisp" (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))

;; (asdf :lw-add-ons)
(ql:quickload :lw-add-ons)

(setf lw-add-ons:*swank-loader-pathname*
  (merge-pathnames
   "quicklisp\\dists\\quicklisp\\software\\slime-20120107-cvs\\swank-loader.lisp"
   (user-homedir-pathname)))

;; select backup "strategy"
(setq lw-add-ons:*make-backup-filename-function*
      'lw-add-ons:make-backup-filename-using-backup-directory)

#+(and :win32 (not :console-image))
(define-action "Initialize LispWorks Tools" "Open Editor And Tile Windows"
               'lw-add-ons::open-editor-and-tile-windows-vertically)

;;; some key bindings
(editor:bind-key "Insert Space and Show Arglist" #\Space)

(editor:bind-key "Compile Defun" #(#\control-\c #\control-\c) :mode "Lisp")
(editor:bind-key "Compile and Load Buffer File" #(#\control-\c #\control-\k) :mode "Lisp")

;;(editor:bind-key "Tools Apropos" #(#\control-\c #\control-\a))
(editor:bind-key "Apropos" #(#\control-\c #\control-\a))

(editor:bind-key "Toggle Trace" #(#\control-\c #\control-\t) :mode "Lisp")

(editor:bind-key "Evaluate Last Form And Inspect" #(#\control-\c #\i))
(editor:bind-key "Evaluate Last Form And Describe" #(#\control-\c #\d))

;;(editor:bind-key "Set Mark And Highlight" #\control-\@)
;;(editor:bind-key "Set Mark And Highlight" #\control-space)

;;(editor:bind-key "Indent and Complete Symbol" #\Tab :mode "Lisp")

(editor:bind-key "Edit Callers" #(#\control-\c #\<) :mode "Lisp")
(editor:bind-key "Edit Callees" #(#\control-\c #\>) :mode "Lisp")

(editor:bind-key "Meta Documentation" "F5")

(editor:bind-key "Insert \()" #\control-\( :mode "Lisp")
(editor:bind-key "Insert \()" #\control-\( :mode "Execute")

(editor:bind-key "Indent New Line" #\Return :mode "Lisp")

#+:editor-does-not-have-go-back
(editor:bind-key "Pop Definitions Stack" #\control-\Backspace)

#-:editor-does-not-have-go-back
(progn
  (editor:bind-key "Kill Previous Word" #\control-\Backspace)
  (editor:bind-key "Go Back" #\meta-\Backspace))

#-:editor-does-not-have-go-back
(editor:bind-key "Select Go Back" #(#\control-\c #\Backspace))

(editor:bind-key "Macroexpand Form" #(#\control-\c #\Return))
(editor:bind-key "Walk Form" #(#\control-\x #\Return))

(editor:bind-key "Maybe Invoke Listener Shortcut" #\, :mode "Execute")

(editor:bind-key "Tools Editor" "F11")
(editor:bind-key "Tools Listener" "F12")

;; custom
(editor:bind-key "Beginning of Line" "Home")
(editor:bind-key "End of Line" "End")
(editor:bind-key "Undo" #\control-\/)

(editor:bind-key "Mark Form" #\control-\meta-\Space)

(editor:bind-key "Show Documentation" #(#\control-\c #\control-\d #\d) :mode "Lisp")
(editor:bind-key "Show Documentation" #(#\control-\c #\control-\d #\control-\d) :mode "Lisp")

(editor:bind-key "Function Arglist Displayer" #\control-\i :mode "Lisp")
(editor:bind-key "Toggle Breakpoint" #(#\control-\c #\b) :mode "Lisp")

;;;; (editor:bind-key "Next Window" #\control-\t :mode "Lisp")
;;;; (editor:bind-key "Previous Window" #\control-\T :mode "Lisp")
(editor:bind-key "Next Window" #\control-\t)
(editor:bind-key "Previous Window" #\control-\T)

(editor:bind-key "Tools Listener" #(#\control-\c #\control-\z))
(editor:bind-key "Tools Editor" #(#\control-\c #\z))

(editor:bind-key "Expand File Name" #(#\control-\c #\Tab))

(editor:bind-key "Last Keyboard Macro" "F4")


;; for slime with Emacs

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
  (ql:quickload :swank)
  (lw-add-ons:start-swank-server))

(in-package :editor)
;; http://permalink.gmane.org/gmane.lisp.lispworks.general/671
;;(editor:defcommand "Delete Comment Prefix in Region" (p)
(editor:defcommand "Uncomment Region" (p)
     "Delete all sequences of ; at start of each line in region"
     "Delete comment prefixes"
  (declare (ignore p))
  (let ((buffer (editor:current-buffer)))
    (editor:with-point
       ((start (editor:buffer-point buffer))
        (end (editor:buffer-mark buffer)))
      (when (editor:point> start end)
        (rotatef start end)) ; so point<= start end
      (editor:collect-undo buffer
        (loop while (editor:point< start end)
              do
              (unless (editor:start-line-p start)               ; ensure at start of line
                (editor:line-start start))
              (editor:with-point ((end1 start))
                ;; move a point to end of command prefix
                (loop while (eq (editor:character-at end1 0) #\;)
                      do (editor:character-offset end1 1))
                (unless (point= end1 start)
                  (when (eq (editor:character-at end1 0) #\Space) ; remove separating space
                    (editor:character-offset end1 1)))          ; if any
                (editor:delete-between-points start end1))      ; delete the comment prefix
              (editor:line-offset start 1))))))                 ; move to next line

(in-package :cl-user)
