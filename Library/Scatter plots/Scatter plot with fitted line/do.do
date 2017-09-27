
	* Load data
	* ---------
	use "$VisLib\Scatter plots\Scatter plot with fitted line\data.dta", clear
	
	* Plot
	* ----
	twoway 	(scatter revenue area_cult if post == 0, msize(vsmall) mcolor(gs14)) ///
			(lfit revenue area_cult if post == 0, color(gs12)) ///
			(scatter revenue area_cult if post == 1, msize(vsmall) mcolor(stone)) ///
			(lfit revenue area_cult if post == 1, color(sand)), ///
			ytitle(Agriculture revenue (BRL thousands)) ///
			xtitle(Cultivated area) ///
			legend(order(2 "Pre-treatment" 4 "Post-treatment")) ///
			bgcolor (white) graphregion(color(white))
			
	* Export image
	* ------------
	gr export "$VisLib\Scatter plots\Scatter plot with fitted line\plot.png", width(5000) replace

			
			