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

# Functions --------------------------------------------------------------

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
                                   "WHERE pf.pop_group_dim_id = 7),",
                         "h AS (SELECT hf.data_year, hf.households/1000 AS hhs",
                                   "FROM Macroeconomic.household_facts AS hf)",
                     "SELECT e.data_year AS d_year, p.pop AS eco_pop, e.emp AS eco_emp, h.hhs AS eco_hhs",
                        "FROM e JOIN p ON e.data_year = p.data_year",
                               "JOIN h ON e.data_year = h.data_year",
                        "ORDER BY e.data_year;")
eco_xrpt <- dbGetQuery(elmer_connection,SQL(select_sql)) %>% setDT() %>% setkey("d_year")          # Pull the EcoNW/PSRC forecast (2018)
dbDisconnect(elmer_connection)

# Woods & Poole import ---------------------------------------------------
wp_eco <- list()
wp_files <- c("KG","KT","PI","SN") %>% paste0("2020 Forecast Product/",.,"ECO.CSV")
fread_wp <- function(filename){                                                                    # Function to read W&P -'ECO.CSV' files
  wp_dir <- "J:/Projects/Forecasts/Regional/WoodsPooleProducts/"
  inpath <- paste0(wp_dir, filename)
  ret <- fread(inpath, sep=",", nrows=116, header=TRUE, na.strings=c('\"n.a.\"'), skip=2, 
               colClasses = c("character", rep("numeric", 82)), fill=TRUE) %>%
         transpose(keep.names="d_year", make.names=1) %>% .[,d_year:=as.integer(d_year)]
  return(ret)
}
wp_eco[1:4] <- lapply(wp_files,fread_wp)
wp_psrc <- rbindlist(wp_eco, use.names = TRUE) %>% .[,lapply(.SD, sum, na.rm=TRUE), by=d_year]     # Aggregate to regional level
wp_xrpt <- wp_psrc[,c(1:2,18,92)] %>% setkey("d_year") %>% setnames(c(2:4),c("wp_pop","wp_emp","wp_hhs"))

wp_usfile <- "2020 Forecast Product/USECO.CSV"
wp_us <- fread_wp(wp_usfile)
wp_usxrpt <- wp_us[,c(1:2,18,87,92)] %>% setkey("d_year") %>% setnames(c(2:5),c("wp_uspop","wp_usemp","wp_usgdp","wp_ushhs"))

# Combined dataset & statistical operations ------------------------------
eco_wp <- wp_xrpt[eco_xrpt,on=.(d_year)] %>% .[d_year>=2015]                                       # Combine two forecasts in one table
ts_ecwp <- ts_ts(ts_long(eco_wp))                                                                  # Covert to time-series object
ts_ggplot(ts_ecwp)                                                                                 # Plot time-series



