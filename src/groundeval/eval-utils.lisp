;
; Consider moving this stuff to pvs2.3/src/utils.lisp
;

(in-package 'pvs) 

(defun mk-translate-cases-to-if (cases-expr)
  (mk-translate-cases-to-if* (expression cases-expr)
			     (selections cases-expr)
			     (else-part  cases-expr)))

(defun mk-translate-cases-to-if* (expr selections else-part &optional chained?)
  (cond ((and (null (cdr selections))
	      (null else-part))
	 (mk-subst-accessors-in-selection expr (car selections)))
	((null selections)
	 else-part)
	(t (let* ((sel (car selections))
		  (thinst (module-instance (find-supertype (type expr))))
		  (rec (subst-mod-params (recognizer (constructor sel)) thinst))
		  (cond (make!-application rec expr))
		  (then (mk-subst-accessors-in-selection expr sel))
		  (else (mk-translate-cases-to-if* expr (cdr selections)
						   else-part t)))
	     (if chained?
		 (make!-chained-if-expr cond then else)
		 (make!-if-expr cond then else))))))

(defun mk-subst-accessors-in-selection (expr sel)
  (let* ((thinst (module-instance (find-supertype (type expr))))
	 (accs (subst-mod-params (accessors (constructor sel)) thinst))
	 (vars (args sel))
	(selexpr (expression sel)))
    (substit selexpr
      (pairlis vars
	       (mapcar #'(lambda (acc) (make!-application acc expr))
		       accs)))))











