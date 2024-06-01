(defun p_e_escape-string (s)
    (let ((p_e_escape-char (lambda (c)
            (cond
                ((char= c #\\) "\\\\")
                ((char= c #\") "\\\"")
                ((char= c #\Newline) "\\n")
                ((char= c #\Tab) "\\t")                
                (t (string c))))))
        (format nil "~{~A~}" (mapcar p_e_escape-char (coerce s 'list)))))

(defun p_e_bool ()
    (lambda (b)
    (unless (or (eq b t) (eq b nil)) (error "IllegalArgumentException"))
    (if b "true" "false")))

(defun p_e_int ()
    (lambda (i)
    (unless (integerp i) (error "IllegalArgumentException"))
    (write-to-string i)))

(defun p_e_double ()
    (lambda (d)
    (unless (floatp d) (error "IllegalArgumentException"))
    (let* ((s0 (format nil "~,7F" d))
            (s1 (subseq s0 0 (- (length s0) 1))))
        (if (string= s1 "-0.000000") "0.000000" s1))))

(defun p_e_string ()
    (lambda (s)
    (unless (stringp s) (error "IllegalArgumentException"))
    (concatenate 'string "\"" (p_e_escape-string s) "\"")))

(defun p_e_list (f0)
    (lambda (lst)
        (unless (listp lst) (error "IllegalArgumentException"))
        (concatenate 'string "[" (format nil "~{~A~^, ~}" (mapcar f0 lst)) "]")))

(defun p_e_ulist (f0)
    (lambda (lst)
        (unless (listp lst) (error "IllegalArgumentException"))
        (concatenate 'string "[" (format nil "~{~A~^, ~}" (sort (mapcar f0 lst) #'string<)) "]")))

(defun p_e_idict (f0)
    (let ((f1 (lambda (k v) (concatenate 'string (funcall (p_e_int) k) "=>" (funcall f0 v)))))
        (lambda (dct)
            (unless (hash-table-p dct) (error "IllegalArgumentException"))
            (let ((ret '()))
                (maphash (lambda (k v) (push (funcall f1 k v) ret)) dct)
                (concatenate 'string "{" (format nil "~{~A~^, ~}" (sort ret #'string<)) "}")))))

(defun p_e_sdict (f0)
    (let ((f1 (lambda (kv) (concatenate 'string (funcall (p_e_string) (car kv)) "=>" (funcall f0 (cdr kv))))))
        (lambda (dct)
            (unless (hash-table-p dct) (error "IllegalArgumentException"))
            (let ((ret '()))
                (maphash (lambda (k v) (push (funcall f1 (cons k v)) ret)) dct)
                (concatenate 'string "{" (format nil "~{~A~^, ~}" (sort ret #'string<)) "}")))))

(defun p_e_option (f0)
    (lambda (opt)
        (if opt (funcall f0 opt) "null")))

(defun p_e_create-dict (lst)
    (let ((ret (make-hash-table :test #'equal)))
        (dolist (kv lst)
            (setf (gethash (car kv) ret) (cdr kv)))
        ret))

$$code$$

(let ((p_e_out (p_e_entry)))
    (with-open-file (stream "result.out" :direction :output :if-exists :supersede)
        (format stream p_e_out)))
