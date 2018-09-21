*Figure: Line plots witthed line with confidence interval

	* Load data set
	cd "{directory}"
	use "data.dta", clear
	
	* Treament effect															
	reg 	y_var x_var post x_var_post control
	
	* Save coefficients for graph
	local   beta_pre  = round(_b[x_var],0.001)
	local 	beta_post = round(_b[x_var] + _b[x_var_post],0.001)
	
	* Save F-test P-values for graph
	test 	_b[x_var_post] = 1
	local 	f_pre = round(r(p),0.001)
	if 		`f_pre' == 0 local f_pre = "0.000"
	
	test 	_b[x_var_post] + _b[x_var_post] = 1
	local 	f_post = round(r(p),0.001)
	
	* Graph
	twoway 	(lfitci y_hat x_var if post == 1, color("222 235 247") lwidth(.05)) ///
			(lfitci y_hat x_var if post == 0, color(gs15)) /// 
			(lfit	x_var x_var	if post == 1, color(red) lwidth(.5) lpattern(dash)) ///
			(lfit 	y_hat x_var	if post == 0, color(gs8) lwidth(.5)) /// 
			(lfit 	y_hat x_var	if post == 1, color(edkblue) lwidth(.5)), ///
			text(5 9 "Pre-treatment" "Regression coefficent: 0`beta_pre'" "P-value of coefficent = 1: `f_pre'" ///
				 12 9 "Post-treatment" "Regression coefficent: 0`beta_post'" "P-value of coefficent = 1: 0`f_post'", ///
				 orient(horizontal) size(vsmall) justification(center) fcolor(white) box margin(small)) ///
			xtitle("Independent variable value") ///
			ytitle("Predicted value of dependent variable") ///
			legend(order (6 "Pre-treatment" 7 "Post-treatment" 3 "Pre-treatment 95%CI" 1 "Pre-treatment 95%CI")) ///
			graphregion(color(white)) bgcolor(white)
	
	* Save graph
	gr export	"figure.png", width(5000) replace

* Have a lovely day!
