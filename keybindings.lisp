;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

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

