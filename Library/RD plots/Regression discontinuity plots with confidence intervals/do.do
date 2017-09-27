	
	* Load data
	* ---------
	use "$VisLib\RD plots\Regression discontinuity plots with confidence intervals\data.dta", clear
	
	* Calculate cutoff
	* ----------------
	sum 	cutoff
	local 	cutoff = r(mean)
	
	
	* Plot
	* ----
	twoway  (lpolyci tmt_status pmt_score if pmt_score < `cutoff', clcolor(navy) acolor(gs14)) || ///
			(lpolyci tmt_status pmt_score if pmt_score > `cutoff', clcolor(navy) acolor(gs14)), ///
			xline(`cutoff', lcolor(red) lwidth(vthin) lpattern(dash)) ///
			ytitle(Probability of receiving treatment) ///
			xtitle(Proxy means test score) ///
			legend(off) ///
			bgcolor (white) graphregion(color(white))  ///
			note("Note: gray area is 95% confidence interval.")
			
	* Export image
	* ------------
	gr export "$VisLib\RD plots\Regression discontinuity plots with confidence intervals\plot.png", width(5000) replace
