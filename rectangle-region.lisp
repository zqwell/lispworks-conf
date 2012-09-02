(in-package :editor)

(defparameter editor::*kill-ring-length* 100)
(defparameter editor::*kill-ring* (make-ring editor::*kill-ring-length* "Kill ring."))

;; 矩形領域切り取りコマンド定義
(defvar *kill-rectangle-ring* (make-ring 100 "kill rectangle ring"))
;;(defparameter *kill-rectangle-ring* (make-ring 10 "kill rectangle ring"))

(editor:defcommand "Save Rectangle Region" (p)
     "Save Rectangle Region"
     "Save Rectangle Region"
  (declare (ignore p))
  (let ((buffer (editor:current-buffer)))
    (save-excursion
      (with-buffer-locked (buffer)
        (with-point
           ((start (editor:buffer-point buffer) :after-insert)
            (end (editor:buffer-mark buffer) :after-insert))
          (when (editor:point> start end)
            (rotatef start end))
          (let* ((min-column (min (editor:point-column start)
                                  (editor:point-column end)))
                 (max-column (max (editor:point-column start)
                                  (editor:point-column end)))
                 (width (- max-column min-column)))
            (loop while (editor:point<= start end)
                  with string-list = nil
                  do
                  (with-point
                     ((pt1 start :after-insert)
                      (pt2 start :after-insert))
                    (line-start pt1)
                    (line-end pt2)
                    (push
                     (cond
                      ((< (point-column pt2) min-column) "")
                      ((< (point-column pt2) max-column)
                       (character-offset pt1 min-column)
                       (points-to-string pt1 pt2))
                      (t
                       (character-offset pt1 min-column)
                       (line-start pt2)
                       (character-offset pt2 max-column)
                       (points-to-string pt1 pt2)))
                     string-list))
                  while (line-offset start 1)
                  finally (ring-push
                           (reverse
                            (mapcar (lambda (line)
                                      (if (< (length line) width)
                                          (concatenate 'string line
                                                       (make-string (- width (length line))
                                                                    :initial-element #\space))
                                        line))
                                    string-list))
                           *kill-rectangle-ring*))))))))

(editor:defcommand "Kill Rectangle Region" (p)
     "Kill Rectangle Region"
     "Kill Rectangle Region"
  (declare (ignore p))
  (let ((buffer (editor:current-buffer)))
    (save-excursion
      (with-buffer-locked (buffer)
        (with-point
           ((start (editor:buffer-point buffer) :after-insert)
            (end (editor:buffer-mark buffer) :after-insert))
          (when (editor:point> start end)
            (rotatef start end))
          (let* ((min-column (min (editor:point-column start)
                                  (editor:point-column end)))
                 (max-column (max (editor:point-column start)
                                  (editor:point-column end)))
                 (width (- max-column min-column)))
            (lw-add-ons::recording-for-undo-locking start end
              (loop while (editor:point<= start end)
                    with string-list = nil
                    do
                    (with-point
                       ((pt1 start :after-insert)
                        (pt2 start :after-insert))
                      (line-start pt1)
                      (line-end pt2)
                      (push
                       (cond
                        ((< (point-column pt2) min-column) "")
                        ((< (point-column pt2) max-column)
                         (character-offset pt1 min-column)
                         (prog1
                             (points-to-string pt1 pt2)
                           (delete-between-points pt1 pt2)))
                        (t
                         (character-offset pt1 min-column)
                         (line-start pt2)
                         (character-offset pt2 max-column)
                         (prog1
                             (points-to-string pt1 pt2)
                           (delete-between-points pt1 pt2))))
                       string-list))
                    while (line-offset start 1)
                    finally (ring-push
                             (reverse
                              (mapcar (lambda (line)
                                        (if (< (length line) width)
                                            (concatenate 'string line
                                                         (make-string (- width (length line))
                                                                      :initial-element #\space))
                                          line))
                                      string-list))
                             *kill-rectangle-ring*)))))))))

(defun yank-rectangle-region-with-data (point data)
  (let ((buffer (editor:current-buffer)))
    (editor:with-buffer-locked (buffer)
        (collect-undo buffer
          (with-point
             ((start (or point (editor:buffer-point buffer) :before-insert)))
            (let ((column (editor:point-column start))
                  (svstart (copy-point start :before-insert)))
              (save-excursion
                (loop for line in data
                      do
                      (editor:line-end start)
                      (if (< (editor:point-column start) column)
                          (dotimes (v (- column (editor:point-column start)))
                            (editor:insert-character start #\Space))
                        (progn
                          (editor:line-start start)
                          (editor:character-offset start column)))
                      
                      (editor:insert-string start line)
                      
                      (line-start start)
                      (unless (editor:line-offset start 1)
                        (line-end start)
                        (editor:insert-character start #\newline)
                        (editor:line-offset start 1))))
              (move-point (buffer-point buffer) svstart)
              (delete-point svstart)))))))

(editor:defcommand "Yank Rectangle Region" (p)
     "Yank Rectangle Region"
     "Yank Rectangle Region"
  (if (zerop (ring-length *kill-rectangle-ring*))
      (editor-error "Rectangle ring is nothing")
    (yank-rectangle-region-with-data p (ring-ref *kill-rectangle-ring* 0))))


;;;; utility function ;;;;;;
(capi:define-interface select-item-window ()
  ()
  (:panes
   (list-panel
    capi:list-panel
    :items (:initarg items)
    :print-function (:initarg (name-function #'print))
    :callback-type :interface-data
    :selection-callback (:initarg (description-function #'print)
                         (lambda (interface data)
                           (with-slots ((text-pane multi-line-text-input-pane)) interface
                             (setf (capi:text-input-pane-text text-pane)
                                (funcall description-function data))
                             (capi:scroll text-pane :vertical :move :start))))
    :action-callback (:initarg (data-function #'identity)
                      (lambda (interface data)
                        (declare (ignore interface))
                        (capi:exit-dialog (funcall data-function data))))
    :keyboard-search-callback (:initarg keyboard-search-callback))
   (multi-line-text-input-pane
    capi:multi-line-text-input-pane ;
  ;  :font (graphics-ports:make-font-description :family "MS Gothic" :size 10)
    :vertical-scroll t))
  (:layouts
   (main-layout
    capi:column-layout
    '(list-panel :divider multi-line-text-input-pane)
    :ratios '(1 nil 1)))
  (:default-initargs
   :layout 'main-layout))

(defmethod update-description-pane ((interface select-item-window))
  (with-slots (list-panel) interface
    (when (capi:choice-selected-item list-panel)
      (funcall (capi:callbacks-selection-callback list-panel)
               interface (capi:choice-selected-item list-panel)))))

(defmethod initialize-instance :after ((interface select-item-window) &rest initargs &key &allow-other-keys)
  (update-description-pane interface))

(defun popup-select-item-confirmer (items message
                                          &rest interface-args
                                          &key name-function
                                          description-function
                                          data-function
                                          keyboard-search-callback
                                          &allow-other-keys)
                                          
  (apply #'capi:popup-confirmer
         (make-instance 'select-item-window
                        :name-function (or name-function #'print)
                        :description-function (or description-function #'print)
                        :data-function (or data-function #'identity)
                        :keyboard-search-callback (or keyboard-search-callback t)
                        :items items)
         (cons message
               interface-args)))

#| ;; exsample
(popup-select-item-confirmer '(("aa" "bbbb" "ccccc") ("dddddd" "eeee" "ffff") ("gggg" "hhh" "iii"))
                             "select kill rectangle ring"
                             :best-height 500 :best-width 300
                             :name-function #'car
                             :description-function (lambda (data)
                                                             (format nil "~{~A~^~%~}" data)))
|#

(defcommand "Select Kill Rectangle Ring" (p)
  "" ""
  (let ((items
         (loop for x from 0 below (ring-length *kill-rectangle-ring*)
               collect (list x (ring-ref *kill-rectangle-ring* x)))))
    (if (zerop (length items))
        (editor-error "Rectangle ring is nothing")
      (let ((selected-item
             (popup-select-item-confirmer
              items
              "select kill rectangle ring"
              :best-height 500 :best-width 600
              :name-function (lambda (data)
                               (format nil "~{~2D:  ~A~}" data))
              :description-function (lambda (data)
                                      (format nil "~{~A~^~%~}" (second data))))))
        (when selected-item
          ;;(rotate-ring *kill-rectangle-ring* (first selected-item))
          ;;ringの先頭の文字列でないならringへ追加する
          ;;同じ文字列でいっぱいにならないよう取り敢えずの処置
          (unless (zerop (first selected-item))
            (ring-push (second selected-item) *kill-rectangle-ring*))
          (yank-rectangle-region-with-data p (second selected-item)))))))


(defcommand "Select Kill Ring" (p)
  "" ""
  (declare (ignore p))
  (let ((items
         (loop for x from 0 below (ring-length *kill-ring*)
               collect (list x (editor::buffer-string-string (ring-ref editor::*kill-ring* x))))))
    (if (zerop (length items))
        (editor-error "Kill Ring is nothing")
      (let ((selected-item
             (popup-select-item-confirmer
              items
              "select kill ring"
              :best-height 500 :best-width 600
              :name-function (lambda (data)
                               (format nil "~{~2D:  ~A~}" data))
              :description-function (lambda (data)
                                      (format nil "~A" (second data))))))
        (when selected-item
          ;;get-current-yank-text関数内で、clipboradの中身があれば優先して貼り付けるように
          ;;なっているため、選択した文字列が優先して使われるようclipboardの中身を書き換える
          (when *save-region-to-clip-board-by-default*
            (copy-window-region-to-clipboard (current-window) (second selected-item)))
          ;;(rotate-ring editor::*kill-ring* (first selected-item))
          (editor:un-kill-command (1+ (first selected-item))))))))
          ;;(editor:un-kill-command 1))))))

(editor:bind-key "Kill Rectangle Region"  #\control-\W)
(editor:bind-key "Save Rectangle Region"  #\meta-\W)
(editor:bind-key "Yank Rectangle Region"  #\control-\Y)
;(editor:bind-key "Select Kill Rectangle Ring" #\control-\meta-\Y)
;(editor:bind-key "Select Kill Ring" #\control-\meta-\y)
(editor:bind-key "Select Kill Rectangle Ring" #\meta-\Y)
(editor:bind-key "Select Kill Ring" #\meta-\y)


(in-package :cl-user)
