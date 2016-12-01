#### -- set repos to MRAN  -- ####

# set date
my_date <- "2016-11-30"

my_MRAN <- paste0("https://mran.revolutionanalytics.com/snapshot/",
                  my_date)

# force repos to MRAN
options(repos = c(CRAN = my_MRAN))




#### -- End set repos to MRAN -- ####
#### -- Packrat Autoloader (version 0.4.8-1) -- ####
source("packrat/init.R")
#### -- End Packrat Autoloader -- ####

packrat::set_opts(local.repos = my_MRAN)
