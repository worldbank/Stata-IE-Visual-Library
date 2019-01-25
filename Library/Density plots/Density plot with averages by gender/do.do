* Figure: Density plot with averages by gender

	* Load data
	* ---------
	cd		"{directory}"
	use  	"data.dta"		,  clear
	
	* Calculate means (by treatment and gender)
	* ---------------
	sum 	student_average if student_gender  == 0 & school_treated == 0
	local 	control_F 		=  round(`r(mean)', .11)
	sum		student_average if student_gender  == 0 & school_treated == 1
	local 	treat_F   		=  round(`r(mean)', .11)
	sum 	student_average if student_gender  == 1 & school_treated == 0
	local 	control_T 		=  round(`r(mean)', .11)
	sum		student_average if student_gender  == 1 & school_treated == 1
	local 	treat_T   		=  round(`r(mean)', .11)
	
	* Count number of observations
	* ----------------------------
	sum		student_average if student_gender == 0
	local	N_F		  	 	= `r(N)'
	sum		student_average if student_gender == 1
	local	N_M		  		= `r(N)'
	
	* Set locals for line colors and width
	* ------------------------------------
	local 	purple			"132 4 252"		//for girls
	local	green			"4 196 172"		//for boys
		
	local	dens_width		0.6
	local	 avg_width		0.5
	
	* Plot graph
	* ----------
	#d	;
	
		// Girls
		gr	tw (kdensity student_average if student_gender == 0 & school_treated  == 0, color("`purple'") lpattern(dash) lwidth(`dens_width') )
			   (kdensity student_average if student_gender == 0 & school_treated  == 1, color("`purple'")				  lwidth(`dens_width') )
			   ,
			    xline(`control_F', lcolor(`purple') lpattern(dash) lwidth(`avg_width')) 
			    xline(`treat_F'  , lcolor(`purple') 				  lwidth(`avg_width'))
			     title("Female Students")
			    ytitle("Kernel density estimates")
			    xtitle("Test scores (average)")
			    legend(lab(1 "Control") lab(2 "Treatment"))
			    text(0.013 245 "Control mean = `control_F'"
				 			   "Treatment mean = `treat_F'"
				 			   "N. obs = `N_F'"
				 	,
				 	orient(horizontal)  size(small) justification(center)
				 	fcolor(white) box margin(small)
				 	)
			    graphregion(color(white))
			    name(girls, replace)
		;
		
		// Boys
		gr	tw (kdensity student_average if student_gender == 1 & school_treated == 0, color("`green'")   lpattern(dash) lwidth(`dens_width') )
			   (kdensity student_average if student_gender == 1 & school_treated == 1, color("`green'") 			      lwidth(`dens_width') )
			   ,
			    xline(`control_T', lcolor(`green') lpattern(dash) lwidth(`avg_width')) 
			    xline(`treat_T'  , lcolor(`green') 				 lwidth(`avg_width'))
			     title("Male Students")
			    ytitle("")
			    xtitle("Test scores (average)")
			    legend(lab(1 "Control") lab(2 "Treatment"))
			    text(0.013 245 "Control mean = `control_T'"
							   "Treatment mean = `treat_T'"
							   "N. obs = `N_M'"
					 ,
					 orient(horizontal)  size(small) justification(center)
					 fcolor(white) box margin(small)
					 ) 
			    graphregion(color(white))		
			    name(boys, replace)
		;
		
		// Combine two graphs
		gr	combine girls boys
			,
			   title("Test Score Distribution")
			subtitle("By Gender")
			graphregion(color(white))
		;
		
		// Export image
		gr	export	 "figure.png", as(png) width(5000) replace
		;
		
	#d	cr
	
* End of the do-file
