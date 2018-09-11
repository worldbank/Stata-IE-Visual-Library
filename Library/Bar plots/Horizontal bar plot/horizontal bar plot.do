* Figure: horizontal bar plot

	global graph_opts1 bgcolor(white) graphregion(color(white)) legend(region(lc(none) fc(none))) ///
		ylab(,angle(0) nogrid) title(, justification(left) color(black) span pos(11)) subtitle(, justification(left) color(black))


	* Vietnam

		use "${directory}/vietnam_po.dta" , clear

		egen id = group(FACILITY_ID DOCTOR_ID location_type)

		collapse (sum) po_time (firstnm) location_type , by(id)

		gen study = "Vietnam Commune"
		replace study = "Vietnam District" if location_type == 2

		gen facilitycode = "V" + string(id)
		rename po_time tottime

		keep facilitycode study tottime

		tempfile vietnam
			save `vietnam' , replace

	* India

		use "${directory}/knowdo_data.dta" , clear

		gen tottime = .

		replace tottime = po_time * po_patients
		replace tottime = prov_time * prov_caseload if tottime == .

		table study , c(mean tottime count tottime)

		keep if tottime != .

		replace study = "Birbhum, India" if regexm(study,"Birbhum")
		replace study = `""Madhya Pradesh, India" "(Public Clinics)""' if regexm(study,"Mad") & substudy == 2
		replace study = `""Madhya Pradesh, India" "(Private Clinics)""' if regexm(study,"Mad") & substudy == 1

		collapse (mean) tottime (firstnm) study , by(facilitycode)

	* Analysis

		append using `vietnam'

		gen hours = tottime/60

		graph bar hours , $graph_opts1 over(study) ///
			blabel(bar, format(%9.1f)) ///
			hor ylab(1 "1 Hour" 2 "2 Hours" 3 "3 Hours") bar(1,fi(100) lc(black) lw(thin)) ///
			ytit("Average Daily Time Seeing Patients {&rarr}",placement(left) justification(left))

			graph export "${directory}/figure_1.png" , replace width(1000)


* Have a lovely day!
