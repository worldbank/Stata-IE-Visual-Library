* Figure: Treatment effect on multiple variables by gender

	* PREPARE DATA
	* ------------
	
	* Install additional packages required to run the code
	ssc   install reghdfe  , replace
	ssc   install ftools   , replace //needed for reghdfe to work
	ssc   install coefplot , replace
	
	* Load data
	cd	  "{directory}"
	use	  "data.dta"	   , clear
	
	* ESTIMATE COEFFICIENTS
	* ---------------------
	
	local modelList 	  	 ""
	local statSignLevel	   = 90
	
	* Clear estimates
	est   clear
	
	* Loop on different subjects
	foreach subject in math reading human_sci natural_sci average			{
	
		eststo `subject'_F :  qui reghdfe student_`subject'_std school_treated 	///
						   if student_gender == 0				  				///
						   ,  abs(school_strata) cl(school_id)
		
		local 	modelsList `" `modelsList' ( `subject'_F, ciopts(recast(rcap) lcolor("132 4 252")) mcolor("132 4 252") msymbol(circle)  )    "'
		
		eststo `subject'_M :  qui reghdfe student_`subject'_std school_treated 	///
						   if student_gender == 1				  				///
						   ,  abs(school_strata) cl(school_id)
			
		local 	modelsList `" `modelsList' ( `subject'_M, ciopts(recast(rcap) lcolor("4 196 172")) mcolor("4 196 172") msymbol(diamond) ) || "'
	}
	
	* PLOT GRAPH
	* ----------
	
	#d	;
	
		coefplot `modelsList',
			
			keep(*school_treated*)
			vertical bycoefs byopts(yrescale)
			mlab mlabcolor(black) format(%9.2g)
			mlabposition(3) mlabgap(1)
			levels(`statSignLevel') 
										
			   title("Treatment Effect")				
			subtitle("Test Scores")
			ytitle("Standard deviations")
			yline(0, lstyle(foreground))
			yscale(range(-0.2 0.4)) ylabel(-0.1(0.1)0.4)			
			xlabel(1 "Math" 2 "Reading" 3 "Human Science" 4 "Natural Science" 5 "Average", alt)
			
			legend(order(2 4) lab(2 "Female") lab(4 "Male"))
			note("{bf:Note:} Points estimates with `statSignLevel'% confidence interval from regressions with strata fixed effects"
				 "and standard errors clustered at the school level.")
			graphregion(color(white))
		;	
		
	#d	cr
	
	* Store graph in PNG format
	gr  export "figure.png", width(5000) as(png) replace 
	
* End of the do-file
