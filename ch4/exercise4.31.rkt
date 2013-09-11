;;; exercise 4.31

(define (actual-value exp env)
  (force-it (my-eval exp env)))

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj)
  (tagged-list? obj 'thunk))

(define (delay-it-memo exp env)
  (list 'thunk-memo exp env))
(define (thunk-memo? obj)
  (tagged-list? obj 'thunk-memo))

(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))
(define (thunk-value evaluated-thunk)
  (cadr evaluated-thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define (force-it obj)
  (cond ((thunk? obj)
         (actual-value (thunk-exp obj)
                       (thunk-env obj)))
        ((thunk-memo? obj)
         (let ((result (actual-value
                        (thunk-exp obj)
                        (thunk-env obj))))
           (set-car! obj 'evaluated-thunk)
           (set-car! (cdr obj) result)
           (set-cdr! (cdr obj) '())
           result))
        ((evaluated-thunk? obj)
         (thunk-value obj))
        (else obj)))

(define (my-apply proc arguments env)
  (cond ((primitive-procedure? proc)
         (apply-primitive-procedure
          proc 
          (list-of-arg-values arguments env)))
        ((compound-procedure? proc)
         (eval-sequence
          (procedure-body proc)
          (extend-environment
           (remove-parameter-type (procedure-parameters proc))
           (list-of-mixed (procedure-parameters proc)
                          arguments 
                          env)
           (procedure-environment proc))))
        (else
         (error "Unknown procedure type -- MY-APPLY" proc))))

(define (remove-parameter-type pars)
  (cond ((no-parameters? pars) '())
        ((pair? (first-parameter pars))
         (cons (car (first-parameter pars))
               (remove-parameter-type (rest-parameters pars))))
        (else
         (cons (first-parameter pars)
               (remove-parameter-type (rest-parameters pars))))))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps) env)
            (list-of-arg-values (rest-operands exps) env))))

(define (list-of-mixed pars exps env)
  (cond ((no-operands? exps) '())
        ((not (pair? (first-parameter pars)))
         (cons (actual-value (first-operand exps) env)
               (list-of-mixed (rest-parameters pars)
                              (rest-operands exps)
                              env)))
        (else (let ((par (first-parameter pars)))
                (cond ((lazy? par)
                       (cons (delay-it (first-operand exps) env)
                             (list-of-mixed (rest-parameters par)
                              (rest-operands exps)
                              env)))
                      ((lazy-memo? par)
                       (cons (delay-it-memo (first-operand exps)
                                            env)
                             (list-of-mixed (rest-parameters par)
                              (rest-operands exps)
                              env)))
                      (else
                       (error "Unknown parameter type" par)))))))

(define (lazy? parameter)
  (eq? 'lazy (cadr parameter)))
(define (lazy-memo? parameter)
  (eq? 'lazy-memo (cadr parameter)))

(define (no-parameters? pars)
  (null? pars))
(define (first-parameter pars)
  (car pars))
(define (rest-parameters pars)
  (cdr pars))
         
  
