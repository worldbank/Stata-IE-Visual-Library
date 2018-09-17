* Figure: Horizontal Bar graph with betterbar code

* Indicate the location of the Public Release folder: only this line should need to be edited by the user.

	cd "{directory}"

* Load adofiles

	* These files are created by the authors for the purposes of this study and are not publicly available for general use.
	* These files are not guaranteed to produce appropriate statistics other than those contained in this replication file.

		qui do "betterbar.ado"
	
	* In addition, this dofile relies on two other publicly available STATA extensions: 
		* firthlogit, in package firthlogit from http://fmwww.bc.edu/RePEc/bocode/f
		* estadd, in package st0085_2 from http://www.stata-journal.com/software/sj14-2
		* xml_tab, in package dm0037 from http://www.stata-journal.com/software/sj8-3
	
	version 13
	
	use "data.dta", clear
		
	betterbar ///
		( sp1_h1 sp1_h2 sp1_h3 sp1_h4 sp1_h5 sp1_h7 sp1_h8 sp1_h9 sp1_h10 sp1_h11 sp1_h12 sp1_h13 sp1_h14 sp1_h15 sp1_h16 sp1_h17 sp1_h18 sp1_h19 sp1_h20 sp1_h21 ) ///
		( sp1_e1 sp1_e2 sp1_e3 sp1_e5 sp1_e6 ) ///
		, d(1) xlab(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%") barl(mean) barlook(1 fc(black) lc(black))
		
*		graph save   "Figure_1.gph" , replace
*		graph export "Figure_1.eps" , replace
		graph export "figure.png" , width(4000) replace

* Have a lovely day!
