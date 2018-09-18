## 1. Install sublime text 3
Follow instructions on: https://github.com/mattiasnordin/StataEditor
*hint* Under section "Requirements and Setup", step 5: Even though I use Windows10, I needed to follow the instruction for Windows Vista.

## 2. Install anaconda navigator
Follow instructions on: https://kylebarron.github.io/stata_kernel/getting_started/#configuration to download Anaconda Navigator
*hint* After installing Anaconda, command prompt you need to use is the Anaconda command prompt.
The Jupyter should work through Anaconda Navigator application, by choosing Jupyter and click "Launch". This should open a window in your default web browser.

## 3. Package Install
Continue following instructions on the website from step 2. 

## 4. Configuration
With sublime text 3 already working with Stata, steps from section "Configuration" onwards should be unnecessary, except to change graph option.
To locate .stata_kernel.conf, open annaconda prompt, and type "cd". This will show where your home base directory is. (should be the same as where anaconda package is stored.)
Within the location, find ".stata_kernel.conf". 
Open the file with sublime text 3, change graph to png, by changing the line to "graph_format = png". Save and close.

## 4. Check installation
Open jupyter notebook, click "new" on the top right and see if option "Stata" is there. Click on it to start the jupyter notebook.
