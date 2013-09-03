;;; exercise 4.12

(define (traverse-frame var frame op f)
  (define (scan vars vals)
    (cond ((null? vars)
           (f frame))
          ((eq? var (car vars))
           (op vals))
          (else (scan (cdr vars) (cdr vals)))))
  (scan (frame-variables frame)
        (frame-values frame)))

(define (lookup-variable-value var env)
  (if (eq? env the-empty-environment)
      (error "Unbound variable -- LOOKUP-VARIABLE-VALUE" var)
      (traverse-frame var 
                      (first-frame env)
                      (lambda (vals)
                        (car vals))
                      (lambda (frame)
                        (lookup-variable-value
                         var
                         (enclosing-environment env))))))

(define (set-variable-value! var val env)
  (if (eq? env the-empty-environment)
      (error "Unbound variable -- SET-VARIABLE-VALUE!" var)
      (traverse-frame var
                      (first-frame env)
                      (lambda (vals)
                        (set-car! vals val))
                      (lambda (frame)
                        (set-variable-value!
                         var
                         val
                         (enclosing-environment env))))))

(define (define-variable! var val env)
  (traverse-frame var
                  (first-frame env)
                  (lambda (vals)
                    (set-car! vals val))
                  (lambda (frame)
                    (add-binding-to-frame! var val frame))))               