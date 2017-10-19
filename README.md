# Retrieving data from APIs

Connor Gilroy, University of Washington

This module teaches you how to access demographic data using web APIs and
the `httr` package. It uses two examples of accessing conventional data 
sources through the web, the US Census and the World Bank. 

The activities in this module will set you up to better understand how to 
access social media data in subsequent modules, and it will facilitate making comparisons between the different sources of data.

## Using this module

The easiest way to work with this module is as an "R Project." To do this, 
open the folder that you downloaded from Dropbox or Github and click on the
`working_with_apis.Rproj` file (not the .R file!). This will open the R Project
in RStudio, and make it convenient to access all of the files you need.

See this page for more information on R Projects in RStudio:

https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects

## Getting a Census API key

In order to be allowed to access data from the US Census through their APIs, 
you need an API key. This is an identifier unique to you, like a password, 
and it should be kept secret. 

Anyone can request a key, and the process is simple and fast.

1. Request an API key from the Census using the form here:  

    https://api.census.gov/data/key_signup.html  
    
    You'll need to provide an email address and an organization name, 
    and agree to the terms of service. You can use your university or 
    other institution as the organization name. 
    
2. You will receive an email after submitting the form. Use the link in 
    the email to activate your key. 
    
3. Now, you need to put your key in a place where you can use it in your code. 
    The best practice is to store it in a separate file from your code. We've
    made a file called "EXAMPLE_census_api_key.txt" for this purpose. 
    
    Open the EXAMPLE_census_api_key.txt file and replace the text with your 
    API key.
    
4. Finally, **RENAME** the file to "census_api_key.txt" by removing the
    "EXAMPLE_" from the beginning of the file name. 
    
    This is important because the code expects the file with the key to be
    named "census_api_key.txt." (Why did we do it this way? It helps keep the
    contents of the file a secret. If you use git, check out the .gitignore 
    file to see how.)

