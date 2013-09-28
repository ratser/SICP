;;; exercise 4.43

(define (fdy-match) ;;; father daughter yacht match
  (define (daughter father)
    (car father))
  (define (yacht father)
    (car (cdr father)))
  (let ((Moore (list (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa)
                     (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa))))
    (require (eq? (daughter Moore) 'MaryAnn)) ;comment out this requirement for the second question
    (require (eq? (yacht Moore) 'Lorna))
    (require (not (eq? (daughter Moore) (yacht Moore))))
    (let ((Barnacle 
           (list (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa)
                 (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa))))
      (require (eq? (daughter Barnacle) 'Melissa))
      (require (eq? (yacht Barnacle) 'Gabrielle))
      (require (not (eq? (daughter Barnacle) (yacht Barnacle))))
      (let ((Hall 
             (list (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa)
                   (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa))))
        (require (eq? (yacht Hall) 'Rosalind))
        (require (not (eq? (daughter Hall) (yacht Hall))))
        (let ((Downing 
               (list (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa)
                     (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa))))
          (require (eq? (yacht Downing) 'Melissa))
          (require (not (eq? (daughter Downing) (yacht Downing))))
          (let ((Parker
                 (list (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa)
                       (amb 'MaryAnn 'Gabrielle 'Lorna 'Rosalind 'Melissa))))
            (define (find-father dt)
              (cond ((eq? (daughter Moore) dt)  Moore)
                    ((eq? (daughter Barnacle) dt)  Barnacle)
                    ((eq? (daughter Hall) dt) Hall)
                    ((eq? (daughter Downing) dt) Downing)
                    (else Parker)))
            (require (eq? (yacht (find-father 'Gabrielle))
                          (daughter Parker)))
            (require (not (eq? (daughter Parker) (yacht Parker))))
            (require (distinct? (list (daughter Moore)
                                      (daughter Barnacle)
                                      (daughter Hall)
                                      (daughter Downing)
                                      (daughter Parker))))
            (require (distinct? (list (yacht Moore)
                                      (yacht Barnacle)
                                      (yacht Hall)
                                      (yacht Downing)
                                      (yacht Parker))))
            (list (cons 'Moore Moore)
                  (cons 'Barnacle Barnacle)
                  (cons 'Hall Hall)
                  (cons 'Downing Downing)
                  (cons 'Parker Parker))))))))
            
            
             