* Figure: Quantile treatment effect by gender
	
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
	local quantileCount    = 0.5	//manually adapt position in the graph
	
	* Loop on quantiles
	forv  quantile   	   = `quantileInterval'(`quantileInterval')`=1-`quantileInterval'' {
			
		local 	  roundQuantile =  round(real(string(`quantile'*100, "%4.0f")),10)/100
		local 	integerQuantile = `roundQuantile'*100
				
		* Loop on gender dummy
		forv 	genderDummy     = 0/1 {
				
			* Set color and estimate suffix depending on gender	
			if `genderDummy'   == 0	  {
				local genderLab  "F"
				local lineColor  "132 4 252" //purple
			}
			if `genderDummy'   == 1   {
				local genderLab  "M"
				local lineColor  "4 196 172" //green
			}
				
			eststo est_q`integerQuantile'_`genderLab':						///
			   qui qreg2 student_average_std school_treated school_strata*	///
				if student_gender == `genderDummy'							///
				 , q(`roundQuantile') cl(school_id)
				
				local modelsList `"`modelsList' (est_q`integerQuantile'_`genderLab', ciopts(recast(rcap) lcolor("`lineColor'")) mcolor("`lineColor'") ) "'
		}
			
		local quantileCount  =  0.1 + 		    `quantileCount'
		local quantileLabels `"`quantileLabels' `quantileCount' "Q{sub:`integerQuantile'}""'
		
	}
	
	* PLOT GRAPH
	* ----------
	
	#d	;
	
		coefplot `modelsList',
		
			keep(*school_treated*)
			vertical bycoefs
			mlab mlabcolor(black) format(%9.2g) msymbol(diamond)
			levels(`statSignLevel')
			
			
			
			   title("Quantile Treatment Effect")
			subtitle("Average Test Score")
			  ytitle("Standard deviations")
			  yline(0, lstyle(foreground))
			  xlab(none) xlabel(`quantileLabels', add)
			
			legend(order(2 4) lab(2 "Female") lab(4 "Male"))
			note("{bf:Note:} Estimates of quantile regressions with strata fixed effects and standard errors clustered"
				 "at the school level. Confidence intervals are `statSignLevel'%.")
			graphregion(color(white))
		;
		
	#d	cr
	
	* Store graph in PNG format
	gr export "figures.png", width(5000) replace

* End of the do-file
