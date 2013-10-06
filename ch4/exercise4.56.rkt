;;; exercise 4.46
;a
(and (supervisor ?name (Bitdiddle Ben))
     (address ?name ?addr))
;b
(and (salary (Bitdiddle Ben) ?bens)
     (salary ?names ?others)
     (lisp-value < ?others ?bens))
;c
(and (supervisor ?name ?sup)
     (not (job ?sup (computer . ?j)))
     (job ?sup ?supjob))