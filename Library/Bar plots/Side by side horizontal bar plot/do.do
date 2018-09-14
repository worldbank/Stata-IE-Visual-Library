* Figure: Side by side horizontal bar plot (Active ingredients in drugs given for each case)

* Replication file for:
* Satyanarayana S, Kwan A, Daniels B, Subbaraman R, McDowell A, Bergkvist S, Das RK, Das V, Das J, Pai M. 
* Use of standardised patients to assess antibiotic dispensing for tuberculosis by pharmacies in urban India: 
* A cross-sectional study. 
* The Lancet Infectious Diseases. 2016 Nov 30;16(11):1261-8.

	version 13
	cd "{directory}"
		
	qui do "betterbar.ado"
	qui do "labelcollapse.ado"

	global graph_opts note(, justification(left) color(black) span pos(7)) title(, justification(left) color(black) span pos(11)) subtitle(, justification(left) color(black) span pos(11)) graphregion(color(white)) ylab(,angle(0) nogrid) ytit("") xtit(,placement(left) justification(left)) yscale(noline) xscale(noline) xsize(7) legend(region(lc(none) fc(none)))
	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ylab(,angle(0) nogrid) subtitle(, justification(left) color(black) span pos(11)) title(, color(black) span)
	global hist_opts ylab(, angle(0) axis(2)) yscale(off alt axis(2)) ytit(, axis(2)) ytit(, axis(1))  yscale(alt)
	global pct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'
	global numbering `""(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)""'
	


	local n_5 = 599
	local n_6 = 601
	
	local title_5 = "Classic case of presumed TB"
	local title_6 = "TB case with positive sputum report"

	qui forvalues i = 5/6 {
	
		local case = `i' - 4

		use "data.dta" , clear
			
			gen n = 1
			bys med_generic: egen med_class_typ = mode(med_class), minmode // Label with most typical medicine code
				label val med_class_typ med_k
				
			keep if case == `i'
			
			labelcollapse (firstnm) n med_class_typ med_generic_encoded sp_location, by(med_generic facilitycode) vallab(med_class_typ med_generic_encoded sp_location)
			
			labelcollapse (sum) n (firstnm) med_generic_encoded med_class_typ, by(med_generic) vallab(med_class_typ med_generic_encoded) 
			
			cap separate n, by(med_generic_encoded) shortlabel
				foreach var of varlist n?* {
					local theLabel : var label `var'
					local theLabel = regexr("`theLabel'","med_generic_encoded == ","")
					
					cap su n if med_generic == "`theLabel'"
						cap local theN = `r(mean)'
					
					label var `var' "`theLabel' [`theN']"
					}
					
				foreach var of varlist n?* {
					replace `var' = . if `var' < 5 // Exclude low volumes
					replace `var' = `var'/`n_`i'' // Number of interactions
					qui sum `var'
						if `r(N)' == 0 drop `var' 
					}
				
			drop if med_generic == "Sodium Chloride" // not an active ingredient
			
			betterbar (n?*) , stat(sum) over(med_class_typ) by(med_class_typ) nobylabel nobycolor d(1)  ///
				legend(span c(1) pos(3) ring(1) symxsize(small) symysize(small) size(small))  ///
				dropzero ///
				xlab(0 "0%" .2 "20%" .4 "40%" .6 "60%") ysize(6) labsize(2) $graph_opts title("Case `case' (N=`n_`i'')") subtitle("`title_`i''")
			
			* graph export "generics_sp`i'.png", replace width(4000)
				graph save "figure_4_`case'.gph" , replace
			
		}
		
		grc1leg ///
			"figure_4_1.gph" ///
			"figure_4_2.gph" ///
			, pos(3) graphregion(color(white)) xsize(7) 
			
			graph export "figure.png", replace width(2000)

* Have a lovely day!
