* Figures: bar plot of two variables

	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ///
		ylab(,angle(0) nogrid) title(, justification(left) color(black) span pos(11)) subtitle(, justification(left) color(black))

		cd "{directory}"
		use "data.dta" , clear

		drop if type == "Baseline Vignette"
		keep if ///
			(	  regexm(study,"China") ///
				| regexm(study,"Delhi") ///
			) ///
			& ///
			(	  regexm(case,"Diarrhea") | regexm(case,"TB1") )

		egen id = group(facilitycode case)
		xtset id type_code
			gen check = l.treat_correct
			gen check2 = f.treat_correct
			drop if check == . & check2 == .

		replace type = "Vignette" if regexm(type,"Vignette")
		replace type = "Standardized Patient" if !regexm(type,"Vignette")
		replace study = "Birbhum" if  regexm(study,"Birbhum")
		replace case = "Diarrhea (ORS)" if regexm(case,"Diarrhea")
		replace case = "Tuberculosis (AFB or CXR)" if regexm(case,"TB1")
		replace study = `""Madhya" "Pradesh""' if regexm(study,"Madhya Pradesh")

		drop if child == 1

		keep study case type treat_correct

		collapse (mean) treat_correct , by(study case type)

		set obs 10 // Bihar paper: https://jamanetwork.com/journals/jamapediatrics/fullarticle/2118580
			replace study = "Bihar" in 9
			replace study = "Bihar" in 10
			replace case = "Diarrhea (ORS)" in 9
			replace case = "Diarrhea (ORS)" in 10
			replace type = "Vignette" in 9
			replace type = "Standardized Patient" in 10
			replace treat_correct = 1 - 0.209 - 0.006 in 9
			replace treat_correct = 1 - 0.719 - 0.073 in 10

		graph bar treat_correct ///
			, over(type) asy bargap(20) over(study) over(case) nofill ///
			blabel(bar, format(%9.2f)) ///
			$graph_opts1 bar(1 , lc(black) lw(thin) fi(100)) bar(2 , lc(black) lw(thin) fi(100)) ///
			legend(r(1) order(0 "Measurement:" 1 "Standardized Patient" 2 "Clinical Vignette")) ///
			ytit("Providers ordering correct treatment {&rarr}", placement(bottom) justification(left)) ylab($pct)

			graph export "figure.png" , replace width(1000)

* Have a lovely day!
