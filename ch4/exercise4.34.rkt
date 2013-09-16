;;; exercise 4.34

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true 'ture initial-env)
    (define-variable! 'false 'false initial-env)
    ;;; exercise 4.34
    ;;; install lazy cons car and cdr into the global environment
    (define-variable!
      'cons 
      (list 'procedure 
            '(x y) 
            '((lazy-list-lambda (m) (m x y)))
            initial-env)
      initial-env)
    (define-variable!
      'car 
      (list 'procedure '(z) '((z (lambda (x y) x))) initial-env)
      initial-env)
    (define-variable!
      'cdr 
      (list 'procedure '(z) '((z (lambda (x y) y))) initial-env)
      initial-env)
    initial-env))

;;; install lazy-list-lambda special form
(put-eval 'lazy-list-lambda eval-lazy-list-lambda)

(define (eval-lazy-list-lambda exp)
  (make-lazy-list-proc (lambda-parameters exp)
                       (lambda-body exp)
                       env))
(define (make-lazy-list-proc parameters body env)
  (list 'lazy-list parameters body env))

(define (lazy-list? p)
  (tagged-list? p 'lazy-list))

;;; modify my-apply to support new representation of lazy list
(define (my-apply proc arguments env)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure
          proc 
          (list-of-arg-values arguments env)))
        ((or (compound-procedure? proc)
             (lazy-list? proc)) ;exercise 4.34
         (eval-sequence
          (procedure-body proc)
          (extend-environment
           (procedure-parameters proc)
           (list-of-delayed-args arguments env)
           (procedure-environment proc))))
        (else
         (error "Unknown procedure type -- MY-APPLY" proc))))

;;; modify user-print to identify lazy list and print the result
(define (user-print object)
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
                        (procedure-parameters object)
                        (procedure-body object)
                        '<procedure-env>)))
        ((lazy-list? object)
         (display (lazy-list->list object 5)))
         (else (display object))))

(define (lazy-list->list object max)
  (define (convert object max remain)
    (define (get-car object)
      (force-it (apply-lazy-list 
                 (actual-value 'car the-global-environment)
                 (list object))))
    (define (get-cdr object)
      (force-it (apply-lazy-list 
                 (actual-value 'cdr the-global-environment)
                 (list object))))
    (define (apply-lazy-list proc args)
      (eval-sequence
       (procedure-body proc)
       (extend-environment
        (procedure-parameters proc)
        args       ;;; note that here args have been evaluated (object)
        (procedure-environment proc))))
    (cond ((= remain 0)
           (if (not (null? object))
               '(...)
               '()))
          ((lazy-list? object)
           (cons (convert (get-car object) max max)
                 (convert (get-cdr object) max (- remain 1))))
          (else object)))
  (convert object max max))


