(in-package 'pvs)

(defvar *eval-array-bound* 10000)    ;shouldn't be used
(defvar *eval-verbose* nil)          ;turn on for verbose translation trace

;;unary primitives
(defun pvs_= (x) (equalp (svref x 0)(svref x 1)))
(defun pvs_/= (x)(not (equalp (svref x 0)(svref x 1))))
(defun pvs_IMPLIES (x) (OR (NOT (svref x 0)) (svref x 1)))
(defun pvs_when (x) (OR (svref x 0)(NOT (svref x 1))))
(defun pvs_=> (x) (pvs_IMPLIES x))
(defun pvs_IFF (x) (equal (svref x 0)(svref x 1)))
(defun pvs_<=> (x) (equal (svref x 0)(svref x 1)))
(defun pvs_and (x)(AND (svref x 0)(svref x 1)))
(defun pvs_& (x)(AND (svref x 0)(svref x 1)))
(defun pvs_or (x) (OR (svref x 0)(svref x 1)))
(defun pvs_not (x) (NOT x))
(defun pvs_+ (x) (+ (svref x 0)(svref x 1)))
(defun pvs_- (x) (- x))  ;;temporary (svref x 0)(svref x 1)))
(defun pvs_-- (x) (- (svref x 0)(svref x 1)))
(defun pvs_* (x) (* (svref x 0)(svref x 1)))
(defun pvs_/ (x) (/ (svref x 0)(svref x 1)))
(defun pvs_< (x) (< (svref x 0)(svref x 1)))
(defun pvs_<= (x) (<= (svref x 0)(svref x 1)))
(defun pvs_> (x) (> (svref x 0)(svref x 1)))
(defun pvs_>= (x) (>= (svref x 0)(svref x 1)))
(defun pvs_|floor| (x) (floor x))
(defun pvs_|ceiling| (x) (ceiling x))
(defun pvs_|rem| (x) (rem (svref x 0)(svref x 1)))
(defun pvs_|div| (x) (let ((z (/ (svref x 0)(svref x 1))))
		     (if (< z 0)(ceiling z)(floor z))))
(defun pvs_|cons| (x) (cons (svref x 0)(svref x 1)))
(defun pvs_|car| (x) (car x))
(defun pvs_|cdr| (x) (cdr x))
(defun pvs_|cons?| (x) (consp x))
(defun pvs_|null?| (x) (null x))
(defun pvs_|restrict| (f) f)

;;multiary macro versions of primitives
(defmacro pvs__= (x y)
  (let ((xx (gentemp))
	(yy (gentemp)))
    `(let ((,xx ,x)
	   (,yy ,y))
       (cond ((symbolp ,xx)
	      (eq ,xx ,yy))
	     ((numberp ,xx) (= ,xx ,yy))
	     (t (equalp ,xx ,yy))))))
(defmacro pvs__/= (x y) `(not (equalp ,x ,y)))
(defmacro pvs__IMPLIES (x y) `(OR (NOT ,x) ,y))
(defmacro pvs__when (x y) `(OR (NOT ,y) ,x))
(defmacro pvs__=> (x y) `(OR (NOT ,x) ,y))
(defmacro pvs__IFF (x y) `(equal ,x ,y))
(defmacro pvs__<=> (x y) `(equal ,x ,y))
(defmacro pvs__and (x y) `(AND ,x ,y))
(defmacro pvs__& (x y) `(AND ,x ,y))
(defmacro pvs__or (x y)  `(OR ,x ,y))
(defmacro pvs__+ (x y) `(+ ,x ,y))
(defmacro pvs__- (x y) `(- ,x ,y))
(defmacro pvs__* (x y) `(* ,x ,y))
(defmacro pvs__/ (x y) `(/ ,x ,y))
(defmacro pvs__< (x y) `(< ,x ,y))
(defmacro pvs__<= (x y) `(<= ,x ,y))
(defmacro pvs__> (x y) `(> ,x ,y))
(defmacro pvs__>= (x y) `(>= ,x ,y))
(defmacro pvs__|floor| (x) `(floor ,x))
(defmacro pvs__|ceiling| (x) `(ceiling ,x))
(defmacro pvs__|rem| (x y)
  (let ((xx (gentemp))
	(yy (gentemp)))
    `(let ((,xx (the integer ,x))
	   (,yy (the integer ,y)))
       (if (< ,xx ,yy) ,xx (rem ,xx ,yy)))))
(defmacro pvs__|div| (x y)
  (let ((xx (gentemp))
	(yy (gentemp)))
    `(let ((,xx ,x)
	   (,yy ,y))
       (if (eq (< ,xx 0)(< ,yy 0))
	   (floor ,xx ,yy)
	   (ceiling ,xx ,yy)))))
(defmacro pvs__|cons| (x y) `(cons ,x ,(the list y)))

(defmacro project (index tuple)
  (let ((ind (1- index)))
    `(let ((val (svref ,tuple ,ind)))
       (if (eq val 'undefined)(undefined nil) val)   ;; what can we do here?
	 )))

