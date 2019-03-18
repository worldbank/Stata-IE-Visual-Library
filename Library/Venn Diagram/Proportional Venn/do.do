* Figure:  Venn diagram
    ** Install pvenn by searching this demand in the search bar and install
cd "{directory}"
	
sysuse auto

generate heavy=weight>3000

generate expensive=price>4000

label variable foreign "foreign"

pvenn foreign heavy

graph export "proportional-venn.png", as(png) replace
	
* Have a lovely day!
