#lang racket

(define (p_e_escape-string s)
    (define (p_e_escape-char c)
        (cond
            [(char=? c #\\) "\\\\"]
            [(char=? c #\") "\\\""]
            [(char=? c #\newline) "\\n"]
            [(char=? c #\tab) "\\t"]
            [else (string c)]))
    (string-join (map p_e_escape-char (string->list s)) ""))

(define (p_e_bool)
    (lambda (b) 
        (unless (boolean? b) (error 'failed))
        (if b "true" "false")))

(define (p_e_int)
    (lambda (i) 
        (unless (integer? i) (error 'failed))
        (number->string i)))

(define (p_e_double)
    (lambda (d) 
        (unless (real? d) (error 'failed))
        (let* ([s0 (~r #:precision '(= 7) d)]
            [s1 (substring s0 0 (- (string-length s0) 1))])
            (if (string=? s1 "-0.000000") "0.000000" s1))))

(define (p_e_string)
    (lambda (s) 
        (unless (string? s) (error 'failed))
        (string-append "\"" (p_e_escape-string s) "\"")))

(define (p_e_list f0)
    (lambda (lst) 
        (unless (list? lst) (error 'failed))
        (string-append "[" (string-join (map f0 lst) ", ") "]")))

(define (p_e_ulist f0)
    (lambda (lst) 
        (unless (list? lst) (error 'failed))
        (string-append "[" (string-join (sort (map f0 lst) string<?) ", ") "]")))

(define (p_e_idict f0)
    (let ([f1 (lambda (kv) (string-append ((p_e_int) (car kv)) "=>" (f0 (cdr kv))))])
        (lambda (dct) 
            (unless (hash? dct) (error 'failed))
            (string-append "{" (string-join (sort (map f1 (hash->list dct)) string<?) ", ") "}"))))

(define (p_e_sdict f0)
    (let ([f1 (lambda (kv) (string-append ((p_e_string) (car kv)) "=>" (f0 (cdr kv))))])
        (lambda (dct) 
            (unless (hash? dct) (error 'failed))
            (string-append "{" (string-join (sort (map f1 (hash->list dct)) string<?) ", ") "}"))))
    
(define (p_e_option f0)
    (lambda (opt) (if opt (f0 opt) "null")))

$$code$$

(let ([p_e_out (p_e_entry)])
    (call-with-output-file "result.out" (lambda (out) (display p_e_out out)) #:exists 'replace))