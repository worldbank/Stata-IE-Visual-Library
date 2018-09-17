* Figure:Side by side horizontal bar plot (Outcomes by City & Case) using weightab

	cd "{directory}"
	qui do "weightab.ado"

	label def case 1 "Case 1" 2 "Case 2" 3 "Case 3" 4 "Case 4" , modify

	local opts lw(thin) lc(white) la(center)

	global graph_opts ///
		title(, justification(left) color(black) span pos(11)) ///
		graphregion(color(white) lc(white) lw(med) la(center)) /// <- remove la(center) for Stata < 15
		ylab(,angle(0) nogrid) xtit(,placement(left) justification(left)) ///
		yscale(noline) xscale(noline) legend(region(lc(none) fc(none)))

	use "data.dta" , clear

	weightab ///
		correct treat_cxr re_3 re_4 treat_refer t_12 ///
		med_any med_l_any_1 med_l_any_2 med_l_any_3  med_k_any_9   ///
		if city == 2 ///
		[pweight = weight_city] ///
		, $graph_opts barlab barlook(1 `opts' fi(100)) title("Patna") over(case) graph legend(off) xlab(${pct})

		graph save "Fig_1_1.gph" , replace

	weightab ///
		correct treat_cxr re_3 re_4 treat_refer t_12 ///
		med_any med_l_any_1 med_l_any_2 med_l_any_3  med_k_any_9  ///
		if city == 3 ///
		[pweight = weight_city] ///
		, $graph_opts barlab barlook(1 `opts'  fi(100)) title("Mumbai") over(case) graph legend(pos(5) ring(0) c(1) symxsize(small) symysize(small)) xlab(${pct})

		graph save "Fig_1_2.gph" , replace

		graph combine ///
			"Fig_1_1.gph" ///
			"Fig_1_2.gph" ///
			, $comb_opts xsize(7) r(1)

		graph export "figure.png" , replace width(2000)


* Have a lovely day!
