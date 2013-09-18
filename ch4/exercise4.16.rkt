;;; exercise 4.16

;;; a
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*)
                 (error "Unassigned variable" var)
                 (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

;;; b
;;; split: split procedure body into definitions part and rest part
(define (split seq f)
  (let ((exp (first-exp seq)))
    (if (last-exp? seq)
        (if (definition-exp? exp)
            (f seq '())
            (f '() seq))
        (if (definition-exp? exp)
            (split (rest-exps seq)
                   (lambda (defs other)
                     (f (cons exp defs) other)))
            (split (rest-exps seq)
                   (lambda (defs other)
                     (f defs (cons exp other))))))))

(define (definition-exp? exp)
  (tagged-list? 'define exp)) 

(define (make-new-body defs rest)
  (define (extract-vars defs)
    (map (lambda (exp) 
           (list (definition-variable exp) (make-quoted '*unassigned*)))
         defs))
  (define (extract-vals defs)
    (map (lambda (exp)
           (make-assignment (definition-variable exp) (definition-value exp)))
         defs))
  (if (null? defs)    ;if there is no definition in the body, just return the original body
      rest
      (list (make-let
             (extract-vars defs)
             (append (extract-vals defs) rest)))))

(define (make-quoted x)
  (list 'quote x))
(define (make-assignment var val)
  (list 'set! var val))
     
(define (scan-out-defines seq)
  (split seq make-new-body))

;;; c
;;; I will install scan-out-defines in make-procedure

(define (make-procedure parameters body env)
  (list 'procedure parameters (scan-out-defines body) env))