;;; exercise 4.8

(define (eval-let exp env)
  (my-eval (let->combination exp) env))
(define (let-variables exp)
  (map car (cadr exp)))
(define (let-exps exp)
  (map cadr (cadr exp)))
(define (let-body exp)
  (cddr exp))

(define (named-let? exp)
  (not (pair? (cadr exp))))
(define (let-name exp)
  (cadr exp))
(define (let-variables-named exp)
  (map car (caddr exp)))
(define (let-exps-named exp)
  (map cadr (caddr exp)))
(define (let-body-named exp)
  (cdddr exp))
(define (make-definition var exp)
  (list 'define var exp))

(define (let->combination exp)
  (if (named-let? exp)
      (cons
       (make-lambda (let-variables-named exp)
                    (cons
                     (make-definition
                      (let-name exp)
                      (make-lambda (let-variables-named exp)
                                   (let-body-named exp)))
                     (let-body-named exp)))
       (let-exps-named exp))
      (cons
       (make-lambda (let-variables exp)
                    (let-body exp))
       (let-exps exp))))