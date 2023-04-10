(defun c:design	()
  (setvar "osmode" 0)
  (command "_.vpoint" "" "0,0,0" "")
  (setq column (entget (car (entsel "Select a column"))))
  (setq i 0)
  (repeat (setq i (length column))
    (if	(= (car (nth i column)) 0)
      (setq enttype_c (cdr (nth i column)))
    )
    (if	(= (car (nth i column)) 8)
      (setq layername_c (cdr (nth i column)))
    )
    (if	(= (car (nth i column)) 62)
      (setq layercolor_c (cdr (nth i column)))
    )
    (if	(= (car (nth i column)) 370)
      (setq lineweight_c (cdr (nth i column)))
    )
    (setq i (1- i))
  )
  (setq sp (list))
  (if (eq (cons 0 enttype_c) "LINE")
  (setq	column_ss (ssget "_X"
			 (list (cons 0 enttype_c)
			       (cons 8 layername_c)
			       (cons 62 layercolor_c)
			       (cons 370 lineweight_c)
			 )
		  )
  )
    (setq	column_ss (ssget "_X"
			 (list (cons 0 enttype_c)
			       (cons 8 layername_c)
			 )
		  )
  )
    )
  (repeat (setq in (sslength column_ss))
    (vla-highlight
      (vlax-ename->vla-object
	(ssname column_ss (setq in (1- in)))
      )
      :vlax-true
    )
    (setq ent (entget (ssname column_ss in)))
  )
  (command "copy"
	   column_ss
	   ""
	   (getpoint "Pick the base point")
	   (getpoint "Pick the final point")
	   ""
  )
  (princ
    "Erase any unwanted items selected and copy any columns that has been missed"
  )
  (setq count 0)
  (while (< count 1)
    (progn
      (setq new_ss_agreement (getstring t "Are you done(y/n)?"))
      (if (or (eq new_ss_agreement "n") (eq new_ss_agreement "n"))
	(command "erase" (ssget) "" "")
	(setq count 1)
      )
    )
  )
  (alert "Select all the revised set of columns")
  (setq new_column_ss (ssget))
  (setq stor_no (getint "Enter the Number of Storeys in the building"))
  (setq	stor_hgt
	 (getint
	   "Enter the height of a typical storey in the building (in m)"
	 )
  )
  (command "_.vpoint" "" "1,1,1" "")
  (command "extrude"
	   new_column_ss
	   ""
	   (* stor_no stor_hgt 3.28 12)
	   ""
  )
  ;; To be made into a dialog box in the future
  (setq	concrete_mix
	 (getstring
	   "Please enter the grade of concrete (M15/M20/M25/M30/M35/M40)"
	 )
  )
  (setq fck 0)
  (cond	((or (eq concrete_mix "m15")
	     (eq concrete_mix "M15")
	     (eq concrete_mix "15")
	 )
	 (setq fck 15)
	)
	((or (eq concrete_mix "m20")
	     (eq concrete_mix "M20")
	     (eq concrete_mix "20")
	 )
	 (setq fck 20)
	)
	((or (eq concrete_mix "m25")
	     (eq concrete_mix "M25")
	     (eq concrete_mix "25")
	 )
	 (setq fck 25)
	)
	((or (eq concrete_mix "m30")
	     (eq concrete_mix "M30")
	     (eq concrete_mix "30")
	 )
	 (setq fck 30)
	)
	((or (eq concrete_mix "m35")
	     (eq concrete_mix "M35")
	     (eq concrete_mix "35")
	 )
	 (setq fck 35)
	)
	((or (eq concrete_mix "m40")
	     (eq concrete_mix "M40")
	     (eq concrete_mix "40")
	 )
	 (setq fck 40)
	)
  )
  (setq	steel_grade
	 (getstring
	   "Please enter the grade of steel(Yield Stress) (Fe 345/Fe 415/Fe 500/Fe 515)"
	 )
  )
  (setq fy 0)
  (cond	((or (eq steel_grade "fe345")
	     (eq concrete_mix "fe 345")
	     (eq concrete_mix "Fe345")
	     (eq concrete_mix "Fe 345")
	 )
	 (setq fy 345)
	)
	((or (eq steel_grade "fe415")
	     (eq concrete_mix "fe 415")
	     (eq concrete_mix "Fe415")
	     (eq concrete_mix "Fe 415")
	 )
	 (setq fy 415)
	)
	((or (eq steel_grade "fe500")
	     (eq concrete_mix "fe 500")
	     (eq concrete_mix "Fe500")
	     (eq concrete_mix "Fe 500")
	 )
	 (setq fy 500)
	)
	((or (eq steel_grade "fe515")
	     (eq concrete_mix "fe 515")
	     (eq concrete_mix "Fe515")
	     (eq concrete_mix "Fe 515")
	 )
	 (setq fy 515)
	)
  )

  (setq	column_breadth
	 (getint
	   "Please enter the breadth of the column (in mm)"
	 )
  )
  (setq	column_width
	 (getint "Please enter the width of the column (in mm)")
  )
  (setq	column_cover
	 (getint
	   "Please enter the Steel cover for the column (in mm)"
	 )
  )
  (command "_.vpoint" "" "0,0,0" "")
  (alert "Now lets get started on the beam positions")
  (setq wall (entget (car (entsel "Select a wall"))))
  (setq i 0)
  (repeat (setq i (length wall))
    (if	(= (car (nth i wall)) 0)
      (setq enttype_b (cdr (nth i wall)))
    )
    (if	(= (car (nth i wall)) 8)
      (setq layername_b (cdr (nth i wall)))
    )
    (if	(= (car (nth i wall)) 62)
      (setq layercolor_b (cdr (nth i wall)))
    )
    (if	(= (car (nth i wall)) 370)
      (setq lineweight_b (cdr (nth i wall)))
    )
    (setq i (1- i))
  )
  
  (setq	ss_b (ssget "_X"
		    (list (cons 0 enttype_b)
			  (cons 62 layercolor_b)
			  (cons 370 linewei
				ght_b)
		    )
	     )
  )
  (alert "The beam selection happened")
  (repeat (setq in (sslength ss_b))
    (vla-highlight
      (vlax-ename->vla-object (ssname ss_b (setq in (1- in))))
      :vlax-true
    )
    (setq ent (entget (ssname ss_b in)))
  )
  (command "_.vpoint" "" "0,0,0" "")
  (command "copy"
	   ss_b
	   ""
	   (getpoint "Pick the base point with reference to a column")
	   (getpoint "Pick the final point on the 3d columns")
	   ""
  )
  (princ
    "Erase any unwanted items selected and copy any walls that has been missed"
  )
  (setq count 0)
  (while (< count 1)
    (progn
      (setq new_ss_agreement (getstring t "Are you done(y/n)?"))
      (if (or (eq new_ss_agreement "n") (eq new_ss_agreement "N"))
	(progn
	  (command "erase" (ssget) "" "")
	  (command "copy" (ssget) "" (getpoint) (getpoint) "")
	)
	(setq count 1)
      )
    )
  )
  (alert "Select the area with only the walls")
  (setq	new_beam_ss
	 (ssget	"_X"
		(list (cons 0 enttype_b)
		      (cons 62 layercolor_b)
		      (cons 370 lineweight_b)
		)
	 )
  )
  (setq	beam_depth
	 (getint "Please enter the depth of the beam (in mm)")
  )
  (setq	beam_width
	 (getint "Please enter the width of the beam (in mm)")
  )
  (setq	beam_cover
	 (getint
	   "Please enter the Steel cover for the beam (in mm)"
	 )
  )
  (setq j 0)
  (setq base_point (getpoint "Select the base point"))
  (while (<= j stor_no)
    (progn
      (command
	"copy"
	new_beam_ss
	""
	base_point
	(mapcar
	  '+
	  base_point
	  (list	0
		0
		(- (* stor_hgt j 3.28 12)
		   (* (/ beam_depth 1000.00) (/ 1000 (* 25.4 12)) 12)
		)
	  )
	)
	""
      )
      (setq copy_ss_b (ssget "L"))
      (command "extrude"
	       copy_ss_b
	       ""
	       (* (/ beam_depth 1000.00) (/ 1000 (* 25.4 12)) 12)
	       ""
      )
      (repeat (setq in (sslength copy_ss_b))
	(vla-highlight
	  (vlax-ename->vla-object
	    (ssname copy_ss_b (setq in (1- in)))
	  )
	  :vlax-true
	)
	(setq ent (entget (ssname copy_ss_b in)))
	(command "extrude"
		 copy_ss_b
		 ""
		 (* (/ beam_depth 1000.00) (/ 1000 (* 25.4 12)) 12)
		 ""
	)
      )
      (setq j (1+ j))
    )
  )
  (command "_.vpoint" "" "1,1,1" "")
  (setq	slab_depth
	 (getint "Please enter the depth of the slab (in mm)")
  )
  (setq	slab_cover
	 (getint "Please enter the cover of the slab (in mm)")
  )
  (setq live_load (getreal "What is the live load? (in kN/m)"))
  (setq roof_load (getreal "What is the roof load? (in kN/m)"))
  (list slab_point (list))
  (setq finish "false")
  (command "_.vpoint" "" "0,0,0" "")
  (while (eq finish "false")
    (setq count 0)
    (while (< count 1)
      (setq
	ly (/ (getdist
		"Select the end points of a slab in longer direction"
	      )
	      (* 12 3.28)
	   )
      )
      (setq lx
	     (/	(getdist
		  "Select the end points of slab in the shorter direction"
		)
		(* 12 3.28)
	     )
      )
      (setq ld_prov (/ lx (- slab_depth slab_cover)))
      (setq eff_d (- slab_depth slab_cover))
      (if (> (/ ly lx) 2)
	(progn
	  (setq ef_span 0)
	  (if (< (+ lx beam_width) (+ lx (- slab_depth slab_cover)))
	    (setq ef_span (+ lx (/ beam_width 1000.00)))
	    (setq ef_span (+ lx (/ eff_d 1000)))
	  )
	  (setq w (+ (* (/ slab_depth 1000.00) 25) live_load roof_load))
	  (setq factored_load (* w 1.5))
	  (setq max_bm (/ (* factored_load ef_span ef_span) 8))
	  (setq max_sf (/ (* factored_load lx) 2))
	  (setq	msteel_percentage
		 (* (/ (* 50.00 fck) fy)
		    (- 1
		       (sqrt (-	1.0
				(/ (* 4.6 max_bm (expt 10 6))
				   (* fck 1000.0 eff_d eff_d)
				)
			     )
		       )
		    )
		 )
	  )
	  (setq m_ast (/ (* msteel_percentage 1000.00 eff_d) 100.00))
	  (setq spacing 0)
	  (foreach i (list 8 10 12 16 20 25 32)
	    (setq spacing (fix (qd:rounddown (/ (* (/ (* pi i i) 4) 1000) m_ast) 10)))
	    (princ (strcat "For main bar, a "
			   (itoa i)
			   " mm steel bar given at a spacing of "
			   (itoa spacing)
			   " mm\n"
		   )
	    )
	    )
	    (setq m_ast_dia
		   (getint
		     "Which diameter steel do you want?(8/10/12/16/20/25/32)"
		   )
	    )
	    (setq n_prov
		   (1+ (fix (/ m_ast (/ (* pi m_ast_dia m_ast_dia) 4)))
		   )
	    )
	    (setq m_ast_prov (/ (* n_prov pi m_ast_dia m_ast_dia) 4))
	    (setq d_ast (/ (* 0.12 1000 eff_d) 100))
	    (foreach i (list 8 10 12 16 20 25 32)
	      (setq spacing (fix (qd:rounddown (/ (* (/ (* pi i i) 4) 1000) m_ast) 10)))
	      (princ (strcat "For distribution bar, a "
			     (itoa i)
			     " mm steel bar given at a spacing of "
			     (itoa spacing)
			     " mm\n"
		     )
	      )
	    )
	    (princ "Checking for deflection\n")
	    (setq fs (/ (* 0.58 fy m_ast) m_ast_prov))
	    (setq
	      kt (/ 1
		    (+ 0.225
		       (* 0.00322 fs)
		       (* -0.625
			  (/ (log (/ 1 msteel_percentage)) (log 10))
		       )
		    )
		 )
	    )
	    (setq l_dmax (* 20 kt))
	    (setq l_dprov (/ (* lx 1000) eff_d))
	    (if	(> l_dmax l_dprov)
	      (princ
		(strcat
		  "Slab design is OK. Max deflection is "
		  (itoa (fix l_dmax))
		  " mm while the provided steel leads to a deflection of "
		  (itoa (fix l_dprov))
		  " mm."
		 )
	      )
	      (princ (strcat "Slab design is not OK."))
	    )
	  )
	(progn
	  (if (< (+ lx beam_width) (+ lx (- slab_depth slab_cover)))
	    (setq x_ef_span (+ lx beam_width))
	    (setq x_ef_span (+ lx (- slab_depth slab_cover)))
	  )
	  (if (< (+ ly eff_d) ly)
	    (setq y_ef_span (+ ly eff_d))
	    (setq y_ef_span ly)
	  )
	  (setq w (+ (* (/ slab_depth 1000.00) 25) live_load roof_load))
	  (setq factored_load (* w 1.5))
	  (setq ss_alpha_coeff (qd:ss_alpha_coeff (/ ly lx)))
	  (setq ss_neg_bm (- (* (nth 0 ss_alpha_coeff) factored_load lx lx)))
	  (setq ss_pos_bm (* (nth 1 ss_alpha_coeff) factored_load lx lx))
	  (setq ls_neg_bm (* -0.032 factored_load ly ly))
	  (setq ls_pos_bm (* 0.024 factored_load ly ly))
	  (setq ast_min (* 0.12 1000 eff_d))
	  (setq ss_pos_msteel_percentage (* (/ (* 50 fck) fy)
		    (- 1
		       (sqrt (-	1
				(/ (* 4.6 ss_pos_bm)
				   (* fck 1000 eff_d)
				)
			     )
		       )
		    )
		))
	  (setq ss_pos_m_ast (/ (* ss_pos_msteel_percentage 1000 eff_d 100) 100))
	  (foreach i (list 8 10 12 16 20 25 32)
	    (setq n (1+ (fix (/ ss_pos_m_ast (/ (* pi i i) 4)))))
	    (princ (strcat "For main bar, a "
			   (itoa i)
			   " mm steel bar give "
			   (itoa n)
			   " number of bars\n"
		   )
	    )
	    )
	    (setq ss_pos_m_ast_dia
		   (getint
		     "Which diameter steel do you want?(8/10/12/16/20/25/32)"
		   )
	    )
	    (setq ss_pos_n_prov
		   (1+ (fix (/ m_ast (/ (* pi ss_pos_m_ast_dia ss_pos_m_ast_dia) 4)))
		   )
	    )
	    (setq ss_pos_m_ast_prov (/ (* ss_pos_n_prov pi ss_pos_m_ast_dia ss_pos_m_ast_dia) 4))
	  (setq ss_neg_msteel_percentage (* (/ (* 50 fck) fy)
		    (- 1
		       (sqrt (-	1
				(/ (* 4.6 ss_neg_bm)
				   (* fck 1000 eff_d)
				)
			     )
		       )
		    )
		))
	  (setq ss_neg_m_ast (/ (* ss_neg_msteel_percentage 1000 eff_d 100) 100))
	  (foreach i (list 8 10 12 16 20 25 32)
	    (setq n (1+ (fix (/ ss_neg_m_ast (/ (* pi i i) 4)))))
	    (princ (strcat "For main bar, a "
			   (itoa i)
			   " mm steel bar give "
			   (itoa n)
			   " number of bars\n"
		   )
	    )
	    )
	    (setq ss_neg_m_ast_dia
		   (getint
		     "Which diameter steel do you want?(8/10/12/16/20/25/32)"
		   )
	    )
	    (setq ss_neg_n_prov
		   (1+ (fix (/ ss_neg_m_ast (/ (* pi ss_neg_m_ast_dia ss_neg_m_ast_dia) 4)))
		   )
	    )
	    (setq ss_neg_m_ast_prov (/ (* ss_neg_n_prov pi ss_neg_m_ast_dia ss_neg_m_ast_dia) 4))
	  (setq ls_neg_msteel_percentage (* (/ (* 50 fck) fy)
		    (- 1
		       (sqrt (-	1
				(/ (* 4.6 ls_neg_bm)
				   (* fck 1000 eff_d)
				)
			     )
		       )
		    )
		))
	  (setq ls_neg_m_ast (/ (* ls_neg_msteel_percentage 1000 eff_d 100) 100))
	   (foreach i (list 8 10 12 16 20 25 32)
	    (setq n (1+ (fix (/ ls_neg_m_ast (/ (* pi i i) 4)))))
	    (princ (strcat "For main bar, a "
			   (itoa i)
			   " mm steel bar give "
			   (itoa n)
			   " number of bars\n"
		   )
	    )
	    )
	    (setq ls_neg_m_ast_dia
		   (getint
		     "Which diameter steel do you want?(8/10/12/16/20/25/32)"
		   )
	    )
	    (setq ls_neg_n_prov
		   (1+ (fix (/ ls_neg_m_ast (/ (* pi ls_neg_m_ast_dia ls_neg_m_ast_dia) 4)))
		   )
	    )
	    (setq ls_neg_m_ast_prov (/ (* ls_neg_n_prov pi ls_neg_m_ast_dia ls_neg_m_ast_dia) 4))
	  (setq ls_pos_msteel_percentage (* (/ (* 50 fck) fy)
		    (- 1
		       (sqrt (-	1
				(/ (* 4.6 ls_pos_bm)
				   (* fck 1000 eff_d)
				)
			     )
		       )
		    )
		))
	  (setq ls_pos_m_ast (/ (* ls_pos_msteel_percentage 1000 eff_d 100) 100))
	     (foreach i (list 8 10 12 16 20 25 32)
	    (setq n (1+ (fix (/ ls_pos_m_ast (/ (* pi i i) 4)))))
	    (princ (strcat "For main bar, a "
			   (itoa i)
			   " mm steel bar give "
			   (itoa n)
			   " number of bars\n"
		   )
	    )
	    )
	    (setq ls_pos_m_ast_dia
		   (getint
		     "Which diameter steel do you want?(8/10/12/16/20/25/32)"
		   )
	    )
	    (setq ls_pos_n_prov
		   (1+ (fix (/ ls_pos_m_ast (/ (* pi ls_pos_m_ast_dia ls_pos_m_ast_dia) 4)))
		   )
	    )
	    (setq ls_pos_m_ast_prov (/ (* ls_pos_n_prov pi ls_pos_m_ast_dia ls_pos_m_ast_dia) 4))
	  (princ "Checking the shear")
	  (setq max_shear (/ (* factored_load ly) 2))
	  (setq tau_v (/ (* max_shear 1000) (* 1000 eff_d)))
	  (setq send_to_func (/ (* 100 ls_pos_m_ast) (* 1000 eff_d)))
	  (setq tau_c (qd:tau_c_coeff fck send_to_func))
	  (if (> tau_c tau_v)
	    (princ "Slab design is O.K.")
	    (princ "Slab design is not OK")
	    )	  
	)
      )
      (setq count (1+ count))
      (princ slab_point)
    )
    (setq answ (getstring "Are you done (y/n)?"))
    (if	(or (eq answ "y") (eq answ "Y"))
      (progn
	(setq finish "true")
	(exit)
      )
      (setq finish "false")
    )
  )
  )





