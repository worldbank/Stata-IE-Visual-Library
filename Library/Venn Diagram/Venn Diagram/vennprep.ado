* Venn prep
* Prepares data for Venn generator at:
* http://www.pangloss.com/seidel/Protocols/venn4.cgi

cap prog drop vennprep
prog def vennprep

syntax anything
count
	local theN = `r(N)'

unab theVarlist : `anything'

* Set up

	tempvar uid
	gen `uid' = _n

	tempvar n

	tempfile theData
		save `theData'

	* Variables

		foreach var in `theVarlist' {
			use `theData' , clear

			keep `var' `uid'
			gen `var'_new = `uid'
			keep if `var' == 1

			tempvar `var'n
			gen `n' = _n

			tempfile `var'
				save ``var''
			}

* stack

	clear
	set obs `theN'

	gen `n' = _n

	foreach var in `theVarlist' {
		merge 1:1 `n' using ``var'' , nogen
	}

end

*
