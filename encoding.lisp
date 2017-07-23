;;; -*- Mode: LISP; Syntax: COMMON-LISP; Package: CL-USER; Base: 10 -*-

(in-package :cl-user)

;;;; ------------------------------------------------------------------
;;;; Setting for the Encoding.
;;;; ------------------------------------------------------------------
;;; To change the default encoding to UTF-8 for all file access.
(defun force-utf-8-file-encoding (pathname ef-spec buffer length)
  (declare (ignore pathname buffer length))
  (system:merge-ef-specs ef-spec :utf-8))
;;  (system:merge-ef-specs ef-spec '(:utf-8 :eol-style :lf)))

(asdf :guess)
(defun guess-japanese-encoding (pathname ef-spec buffer length)
  (ignore-errors
    (if-let (spec (guess:ces-guess-from-vector
                   (external-format:encode-lisp-string buffer :latin-1 :start 0  :end length)
                   :jp))
        (system:merge-ef-specs ef-spec spec)
      ef-spec)))

(setf system:*file-encoding-detection-algorithm*
      '(system:find-filename-pattern-encoding-match
        system:find-encoding-option
        system:detect-utf32-bom
        system:detect-unicode-bom
        system:detect-utf8-bom
        guess-japanese-encoding
        system:detect-japanese-encoding-in-file
        force-utf-8-file-encoding
        system:locale-file-encoding))

(setf stream::*default-external-format* '(:utf-8 :eol-style :lf))

(setf (editor:variable-value "Input Format Default")
      :default)
(setf (editor:variable-value "Output Format Default")
      '(:utf-8 :eol-style :lf))

;;; If you want to use the encoding by UTF-8 and CRLF in the editor, uncomment the following.
;;;;   (setf (editor:variable-value "Input Format Default")
;;;;         '(:utf-8 :eol-style :crlf))
;;;;   (setf (editor:variable-value "Output Format Default")
;;;;         '(:utf-8 :eol-style :crlf))
