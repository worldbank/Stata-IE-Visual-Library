### Data Visualization Library Submission Checklist

## 1. Create a folder that contains data necessary for code replication. The folder should contain data for only one type of visualization per folder.

	Name of the folder should be the description of the visualization, 
	e.g. "Scatter plot with fitted line", "Bar plot of two variables".

In the folder there should be:
	- do.file 						(conventionally: file name 		"do.do"							)

	- dta 							(conventionally: file name 		"data.dta", "data2.dta", etc.	)

	- visualization output 			(conventionally: file name 		"figure.png"
													 file format	"png"							)

	- Any other file necessary for replication (ado, excel etc.)


## 2. Standardize do.file direcotry
As all files are in one folder, do.file should first set the current directory. Then run commands from the current directory.

--------------------------------
--------------------------------
Example:

cd "{directory}"
use "data.dta", clear

twoway ......

gr export "figure.png", width(5000) replace

--------------------------------
--------------------------------

## 3. Move the folder with all the file
There will be different type of visualization folders. Add the file under the category that best matches the folder. If it is a new type of file, create a new folder with type of visualization. e.g. "Box plot"

## 4. Update the README.md under "doc"  