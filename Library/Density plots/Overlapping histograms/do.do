* Figure: Overlapping histograms
		
	* Load data
	cd	    	 "{directory}"	
	use	    	 "data.dta"	 , clear
	append using "data2.dta" , gen(group)
	
	* Set general options
	local histOptions "start(0) width(20) percent gap(5)"		 
	
	* Plot two histograms
	#d	;
		tw (hist areacult_share if areacult_share > 0 & !group , `histOptions' 				    color(navy%75)   			  )
		   (hist areacult_share if areacult_share > 0 &  group , `histOptions' fcolor(white%0) lcolor(eltblue) lwidth(vthick) )
				 ,
				 ylab(, angle(horizontal) nogrid)
				 xlab(10 "0-20"
					  30 "20-40"
					  50 "40-60"
					  70 "60-80"
					  90 "80-100")
				 xtitle("Share of area cultivated with improved seeds (%)")
				 
				 legend(order(1 "SECFs"
							  2 "SFs"))
				 
				 xscale(titlegap(2))
				 
				 plotregion(margin(l-10))
				 graphregion(margin(r+4))
				 graphregion(color(white))				  
		;
	#d	cr
	
	gr export "figure.png", width(5000) replace
		
* End of the do-file
