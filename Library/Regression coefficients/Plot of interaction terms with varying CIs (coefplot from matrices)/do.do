/*******************************************************************************
This dofile demonstrates how to plot interaction terms, including some base 
coefficients, with varying levels of confidence intervals from matrices, 
using Ben Jann's coefplot. 

For more infomation about his command, please visit his webpage below.
http://repec.sowi.unibe.ch/stata/coefplot/getting-started.html

While the below page shows how to add multiple CIs to a coefficient plot with 
color gradation, it is a bit cumbersome to do this when plotting from a matrix.
http://repec.sowi.unibe.ch/stata/coefplot/confidence-intervals.html#h-2
********************************************************************************/


	clear all
	set maxvar 32767
	set more off
	
	ssc install coefplot, replace

	cd // "{directory}"
			
	use data.dta, clear
	
	tempname reg_result ci_table
	cap matrix drop T C
					
	* Run the regression and store the results in each matrix for T and C
	reg w95_total_val_harvested ///
		treatment_hh#gender_hhh#year treatment_hh##year
	
	matrix `reg_result' = r(table)
	matrix list `reg_result'
	
	foreach group in T C {
		
		if "`group'" == "T" local col_range = "16..20"
		else local col_range = "6..10"
		
		matrix `group' = `reg_result'[1, `col_range'] \ `reg_result'[5, `col_range'] \ `reg_result'[6, `col_range']
		matrix `group' = `group''
		matrix rownames `group' = 2012 2013 2014 2016 2017		
		matrix colnames `group' = B l_95 u_95
		}

		
	* Get 99 and 90 CIs and add to the Treatment and Control matrices
	foreach level in 99 90 {
	
		reg, level(`level')
		matrix `ci_table' = r(table)		
		
		foreach group in t c {
			
			if "`group'" == "t" local col_range = "16..20"
			else local col_range = "6..10"
			
			matrix `group'_ci`level' = `ci_table'[5, `col_range'] \ `ci_table'[6, `col_range']
			matrix `group'_ci`level' = `group'_ci`level''
			matrix rownames `group'_ci`level' = 2012 2013 2014 2016 2017		
			matrix colnames `group'_ci`level' = l_`level' u_`level'						
			}
		}

	matrix T = T, t_ci99, t_ci90
	matrix C = C, c_ci99, c_ci90
	
	* Sanity check
	matrix list T
	matrix list C
	
	***** Graph point estimates and CIs by group		
	coefplot (matrix(T[,1]), ///
				ci( (T[,4] T[,5]) (T[,2] T[,3]) (T[,6] T[,7])  ) ///     
				mcolor(white) msize(medlarge) ///
				mlcolor(gs4) mlwidth(vthin) ///
				ciopts( lcolor(gs4*0.33 gs4*0.66 gs4) lwidth(3 ..) ) ) ///
			 (matrix(C[,1]), ///
				ci( (C[,4] C[,5]) (C[,2] C[,3]) (C[,6] C[,7]) ) /// // order of 99 95 90
				msymbol(T) mcolor(white) msize(medlarge) ///
				mlcolor(gs13) mlwidth(vthin) ///
				ciopts( lcolor(gs13*0.33 gs13*0.66 gs13) lwidth(3 ..) ) ), ///
		vertical yline(0) grid(none) ///
		title("Total Harvest Values") ///
		subtitle("Season A") ///
		ytitle("RWF") ///
		ylabel(, angle(horizontal)) ///
		graphregion(color(white)) ///
		legend(order(4 "Treatment group gender gap" ///
					 8 "Control group gender gap") ///
			   rows(1) cols(4))	///
		note("The color shades indicate 99%, 95% and 90% confidence intervals, respectively.")
	graph export graph.png, replace
		