(defun qd:ss_alpha_coeff (ratio)
  (setq	ss_alphas '((0.032 0.037 0.043 0.047 0.051 0.053 0.060 0.065)
		 (0.024 0.028 0.032 0.036 0.039 0.041 0.045 0.049)
		)
  )
  (setq coefficient '(1.0 1.1 1.2 1.3 1.4 1.5 1.75 2.0))
  (setq neg_alpha 0)
  (setq pos_alpha 0)
  (setq return_values (list))
  (setq i 0)
  (while (< i 8)
    (if	(and (> ratio (nth i coefficient))
	     (< ratio (nth (1+ i) coefficient))
	)
      (progn
	(setq
	  neg_alpha (/ (+ (nth (1+ i) (nth 0 ss_alphas)) (* (nth i (nth 0 ss_alphas)) (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient)))))
		       (1+ (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient))))))
	(princ (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient))))
	(princ "\n")
	(princ (+ (nth (1+ i) (nth 0 ss_alphas)) (* (nth i (nth 0 ss_alphas)) (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient))))))
	(princ "\n")
	(princ (/ (- (nth (1+ i) coefficient) ratio)
			     (- ratio (nth i coefficient))
			  ))
	(princ "\n")
	(setq
	  pos_alpha (/ (+ (nth (1+ i) (nth 1 ss_alphas)) (* (nth i (nth 1 ss_alphas)) (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient)))))
		       (1+ (/ (- (nth (1+ i) coefficient) ratio) (- ratio (nth i coefficient)))))
	)
	(princ pos_alpha)
	(setq return_values
	       (append retuen_values
		       (list neg_alpha pos_alpha)
	       )
	)
	(princ return_values)
      )
    )
    (setq i (1+ i))
  )
  (princ return_values)
)



