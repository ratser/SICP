;;; exercise 4.7

(define (eval-let* exp env)
  (my-eval (let*->nested-lets exp) env))

(define (make-let bindings body)
  (cons 'let (cons bindings body)))

(define (let*-bindings exp)
  (cadr exp))
(define (first-binding bindings)
  (list (car bindings)))
(define (rest-bindings bindings)
  (cdr bindings))
(define (last-binding? bindings)
  (null? (cdr bindings)))
(define (let*-body exp)
  (cddr exp))

(define (let*->nested-lets exp)
  (let*-expand (let*-bindings exp)
               (let*-body exp)))

(define (let*-expand bindings body)
  (if (last-binding? bindings)
      (make-let bindings body)
      (make-let (first-binding bindings)
                (list (let*-expand (rest-bindings bindings)
                             body)))))