;;; parsing natural language
;;; exercise 4.49

(define (list->amb lst)
  (cond ((null? lst) (amb))
        (else (amb (car lst) (list->amb (cdr lst)))))) 

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (list->amb (cdr word-list)))) ;here is the difference
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))