** Figure:  Venn diagram
cd "{directory}"

* 1. Install venndiag
ssc install venndiag

* 2. Load the data
use "data.dta" 

* 3. Plot the graph
venndiag med_l_any_2 med_k_any_16 med_l_any_3
	
* 4. Export the graph
graph export "3-way-venn.png", as(png) replace

* Have a lovely day!
