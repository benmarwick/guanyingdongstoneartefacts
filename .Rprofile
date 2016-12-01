#### -- checkpoint Autoloader  -- ####

# set date
my_date <- "2016-11-30"

# run checkpoint
checkpoint::checkpoint(my_date, 
                       use.knitr = TRUE, 
                       checkpointLocation = getwd())
# force repos to MRAN
options(repos = c(CRAN = paste0("https://mran.revolutionanalytics.com/snapshot/",
                                my_date)))
#### -- End checkpoint Autoloader -- ####
