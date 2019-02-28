# How to contribute:
If you have suggestions of plots you would like to see in this library and are not currently here, you can open an issue describing your suggestion.

If you have some nice looking graphs you would like to add to this library and are familiar with how GitHub works, please feel free to make a fork and submit a pull request *to the develop branch* for any additions you want to make, but please read the **Visual library contribution conventions** section below first. If you are new to GitHub, start by reading the **Bug reports and feature requests** section below. Note that the folder structure used here consist of broad plot categories with individual folders for each plot. Each individual folder contains (1) the de-identified data used to create the plot and (2) the code that creates the plots from such data. .png files should not be loaded in these folders. The image will be added directly to the GitHub page.

If you have some nice looking graphs you would like to add to this library and are not familiar with how GitHub works, you can send an e-mail to dimeanalytics@worldbank.org with a zipped folder containing (1) the de-identified data used to create the plot and (2) the code that creates the plots from such data.


## Bug reports and feature requests
An easy but still very efficient way to provide any feedback on these commands that does not require any GitHub knowledge is to create an *issue*. You can read *issues* submitted by other users or create a new *issue* [here](https://github.com/worldbank/Stata-IE-Visual-Library/issues). While the word *issue* has a negative connotation outside GitHub, it can be used for any kind of feedback. If you have an idea for a new command, or a new feature on an existing command, creating an *issue* is a great tool for suggesting that to us. Please read already existing *issues* to check whether someone else has made the same suggestion or reported the same error before creating a new *issue*.


# Visual library contribution conventions
In addition to using common GitHub practices, please follow these conventions to make it possible to keep an overview of the progress made to the code in this toolkit.


## Branch naming conventions
Please make pull requests to the `master` branch **only** if you wish to contribute to README, LICENSE or similar meta data files. If you wish to make a contribution to any Stata file, then please **do not** use the `master` branch. If you wish to make a contribution to any Stata files that we have published at least once, then please fork from and make your pull request to the `develop` branch. The `develop` branch includes all minor edits we have made to already published commands since the last release that we will include in the next version released on the SSC server. If your addition is related to a specific issue in the repository, then create a new branch named after the repository, for example `Bar plot of multiple variables: adding graphs`. 


## Data visualization folder conventions
If you have a visualization code, please create a folder that contains: data necessary for code replication (ado. file (if applicable), .dta file and .do file), any other file necessary (excel, shape file, etc.) Please name the folder the description of the visualization, for example `Scatter plot with fitted line`. Please name the .do file `do.do`, .dta file `data.dta`, `data2.dta` etc. (.ado file name does not have to be changed.) In the .do file, first set the directory by `cd "{directory}"`, and then use `use` or `do` command to run other files. 


## Folder location convention
Place the folder created under the same category, for example, if the code is for line plots, locate the folder under `Line plots` folder in the `Library`. If none of the existing folder fits the category, create new folder with name of the type of visualization. 
