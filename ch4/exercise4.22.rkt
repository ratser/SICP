;;; exercise 4.22
(define (analyze-let exp)
  (analyze (let->combination exp)))

(put-analyze 'let analyze-let)