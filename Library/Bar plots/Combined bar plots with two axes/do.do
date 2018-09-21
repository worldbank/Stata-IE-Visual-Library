* Figure: combined bar plots with two axes

	* Load data
	* ---------
	cd "{directory}"
	use "data.dta", clear
	
	* Adjust variable for bar position
	gen x = int1mo+.5
	
	* Create individual graphs
	* ------------------------
	foreach foodGroup in animal fruit grain fats veg starch beverages  processed_sugar nut_pulse_seed spices other {
		
		if "`foodGroup'" == "animal"			local graphTitle Animal Sourced
		if "`foodGroup'" == "fruit"				local graphTitle Fruit
		if "`foodGroup'" == "grain"				local graphTitle Grain
		if "`foodGroup'" == "veg"				local graphTitle Vegetables
		if "`foodGroup'" == "starch"			local graphTitle Starchy Foods
		if "`foodGroup'" == "processed_sugar"	local graphTitle Processed/Sugar

		twoway 	bar number_group x if food_group=="`foodGroup'", ///
				yaxis(1) ytitle("Avg. Number of Foods from" "Group Consumed Last Month", axis(1)) ///
				barwidth(.9) fintensity(inten0) lcolor(black) /// 
				xlabel(0 "0" 3 "3" 6 "6" 9 "9" 12 "12") ///
				ylabel(0 "0" 1 "1" 2 "2" 3 "3", axis(1)) || ///
				line total_exp int1mo if food_group=="`foodGroup'", ///
				yaxis(2) ytitle("Total Value of Exp." "1000 Real Tz Sh.", axis(2)) ///
				ylabel(0 "0" 500 "500" 1000 "1000" 1500 "1500" 2000 "2000" 2500 "2500", axis(2)) ///
				xlabel(3 "3" 6 "6" 9 "9" 12 "12") lwidth(1.2) ///
				title("`graphTitle'") xtitle("Month of Interview") ///
				graphregion(color(white)) bgcolor(white) ///
				legend(off) ///
				name("`foodGroup'") 
				
	}

	* Combine graphs into one
	* -----------------------
	graph combine 	starch animal fruit grain processed_sugar veg, ///
					graphregion(color(white)) plotregion(color(white)) 
					
	* Save
	* ----
	graph export "figure.png", as(png) replace

* Have a lovely day!
