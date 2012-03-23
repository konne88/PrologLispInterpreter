;x
5
(list 1 2)
(cdr (list 1 2 3))
(car (list 1 2)); x 4 5))
(defun test2 (a)  a)
(defun test1 (x y)  (list 1 2 x y))
; (test1 1337)
; (test2 3 4)
(quote (a (+ 3 4) var 66 du (1 6 8 (() ()) va)))
(+ 2 5)
(- 2 5)
(* 2 5)
(/ 2 5)
(/ 10 2)
(< 2 5)
(> 2 5)
t
nil
(null nil)
(null ())
(null 1)
(cond (t 5))
(cond ((> 2 3) 1) (t 2))
(cond ((> 3 5) 0) ((< (car (quote 2 5)) 3) 1) (t 2))
(if (null nil) (quote right) (quote wrong))
(if (null (list 1)) (quote wrong) (quote right))


