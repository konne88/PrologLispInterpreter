; Test expressions for pli
5
(list 1 2)
(cdr (list 1 2 3))
(car (list 1 2)); x 4 5))
(cons 3 (list 2 1))
(cons 1 2)
(cons 2 (cons 1 nil))
(quote (a (+ 3 4) var 66 du (1 6 8 (() ()) va)))
(+ 2 5)
(- 2 5)
(* 2 5)
(/ 2 5)
(/ 10 2)
(< 2 5)
(< 1 0)
(> 2 5)
(> 1 0)
t
nil
(null nil)
(null ())
(null 1)
(floor 4 2)
(floor 7 2)
(cond (t 5))
(cond ((> 2 3) 1) 
      (t 2))
(cond ((> 3 5) 0) 
      ((< (car (quote (2 5))) 3) 1) 
      (t 2))
(if (null nil) (quote right) (quote wrong))
(if (null (list 1)) (quote wrong) (quote right))

(let ((a 1337)) (list a))
(let ((a 1337)) (let ((b (+ 1 (car (list a 2))))) (list a b)))

(defun test1 (a)  a)
(defun test2 (x y)  (list 1 2 x y))
(test1 1337)
(test2 3 4)

(print (quote (1,3,3,7)))

(let ((a 0) (b 1))
  (cond 
        ((print (null b)) 1)))

(defun len (lst) 
  (cond ((null lst) 0)
        (t (+ 1 (len (cdr lst))))))

(len (list 1 2 3 4 5 6 7 8 9 10))

(defun mergeLists (a b)
  (cond ((null a) b)
        ((null b) a)
        ((< (car a) (car b)) (cons (car a) (mergeLists (cdr a) b)))
        (t (cons (car b) (mergeLists a (cdr b))))))

(mergeLists (list 1 4 6 7 98) (list 0 5 9 10 34 2343))

(defun split (lst i parsed)
  (cond ((> i 0) (split (cdr lst) (- i 1) (cons (car lst) parsed)))
        (t (cons parsed lst))))

(print (split (list 1 2 3 4 5 6 7 8 9) 4 ()))

(defun mergeSort (lst)
   (cond ((null lst) lst)
         ((null (cdr lst)) lst)
         (t (let ((sp (split lst (floor (len lst) 2) ())))
            (mergeLists (mergeSort (car sp)) (mergeSort (cdr sp)))))))

(print (mergeSort (print (quote (2 9 1 9 13 9 1 2 34 4 5 6 10 4 0 3 7 1 2 7 4 3 2 1 9)))))
