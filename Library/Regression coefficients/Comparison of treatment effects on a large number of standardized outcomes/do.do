/*******************************************************************************

  Comparison of treatment effects on a large number of standardized outcomes

--------------------------------------------------------------------------------  
  
  NOTES: 

  1. This graph is achieved by combining smaller graphs, using the titles of the
     small graphs as separations for each category of variables.

  2. All variables are standardized in the dofile to ensure the results are
     comparable. Different functions can be used for standardization, here we 
     use egen, std(). This command is not very flexible in the sense that the 
     graph command does not really adapt the graph(s) to the actual number. 
     It is then very likely that when using this code on a different dataset or 
     a different number of variables, you will need to change the format. 
     To do that you will need to play with the different parameters listed below
     until you find the right specification for your specific data:
        - lab_loc
        - xscale(range(-1.8 2))
        - fxsize(120)
        - fysize(`j')
        - graphregion(margin(0 0 0 0))
        - plotregion(margin(0 0 2 2))

  3. The code is inspired by the paper "No Household Left Behind : Afghanistan 
     Targeting the Ultra Poor Impact Evaluation" by Bedoya et al, but the data
     is comprised of a subsample explaining why there are so few observations
	 
*******************************************************************************/

	cd "${directory}"
	use "data.dta", clear

/*------------------------------------------------------------------------------
	PART 1: Setttings
------------------------------------------------------------------------------*/

	* Graph options
	local graph_opts ///
		  title(, justification(left) color(black) span pos(11)) ///
		  graphregion(color(white)) ///
		  ylab(, angle(0) nogrid) ///
		  xtit(, placement(center) justification(center)) ///
		  yscale(noline) ///
		  legend(region(lc(none) fc(none)))

	/* Variable groups
	
	   The first local is for the name of the main categories of variables. 
	   The name of each category is also a global which contains all the 
	   variables in the category.  */
	   
	local all 					consumption_sum asset_sum time_sum time_sum_pm fin_sum revenues_sum psy_sum fem_empo childhealth 	

	local consumption_sum 		index_sdC_food_sec exp_tot_m_pc_c_ppp
	local fin_sum 				loan_ppp access_credit saving_4w_ppp  
	local asset_sum 			wealth_score tot_lstock_value_ppp
	local time_sum				hr_othwork_4w_d_pf hr_ownBusiness_4w_d_pf hr_ownFarming_4w_d_pf hr_livestock_4w_d_pf hr_tot_labor_nohh_4w_d_pf labor_particip_pf 	
	local time_sum_pm			hr_othwork_4w_d_pm hr_ownBusiness_4w_d_pm hr_ownFarming_4w_d_pm hr_livestock_4w_d_pm hr_tot_labor_nohh_4w_d_pm labor_particip_pm 	
	local revenues_sum			tot_hh_pay_ppp tot_biz_revenue_ppp tot_crop_revenue_ppp tot_lstock_revenue_ppp tot_hh_income_ppp
	local psy_sum 				psy_indexC_sdC_fl1_m psy_indexC_sdC_fl1
	local fem_empo 			    index_sdC_f_empowerment index_sdC_hhexp
	local childhealth	   		diarrhea_yes
	
	*The last category has to be treated separately as the graph will be slightly different, notably including the x axis and some specific formatting	
	local schoolchild		days_missed_school_hh child_inschool_hh 

	* Title for graphs by group
	local childhealthtitle      "Child Health"
	local consumption_sumtitle  "Consumption & Food Security"
	local fem_empotitle         "Women's Empowerment"
	local fin_sumtitle          "Finance"
	local asset_sumtitle        "Assets"
	local revenues_sumtitle     "Income and Revenues"
	local psy_sumtitle          "Psychological Well-Being"
	lcoal time_sumtitle         "Labor Supply and Time Use, Primary Woman"
	local time_sum_pmtitle      "Labor Supply and Time Use, Primary Man"	

	
local lab_loc = -1.7
gen loc = `lab_loc' //For the location of the labels on the graph. To change depending on the results of the regression, format needs to be adapted.

*Need to standardize all the variables to have comparable results. 
foreach group in `all' schoolchild {
		foreach var in ``group'' {
	egen `var'_ind = std(`var')
	}
}

	local k 	= 1
foreach group in ${all}  {
	gen counter = _n
	local i 	= 1	

*Variables to store confidence intervals and estimates
	gen CI_l 	= .
	gen CI_h 	= .
	gen estim 	= .
	local theLabels ""
	*Entering the specific titles of each category
	
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
	,	$graph_opts title("``group'title'",size(medsmall)) ylab("") ytit(" ") xlab("") xscale(range(-1.8 2)) ///
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
