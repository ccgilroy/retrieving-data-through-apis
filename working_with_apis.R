#' ---
#' title: "Retrieving data through APIs"
#' author: "Connor Gilroy"
#' date: "`r Sys.Date()`"
#' output: 
#'   beamer_presentation: 
#'     theme: "metropolis"
#'     latex_engine: xelatex
#'     # fig_caption: false
#'     highlight: pygments
#'     df_print: kable
#' ---

#' ## APIs and why
#' 
#' This is a test
#' 


#' ## APIs vs web scraping
#' 
#' 

#' Structured way of one computer asking another computer for some resource over the internet.
#' 
#' You make a **request** and get a **response**.
#' 
#' There are standard *methods* defined by HTTP
#' 
#' These are verbs: GET, POST, PUT, DELETE...
#' 
#' headers, body, http statuses
#' 

#' ## Packages
#' 
#' Our main tool for interacting with APIs from R is the `httr` package: 
library(httr)

#' We need a package to help us work with JSON-formatted files:
library(jsonlite)

#' And we'll also functions from the tidyverse:
#+ warning=FALSE, message=FALSE
library(tidyverse)

#' ## A simple illustration

r <- GET("https://http.cat/200")
r

#' ## Looking at the response

status_code(r)

r_body <- content(r, as = 'raw')
head(r_body)
write_file(r_body, "200.jpeg")

#' ##  
#' 
#' ![source: http.cat](200.jpeg)
#'

#' ## Example 1: The US Census API
#' 
#' Question: What are the largest Census-designated places in the US?
#' 
#' 

#' ## Example 1: The US Census API
#' 
#' First, read in your API key from a config file: 
census_api_key <- read_lines("census_api_key.txt")

#' This is the base url for the 2015 5-year American Community Survey: 
acs_url <- "https://api.census.gov/data/2015/acs5"

#' ## Documentation
#' 
#' https://www.census.gov/data/developers/data-sets/acs-5year.html
#' 
#' examples: https://api.census.gov/data/2015/acs5/examples.html
#' 
#' all variables: https://api.census.gov/data/2015/acs5/variables.html
#' 
#' ## Using the documentation
#' 
#' What syntax do I use to make a request? 
#' 
#' For the Census API, we request variables through the `get` field. 
#' We specify different geographies with the `for` or `in` field, 
#' using `*` to get all locations of a particular type. 
#' 
#' What is the information I want called?
#' 
#' For total population, the estimate is a variable named `B01003_001E`, and
#' the margin of error is `B01003_001M`. We also want the `NAME` of each place.
#' 

#' ## Constructing a query 
#' 
#' We want to attach a query to the end of the url: 
#' 
#' https://url.com/data?q=query&key=YOURKEY
#' 
#' `httr` will do this for us if we put the fields we want into a list:
#' 
acs_query <- list(
  get = "B01003_001E,B01003_001M,NAME",
  `for` = "place:*",
  # "for" is a reserved keyword in R! 
  # You need backticks to use it as a name
  key = census_api_key
)

#' ## Request
acs_r <- GET(url = acs_url, query = acs_query)

#' ## Response
#' 
#' Look at the response. The body is a JSON array that looks like this: 
#' 
#' ```
#' [["B01003_001E","B01003_001M","NAME","state","place"],
#' ["52","52","Abanda CDP, Alabama","01","00100"],
#' ["2646","23","Abbeville city, Alabama","01","00124"],
#' ["4454","21","Adamsville city, Alabama","01","00460"],
#' ["682","154","Addison town, Alabama","01","00484"],
#' ["293","84","Akron town, Alabama","01","00676"],
#' ["31905","63","Alabaster city, Alabama","01","00820"],
#' ...
#' ```

#' ## Data processing
#' 
#' We want to turn this JSON object into a data frame, 
#' using `jsonlite::fromJSON`.
#' 
#' The first row contains the names of the columns; 
#' the remaining rows are values.
#' 
acs_m <- fromJSON(content(acs_r, as = "text"))
acs_df <- as_data_frame(acs_m[-1, ])
colnames(acs_df) <- acs_m[1, ]

#' ##
head(acs_df)

#' ## What are the 10 largest cities in the US?
#' 
acs_df <- 
  acs_df %>%  
  mutate(B01003_001E = as.numeric(B01003_001E), 
         B01003_001M = as.numeric(B01003_001M)) %>%
  arrange(desc(B01003_001E)) %>%
  select(-B01003_001M) 

#' ##
head(acs_df, 10)

#' ## Alternative: Specialized packages
#' 
#' for example, `tidycensus` for the Census
#' 
#' or `rtimes` for the New York Times
#' 
#' 
#' ## 
#' 
#' But...
#' 
#' - ...what if the API you want to use *doesn't* have a package?
#' - ...what if you want to access API functionality the package doesn't support?
#' 
#' ## Exercises
#'
#' 1. Request [some new piece of information] from [some API]. [link to documentation]
#' 
#' Use the 2016 1-year ACS to get the population of every state. What are the 5 smallest states?
#' 
#' url: https://api.census.gov/data/2016/acs/acs1
#' 
#' 2. Request [some other piece of information] from [other API]. [link]
#' 
#' 3. Challenge problem: sign up for a new API from here [link to Chris Bail]
