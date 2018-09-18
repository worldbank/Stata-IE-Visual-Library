* Figure: Stack bar graph by two variables (Drug use by referral decisions for two standardised patient cases)

* Replication file for:
* Satyanarayana S, Kwan A, Daniels B, Subbaraman R, McDowell A, Bergkvist S, Das RK, Das V, Das J, Pai M. 
* Use of standardised patients to assess antibiotic dispensing for tuberculosis by pharmacies in urban India: 
* A cross-sectional study. 
* The Lancet Infectious Diseases. 2016 Nov 30;16(11):1261-8.

	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ylab(,angle(0) nogrid) subtitle(, justification(left) color(black) span pos(11)) title(, color(black) span)
	global pct `" 0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%" "'


	version 13
	cd "{directory}"

	qui do "tabgen.ado"
	
	use "data.dta", clear
	
	gen n = 1 
	
	replace med_b2_antister_cat = 5 if med == 0
	
	egen checkgroup = group(case dr_3), label
		label def checkgroup 1 `""Case 1" "(503/599)""' 2 `""Case 1" "(96/599)""' ///
			3 `""Case 2" "(200/601)""' 4 `""Case 2" "(401/601)""' , modify
	
	tabgen med_b2_antister_cat
	
	graph bar med_b2_antister_cat?? ///
		if dr_3 == 1 ///
		, stack over(checkgroup) nofill ///
		ylab($pct) legend(order(5 "No Medication" 4 "Antibiotic and Steroid" 3 "Antibiotic" 2 "Steroid" 1 "No Antibiotic or Steroid") ///
			c(1) symxsize(small) symysize(small) pos(3) size(small)) ///
		$graph_opts1 bar(5, color(white) lc(black) lp(solid) lw(thin)) ///
		bar(1,lw(thin) lc(black)) bar(2,lw(thin) lc(black)) bar(3,lw(thin) lc(black)) bar(4,lw(thin) lc(black)) ///
		subtitle("Referral" ,color(black) justification(center) pos(12)) 
		
		graph save "figure_1.gph" , replace
		
	graph bar med_b2_antister_cat?? ///
		if dr_3 == 0 ///
		, stack over(checkgroup) nofill ///
		ylab($pct) legend(order(5 "No Medication" 4 "Antibiotic and Steroid" 3 "Antibiotic" 2 "Steroid" 1 "No Antibiotic or Steroid") ///
			c(1) symxsize(small) symysize(small) pos(3) size(small)) ///
		$graph_opts1 bar(5, color(white) lc(black) lp(solid) lw(thin)) ///
		bar(1,lw(thin) lc(black)) bar(2,lw(thin) lc(black)) bar(3,lw(thin) lc(black)) bar(4,lw(thin) lc(black)) ///
		subtitle("No Referral" ,color(black) justification(center) pos(12)) 
		
		graph save "figure_2.gph" , replace
		
	grc1leg ///
		"figure_2.gph" ///
		"figure_1.gph" ///
		, pos(3) graphregion(color(white)) xsize(7) rows(1) leg("figure_2.gph")
		
	graph export "figure.png" , replace
		


* Have a lovely day!
