(defun c:design_tmp ()
  (setvar "osmode" 0)
  (command "_.vpoint" "" "0,0,0" "")
  (setq wall (entget (car (entsel "Select a wall"))))
  (repeat (setq i (length wall))
    (if	(= (car (nth i wall)) 0)
      (setq enttype_w (cdr (nth i wall)))
    )
    (if	(= (car (nth i wall)) 8)
      (setq layername_w (cdr (nth i wall)))
    )
    (setq i (1- i))
  )
  (setq sp (list))
  (if (eq enttype_w "LINE")
    (setq wall_ss (ssget "_X"
			 (list (cons 0 enttype_w)
			       (cons 8 layername_w)
			 )
		  )
  )
    )
  (repeat (setq in (sslength wall_ss))
    (vla-highlight
      (vlax-ename->vla-object
	(ssname wall_ss (setq in (1- in)))
      )
      :vlax-true
    )
    (setq ent (entget (ssname wall_ss in)))
  )
  (setq startp (list))
  (setq endp (list))
  (repeat (setq in (sslength wall_ss))
    (setq in (1- in))
    (setq startp (cons (cdr (assoc 10 (entget (ssname wall_ss in)))) startp))
    (setq endp (cons (cdr (assoc 11 (entget (ssname wall_ss in)))) endp))
    )
  (setq a1 1)
  (setq a2 0)
  (setq theotherentity (list))
  ;|(while (< a1 (- (length startp) 1))
    (setq ent1 (vlax-ename->vla-object (nth a1 wall_ss)))
    (setq a2 0)
    (while (< a2 (- (length startp) 1))
      (setq ent2 (vlax-ename->vla-object (nth a2 wall_ss)))
      |;
      
 ;;(alert "Select among the following your preferable column positions")
  (while (< a1 (- (length startp) 1))
    (setq a2 (1+ a1))
    (setq n (rand))
    (progn
      (while (< a2 (- (length startp) 1))
	(if (eq (fix (distance (nth a2 startp) (nth a1 startp))) 0)
	  (progn
	    (command "rectang"
		     (nth a2 startp)
		     (mapcar '+ (nth a2 startp) (list 200 300 0)) ""
		     )
	  (princ a2)
	  (setq theotherentity (append (nth a2 startp) theotherentity))
	  )
	  )
	(setq a2 (1+ a2))
	)
      ) 
    (setq a1 (1+ a1))
  )
  (setq theotherentity (list))
(setq b1 0)
  (setq b2 0)
  (setq pt1 (getpoint "Pick the base point"))
  (setq pt2 (getpoint "Pick the final point"))
  (command "copy"
	   wall_ss
	   ""
	   pt1
	   pt2
	   ""
	   )
  (setq endp (mapcar '(lambda (x) (mapcar '+ x pt2)) endp))
  (while (< b1 (- (length endp) 1))
    (setq b2 (1+ b1))
    (setq n (rand))
    (progn
      (while (< b2 (- (length endp) 1))
	(if (eq (fix (distance (nth b2 endp) (nth b1 endp))) 0)
	  (progn
	    (command "rectang"
		     (nth b2 endp)
		     (mapcar '+ (nth b2 endp) (list 200 200 0))
		     ""
		     )
	  (princ b2)
	  (setq theotherentity (append (nth b2 endp) theotherentity))
	  )
	  )
	(setq b2 (1+ b2))
	)
      ) 
    (setq b1 (1+ b1))
  )
  )



  ;|(setq sp (getfiled "Create output file" "" "csv" 1))
  (if (Lm:writecsv (reverse startp) sp)
    (startapp "explorer" |;
    (defun LM:writecsv ( lst csv / des sep )
    (if (setq des (open csv "w"))
        (progn
            (setq sep (cond ((vl-registry-read "HKEY_CURRENT_USER\\Control Panel\\International" "sList")) (",")))
            (foreach row lst (write-line (LM:lst->csv row sep) des))
            (close des)
            t
        )
    )
)

;; List -> CSV  -  Lee Mac
;; Concatenates a row of cell values to be written to a CSV file.
;; lst - [lst] list containing row of CSV cell values
;; sep - [str] CSV separator token

(defun LM:lst->csv ( lst sep )
    (if (cdr lst)
        (strcat (LM:csv-addquotes (car lst) sep) sep (LM:lst->csv (cdr lst) sep))
        (LM:csv-addquotes (car lst) sep)
    )
)

(defun LM:csv-addquotes ( str sep / pos )
    (cond
        (   (wcmatch str (strcat "*[`" sep "\"]*"))
            (setq pos 0)    
            (while (setq pos (vl-string-position 34 str pos))
                (setq str (vl-string-subst "\"\"" "\"" str pos)
                      pos (+ pos 2)
                )
            )
            (strcat "\"" str "\"")
        )
        (   str   )
    )
)
  ;|(defun bin_search (listtoSearch lo high target)
    (setq mid (/ (+ lo high) 2))
    (if (eq (fix (distance (nth mid listtoSearch) target)) 0)
      (progn
      (princ mid)
      (exit)
      )
      (progn
    (if (eq (fix (distance (nth mid listtoSearch) target)) 0)
	(setq high (- mid 1))
	(setq lo (+ mid 1))
	)
      )
      )
    (bin_search listtoSearch lo high target)
    )|;
(defun lin_search (listtoSearch first_occurence target)
  (setq w first_occurence)
  (while (< w (- (length listtoSearch) 1))
    (setq w (1+ w))
    (if (eq (fix (distance (nth w listtoSearch) target)) 0)
	(princ w)
      )
    
    )
  )

(defun LM:intersections ( ob1 ob2 mod / lst rtn )
    (if (and (vlax-method-applicable-p ob1 'intersectwith)
             (vlax-method-applicable-p ob2 'intersectwith)
             (setq lst (vlax-invoke ob1 'intersectwith ob2 mod))
        )
        (repeat (/ (length lst) 3)
            (setq rtn (cons (list (car lst) (cadr lst) (caddr lst)) rtn)
                  lst (cdddr lst)
            )
        )
    )
    (reverse rtn)
)

(defun rand (/ a c m)
  (setq m 4294967296.0
	a 1664525.0
	c 1013904223.0
    $xn (rem (+ c (* a (cond ($xn) ((getvar 'date))))) m)
    )
    (/ $xn m)
)
(defun randrange ( a b )
    (+ (min a b) (fix (* (rand) (1+ (abs (- a b))))))
)
		     
;|(if (and (/= (lin_search startp a (nth a startp)) a) (lin_search startp a (nth a startp)))
      (progn
	(setq theotherentity (append (list (lin_search startp a (nth a startp))) theotherentity))
	(princ theotherentity)
	(princ "\n")
	)
      )|;  