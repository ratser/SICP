;;; exercise 4.52

(put-analyze 'if-fail analyze-if-fail)

(define (analyze-if-fail exp)
  (let ((fproc (analyze (if-fail-exp exp)))
        (sproc (analyze (if-fail-alternative exp))))
    (lambda (env succeed fail)
      (fproc env
             succeed
             (lambda ()
               (sproc env
                      succeed
                      fail))))))
(define (if-fail-exp exp)
  (cadr exp))
(define (if-fail-alternative exp)
  (caddr exp))