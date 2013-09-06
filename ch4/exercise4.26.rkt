;;; exercise 4.26

(put-eval 'unless eval-unless)

(define (eval-unless exp env)
  (my-eval (unless->if exp) env))

(define (unless->if exp)
  (make-if (unless-predicate exp)
           (unless-consequent exp)
           (unless-alternative exp)))

(define (unless-predicate exp)
  (cadr exp))
(define (unless-consequent exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))
(define (unless-alternative exp)
  (caddr exp))
