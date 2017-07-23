;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

(editor:bind-key "Help" "F1")
(editor:bind-key "Delete Previous Character" "Control-h")

#+:lw-add-ons
(editor:bind-key "Insert Space and Show Arglist" #\Space)

(editor:bind-key "Compile Defun" #("Control-c" "Control-c") :mode "Lisp")
(editor:bind-key "Compile and Load Buffer File" #("Control-c" "Control-k") :mode "Lisp")

;;(editor:bind-key "Tools Apropos" #("Control-c" "Control-a"))
(editor:bind-key "Apropos" #("Control-c" "Control-a"))

(editor:bind-key "Toggle Trace" #("Control-c" "Control-t") :mode "Lisp")
(editor:bind-key "Clear Listener" #("Control-c" "Control-t") :mode "Execute")

(editor:bind-key "Evaluate Last Form And Inspect" #("Control-c" "i"))
(editor:bind-key "Evaluate Last Form And Describe" #("Control-c" "d"))

(editor:bind-key "Set Mark And Highlight" "Control-@")
(editor:bind-key "Set Mark And Highlight" "Control-Space")

;; (editor:bind-key "Indent and Complete Symbol" #\Tab :mode "Lisp")

(editor:bind-key "Edit Callers" #("Control-c" "<") :mode "Lisp")
(editor:bind-key "Edit Callees" #("Control-c" ">") :mode "Lisp")

(editor:bind-key "Meta Documentation" "F5")
(editor:bind-key "Function Documentation" "Shift-F5")
(editor:bind-key "Show Documentation" "Ctrl-F5")

(editor:bind-key "Indent New Line" #\Return :mode "Lisp")

(editor:bind-key "Insert Parentheses For Selection" #\( :mode "Lisp")
(editor:bind-key "Insert Double Quotes For Selection" #\" :mode "Lisp")
(editor:bind-key "Move Over ()" #\) :mode "Lisp")
(editor:bind-key "Insert Parentheses For Selection" #\( :mode "Execute")
(editor:bind-key "Insert Double Quotes For Selection" #\" :mode "Execute")
(editor:bind-key "Move Over ()" #\) :mode "Execute")

;;;; (editor:bind-key "Indent New Line" "Return" :mode "Lisp")
;;;; (editor:bind-key "Insert \()" "Control-(" :mode "Lisp")
;;;; (editor:bind-key "Insert \()" "Control-(" :mode "Execute")

(editor:bind-key "Kill Previous Word" "Control-Backspace")
(editor:bind-key "Backward Kill Form" "Meta-Backspace")

(editor:bind-key "Go Back" "Meta-,")
(editor:bind-key "Select Go Back" #("Control-c" "Backspace"))

(editor:bind-key "Macroexpand Form" #("Control-c" "Return"))
(editor:bind-key "Walk Form" #("Control-x" "Return"))

(editor:bind-key "Maybe Invoke Listener Shortcut" "," :mode "Execute")

(editor:bind-key "Tools Editor" "F11")
(editor:bind-key "Tools Listener" "F12")

(editor:bind-key "Beginning of Line" "Home")
(editor:bind-key "End of Line" "End")
(editor:bind-key "Undo" "Control-/")

(editor:bind-key "Mark Form" "Control-Meta-Space")

(editor:bind-key "Show Documentation" #("Control-c" "Control-d" "d") :mode "Lisp")
(editor:bind-key "Show Documentation" #("Control-c" "Control-d" "Control-d") :mode "Lisp")

(editor:bind-key "Function Arglist Displayer" "Control-i" :mode "Lisp")
(editor:bind-key "Toggle Breakpoint" #("Control-c" "b") :mode "Lisp")

(editor:bind-key "Next Window" "Control-t")
(editor:bind-key "Previous Window" "Control-T")

(editor:bind-key "Tools Listener" #("Control-c" "Control-z"))
(editor:bind-key "Tools Editor" #("Control-c" "z"))

;; (editor:bind-key "Expand File Name" #("Control-c" "Tab"))
(editor:bind-key "Expand File Name With Space" #("Control-c" "Tab"))

(editor:bind-key "Last Keyboard Macro" "F4")

(editor:bind-key "Search Files" "Control-Meta-g")
(editor:bind-key "Search System" "Control-Meta-G")

;; (editor:bind-key "Forward Up List" "Control-Meta-u" :mode "Lisp")
