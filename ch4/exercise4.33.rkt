;;; exercise 4.33

(define (eval-quoted exp env)
  (let ((text (text-of-quotation exp)))
    (if (not (pair? text))
        text
        (my-eval (make-lazy-list text) env))))

(define (text-of-quotation exp)
  (cadr exp))
(define (make-lazy-list text)
  (if (null? text)
      '()
      (list 'cons (make-quoted (car text)) (make-lazy-list (cdr text)))))
(define (make-quoted x)
  (list 'quote x))
     
;(define (cons x y) (lambda (m) (m x y)))
;(define (car z) (z (lambda (p q) p)))
;(define (cdr z) (z (lambda (p q) q)))