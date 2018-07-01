;;;; fyre-client.lisp

(in-package #:fyre-client)

(defparameter *maine* (qload-ui "/home/silver/quicklisp/local-projects/fyre-client/fyre-client.ui"))
(defparameter *spark-text* (qfind-child *maine* "sparktext"))
(defparameter *fyre-path* (qfind-child *maine* "fyrepath"))
(defparameter *spark-button* (qfind-child *maine* "sparkbutton"))
(defparameter *fyre-label* (qfind-child *maine* "fyrelabel"))
(defparameter *ember-desc* (qfind-child *maine* "emberdesc"))
(defparameter *ember-update* (qfind-child *maine* "emberupdate"))
(defparameter *ember-remove* (qfind-child *maine* "emberremove"))
(defparameter *ember-price* (qfind-child *maine* "emberprice"))
(defparameter *ember-qty* (qfind-child *maine* "emberqty"))
(defparameter *ember-view* (qfind-child *maine* "emberview"))
(defparameter *fyre-pit* (qfind-child *maine* "fyrepit"))
(defparameter *ember-rotate* (qfind-child *maine* "emberrotate"))
(defparameter *ember-multi-pic* (qfind-child *maine* "embermultipic"))

(defparameter *icon-size* (* 400 400))

(defparameter *fyre-list-recv* '())
(defparameter *ember-list-recv* '())
(defparameter *spark-list-recv* '())
  

(defun get-id-value (req-id)
  (drakma:http-request (format nil "http://localhost:8900/getid?value=~a"
			       req-id )))
(defun get-fyre-list ()
  (pl-all-values
   (pl-all-elements
    (plump:parse (drakma:http-request "http://localhost:8900/fyre-list")))))
  

(defun get-ember-list (fyre)
  (drakma:http-request (format nil "http://localhost:8900/ember-list?fyre=~a" fyre)))

(defun get-spark-list (ember)
  (setf *spark-list-recv*
	(drakma:http-request
	 (format nil "http://localhost:8900/spark-list?ember=~a" ember))))

(defun update-fyre-chat (args)
  (mapcar #'(lambda (x) (|appendPlainText| *fyre-pit* (format nil "~a" x)))
	  args))

;;;Func for clearing Fyre-pit



;;;Parse HTML into a list of IDS

(defun pl-all-elements (parsed-htm)
  (defun all-elements (index)
    (let ((cur-elem (plump:get-element-by-id parsed-htm (write-to-string index))))
      (if (null (plump:next-element cur-elem))
	  (list cur-elem)
	  (cons cur-elem (all-elements (+ index 1))))))
  (all-elements 0))

(defun pl-all-attributes (elem-list attribute)
  (mapcar #'(lambda (x) (plump:attribute x attribute))
	  elem-list))

(defun pl-all-values (elem-list)
  (pl-all-attributes elem-list "value"))

(defun clear-fyre-pit ()
  (qinvoke-method *fyre-pit* "clear"))

(defun add-fyre-pit (value)
  (qinvoke-method *fyre-pit* "addItem" value))

(defun add-fyre-pits (value-list)
  (mapcar #'(lambda (elem) (add-fyre-pit elem))
	  value-list))

(defun clear-and-add-fyre-pit (value-list)
  (clear-fyre-pit)
  (add-fyre-pits value-list))

;;;Setup modes for allowing images in the list
(defun init-fyre-pit ()
  (qinvoke-method *fyre-pit* "setIconSize" (* *icon-size* *icon-size*))
  (qinvoke-method *fyre-pit* "setResizeMode" 1)
  (qinvoke-method *fyre-pit* "setViewMode" 1))

(defun new-pixmap-image (filepath)
  (qnew "QPixmap" filepath))

(defun new-qicon (pixmap)
  (qnew "QIcon" pixmap))

(defun new-icon-list-widget (qicon text)
  (qnew "QListWidgetItem" qicon text))



;;;Basic Pattern for Loading Image
;;;flexi-streams:make-in-memory-input-stream drakma:image-request
;;;(qnew QPixmap)
;;;qinvoke loadFromData timmy (length timmy)
;;;(qnew QIcon)
;;;(qinvoke Icon addPixmap Pixmap)
;;;(qnew "QListItemWidget")
;;;(qinvoke Widget setIcon Icon)


;;;rewrite all these for memory reasons
(defun gen-list-widgets (icon-list)
  (mapcar #'(lambda (elem) (let
			       ((item (qnew "QListWidgetItem")))
			     (qfun item "setIcon" elem)
			     item))
	  icon-list))

(defun gen-image-icon (image)
  (let
      ((ll (qnew "QPixmap"))
       (rr (qnew "QIcon")))
    (|loadFromData| ll image (length image))
    (|addPixmap| rr ll)
    rr))

(defun get-image-from-id (id)
  (drakma:http-request (format nil "http://localhost:8900/fyre-pit/blob-root/~a" id)))

(defun gen-image-icons (image-list)
  (mapcar #'gen-image-icon
	  image-list))

(defun get-images-from-id (ids)
  (mapcar #'get-image-from-id
	  ids))
