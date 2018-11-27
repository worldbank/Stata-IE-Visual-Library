* Figure 4: Chart of marginal effect with results table (from two data dta)

	global graph_opts ///
		title(, justification(left) color(black) span pos(11)) ///
		graphregion(color(white) lc(white) la(center)) /// <- remove la(center) for Stata < 15
		ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
		yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))


	cd "{directory}"
	
	qui do "chartable.ado"

	use "data.dta" , clear

		chartable ///
			correct treat_cxr re_3 re_4 treat_refer med_any med_l_any_1 med_l_any_2 med_l_any_3  med_k_any_9  ///
			[pweight = weight_city] , $graph_opts title("A. Case 1 vs Case 3 in all providers receiving both cases")  rhs(3.case i.city i.type_formal) case0(Case 1 ({it:N} = 407)) case1(Case 3 ({it:N} = 352)) or command(logit)

		graph save "Fig_4_1.gph" , replace

	use "data2.dta" , clear

		chartable ///
			correct treat_cxr re_3 re_4 treat_refer med_any med_l_any_1 med_l_any_2 med_l_any_3  med_k_any_9  ///
			, $graph_opts title("B. SP4 with and without sputum report in Mumbai MBBS+") rhs(sp4_spur_1) case0(Ordinary ({it:N} = 51)) case1(Report ({it:N} = 50)) or command(logit)

		graph save "Fig_4_2.gph" , replace

		graph combine ///
			"Fig_4_1.gph" ///
			"Fig_4_2.gph" ///
			, $comb_opts xsize(7) c(1)

		graph export "figure.png" , replace width(2000)


* Have a lovely day!
