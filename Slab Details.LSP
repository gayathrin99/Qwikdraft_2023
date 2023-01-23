(defun c:slabdetails ()
  (if (< 20230130 (getvar "cdate"))
    (progn
      (princ "\n*** This version of Qwikdraft software has expired***")
      (exit)
      )
    )
  (progn
  (setvar "cmdecho" 0)
  (setq restoreosmode (getvar "osmode"))
  ;;(setvar "osmode" 0)
  (setvar "INSUNITS" 4)
  (setq unit (getstring "Is the drawings in Foot & inches system?(y/n)"))
  (setq count 0)
  (setq c (getint "Please enter the cover for the steel"))
  (while (eq count 0)
    (setq pt1 (getpoint "Select the top-left corner of the slab"))
    (setq pt2 (getpoint "Select the top-right corner of the slab"))
    (setq pt3 (getpoint "Select the bottom-left corner of the slab"))
    (setq pt4 (getpoint "Select the bottom-right corner of the slab"))
      (command "line" (mapcar '+ pt1 (list (/ (distance pt1 pt2) 2) (- c) 0))
	       (mapcar '+ pt1 (list (/ (distance pt1 pt2) 2) (- c) 0) (list -18 0 0))
	       "")
      (command "line" (mapcar '+ pt1 (list (/ (distance pt1 pt2) 2) (- c) 0))
	       (mapcar '+ pt1 (list (/ (distance pt1 pt2) 2) (- c (distance pt1 pt3)) 0))
	       "")
      (command "line" (mapcar '+ pt3 (list (/ (distance pt3 pt4) 2) c 0))
	       (mapcar '+ pt3 (list (/ (distance pt3 pt4) 2) c 0) (list -18 0 0))
	       "") 
    (command "line" (mapcar '- pt1 (list (- c) (/ (distance pt1 pt3) 2) 0))
	       (mapcar '- pt1 (list (- c) (/ (distance pt1 pt3) 2) 0) (list 0 -18 0))
	       "")
      (command "line" (mapcar '- pt1 (list (- c) (/ (distance pt1 pt3) 2) 0))
	       (mapcar '- pt1 (list (- c (distance pt1 pt2)) (/ (distance pt1 pt3) 2) 0))
	       "")
      (command "line" (mapcar '- pt2 (list c (/ (distance pt1 pt3) 2) 0))
	       (mapcar '- pt2 (list c (/ (distance pt1 pt3) 2) 0) (list 0 -18 0))
	       "")
    (command "line" (mapcar '+ pt1 (list (- (/ (distance pt1 pt2) 2) 20) (- c) 0))
	     (mapcar '+ pt1 (list (- (/ (distance pt1 pt2) 2) 20) (- (qd:roundup (* (distance pt1 pt3) 0.33) 3)) 0))
	     "")
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "150"
	     ""
    )
    (command "line" (mapcar '+ pt3 (list (- (/ (distance pt3 pt4) 2) 20) c 0))
	     (mapcar '+ pt3 (list (- (/ (distance pt3 pt4) 2) 20) (qd:roundup (* (distance pt1 pt3) 0.33) 3) 0))
	     "")
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "150"
	     ""
    )
    (command "line" (mapcar '- pt1 (list (- c) (- (/ (distance pt1 pt3) 2) 20) 0))
	     (mapcar '- pt1 (list (- (qd:roundup (* (distance pt1 pt2) 0.33) 3)) (- (/ (distance pt1 pt3) 2) 20) 0))
	     "")
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line" (mapcar '- pt2 (list c (- (/ (distance pt1 pt3) 2) 20) 0))
	     (mapcar '- pt2 (list (+ (qd:roundup (* (distance pt1 pt2) 0.33) 3)) (- (/ (distance pt1 pt3) 2) 20) 0))
	     "")
    (command "chprop"
	     (entlast)
	     ""
	     "LT"
	     "DASHED"
	     ""
	     "LTScale"
	     "15"
	     ""
    )
    (command "line" (mapcar '+ pt1 (list (- (/ (distance pt1 pt2) 2) 10) (- (qd:rounddown (* (distance pt1 pt3) 0.15) 3)) 0))
	     (mapcar '+ pt1 (list (- (/ (distance pt1 pt2) 2) 10) (+ (- (distance pt1 pt3)) (qd:rounddown (* (distance pt1 pt3) 0.15) 3)) 0))
	     "")
    (command "line" (mapcar '+ pt1 (list (qd:rounddown (* (distance pt1 pt2) 0.15) 3) (+ (/ (distance pt1 pt3) -2) 10) 0))
	     (mapcar '+ pt1 (list (+ (distance pt1 pt2) (- (qd:rounddown (* (distance pt1 pt3) 0.15) 3))) (+ (/ (distance pt1 pt3) -2) 10) 0))
	     "")
    (setq finish (getstring "Are you done? (y/n)"))
    (if (or (eq finish "y") (eq finish "Y"))
      (setq count 1)
      (setq count 0)
      )
    )
  )
  )
  (defun qd:rounddown	(n m)
      ((lambda (r)
	 (cond ((equal 0.0 r 1e-8) n)
	       ((< n 0) (- n r m))
	       ((- n r))
	 )
       )
	(rem n m)
      )
    )
  (defun qd:roundup (n m)
      ((lambda (r)
	 (cond ((equal 0.0 r 1e-8) n)
	       ((< n 0) (- n r))
	       ((+ n (- m r)))
	 )
       )
	(rem n m)
      )
    )
  
    
  
  
  
  