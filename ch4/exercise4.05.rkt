;;; exercise 4.5 

(define (eval-cond exp env)
  (my-eval (cond->if exp) env))

(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause)
  (car clause))
(define (cond-actions clause) (cdr clause))

(define (cond=>clause? clause)
  (eq? (cadr clause) '=>))
(define (cond-func clause)
  (caddr clause))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (cond ((cond-else-clause? first)
               (if (null? rest)
                   (seq->exp (cond-actions first))
                   (error "ELSE clause isn't last -- COND->IF"
                          clauses)))
              ((cond=>clause? first)
               (make-if
                (cond-predicate first)
                (cons (cond-func clause) 
                      (cons (cond-predicate first) '()))
                (expand-clauses rest)))
              (else (make-if
                     (cond-predicate first)
                     (seq->exp (cond-actions first))
                     (expand-clauses rest)))))))
