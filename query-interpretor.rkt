#lang r5rs
(#%require "stream.rkt")
(#%require "table.rkt")
;;;table for special forms
(define query-special-form-table (make-anyD-table))
(define (get-query-proc type-tag)
  ((query-special-form-table 'lookup) (list type-tag)))
(define (put-query-proc type-tag proc)
  ((query-special-form-table 'insert!)
   (list type-tag)
   proc))

;;;Driver loop
(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query results:")
(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion!
            (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiates ;use "instantiate" will cause incorrect auto indention
                q
                frame
                (lambda (v f)
                  (contract-question-mark v))))
             (qeval q (singleton-stream '()))))
           (query-driver-loop)))))

(define (prompt-for-input string)
  (newline)
  (display string)
  (newline))
;;;instantiate procedure
(define (instantiates exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
                 (copy (binding-value binding))
                 (unbound-var-handler exp frame))))
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp)))
  (copy exp))
;;; evaluator
(define (qeval query frame-stream)
  (let ((qproc (get-query-proc (type query))))
    (if qproc
        (qproc (contents query) frame-stream)
        (simple-query query frame-stream))))
