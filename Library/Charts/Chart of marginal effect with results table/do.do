* Figure: Chart of primary regression results for a variable list, combined with a table detailing those results

 	cd "{directory}"

	qui do "chartable.ado"
	
	use "data.dta" , clear
	
	label var as_correct "Asthma: Inhaler/Bronchodilator"
	label var ch_correct "Child Diarrhoea: ORS"
	label var cp_correct "Chest Pain: Referral/Aspirin/ECG"
	label var tb_correct "Tuberculosis: AFB Smear"

	chartable ??_correct refer med_any med_class_any_6 med_class_any_16 ///
		, xsize(8) rhs(facility_private i.case_code) command(logit) or p case0(Public) case1(Private)
		
		graph export "figure.png" , replace width(2000)
	
				
* Have a lovely day!
* set the yhat constant, and re-sample error via bootstrap and add that to the yhat with randomly assigned error to calculate more accurate noise pattern 


*Power calculation: 
* wanna

