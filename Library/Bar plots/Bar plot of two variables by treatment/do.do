	
	* Load data
	* ---------
	use "$VisLib\Bar plots\Bar plot of two variables by treatment\data.dta", clear
	
	* Plot
	* ----
	# d;
	graph bar w_total_val_harvested_a w_total_val_inputs_a, 
		  over(treated)		
		  bargap(-30)  legend(label(1 "Total Value Harvested")
							  label(2 "Total Value Inputs"))
		  bar (1, color("0 102 102") ) 
		  bar (2, color("153  0 76") ) 
		  ytitle ("Value in RWF")	
		  title  ("Harvested value and Input Value")
		  subtitle ("By treatment")
		  note ("Note: Variables are winsorized at 0.01");
	# d cr
			
	* Export image
	* ------------
	gr export "$VisLib\Bar plots\Bar plot of two variables by treatment\plot.png", width(5000) replace

			
			