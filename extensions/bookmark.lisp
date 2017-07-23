;;;;;; Bookmark Utility ;;;;;;;;;;;;;;;

(in-package :editor)

;(export '(restore-bookmark
;          remove-bookmark-if-does-not-exists))

(defvar *bookmark-file-name* ".lispworks.bmk")

(defvar *bookmark-list* nil
  "((pathhame line-num description) ...)")
;;(defparameter *bookmark-list* nil)

(defun count-lines-at (point)
  (1+ (count-lines (buffers-start (point-buffer point))
                   point)))

(defun point->pathname-and-line (point)
  (list
   (buffer-pathname (point-buffer point))
   (count-lines-at point)))

(defun make-point-from-pathname-and-line (pathname line)
  (when (probe-file pathname)
    (multiple-value-bind (buffer new-buffer?)
        (find-file-buffer pathname)
      (let ((point (copy-point (buffers-start buffer) :before-insert)))
        (values (line-offset point (1- line)) (point-buffer point) new-buffer?)))))
  
(defmacro with-make-point ((point (pathname line &optional (auto-close t))) &body body)
  (let ((new-buffer? (gensym))
        (buffer (gensym)))
    `(multiple-value-bind (,point ,buffer ,new-buffer?)
         (make-point-from-pathname-and-line ,pathname ,line)
       (unwind-protect
           (progn ,@body)
         (when (and ,auto-close ,new-buffer?)
           (delete-buffer ,buffer))
         (delete-point ,point)))))

(defun remove-at (list index)
  (concatenate 'list
               (subseq list 0 index)
               (subseq list (1+ index))))

(defun save-bookmark ()
  (with-open-file (out (merge-pathnames *bookmark-file-name* (user-homedir-pathname))
                       :direction :output
                       :if-does-not-exist :create
                       :if-exists :overwrite)
    (write *bookmark-list* :stream out)))

(defun restore-bookmark ()
  (with-open-file (in (merge-pathnames *bookmark-file-name* (user-homedir-pathname))
                       :direction :input
                       :if-does-not-exist nil)
    (when in
      (setf *bookmark-list* (read in)))))

(defun remove-bookmark (index)
  (setf *bookmark-list* (remove-at *bookmark-list* index))
  (save-bookmark))

(defun remove-bookmark-if-does-not-exists ()
  (setf *bookmark-list*
        (remove-if (lambda (elem)
                     (or (not (probe-file (first elem)))
                         (with-make-point (pt ((first elem) (second elem)))
                           (null pt))))
                   *bookmark-list*))
  (save-bookmark))

(defun remove-bookmark-with-filename-and-line (filename line)
  (setf *bookmark-list*
        (remove-if (lambda (elem)
                     (and (equalp (first elem) filename)
                          (= (second elem) line)))
                   *bookmark-list*))
  (save-bookmark))

(editor:defcommand "Add Bookmark" (p)
     "" ""
  (declare (ignore p))
  (if (buffer-pathname (current-buffer))
    (let ((pt (copy-point (editor:current-point) :before-insert))
          (desc (editor:prompt-for-string :prompt "Description: "
                                          :help "Enter the description for the bookmark")))
      (editor:line-start pt)
      (push  (nreverse (cons desc (nreverse (point->pathname-and-line pt)))) *bookmark-list*)
      (save-bookmark))
    (editor-error "Cannot add a bookmark which does not exist file")))

(defun near-point-string (point &optional (forward-num 0) (backward-num 0) (highlight nil))
  (with-point ((sp point)
               (ep point))
    (line-start sp)
    (or (line-offset sp (- forward-num)) (buffer-start sp))
    (line-start ep)
    (or (line-offset ep backward-num) (buffer-end ep))
    (line-end ep)
    (format nil "~{~A~^~%~}"
            (loop while (point< sp ep)
                  for i from 0
                  collect (if highlight
                              (if (and (point<= sp point) (= (count-lines sp point) 0))
                                  (concatenate 'string "★" (line-string sp) "★")
                                (line-string sp))  
                            (line-string sp))
                  while (line-offset sp 1)))))

(defcommand "Select Bookmark" (p)
     "" ""
  (declare (ignore p))
  (if (zerop (length *bookmark-list*))
      (editor-error "Bookmark is empty")
    (progn
      
      (let ((selected-item
             (popup-select-item-confirmer
              *bookmark-list*
              "select bookmark"
              :best-height 500 :best-width 600
              :name-function
              (lambda (data)
                (let ((filename (first data))
                      (line (second data)))
                  (with-make-point (point (filename line))
                    (format nil "~10A (~A): ~A" filename line
                            (if point
                                (line-string point)
                              "--bookmark point does not exist--")))))
              :description-function
              (lambda (data)
                (with-make-point (point ((first data) (second data)))
                  (format nil "[desctiption]: ~A~%[peek text]~%~A" (third data)
                          (if point
                              (near-point-string point 6 6 t)
                            "--bookmark point does not exist--"))))
              :keyboard-search-callback
              (lambda (pane string position)
                (declare (ignore position))
                (let ((selected-index (capi:choice-selection pane)))
                  (when selected-index
                    (cond
                     ((string= "d" string)
                      (when (capi:confirm-yes-or-no "Delete a selected bookmark?")
                        (remove-bookmark selected-index)
                        (setf (capi:collection-items pane) *bookmark-list*)
                        (if (> (length (capi:collection-items pane)) 0)
                            (setf (capi:choice-selection pane) (max (1- selected-index) 0))
                          (capi:exit-dialog nil))))
                     ((string= "e" string)
                      (let ((desc (capi:prompt-for-string
                                   "Enter a bookmark description:"
                                   :initial-value (third (nth selected-index *bookmark-list*))
                                   :accept-null-string t
                                   :pane-args '(:visible-min-width (:character 70)))))
                        (when desc
                          (setf (third (nth selected-index *bookmark-list*)) desc)
                          (save-bookmark)
                          (setf (capi:collection-items pane) *bookmark-list*)
                          (setf (capi:choice-selection pane) selected-index)
                          (update-description-pane (capi:element-interface pane))))))))
                (capi:activate-pane pane) nil))))
        (when selected-item
          (with-make-point (point ((first selected-item) (second selected-item) nil))
            (if point
                (goto-buffer-point (point-buffer point) point :in-same-window t)
              (when (capi:confirm-yes-or-no "This bookmark does not exist. Delete a bookmark?")
                (remove-bookmark-with-filename-and-line
                 (first selected-item)
                 (second selected-item))))))))))

(editor:bind-key "Add Bookmark"  "F2")
(editor:bind-key "Select Bookmark"  "F3")

(in-package :cl-user)
