;;; exercise 4.69
(assert! (son Adam Cain))
(assert! (son Cain Enoch))
(assert! (son Enoch Irad))
(assert! (son Irad Mehujael))
(assert! (son Mehujael Methushael))
(assert! (son Methushael Lamech))
(assert! (wife Lamech Ada))
(assert! (son Ada Jabal))
(assert! (son Ada Jubal))

(assert! (rule (grandson ?g ?s)
               (and (son ?g ?f)
                    (son ?f ?s))))
(assert! (rule (son ?m ?s)
               (and (wife ?m ?f)
                    (son ?f ?s))))

(assert! (rule (ends-with (?x . ?y) ?z)
               (ends-with ?y ?z)))

(assert! (rule (ends-with (?x) ?x)))

;(ends-with ?x grandson) will goes into an infinite loop
;as a result, (?rel Adam Irad) will goes into an infinite loop after 
;prints a result
(assert! (rule ((grandson) ?g ?gs)
               (grandson ?g ?gs)))

(assert! (rule ((great . ?rel) ?x ?y)
               (and (ends-with ?rel grandson)
                    (son ?x ?s)
                    (?rel ?s ?y))))

