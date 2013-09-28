;;; exercise 4.44

;;; the solution below runs slowly on amb-interpretor
;;; And I have no idea how to improve it currently
(define (queens board-size)
  ;;represent board
  (define empty-board '())
  (define (empty-board? board)
    (null? board))
  (define (get-next-pos board)
    (car board))
  (define (rest-poses board)
    (cdr board))
  (define (row-index pos)
    (car pos))
  (define (col-index pos)
    (cdr pos))
  (define (add-pos pos board)
    (cons pos board))
  (define (safe? pos board)
    (if (empty-board? board)
        true
        (let* ((next-pos (get-next-pos board))
               (row-dis (abs (- (row-index pos) (row-index next-pos))))
               (col-dis (abs (- (col-index pos) (col-index next-pos)))))
          (and (not (= row-dis 0))
               (not (= col-dis 0))
               (not (= row-dis col-dis))
               (safe? pos (rest-poses board))))))
  (define (amb-enum m n)
    (if (< n m)
        (amb)
        (amb m (amb-enum (+ m 1) n))))
  (define (board-gen n board)
    (if (= n (+ 1 board-size))
        board
        (let ((next-pos (cons (amb-enum n board-size)
                              (amb-enum 1 board-size))))
          (require (safe? next-pos board))
          (board-gen (+ n 1) (add-pos next-pos board)))))
  (board-gen 1 empty-board))
          
        