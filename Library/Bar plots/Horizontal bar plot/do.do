* Figure: horizontal bar plot

	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ///
		ylab(,angle(0) nogrid) title(, justification(left) color(black) span pos(11)) subtitle(, justification(left) color(black))

	
	cd "{directory}"

	* Manipulation of data 1
		use "data1.dta" , clear

		*Data manipulation: Making data to have only these three variables
		keep facilitycode study hours

		tempfile vietnam
			save `vietnam' , replace

	* India

		use "data2.dta" , clear

		*Data manipulation: Making data have the same variables
		gen hours = tottime/60
		drop tottime

	* Analysis

		append using `vietnam'
		

		graph bar hours , $graph_opts1 over(study) ///
			blabel(bar, format(%9.1f)) ///
			hor ylab(1 "1 Hour" 2 "2 Hours" 3 "3 Hours") bar(1,fi(100) lc(black) lw(thin)) ///
			ytit("Average Daily Time Seeing Patients {&rarr}",placement(left) justification(left))

		graph export "figure.png" , replace width(1000)


* Have a lovely day!
