	* Using existing variables to create separate for rounds
	foreach var of varlist 	w_Main_Paddy_Prod w_Wheat_Prod w_Spring_Winter_Potato_Prod w_Summer_Maize_Prod w_Spring_Winter_Maize_Prod w_Summer_Potato_Prod  ///
							w_Upland_Paddy_Prod w_Millet_Prod w_Barley_Prod w_Mustard_Prod w_Beans_Prod w_Soybeans_Prod w_Lentil_Prod w_Black_Gram_Prod w_Pea_Prod    {
		  gen bl_`var' = `var' if round == 1
		  gen ml_`var' = `var' if round == 2
	  }
  
	
	* Identify treatment group
	gen 	tmt_group = (treatment == 1 | treatment == 2)
	replace tmt_group = 0 if tmt_group == .	 
	
	* Collapse variables per T and C
	collapse bl_* ml_*, by(tmt_group)
	
	* Reshape data set 
	reshape long bl_ ml_, i(tmt_group) j(crop) str		
	reshape wide bl_ ml_, i(crop) j(tmt_group)
	
	gsort -ml_1
	keep if _n<4
	gen xml_1 = _n
	gen xml_0 = xml_1 +.2
	gen xbl_1 = xml_1 +.4
	gen xbl_0 = xml_1 +.6
	
	foreach var of varlist bl_* ml_* {
		replace `var' = round(`var',.1)
	}
	
	replace crop = subinstr(crop, "_", " ",.) 
	replace crop = subinstr(crop, " pct", "",.)
	replace crop = subinstr(crop, "w", " ",.)
	
	forvalues j = 1/3 {
		levelsof crop if _n==`j', local(crop`j')
		di `crop`j''
	}
			
	twoway bar bl_0 xbl_0, horizontal bcolor(edkblue) barwidth(.2) || ///
		bar ml_0 xml_0, horizontal bcolor(eltblue) barwidth(.2) || ///
		scatter xml_0 ml_0, mlabel(ml_0) mlabcolor(black) msymbol(none) mlabsize(vsmall) || ///
		scatter xbl_0 bl_0, mlabel(bl_0) mlabcolor(black) msymbol(none) mlabsize(vsmall) || ///
		bar bl_1 xbl_1, horizontal bcolor(emidblue) barwidth(.2) || ///
		bar ml_1 xml_1, horizontal bcolor(black) barwidth(.2) || ///
		scatter xml_1 ml_1, mlabel(ml_1) mlabcolor(black) msymbol(none) mlabsize(vsmall) || ///
		scatter xbl_1 bl_1, mlabel(bl_1) mlabcolor(black) msymbol(none) mlabsize(vsmall) ///
  		xlabel(0 "0" 50 "50" 100 "100" 150 "150") ///
		xscale(range(0(20)100)) /// 
		ylabel(1.3 `crop1' 2.3 `crop2' 3.3 `crop3', angle(0)) ///
		graphregion(color(white)) bgcolor(white) ///
		legend(label(1 "Baseline-Control") label(2 "Midline-Control") label(5 "Baseline-Treatment") label(6 "Midline-Treatment") order(1 5 2 6)) 
	graph export "$data/Documentation/Graphs and figures/agriculture/Figure 18 - average annual production of common crops - combined.pdf", replace
restore 
}
 

