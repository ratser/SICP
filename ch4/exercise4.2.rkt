;;; exercise4.2

;;;   the implementation of application? operator and
;;; operands should be changed respectively.

(define (application? exp)
  (eq? (get-tag exp) 'call))
(define (operator exp) (cadr exp))
(define (operands exp) (cddr exp))