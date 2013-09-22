;;; exercise4.3

;;; table for installing eval procedures of special forms
(define special-form-table (make-anyD-table))
(define (put-eval tag proc)
  ((special-form-table 'insert!) (list tag) proc))
(define (get-eval tag)
  ((special-form-table 'lookup) (list tag)))

(define (my-eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((get-eval (get-tag exp))
         ((get-eval (get-tag exp)) exp env))
        ((application? exp)
         (my-apply (my-eval (operator exp) env)
                   (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- MY-EVAL" exp))))