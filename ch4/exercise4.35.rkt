;;; exercise 4.35

(define (an-integer-between low high)
  (require (or (< low high) (= low high)))
  (amb low (an-integer-between (+ low 1) high)))

;(define (a-pythagorean-triple-between low high)
;  (let* ((i (an-integer-between low high))
;         (j (an-integer-between i high))
;         (k (an-integer-between j high)))
;    (require (= (+ (* i i) (* j j)) (* k k)))
;    (list i j k)))