#lang r5rs
(#%provide (all-defined))

(define-syntax cons-stream 
  (syntax-rules () 
    ((_ x y) (cons x (delay y)))))

(define (stream-car stream)
  (car stream))

(define (stream-cdr stream)
  (force (cdr stream)))

(define the-empty-stream '())

(define (stream-null? x)
  (null? x))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc
                    (map stream-cdr argstreams))))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (stream-ref stream pos)
  (cond ((stream-null? stream) the-empty-stream)
        ((= 0 pos) (stream-car stream))
        (else (stream-ref (stream-cdr stream) (- pos 1)))))

(define (stream-filter predicate? s)
  (cond ((stream-null? s) the-empty-stream)
        ((predicate? (stream-car s))
         (cons-stream (stream-car s)
                      (stream-filter predicate? (stream-cdr s))))
        (else (stream-filter predicate? (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x)
  (display x)
  (newline))

(define (stream-for-each-n proc s n)
  (cond ((or (<= n 0) (stream-null? s)) 'done)
        (else (proc (stream-car s))
              (stream-for-each-n proc (stream-cdr s) (- n 1)))))
(define (display-stream-n s n)
  (stream-for-each-n display-line s n))

;;;;;;;;;;this procedure is for test;;;;;;;;;;
(define stream-list
  (lambda x
          (if (null? x)
              the-empty-stream
              (cons-stream (car x)
                           (apply stream-list (cdr x))))))
