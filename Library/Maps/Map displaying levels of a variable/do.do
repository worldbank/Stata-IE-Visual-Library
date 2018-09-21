* Maps displaying levels of a variable

* ------------------------------------------------------------------------------
* 	Packages
* ------------------------------------------------------------------------------

	ssc install spmap
	ssc install shp2dta

* ------------------------------------------------------------------------------
* 	Data
* ------------------------------------------------------------------------------

	cd "{directory}"

	*Shapefiles 
	cap erase world_shape.dta
	cap erase world_shape_coord.dta
	shp2dta using "ne_110m_admin_0_countries.shp", database(world_shape) ///		//Source: http://www.naturalearthdata.com/downloads/110m-cultural-vectors/
	coordinates(world_shape_coord) genid(id)

	*Correct iso_a2
	use  world_shape, clear
	drop if iso_a2=="-99"

	merge 1:1 iso_a2 using data, keep(1 3) nogen

* ------------------------------------------------------------------------------
* 	Map
* ------------------------------------------------------------------------------

	spmap jobs_scarce_code using world_shape_coord if admin!="Antarctica", id(id) ///
	fcolor(Reds) osize(.1) ocolor(black) ///
	clmethod(custom)  clbreaks(0 .2 .40 .6 .8 1)  ///
	legend(position(8) ///
	region(lcolor(black)) ///
	label(1 "No data") ///
	label(2 "0% to 20%") ///
	label(3 "20% to 40%") ///
	label(4 "40% to 60%") ///
	label(5 "60% to 80%") /// 
	label(6 "80% to 100%")) ///
	legend(region(color(white))) ///
	plotregion(icolor(bluishgray)) ///
	title("When jobs are scarce, men should have more of a right to a job than women.") ///
	subtitle("Agreement with the statement above by country") ///
	note("Source: World Values Survey (2014 or last available year)") ///
	saving(map, replace)
	graph export map.png, as(png)  replace

* Have a lovely day!
