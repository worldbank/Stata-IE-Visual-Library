* Figure: Quantile treatment effect
	
	* PREPARE DATA
	* ------------
	
	* Install additional packages required to run the code
	ssc   install qreg2	   , replace
	ssc   install coefplot , replace
	
	* Load data
	cd	  "{directory}"	
	use	  "data.dta"	   , clear
	
	* Generate dummies for strata (factor variables do not work in 'qreg2')
	tab   school_strata    , gen(school_strata_)
	
	* ESTIMATE COEFFICIENTS
	* ---------------------
	
	* Define regression options
	local quantileInterval = 0.1
	local statSignLevel    = 90
	
	* Initiate locals (to be filled in the next loop)
	local quantileLabels   = ""		//x-axis label
	local modelsList 	   = ""		//estimates name
	local quantileCount    = 1		//count of quantile regression
	
	* Loop on quantiles
	forv  quantile 		   = `quantileInterval'(`quantileInterval')`=1-`quantileInterval'' {
			
		local    roundQuantile =  round(real(string(`quantile'*100, "%4.0f")),10)/100 //this is needed, otherwise Stata gives issue with the last numbers of the sequence and with rounding
		local  integerQuantile = `roundQuantile'*100
			
		* Store estimates from quantile regression with fixed effects and clustered standard errors
		eststo est_q`integerQuantile': 									///
		   qui qreg2 student_average_std school_treated school_strata_*	///
			 , q(`roundQuantile') cl(school_id)
			
		* Add these estimate to locals
		local  quantileLabels `"`quantileLabels' `quantileCount++' "Q{sub:`integerQuantile'} "	"'
		local  modelsList 	  `"`modelsList' 						  est_q`integerQuantile' || "'
	}
		
	* PLOT GRAPH
	* ----------
	
	#d	;
		
		coefplot `modelsList',					
			
			keep(*school_treated*)
			vertical bycoefs
			mlab format(%9.2g) msymbol(diamond) mcolor(ebblue)
			levels(`statSignLevel')
			ciopts(recast(rcap) lcolor(ebblue))
					
			   title("Quantile Treatment Effect")
			subtitle("Average Test Score")
			  ytitle("Standard deviations")
			  yline(0, lstyle(foreground))
			  xlab(none) xlab(`quantileLabels', add)
			
			note("{bf:Note:} Estimates of quantile regressions with strata fixed effects and standard errors clustered"
				 "at the school level. Confidence intervals are `statSignLevel'%.")
			legend(off) graphregion(color(white))
		;
		
	#d	cr
		
	* Store graph in PNG format
	gr export "figure.png", width(5000) replace

* End of the do-file
