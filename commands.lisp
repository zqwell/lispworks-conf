;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

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
