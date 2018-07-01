;;;; fyre-server.asd

(asdf:defsystem #:fyre-server
  :description "Describe fyre-server here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:drakma #:bknr.datastore #:bknr.indices
			#:hunchentoot
			#:cl-who)
  :components ((:file "package")
               (:file "fyre-server")))