(defun qd:ss_selection (ent)
  (setq i 0)
  (repeat (setq i (length ent))
    (if	(= (car (nth i ent)) 0)
      (setq enttype (cdr (nth i ent)))
    )
    (if	(= (car (nth i ent)) 8)
      (setq layername (cdr (nth i ent)))
    )
    (if	(= (car (nth i ent)) 62)
      (setq layercolor (cdr (nth i ent)))
    )
    (if	(= (car (nth i ent)) 370)
      (setq lineweight (cdr (nth i ent)))
    )
    (setq i (1- i))
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
(defun qd:tau_c_coeff (conc_grade send_to_func)
  (setq	tau_c_coeff '((0.28 0.35 0.46 0.54 0.60 0.64 0.71 0.71 0.71 0.71 0.71 0.71)
		 (0.28 0.36 0.48 0.56 0.62 0.67 0.72 0.75 0.79 0.81 0.82 0.82 0.82)
		      (0.29 0.36 0.49 0.57 0.64 0.70 0.74 0.78 0.82 0.85 0.88 0.90 0.92)
		      (0.29 0.37 0.50 0.59 0.66 0.71 0.76 0.80 0.84 0.88 0.91 0.94 0.96)
		      (0.29 0.37 0.50 0.59 0.67 0.73 0.78 0.82 0.86 0.90 0.93 0.96 0.99)
		      (0.30 0.38 0.51 0.60 0.68 0.74 0.79 0.84 0.88 0.92 0.95 0.98 1.01)
		)
  )
  (setq concrete_grade '(15 20 25 30 35 40))
  (setq left_side_values '(0.0 0.15 0.25 0.5 0.75 1.0 1.25 1.5 1.75 2.0 2.25 2.5 2.75 3.0))
  (setq return_values 0.0)
  (setq i 0)
  (setq j 0)
    (foreach e concrete_grade
	(if (eq conc_grade (nth j concrete_grade))
	  (progn
	    (princ "We are in conc grade")
	    (princ "\n")
	  (while (< i 14)
	  (progn
	  (if (and (> send_to_func (nth i left_side_values))
	     (< send_to_func (nth (1+ i) left_side_values))
	)
      (progn
	(setq
	  return_values (/ (+ (nth (1+ i) (nth j tau_c_coeff)) (* (nth i (nth j tau_c_coeff)) (/ (- (nth (1+ i) left_side_values) send_to_func) (- send_to_func (nth i left_side_values)))))
		       (1+ (/ (- (nth (1+ i) left_side_values) send_to_func) (- send_to_func (nth i left_side_values))))))
	(princ return_values)
	(princ "\n")
      )
    )
    (setq i (1+ i))
  )
	    )
	  )
	  )
      (setq j (1+ j))
      (princ j)
      )
  (princ return_values)
)
(defun qd:rounddown ( n m )
      ((lambda ( r )
	 (cond ((equal 0.0 r 1e-8) n)
	       ((< n 0) (- n r m))
	       ((- n r))
	 )
       )
	(rem n m)
      )
    )

(defun C:samp1 ()
  (setq mix "M20")
  (setq names '("M6" "M8" "M10" "M12" "M15" "M16" "M20" "M24" "M25" "M30"))
  
  (setq dcl_id (load_dialog "E:\\purvaja\\WDBM\\LISP\\QWIKDRAFT\\AUTOLISP\\Website\\Drafting\\Drawings - code\\samp1.DCL"))
		 
  (if (not (new_dialog "samp1" dcl_id)			;test for dialog
 
      );not
 
    (exit)						;exit if no dialog
 
  );if
  (setq w1 (dimx_tile "im")
	h1 (dimx_tile "im")
	)
 
     (action_tile
    "cancel"						;if cancel button pressed
    "(done_dialog) (setq userclick nil)"		;close dialog, set flag
    );action_tile
 
  (action_tile
    "accept"						;if O.K. pressed
    " (done_dialog)(setq userclick T))"			;close dialog, set flag
  );action tile
 
  (start_dialog)					;start dialog
 
  (unload_dialog dcl_id)				;unload
 
(princ)
 
);defun C:samp
 
(princ)
