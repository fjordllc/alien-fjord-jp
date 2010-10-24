(load "/Users/komagata/quicklisp/setup.lisp")
(ql:quickload "hunchentoot")

(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :hunchentoot))

(defun main ()
  (let ((*invoke-debugger-hook*
         (lambda (condition hook)
           (declare (ignore hook))
           (format *error-output* "error: ~a~%" condition)
           (quit :unix-status 1)))
        (document-root (second *posix-argv*))
        (port (third *posix-argv*)))
    (print (list document-root port))
    (push (hunchentoot:create-folder-dispatcher-and-handler
           "/" (make-pathname :directory document-root))
          hunchentoot:*dispatch-table*)
    (push (hunchentoot:create-static-file-dispatcher-and-handler
           "/" (make-pathname :directory document-root :name "index.html"))
          hunchentoot:*dispatch-table*)
    (let ((acceptor (make-instance 'hunchentoot:acceptor
                                   :port (read-from-string port))))
      (hunchentoot:start acceptor)))
  (loop (sleep 777)))
(setq *posix-argv* '("alien.lisp" "/Users/komagata/Sites/alien-fjord-jp/public" "8888"))
(main)
