* Figure: Bar plot with grouping of variables, standard error bars, and cross-group comparisons

	cd "{directory}"
	qui do "betterbar.ado"

	use "sp_comparison.dta", clear
		
	recode study_code (2 = 1 "Kenya") (3/4 = 2 "India") (5 = 3 "China") (* = .), gen(studytemp)
	
	drop if studytemp == .
	
	recode study_code (2 = 1 "Nairobi, Kenya") (5 = 2 "Rural China") (3 = 3 "Rural India") (4 = 4 "Urban India") , gen(studygraph)
	
	label var refer "Referred"
	label var correct "Correct"
	
	label def check 1 "Asthma" 2 "Chest Pain" 3 "Diarrhoea" 4 "Tuberculosis"
		label val case_code check
	
	betterbar ///
		correct refer ch_child med_class_any_6 ///
		, over(studygraph) by(case_code) ///
			nobycolor se dropzero xlab(${pct}) ///
			legend(symxsize(small) symysize(small) pos(6) ring(1) r(2) ) ///
			barlook(1 lc(white) lw(thin) fi(100)) ysize(6)
			
		graph export "Figure_2.png" , replace width(2000)
				
* Have a lovely day!
