;;; exercise4.4

(define (or-seq exp)
  (cdr exp))
(define (and-seq exp)
  (cdr exp))

;;; direct defining
(define (eval-or exp env)
  (direct-or (or-seq exp) env))
(define (direct-or seq env)
  (cond ((last-exp? seq) (my-eval (first-exp seq) env))
        ((true? (my-eval (first-exp seq) env))
         (my-eval (first-exp seq) env))
        (else (direct-or (rest-exps seq) env))))

(define (eval-and exp env)
  (direct-and (and-seq exp) env))
(define (direct-and seq env)
  (cond ((last-exp? seq) (my-eval (first-exp seq) env))
        ((true? (my-eval (first-exp seq) env))
         (direct-and (rest-exps seq) env))
        (else 'false)))

;;; derived expression
(define (eval-or exp env)
  (my-eval (or->if exp) env))
(define (or->if exp)
  (expand-or (or-seq exp)))
(define (expand-or seq)
  (if (last-exp? seq)
      (first-exp seq)
      (make-if
       (first-exp seq)
       (first-exp seq)
       (expand-or (rest-exps seq)))))

(define (eval-and exp env)
  (my-eval (and->if exp) env))
(define (and->if exp)
  (expand-and (and-seq exp)))
(define (expand-and seq)
  (if (last-exp? seq)
      (first-exp seq)
      (make-if
       (first-exp seq)
       (expand-and (rest-exps seq))
       'false)))

      