* Figure: Density plots with averages

	* Load data
	* ---------
	cd "{directory}"
	use "data.dta", clear
	
	* Calculate means
	* ---------------
	sum 	revenue if post == 0
	local 	pre_mean = r(mean)
	sum		revenue if post == 1
	local 	post_mean = r(mean)
	
	* Plot
	* ----
	twoway 	(kdensity revenue if post == 0, color(gs10)) ///
			(kdensity revenue if post == 1, color(emerald)), ///
			xline(`pre_mean', lcolor(gs12) lpattern(dash)) ///
			xline(`post_mean', lcolor(eltgreen) lpattern(dash)) ///
			legend(order(1 "Pre-treatment" 2 "Post-treatment")) ///
			xtitle(Agriculture revenue (BRL thousands)) ///
			ytitle(Density) ///
			bgcolor (white) graphregion(color(white))
			
	* Export image
	* ------------
	gr export "figure.png", width(5000) replace

* Have a lovely day!
