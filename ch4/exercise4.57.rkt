;;; exercise 4.57

(rule (replace ?person1 ?person2)
      (and (or (and (job ?person1 ?job)
                    (job ?person2 ?job))
               (and (job ?person1 ?job1)
                    (job ?person2 ?job2)
                    (can-do-job ?job1 ?job2))) 
           (not (same ?person1 ?person2))))
;a
(replace ?person (Fect Cy D))
;b
(and (replace ?person ?someone)
     (salary ?person ?ps)
     (salary ?someone ?ss)
     (lisp-value < ?ps ?ss))