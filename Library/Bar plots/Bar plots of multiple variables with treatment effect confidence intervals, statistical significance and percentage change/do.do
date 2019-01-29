* Figure: Bar plots of multiple variables with treatment effect confidence intervals, statistical significance and percentage change
	
	* INTRO
	* -----
	
	* Install additional packages required to run the code
	ssc 	install reghdfe , replace
	ssc 	install ftools  , replace // needed for reghdfe to work
	
	* Load data
	cd	    "{directory}"
	use	    "data.dta"    	, clear
	
	* Drop all existing matrices (otherwise, 'nullmat' will not work)
	cap mat drop _all
	
	
	* STORE RESULTS
	* -------------
	
	* Store control means
	foreach 	subject in math reading human_sci natural_sci average	{
	
		qui sum student_`subject' if school_treated == 0
		scalar     mean_`subject' = r(mean)
		mat        mean_control	  = nullmat(mean_control) \ mean_`subject'  
	}
	
	* Estimate treatment effect
	foreach 	subject in math reading human_sci natural_sci average	{
		
		qui reghdfe student_`subject' school_treated					, ///
			abs(school_strata) cl(school_id)
			
			* Store regression table
			mat results 	= r(table)
			
			* Store treatment effect coefficient and standard error
			mat beta    	= nullmat(beta)    \  _b[school_treated] 
			mat beta_se 	= nullmat(beta_se) \ _se[school_treated]
			
			* Retrieve p-values from regression table and store them
			mat pvalue_aux	= results[4,1]
			mat pvalue		= nullmat(pvalue)  \ pvalue_aux		
	}
	
	
	* PREPARE STATS
	* -------------
	
	* Remove data from memory
	clear
	
	* Set outcome variables
	set 	obs 						   5

	gen 	dep_var = ""
	replace dep_var = "Math" 			in 1
	replace dep_var = "Reading" 		in 2 
	replace dep_var = "Human Science" 	in 3
	replace dep_var = "Natural Science" in 4
	replace dep_var = "Average" 		in 5
	 
	* Import results from matrices
	svmat 	beta
	svmat	beta_se
	svmat	pvalue
	svmat	mean_control
	
	* Rename all new variables
	rename *1 *
	
	* Expand data to allow for control and treatment arms
	expand  2 , gen(treatment)
	
	* Define outcome variable
	gen 	y 				= mean_control 								   if !treatment
	replace y 				= mean_control + beta 						   if  treatment

	* Generate high and low points for standard error bars
	gen   	hiy 			= y + 1.65 * beta_se  						   if  treatment
	gen  	lowy 			= y - 1.65 * beta_se  						   if  treatment
	
	* Transform coefficient in string with two decimals + add stars
	gen 	coefficient_str = ""
	replace coefficient_str = string(round(beta,.01), "%9.2f") + "*"   	   if  pvalue>0.05 & pvalue<=0.10
	replace	coefficient_str = string(round(beta,.01), "%9.2f") + "**"  	   if  pvalue>0.01 & pvalue<=0.05
	replace	coefficient_str = string(round(beta,.01), "%9.2f") + "***" 	   if 			     pvalue<=0.01
	
	* Calculate percentage change and save it in string variable
	gen		pct_change		= beta / mean_control * 100				   	   if 				 pvalue<=0.10
	gen	    pct_change_str  = string(round(pct_change,.01), "%9.2f") + "%" if 				 pvalue<=0.10
	
	* Concatenate coefficient and percentange change (only when there is a significant effect)
	gen		effect_lab		= coefficient_str + ": +" + pct_change_str	   if  pct_change>0 & !mi(pct_change)
	replace	effect_lab		= coefficient_str + ": -" + pct_change_str	   if  pct_change<0 & !mi(pct_change)
	
	* Specify bars and label positioning
	gen 	bar_position 	= treatment    + 0.5  						   if  dep_var == "Math"
	replace bar_position 	= treatment	   + 4.5  						   if  dep_var == "Reading"
	replace bar_position 	= treatment	   + 8.5  						   if  dep_var == "Human Science"
	replace bar_position 	= treatment	   + 12.5 						   if  dep_var == "Natural Science"
	replace bar_position 	= treatment	   + 16.5 						   if  dep_var == "Average"
		
	gen		effect_position = bar_position + 0.5 						   if  treatment
	

	* PLOT GRAPH
	* ----------
	
	#d	;
	
		gr tw ( bar y bar_position if !treatment , color(edkblue)   lcolor(black*0.85) )	
			  ( bar y bar_position if  treatment , color(eltblue)   lcolor(black*0.85) )
			  
			  ( rcap hiy lowy bar_position	  	 , msize(.75)	    lcolor(black*0.85) )
			  
			  ( scatter y effect_position		 , msize(zero)
												   mlab(effect_lab)
												   mlabpos(12) 	    mlabgap(3)
												   mlabcolor(black) mlabsize(small)    )							   					     
			  ,
			  
			    title("Impact on Test Scores")
			   ytitle("")
			   xtitle("")
			   yscale(range(0 200))
			   ylab(0(50)200)
			   xlab(1 "Math" 5 "Reading" 9 "Human Science" 13 "Natural Science" 17 "Average", alt)
			  
			   legend(order (1 "Control" 2 "Treatment"))	
			   note("{bf:Note:} Means with 90% confidence intervals of the treatment effect, estimated by regressions"
				    "with strata fixed effects and standard errors clustered at the school level.")
			  
			   graphregion(color(white))
			   graphregion(margin(8 8 2 2))
		;	
		
	#d	cr
	
	* Store graph in PNG format
	gr  export "figure.png", width(5000) as(png) replace

* End of the do-file
