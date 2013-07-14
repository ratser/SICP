#lang r5rs
(#%require "error.rkt")
(#%provide (all-defined))
;;;; ONE-DIMENSIONAL TABLE ;;;;;
(define (make table)
  (list '*table*))

(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
        (cdr record)
        #f)))
(define (assoc key records)
  (cond ((null? records) #f)
        ((equal? key (caar records))
         (car records))
        (else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record 
        (set-cdr! record value)
        (set-cdr! table
                  (cons (cons key value)
                        (cdr table)))))
  'OK)

;;;; TWO-DIMENTIONAL TABLE ;;;;;
(define (make-2D-table)
  (let ((local-table (list '*table*)))
    (define (lookup key1 key2)
      (let ((subtable (assoc key1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key2 (cdr subtable))))
              (if record
                  (cdr record)
                  #f))
            #f)))
    (define (insert! key1 key2 value)
      (let ((subtable (assoc key1 (cdr local-table))))
        (if subtable
            (let ((record (assoc key2 (cdr subtable))))
              (if record
                  (set-cdr! record value)
                  (set-cdr! subtable
                            (cons (cons key2 value)
                                  (cdr subtable)))))
            (set-cdr! local-table
                      (cons (list key1
                                  (cons key2 value))
                            (cdr local-table)))))
      'OK)
    (define (assoc key records)
      (cond ((null? records) #f)
            ((equal? key (caar records))
             (car records))
            (else (assoc key (cdr records)))))
    (define (dispatch m)
      (cond ((eq? m 'lookup) lookup)
            ((eq? m 'insert!) insert!)
            (else (error "Unknowen operation -- TABLE" m))))
    dispatch))

;;;;;; N-DIMENTIONAL TABLE ;;;;;;;;
(define (make-anyD-table)
  (let ((table (list '*table* '())))
    (define (rec-lookup subtable key-list)
      (cond ((null? key-list) #f)
            (else
             (let ((subobj (assoc (cddr subtable)
                                  (car key-list))))
               (if subobj
                   (if (null? (cdr key-list))
                       (if (null? (cadr subobj))
                           #f
                           (cadr subobj))
                       (rec-lookup subobj (cdr key-list)))
                   #f)))))
    (define (rec-insert! subtable key-list value)
      (cond ((null? key-list) #f)
            (else
             (let ((subobj (assoc (cddr subtable)
                                  (car key-list))))
               (if subobj
                   (if (null? (cdr key-list))
                       (set-car! (cdr subobj) value)
                       (rec-insert! subobj (cdr key-list) value))
                   (if (null? (cdr key-list))
                       (set-cdr!
                        (cdr subtable)
                        (cons (list (car key-list) value)
                              (cddr subtable)))
                       (begin
                         (set-cdr!
                          (cdr subtable)
                          (cons (list (car key-list) '())
                                (cddr subtable)))
                         (rec-insert! (caddr subtable)
                                  (cdr key-list)
                                  value))))))))
    (define (assoc records key)
      (cond ((null? records) #f)
            ((eq? key (caar records)) (car records))
            (else (assoc (cdr records) key))))
    
    (define (lookup key-list)
      (rec-lookup table key-list))
    (define (insert! key-list value)
      (rec-insert! table key-list value))
    
    (define (dispatch m)
      (cond ((eq? m 'lookup) lookup)
            ((eq? m 'insert!) insert!)
            (else (error "Unknowen operation -- TABLE" m))))
    dispatch))
    