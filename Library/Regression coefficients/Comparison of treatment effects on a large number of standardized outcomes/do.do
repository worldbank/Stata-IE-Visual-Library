/*
This graph is achieved by combining smaller graphs, using the titles of the small graphs as separations for each category of variables.
All variables are standardized in the dofile to ensure the results are comparable. Different functions can be used for standardization, here we use egen, std(). 
This command is not very flexible in the sense that the graph command does not really adapt the graph(s) to the actual number. 
It is then very likely that when using this code on a different dataset or a different number of variables, you will need to change the format. 
To do that you will need to play with the different parameters entered here (mostly lab_loc, xscale(range(-1.8 2), fxsize(120), fysize(`j'), graphregion(margin(0 0 0 0)), plotregion(margin(0 0 2 2))
until you find the right specification for your specific data
Code is inspired by TUP paper but database is different, with random assignement of treatment, explaining why there is no effect
*/

clear all
global directory "C:\Users\escan\OneDrive\Bureau\Github\Visual_library"

	cd "${directory}"
	use "data.dta", clear

	global graph_opts title(, justification(left) color(black) span pos(11)) graphregion(color(white)) ylab(,angle(0) nogrid) xtit(,placement(center) justification(center)) yscale(noline) legend(region(lc(none) fc(none)))


*The first global is for the name of the main categories of variables. The name of each category is also a global which contains all the variables in the category.  
		global all 					consumption_sum asset_sum time_sum time_sum_pm fin_sum revenues_sum psy_sum fem_empo childhealth 	
 
		global consumption_sum 		index_sdC_food_sec exp_tot_m_pc_c_ppp
		global fin_sum 				loan_ppp access_credit saving_4w_ppp  
		global asset_sum 			wealth_score tot_lstock_value_ppp
		global time_sum				hr_othwork_4w_d_pf hr_ownBusiness_4w_d_pf hr_ownFarming_4w_d_pf hr_livestock_4w_d_pf hr_tot_labor_nohh_4w_d_pf labor_particip_pf 	
		global time_sum_pm			hr_othwork_4w_d_pm hr_ownBusiness_4w_d_pm hr_ownFarming_4w_d_pm hr_livestock_4w_d_pm hr_tot_labor_nohh_4w_d_pm labor_particip_pm 	
		global revenues_sum			tot_hh_pay_ppp tot_biz_revenue_ppp tot_crop_revenue_ppp tot_lstock_revenue_ppp tot_hh_income_ppp
		global psy_sum 				psy_indexC_sdC_fl1_m psy_indexC_sdC_fl1
		global fem_empo 			index_sdC_f_empowerment index_sdC_hhexp
		global childhealth	   		diarrhea_yes
		
*The last category has to be treated separately as the graph will be slightly different, notably including the x axis and some specific formatting	
		global schoolchild		days_missed_school_hh child_inschool_hh 



*Label variable for the figure

	label var exp_tot_m_pc_c_ppp 		"Consumption Per Capita, Month"
	
	label var wealth_score 				"Household Asset Ownership Index"
	label var tot_lstock_value_ppp 		"Value of Livestock" 

	label var tot_lstock_revenue_ppp 	"Livestock Revenues"
	label var tot_crop_revenue_ppp  	"Agriculture Revenues"
	label var tot_biz_revenue_ppp  		"Non-agricultural Business Revenues"
 	label var tot_hh_pay_ppp 			"Paid Labor Income, All Adults"
 	label var tot_hh_income_ppp			"Total Household Income and Revenues"

	label var psy_indexC_sdC_fl1 		"Psychological Well-Being Index, Primary Woman"
	label var psy_indexC_sdC_fl1_m 		"Psychological Well-Being Index, Primary Man"

	label var index_sdC_hhexp 			"Household Expenditures Decision Index (1 Dimension)"

	label var diarrhea_yes				"Diarrhea Rate in Oldest U5 Child, Last 2 weeks"

	label var loan_ppp 					"Household Total Outstanding Cash Loans"
	label var saving_4w_ppp				"Household Savings, Last 4 Weeks"
 	label var access_credit				"Household Members Can Access Formal Credit if Needed"

	label var hr_livestock_4w_d_pm 		"Household Livestock"
	label var hr_ownFarming_4w_d_pm  	"Household Agriculture"
	label var hr_ownBusiness_4w_d_pm  	"Own Non-Agriculture Business"
	label var hr_tot_labor_nohh_4w_d_pm "Total Time Spent Working"
	label var hr_othwork_4w_d_pm 		"Other Paid and Unpaid Work"
	
	label var hr_livestock_4w_d_pf 		"Household Livestock"
	label var hr_ownFarming_4w_d_pf  	"Household Agriculture"
	label var hr_ownBusiness_4w_d_pf  	"Own Non-Agriculture Business"
	label var hr_tot_labor_nohh_4w_d_pf "Total Time Spent Working"
	label var hr_othwork_4w_d_pf 		"Other Paid and Unpaid Work"	

	
	label var child_inschool_hh  	"School Enrollment"
	label var days_missed_school_hh "School Absenteeism, Last 4 Weeks"

	
local lab_loc = -1.7
gen loc = `lab_loc' //For the location of the labels on the graph. To change depending on the results of the regression, format needs to be adapted.

*Need to standardize all the variables to have comparable results. 
foreach group in $all schoolchild {
		foreach var in ${`group'} {
		disp "`group'"
		disp "`var'"
	egen `var'_ind = std(`var')
	}
}

	local k 	= 1
