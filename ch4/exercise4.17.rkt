;;; exercise 4.17
;;; we can just move all internal definitions to the top of the procedure body

;;; note: only make-new-body of exercise 4.16 need to be changed
;;; There is a subtle difference between the implementations in exercise 4.16 and exercise 4.17
;;; see exercise 4.19

(define (make-new-body defs rest)
  (append defs rest))