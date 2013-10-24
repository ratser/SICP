;;; exercise 4.68
(assert! (rule (append-to-form (?u . ?v) ?y (?u . ?z))
               (append-to-form ?v ?y ?z)))
(assert! (rule (append-to-form () ?y ?y)))

; the two rules below reverse a list but query (reverse ?x (1 2 3))
; will first pirnts right result then goes into an infinite loop.
; exchange the add order of the rules (i.e add the second rule 
; into the data base first) will directly goes into an infinite loop
; without prints any result when query (reverse ?x (1 2 3))

(assert! (rule (reverse (?x . ?y) ?z)
               (and (reverse ?y ?ry)
                    (append-to-form ?ry (?x) ?z))))
(assert! (rule (reverse (?x) (?x))))                               
                        