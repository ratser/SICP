;;; exercise 4.50
;;; one possible implementation is sorting cprocs randomly
;;; and keeping rest of the program unchanged.
;;; I will use shuffle procedure from racket/list module.
;;; to use shuffle, add the #%require code below to the header of
;;; amb-interpretor.rkt
(#%require racket/list)
;;; here is another issue: the list in language r5rs is in fact 
;;; a mlist(mutable list) in language racket, so if we pass list in r5rs 
;;; to shuffle directly will produce an error. so we should convert
;;; mlist(list in r5rs) to list before apply it to shuffle.
;;; the procedure list->mlist and mlist->list are in racket/mpair module
(#%require racket/mpair)
(put-analyze 'ramb analyze-ramb)
(define (analyze-ramb exp)
  (analyze-amb
   (cons 'ramb
         (list->mlist 
                 (shuffle 
                  (mlist->list 
                   (amb-choices exp)))))))