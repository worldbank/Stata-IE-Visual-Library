*Figure: Bar plot of multiple variables

*	cd "{directory}"
	use "data.dta", clear

	* We will create mean of all crop observations across each "treatment_group, baseline, and midline category.

	* Collapse baseline and midline variables to get Treatment/Control mean
	collapse bl_* ml_*, by(treatment_group) 
	
	* Reshape dataset to a long-format, indexed by newly created "crop" variable. This is a string variable with the name of the crop.
	reshape long bl_ ml_, i(treatment_group) j(crop) str

	* Reshape again dataset to wide-format, indexed by "treatment_group" for each baseline and midlline values.
	reshape wide bl_ ml_, i(crop) j(treatment_group)
	
	* Keeping only the variables of interests
	gsort -ml_1
	keep if _n<4

	* Creating position vector for bars for the y-axis 
	gen xml_1 = _n
	gen xml_0 = xml_1 +.2
	gen xbl_1 = xml_1 +.4
	gen xbl_0 = xml_1 +.6
	
	* setting decimal to the 10th for the graph
	foreach var of varlist bl_* ml_* {
		replace `var' = round(`var',.1)
	}
	
	* Cleaning 
	replace crop = subinstr(crop, "_", " ",.) 
	replace crop = subinstr(crop, "w", " ",.)
	
	* Insert the list of values in the local macro macname 
	forvalues j = 1/3 {
		levelsof crop if _n==`j', local(crop`j')
	}

	* Creating the graph
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


	*Exporting the graph
	graph export "figure.png", replace

* Have a lovely day!
