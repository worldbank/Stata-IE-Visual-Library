* Figure: Scatter plot of major outcome (mean variable value), stratified by a variable

** Master file for results replication.
** Please note that tables will be produced in "raw" form and require manual recombination and/or formatting to match the finished tables.

* Indicate the location of the Public Release folder: only this line should need to be edited by the user.

	cd "{directory}"

* Load adofiles

	* These files are created by the authors for the purposes of this study and are not publicly available for general use.
	* These files are not guaranteed to produce appropriate statistics other than those contained in this replication file.

		qui do "labelcollapse.ado"
		qui do "freeshape.ado"
	
	* In addition, this dofile relies on two other publicly available STATA extensions: 
		* firthlogit, in package firthlogit from http://fmwww.bc.edu/RePEc/bocode/f
		* estadd, in package st0085_2 from http://www.stata-journal.com/software/sj14-2
		* xml_tab, in package dm0037 from http://www.stata-journal.com/software/sj8-3
	
	version 13

* Figure S1. Major outcomes, stratified by standardized patient case

	use "data.dta", clear
	
	* Collapse and Reshape Data
			
		labelcollapse 			essential correct cxr sputum dstgx s5_referral sp_drugs_tb sp_drugs_antibio sp_drugs_quin, by(sp_case)
		freeshape 				essential correct cxr sputum dstgx s5_referral sp_drugs_tb sp_drugs_antibio sp_drugs_quin, i(sp_case) j(var)
	
		local x = 1
		gen order = 0
		qui foreach name in 	essential correct cxr sputum dstgx s5_referral sp_drugs_tb sp_drugs_antibio sp_drugs_quin {
			replace order = `x' if var_name == "`name'"
			local ++x
			}
			
	* Output

		graph dot var_value , asy over(sp_case) over(var_label, sort(order)) linegap(20) graphregion(color(white)) xsize(7) legend(region(lc(none) fc(none))) ///
			yscale(noline) ytit("") ylab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") ///
			linetype(line) lines( lp(.) lc(gs11)) legend(pos(5) ring(0) c(1)  region(lc(white) fc(white))) ///
			marker(1, m(O) mlcolor(black)) ///
			marker(2, m(O) mlcolor(black)) ///
			marker(3, m(O) mlcolor(black)) ///
			marker(4, m(O) mlcolor(black)) 
			
		graph save   "figure.gph" , replace
		graph export "figure.eps" , replace
		graph export "figure.png" , width(4000) replace
		
			
* Have a lovely day!
