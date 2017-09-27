# IE Visual Library in Stata

## [Bar plots]

### [Bar plot of two variables by treatment]

![plot]

```stata
# d;
graph bar w_total_val_harvested_a w_total_val_inputs_a, 
	  over(treated)		
	  bargap(-30)
	  legend(label(1 "Total Value Harvested")
			 label(2 "Total Value Inputs"))
	  bar (1, color("0 102 102") ) 
	  bar (2, color("153  0 76") ) 
	  ytitle ("Value in RWF")	
	  title  ("Harvested value and Input Value")
	  subtitle ("By treatment")
	  note ("Note: Variables are winsorized at 0.01");
# d cr
```


## [Density plots]

### [Density plot with averages]

![plot]

```stata
twoway 	(kdensity revenue if post == 0, color(gs10)) ///
	(kdensity revenue if post == 1, color(emerald)), ///
	xline(`pre_mean', lcolor(gs12) lpattern(dash)) ///
	xline(`post_mean', lcolor(eltgreen) lpattern(dash)) ///
	legend(order(1 "Pre-treatment" 2 "Post-treatment")) ///
	xtitle(Agriculture revenue (BRL thousands)) ///
	ytitle(Density) ///
	bgcolor (white) graphregion(color(white))
			
```

## [RD plots]
### [Regression discontinuity plot with confidence intervals]

![rdplot1]

```stata
twoway  (lpolyci tmt_status pmt_score if pmt_score < `cutoff', clcolor(navy) acolor(gs14)) ///
	(lpolyci tmt_status pmt_score if pmt_score > `cutoff', clcolor(navy) acolor(gs14)), ///
	xline(`cutoff', lcolor(red) lwidth(vthin) lpattern(dash)) ///
	ytitle(Probability of receiving treatment) ///
	xtitle(Proxy means test score) ///
	legend(off) ///
	bgcolor (white) graphregion(color(white))  ///
	note("Note: gray area is 95% confidence interval.")
```


## [Scatter plots]

### [Scatter plot with fitted line]

![scatterplot1]

```stata
twoway 	(scatter revenue area_cult if post == 0, msize(vsmall) mcolor(gs14)) ///
	(lfit revenue area_cult if post == 0, color(gs12)) ///
	(scatter revenue area_cult if post == 1, msize(vsmall) mcolor(stone)) ///
	(lfit revenue area_cult if post == 1, color(sand)), ///
	ytitle(Agriculture revenue (BRL thousands)) ///
	xtitle(Cultivated area) ///
	legend(order(2 "Pre-treatment" 4 "Post-treatment")) ///
	bgcolor (white) graphregion(color(white))
```