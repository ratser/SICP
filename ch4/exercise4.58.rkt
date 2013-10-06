;;; exercise 4.58
(rule 
 (big-shot ?person ?division)
 (and (job ?person (?division . ?pjob))
      (or (not (supervisor ?person ?boss)) ;does not have a supervisor
          (and (supervisor ?person ?boss) ;does have a supervisor but works in different division
               (not (job ?boss (?division . ?bjob)))))))