// Making a map

global directory "/Users/bbdaniels/GitHub/Stata-IE-Visual-Library/Library/Maps/World map/"

// Import data
shp2dta ///
  using "${directory}/gis/ne_50m_admin_0_countries.shp" ///
  , data("${directory}/dta/worlddbf.dta") ///
    coor("${directory}/dta/world.dta") replace

// Make the map


  use "${directory}/dta/Map_Stats.dta", clear

  spmap tpc using "${directory}/dta/world.dta" if _ID!=12, id(_ID) ///
  	title("Total Publications per Million Citizens") clmethod(custom) clbreaks(0 1 3 10 100 120) fcolor(RdYlGn)

  	graph export "${directory}/Total.eps", replace

  spmap fpc using "${directory}/dta/world.dta" if _ID!=12, id(_ID) ///
  	title("First-Tier Publications per Million Citizens") clmethod(custom) clbreaks(0 .05 .5 1 4 8) fcolor(RdYlGn)

  	graph export "${directory}/First.eps", replace

// Have a lovely day!
