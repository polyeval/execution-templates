;; -*- lexical-binding: t -*-  

(require 'seq)
(require 'subr-x)

(defun p_e_escape-string (s)
    (let ((p_e_escape-char (lambda (c)
            (cond
                ((char-equal c ?\\) "\\\\")
                ((char-equal c ?\") "\\\"")
                ((char-equal c ?\n) "\\n")
                ((char-equal c ?\t) "\\t")
                (t (string c))))))
        (string-join (seq-map p_e_escape-char s) "")))

(defun p_e_bool ()
    (lambda (b)
    (unless (booleanp b) (throw "" t))
    (if b "true" "false")))

(defun p_e_int ()
    (lambda (i)
    (unless (integerp i) (throw "" t))
    (number-to-string i)))

(defun p_e_double ()
    (lambda (d)
    (unless (floatp d) (throw "" t))
    (let* ((s0 (format "%.7f" d))
        (s1 (substring s0 0 (- (length s0) 1))))
        (if (string= s1 "-0.000000") "0.000000" s1))))

(defun p_e_string ()
    (lambda (s)
    (unless (stringp s) (throw "" t))
    (concat "\"" (p_e_escape-string s) "\"")))

(defun p_e_list (f0)
    (lambda (lst)
        (unless (listp lst) (throw "" t))
        (concat "[" (string-join (seq-map f0 lst) ", ") "]")))

(defun p_e_ulist (f0)
    (lambda (lst)
        (unless (listp lst) (throw "" t))
        (concat "[" (string-join (seq-sort #'string< (seq-map f0 lst)) ", ") "]")))
    
(defun p_e_idict (f0)
    (let ((f1 (lambda (k v) (concat (funcall (p_e_int) k) "=>" (funcall f0 v)))))
        (lambda (dct)
            (unless (hash-table-p dct) (throw "" t))
            (let ((ret ()))
                (maphash (lambda (k v) (push (funcall f1 k v) ret)) dct)
                (concat "{" (string-join (seq-sort #'string< ret) ", ") "}")))))

(defun p_e_sdict (f0)
    (let ((f1 (lambda (k v) (concat (funcall (p_e_string) k) "=>" (funcall f0 v)))))
        (lambda (dct)
            (unless (hash-table-p dct) (throw "" t))
            (let ((ret ()))
                (maphash (lambda (k v) (push (funcall f1 k v) ret)) dct)
                (concat "{" (string-join (seq-sort #'string< ret) ", ") "}")))))

(defun p_e_option (f0)
    (lambda (opt)
        (if opt (funcall f0 opt) "null")))

(defun p_e_create-dict (lst)
    (let ((ret (make-hash-table)))
        (dolist (pair lst)
            (puthash (car pair) (cdr pair) ret))
        ret))

$$code$$

(let ((p_e_out (p_e_entry)))
    (write-region p_e_out nil "result.out"))