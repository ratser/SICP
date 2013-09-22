;;; exercise 4.6

(define (eval-let exp env)
  (my-eval (let->combination exp) env))

(define (let-variables exp)
  (map car (cadr exp)))
(define (let-exps exp)
  (map cadr (cadr exp)))
(define (let-body exp)
  (cddr exp))
(define (let->combination exp)
  (cons
   (make-lambda (let-variables exp)
                (let-body exp))
   (let-exps exp)))