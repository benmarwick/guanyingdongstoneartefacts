#### -- checkpoint Autoloader  -- ####

# set date
my_date <- "2016-11-30"


# force repos to MRAN
options(repos = c(CRAN = paste0("https://mran.revolutionanalytics.com/snapshot/",
                                my_date)))

# knitr bug
if("knitr" %in% rownames(installed.packages()) == FALSE) {install.packages("knitr")}

# run checkpoint
checkpoint::checkpoint(my_date, 
                       use.knitr = TRUE, 
                       auto.install.knitr = TRUE,
                       checkpointLocation = getwd())

#### -- End checkpoint Autoloader -- ####
