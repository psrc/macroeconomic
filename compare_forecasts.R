library(tidyverse)
library(magrittr)
library(data.table)
library(odbc)
library(DBI)
library(tsbox)
library(ggplot2)

#-=======================================================================-
#   Forecast comparison scripts
#-=======================================================================-
#  Add additional comparisons/tests as we go
#  Initial comparison between PSRC/EcoNW 2018 & Woods&Poole 2020
#  Add others as they become available
#=-----------------------------------------------------------------------=

# PSRC/EcoNW import ------------------------------------------------------
elmer_connection <- dbConnect(odbc::odbc(),                                                        # Create the db connection
                              driver = 'SQL Server',
                              server = 'AWS-PROD-SQL\\Sockeye',
                              database = "Elmer",
                              trusted_connection = "yes",
                              port = 1433)
select_sql <- paste("WITH e AS (SELECT ef.data_year, ef.jobs/1000 AS emp",
                                   "FROM Macroeconomic.employment_facts AS ef",
                                   "WHERE ef.employment_sector_dim_id = 18),",
                          "p AS (SELECT pf.data_year, pf.population/1000 AS pop",
                                   "FROM Macroeconomic.pop_facts AS pf",
                                   "WHERE pf.pop_group_dim_id = 7)",
                     "SELECT e.data_year AS d_year, p.pop AS eco_totpop, e.emp AS eco_totemp",
                        "FROM e JOIN p ON e.data_year = p.data_year",
                        "ORDER BY e.data_year;")
eco_xrpt <- dbGetQuery(elmer_connection,SQL(select_sql)) %>% setDT() %>% setkey("d_year")
dbDisconnect(elmer_connection)

# Woods & Poole import ---------------------------------------------------
wp_eco <- list()
fread_wp <- function(filename){                                                                    # Function to read W&P -'ECO.CSV' files
  require(magrittr)
  wp_dir <- "J:/Projects/Forecasts/Regional/WoodsPooleProducts/2020 Forecast Product/"
  inpath <- paste0(wp_dir, filename)
  ret <- fread(inpath, sep=",", nrows=116, header=TRUE, na.strings=c('\"n.a.\"'),  skip=2, colClasses = c("character", rep("numeric", 82)), fill=TRUE) 
  ret[ret=="n.a."] <- NA
  ret %<>% transpose(keep.names="d_year", make.names=1) %>% .[,d_year:=as.integer(d_year)]
  return(ret)
}
wp_eco[[1]] <- fread_wp("KGECO.CSV") %>% .[,county_id:=33]
wp_eco[[2]] <- fread_wp("KTECO.CSV") %>% .[,county_id:=35]
wp_eco[[3]] <- fread_wp("PIECO.CSV") %>% .[,county_id:=53]
wp_eco[[4]] <- fread_wp("SNECO.CSV") %>% .[,county_id:=61]
wp_psrc <- rbindlist(wp_eco, use.names = TRUE) %>% .[,lapply(.SD, sum, na.rm=TRUE), by=d_year]     # Combine into Regional dataset
wp_xrpt <- wp_psrc[,c(1:2,18)] %>% setkey("d_year") %>% setnames(c(2:3),c("wp_totpop","wp_totemp"))

# Combined dataset & statistical operations ------------------------------
eco_wp <- wp_xrpt[eco_xrpt,on=.(d_year)] %>% .[d_year>=2015] #pivot_longer(-c("d_year"), names_to="series", values_to="d_value") 
ts_ecwp <- ts_ts(ts_long(eco_wp))
#ggplot(data = eco_wp, aes(x=d_year, y=d_value)) + geom_line(aes(colour=series))
ts_ggplot(ts_ecwp) 

