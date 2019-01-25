* Figure: Quantile treatment effect by gender
	
	use "analysis_studentlevel.dta", clear
			
	keep if grade == 6 & pool_6EF == 1
	keep inep prof_media school_treated student_matricula  student_gender  polo
		
	rename inep school_id
	rename student_matricula student_id
	rename prof_media student_average_std
	rename polo school_strata
	
	lab var school_id "School ID"
	lab var student_id "Student ID"
	lab var student_average_std "Student average test score - z-score"
	lab var school_treated "Treatment"
	lab var school_strata  "Strata"
	
	sort  school_id student_id student_average
	order school_id student_id student_average_std student_gender school_treated school_strata
		
	drop if mi(student_gender) | mi(student_average_std)
	lab data "Student Standardized Test Scores"
	
	
	* PREPARE DATA
	* ------------
	
	* Install additional packages required to run the code
	ssc   install qreg2	   , replace
	ssc   install coefplot , replace
	
	* Load data
	cd    "C:\Users\WB527265\Documents\GitHub\Stata-IE-Visual-Library\Library\Regression coefficients\Quantile treatment effect"	
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
				
				local modelsList `"`modelsList' (est_q`integerQuantile'_`genderLab', ciopts(recast(rcap) lcolor(`lineColor')) mcolor(`lineColor') ) "'
		}
			
		local quantileCount  =  0.1 + 		    `quantileCount'
		local quantileLabels `"`quantileLabels' `quantileCount' "Q{sub:`integerQuantile'}""'
		
	}
	
	* PLOT GRAPH
	* ----------
	
	#d	;
	
		coefplot `modelsList',			
			vertical keep(*school_treated*) bycoefs
			mlabel mlabcolor(black) format(%9.2g) msymbol(diamond)
			levels(`statSignLevel')
			xlab(none) xlabel(`quantileLabels', add)
			legend(order(2 4) lab(2 "Female") lab(4 "Male"))
			   title("Quantile treatment effect")
			subtitle("By student gender")
			ytitle("Standard deviations")
			yline(0, lstyle(foreground))
			note("{bf:Note:} Estimates of quantile regression with strata fixed effects and standard errors clustered"
				 "at the school level. Confidence intervals are `statSignLevel'%.")
			graphregion(color(white))
		;
		
	#d	cr
	
	* Store graph in PNG format
	gr export "figures.png", width(5000) replace

* End of the do-file
