(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :hunchentoot)
  (require :cl-who))

(let ((*invoke-debugger-hook*
       (lambda (condition hook)
         (declare (ignore hook))
         (format *error-output* "error: ~a~%" condition)
         (quit :unix-status 1)))
      (document-root "public")
      (port "4466"))
  (print (list document-root port))
  (setq hunchentoot:*hunchentoot-default-external-format*
    (flex:make-external-format :utf-8 :eol-style :lf))
  (setq hunchentoot:*default-content-type* "text/html; charset=utf-8")

  (push (hunchentoot:create-folder-dispatcher-and-handler
         "/" (make-pathname :directory document-root))
        hunchentoot:*dispatch-table*)

  (setq hunchentoot:*dispatch-table*
        (list (hunchentoot:create-regex-dispatcher "^/$" 'index-page)))
  (defun index-page () (cl-who:with-html-output-to-string
		    (str nil :prologue t :indent t)
		    (:html
		      (:head
			(:meta :content "text/html; charset=utf-8" :http-equiv "Content-Type")
			(:meta :content "text/css" :http-equiv "Content-Style-Type")
			(:meta :content "text/javascript" :http-equiv "Content-Script-Type")
			(:title "Alien Parka"))
		      (:body
			(:h1 "Alien Parka")
			(:p "うんｋ")))))

  (let ((acceptor (make-instance 'hunchentoot:acceptor
                                 :port (read-from-string port))))
    (hunchentoot:start acceptor)))
