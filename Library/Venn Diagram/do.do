* Figure:  Venn diagram

	cd "{directory}"

	qui do "vennprep.ado"

	use "data.dta" 

	vennprep  med_l_any_2 med_k_any_16 med_l_any_3 med_k_any_9

	* Data then entered into generator at http://www.pangloss.com/seidel/Protocols/venn4.cgi
	**In the website, enter name of first column in the "List Name 1", and values from column 2 in the "List 1", and so on.


* Have a lovely day!
