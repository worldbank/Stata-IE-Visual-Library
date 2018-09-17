* Figure:  Venn Diagram

	cd "{directory}"

	qui do "vennprep.ado"

	use "data.dta" ///
		if correct == 0 & case == 1 ///
		, clear

	vennprep  med_l_any_2 med_k_any_16 med_l_any_3 med_k_any_9

	* Data then entered into generator at http://www.pangloss.com/seidel/Protocols/venn4.cgi


* Have a lovely day!
