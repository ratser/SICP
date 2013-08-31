;;; exercise 4.1 left->right ;;;
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((left (my-eval (first-operand exps) env)))
        (cons left
              (list-of-values (rest-operands exps) env)))))

;;;  exercise 4.1 right->left ;;;
(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (let ((right (list-of-values (rest-operands exps) env)))
        (cons (my-eval (first-operand exps) env)
              right))))
