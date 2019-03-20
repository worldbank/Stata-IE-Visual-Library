* Figure:  Venn diagram

** 1. Install package: pvenn
ssc install pvenn

** 2. Prepare the data
sysuse auto

generate heavy=weight>3000

generate expensive=price>4000

label variable foreign "foreign"

** 3. Plot the graph
pvenn foreign heavy

graph export "proportional-venn.png", as(png) replace
	
* Have a lovely day!
