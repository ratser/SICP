;;; exercise 4.13
;;; unbind the variable only in its current frame
(define (eval-make-unbound! exp env)
  (if (variable? (unbound-variable exp))
      (let ((frame (first-frame env)))
        (let ((vars (frame-variables frame))
              (vals (frame-values frame)))
          (define (scan vars vals f)  ;;; continuation passing style
            (cond ((null? vars)
                   (f '() '()))
                  ((eq? (unbound-variable exp) (car vars))
                   (scan (cdr vars) (cdr vals) f))
                  (else
                   (scan
                    (cdr vars)
                    (cdr vals)
                    (lambda (rest-vars rest-vals)
                      (f (cons (car vars) rest-vars)
                         (cons (car vals) rest-vals)))))))
          (scan vars vals (lambda (new-vars new-vals)
                            (set-car! frame new-vars)
                            (set-cdr! frame new-vals)))))
      (error "Invalid variable -- MAKE-UNBOUND!" (unbound-variable exp))))

(define (unbound-variable exp)
  (cadr exp))

(put-eval 'make-unbound! eval-make-unbound!)

