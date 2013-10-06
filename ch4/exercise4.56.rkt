;;; exercise 4.46
;a
(and (supervisor ?name (Ben Bitdiddle))
     (address ?name ?addr))
;b
(and (salary (Ben Bitdiddle) ?bens)
     (salary ?names ?others)
     (lisp-value < ?others ?bens))
;c
(and (supervisor ?name ?sup)
     (not (job ?sup (computer . ?j)))
     (job ?sup ?supjob))