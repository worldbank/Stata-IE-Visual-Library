* Figure: Horizontal bar with multiple variables

	global graph_opts title(, justification(left) color(black) span pos(11)) graphregion(color(white)) ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))
	global pct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'

	cd "{directory}"

	qui do "betterbar.ado"	

	use "data.dta" , clear
		
	label var as_correct "Asthma: Inhaler/Bronchodilator"
	label var ch_correct "Child Diarrhoea: ORS"
	label var cp_correct "Chest Pain: Referral/Aspirin/ECG"
	label var tb_correct "Tuberculosis: AFB Smear"

	 recode facility_type (3/5 = 3)
	 
	 label def facility_type 1 "Public" 2 "Private For-Profit" 3 "Private FBO/SFO", modify
		label val facility_type facility_type
	 
	 betterbar ///
		??_correct  checklist  refer med_any  med_class_any_6 med_class_any_16 ///
		, $graph_opts over(facility_type) xlab(${pct}) barlab(mean) legend(r(1) symxsize(small) symysize(small))
		
		graph export "figure.png" , replace width(2000)
		
* Have a lovely day!
