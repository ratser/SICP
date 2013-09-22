;;; exercise 4.36

(define (next-tri tri)
  (let ((first (car tri))
        (second (car (cdr tri)))
        (third (car (cdr (cdr tri)))))
    (cond ((= first second third)
           (list 1 1 (+ third 1)))
          ((= first second)
           (list 1 (+ second 1) third))
          (else (list (+ first 1) second third)))))

(define (amb-tri tri)
  (amb tri (amb-tri (next-tri tri))))

(define (a-pythagorean-triple-from low)
  (let ((triple (amb-tri (list low low low))))
    (let ((i (car triple))
          (j (car (cdr triple)))
          (k (car (cdr (cdr triple)))))
      (require (= (+ (* i i) (* j j)) (* k k)))
      (list i j k))))