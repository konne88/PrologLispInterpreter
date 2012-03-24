;x
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
(> 2 5)
t
nil
(null nil)
(null ())
(null 1)
(floor (/ 4 2))
(floor (/ 7 2))
(cond (t 5))
(cond ((> 2 3) 1) 
      (t 2))
(cond ((> 3 5) 0) 
      ((< (car (quote 2 5)) 3) 1) 
      (t 2))
(if (null nil) (quote right) (quote wrong))
(if (null (list 1)) (quote wrong) (quote right))

(let ((a 1337) (b (+ 1 (car (list a 2))))) (list a b))

(defun test1 (a)  a)
(defun test2 (x y)  (list 1 2 x y))
(test1 1337)
(test2 3 4)

(defun length (lst) 
  (cond ((null lst) 0)
        (t (+ 1 (length (cdr lst))))))

(length (list 1 2 3 4 5 6 7 8 9 10))

(defun merge (a b)
  (cond ((null a) b)
        ((null b) a)
        ((< (car a) (car b)) (cons (car a) (merge (cdr a) b)))
        (t (cons (car b) (merge a (cdr b))))))

(merge (list 1 4 6 7 98) (list 0 5 9 10 34 12 2343))

(defun split (lst,i)
  (cons (cond ((> i 0) (cons (split (cdr lst) (- i 1)) (car lst))))
              (t lst)))

(split (list 1 2 3 4 5 6 7 9) 4)

(defun mergeSort (lst)
   (cond ((null lst) lst)
         ((null (cdr lst)) lst)
         (let ((sp (split lst (floor ((length lst) / 2)))))
         (merge (mergeSort (car sp)) (mergeSort (cdr sp))))))

(defun mergeSort (quote (1 8 1 9 13 9 1 2 34 4 5 6 10 4 0 3 7 1 2 7 4 3 2 1 9)))
