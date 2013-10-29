;;; exercise 4.75
(put-query-proc 'unique uniquely-asserted)

(define (uniquely-asserted uniquely-contents frame-stream)
  (stream-flatmap
   (lambda (frame)
     (let ((result 
            (qeval (uniquely-query uniquely-contents) (singleton frame))))
       (if (singleton-stream? result)
           result
           the-empty-stream)))
   frame-stream))

(define (singleton-stream? stream)
  (cond ((stream-null? stream) #f)
        ((stream-null? (stream-cdr stream)) #t)
        (else #f)))

(define (uniquely-query exp) (car exp))