foreach group in $all  {
	gen counter = _n
	local i 	= 1	

*Variables to store confidence intervals and estimates
	gen CI_l 	= .
	gen CI_h 	= .
	gen estim 	= .
	local theLabels ""
	*Entering the specific titles of each category
	if "`group'" == "childhealth" {
		global title "Child Health"
	}
	if "`group'" == "consumption_sum" {
		global title "Consumption & Food Security"
	}
	if "`group'" == "fem_empo" {
		global title "Women's Empowerment"
	}
	if "`group'" == "fin_sum" {
		global title "Finance"
	}
		if "`group'" == "asset_sum" {
		global title "Assets"
	}
		if "`group'" == "revenues_sum" {
		global title "Income and Revenues"
	}
		if "`group'" == "psy_sum" {
		global title "Psychological Well-Being"
	}

		if "`group'" == "time_sum" {
		global title "Labor Supply and Time Use, Primary Woman"
	}
			if "`group'" == "time_sum_pm" {
		global title "Labor Supply and Time Use, Primary Man"
	}
	local j = 0
	foreach var in ${`group'} {
*Saving coefficients and confidence intervals to later use to generate the graph			
	reg `var'_ind treatment 
	cap mat drop A_`var' 
	mat A_`var'  = r(table)
	replace CI_l 	= A_`var'[5,1] 	if counter == `i'
	replace CI_h 	= A_`var'[6,1]  	if counter == `i'
	replace estim 	= A_`var'[1,1] 	if counter == `i' 
	local theLabel : var label `var'
	local theLabels `"`theLabels' `i' "`theLabel'""'
	disp `theLabels'
	local i = `i' + 1	
	local j = `j' + 1
	}
	local j = `j' * 4 + 5
	gen include = 1 if counter < `i'
	replace counter = . if counter >= `i'

label define test`k' `theLabels'
label value counter test`k'
local k = `k' + 1

*Generating the graph
tw ///
	(rcap CI_l CI_h counter if include == 1 , hor lc(navy)) /// 
	(scatter counter estim if include == 1, mc(black)) ///
	(scatter counter loc if include == 1, ms(none) mla(counter) mlabpos(3) mlabc(gs4) mlabsize(small)) ///		
	,	$graph_opts title("	$title",size(medsmall)) ylab("") ytit(" ") xlab("") xscale(range(-1.8 2)) ///
		xline(1, lc(gs11) lp(dash))  xline(0 , lc(gs11) lp(dash) ) legend(off)   fxsize(120) fysize(`j')  graphregion(margin(0 0 0 0)) plotregion(margin(0 0 2 2))  
 
qui graph save "`group'.gph" , replace

drop  counter CI_l CI_h estim include


}

**********************Adding Child Schooling, the last graph or last category, with some specific formatting
	local k 	= 1
	gen counter = _n
	local i 	= 1	
	global title "Child Education"

*Variables to store confidence intervals and estimates
	gen CI_l 	= .
	gen CI_h 	= .
	gen estim 	= .
	local theLabels ""

	local j = 0
*Saving coefficients and confidence intervals to later use to generate the graph	
	foreach var in $schoolchild {	
	reg `var'_ind treatment 
	cap mat drop A_`var' 
	mat A_`var'  = r(table)
	replace CI_l 	= A_`var'[5,1] 		if counter == `i'
	replace CI_h 	= A_`var'[6,1]  	if counter == `i'
	replace estim 	= A_`var'[1,1] 		if counter == `i' 
	local theLabel : var label `var'
	local theLabels `"`theLabels' `i' "`theLabel'""'
	disp `theLabels'
	local i = `i' + 1	
	local j = `j' + 1
	}
	
	local j = `j' * 4 + 6
	gen include = 1 if counter < `i'
	replace counter = . if counter >= `i'

label define testf`k' `theLabels'
label value counter testf`k'
local k = `k' + 1

*Generating the graph
tw ///
	(rcap CI_l CI_h counter if include == 1 , hor lc(navy)) /// 
	(scatter counter estim if include == 1, mc(black)) ///
	(scatter counter loc if include == 1, ms(none) mla(counter) mlabpos(3) mlabc(gs4) mlabsize(small)) ///	
	,	$graph_opts title("	$title",size(medsmall)) ylab("") ytit(" ") xlab(-1.8(0.2)1.8 0 "0",format(%9.1f) labsize(vsmall)) xscale(range(-1.8 2)) ///
			xline(1, lc(gs11) lp(dash))  xline(0 , lc(gs11) lp(dash) ) legend(off)  fxsize(120) fysize(22)  graphregion( margin(0 0 0 0)) plotregion(margin(0 0 2 2)) ///
			xtit("Effect size in standard deviations of the control group", size(small)  margin(medsmall) justification(center))
qui graph save "schoolchild.gph" , replace


* Combining all the graphs to have a single one as a result
graph combine ///
	"consumption_sum.gph" ///
	"asset_sum.gph" ///
	"revenues_sum.gph" ///	
	"time_sum.gph" ///	
	"time_sum_pm.gph" ///	
	"fin_sum.gph" ///
	"psy_sum.gph" ///
	"fem_empo.gph" ///
	"childhealth.gph" ///
	"schoolchild.gph" ///
	,  ysize(6) c(1)  graphregion(color(white)) imargin(0 0 0 0) 


*Exporting graphs
graph export "figure.pdf" , replace as(pdf)
graph export "figure.png", replace
