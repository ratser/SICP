;;; exercise 4.60
(rule (lives-near ?p1 ?p2)
      (and (address ?p1 (?town . ?addr1))
           (address ?p2 (?town . ?addr2))
           (list-value symbol-list> ?p1 ?p2)))

;;; ordering the names will eliminate repetition of pairs
;;; the function symbol-list> compares two lists of symbols
;;; but I am not able to implement it currently