* Figure: Horizontal bar plot with grouping of variables, standard error bars, and cross-group comparisons

* Replication file for:
* Satyanarayana S, Kwan A, Daniels B, Subbaraman R, McDowell A, Bergkvist S, Das RK, Das V, Das J, Pai M. 
* Use of standardised patients to assess antibiotic dispensing for tuberculosis by pharmacies in urban India: 
* A cross-sectional study. 
* The Lancet Infectious Diseases. 2016 Nov 30;16(11):1261-8.
	

	global graph_opts note(, justification(left) color(black) span pos(7)) title(, justification(left) color(black) span pos(11)) subtitle(, justification(left) color(black) span pos(11)) graphregion(color(white)) ylab(,angle(0) nogrid) ytit("") xtit(,placement(left) justification(left)) yscale(noline) xscale(noline) xsize(7) legend(region(lc(none) fc(none)))
	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ylab(,angle(0) nogrid) subtitle(, justification(left) color(black) span pos(11)) title(, color(black) span)
	global hist_opts ylab(, angle(0) axis(2)) yscale(off alt axis(2)) ytit(, axis(2)) ytit(, axis(1))  yscale(alt)
	global pct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'
	global numbering `""(1)" "(2)" "(3)" "(4)" "(5)" "(6)" "(7)" "(8)" "(9)" "(10)""'

	version 13
	
	cd "{directory}"
		
	qui do "betterbar.ado"

	use "data.dta", clear
	
	replace cp_1 = proper(cp_1)
	encode cp_1, gen(city)

	betterbar ///
		(dr_3 correct_treatment)  ///
		(med_b2_any_antibiotic med_b2_any_steroid med_b2_any_antister med_l_any_2 med_b2_any_schedule_h med_b2_any_schedule_h1 med_b2_any_schedule_x med_l_any_1)   ///
		, over(city) xlab($pct) se bin legend(pos(5) ring(0) c(1) symxsize(small) symysize(small) ) ysize(7) n barlab(upper)
		
		graph export "figure.png" , replace
		
* Have a lovely day!
