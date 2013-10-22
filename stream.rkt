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

(define (stream-append s1 s2)
  (cond ((stream-null? s1) s2)
        (else (cons-stream (stream-car s1)
                           (stream-append (stream-cdr s1) s2)))))

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

;;; stream operations for query systems
(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (stream-append-delayed
        (stream-cdr s1)
        delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (interleave-delayed (force delayed-s2)
                           (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))
(define (flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave-delayed
       (stream-car stream)
       (delay (flatten-stream (stream-cdr stream))))))

(define (singleton-stream x)
  (cons-stream x the-empty-stream))
