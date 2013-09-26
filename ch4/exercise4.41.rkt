;;; exercise 4.41
;;; This code was tested in r5rs of Drracket, but not in interpretor
;;; implemented according to section 4.1. That's because we will use the
;;; procedure apply, which is not availible in later's environment, in the
;;; code below.
;;; r5rs of Drracket use #f and #t to represent boolean values.
(define false #f)
(define true #t)

(define (distinct? lst)
  (cond ((null? lst) true)
        ((null? (cdr lst)) true)
        ((member? (car lst) (cdr lst)) false)
        (else (distinct? (cdr lst)))))
(define (member? item lst)
  (cond ((null? lst) false)
        ((equal? item (car lst)) true)
        (else (member? item (cdr lst)))))

(define (next-choice baker cooper fletcher miller smith)
  (if (< smith 5)
      (list baker cooper fletcher miller (+ smith 1))
      (if (< miller 5)
          (list baker cooper fletcher (+ miller 1) 1)
          (if (< fletcher 5)
              (list baker cooper (+ fletcher 1) 1 1)
              (if (< cooper 5)
                  (list baker (+ cooper 1) 1 1 1)
                  (if (< baker 5)
                      (list (+ baker 1) 1 1 1 1)
                      '()))))))

(define (right-choice? baker cooper fletcher miller smith)
  (and (not (= baker 5))
       (not (= cooper 1))
       (not (= fletcher 5))
       (not (= fletcher 1))
       (> miller cooper)
       (not (= (abs (- smith fletcher)) 1))
       (not (= (abs (- cooper fletcher)) 1))
       (distinct? (list baker cooper fletcher miller smith))))

(define (md-rec lst)
  (cond ((null? lst) '())
        ((apply right-choice? lst)
         (cons lst (md-rec (apply next-choice lst))))
        (else (md-rec (apply next-choice lst)))))

(define (md)
  (md-rec (list 1 1 1 1 1)))
  
