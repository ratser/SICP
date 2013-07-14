#lang r5rs
(#%provide (all-defined))

(define (error string . item)
  (display string)
  (newline)
  (if (not (null? item))
      (display item))
  (newline))

