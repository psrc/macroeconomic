library(tidyverse)
library(magrittr)
library(data.table)
library(tsbox)
library(ggplot2)
library(readxl)
library(stringr)
library(gridExtra)

#-=======================================================================-
#   Forecast comparison scripts
#-=======================================================================-
#  Add additional comparisons/tests as we go
#  Initial comparison between PSRC/EcoNW 2018 & Woods&Poole 2020
#  Add others as they become available
#=-----------------------------------------------------------------------=

# User settings
plot_start_year <- 2010
pdf_file <- "MEF_comparison.pdf" # set this to NULL if no pdf is desired
pdf_file <- NULL

# settings for getting the data
connect_to_elmer <- FALSE
data_base_dir <- "J:/Projects/Forecasts/Regional"
data_base_dir <- "~/J/Projects/Forecasts/Regional"
eco_usfile <- file.path(data_base_dir, "2017/e.Final_forecast/Raw_Output/Final/Eviews\ workfiles", "fm_smoothed.csv") # National series exported from eViews workfile
eco_file <- "eco_xrpt.csv" # not used if connect.to.elmer is TRUE
wp_dir <- file.path(data_base_dir, "WoodsPooleProducts") # Woods & Poole directory
psef_dir <- file.path(data_base_dir, "PSEFProducts")

prfx <- c("eco_","wp_","psef_")                                                                    # Prefixes for individual forecasts
regvars <- c("pop","emp","hhs")                                                                    # Regional variables
natvars <- c("uspop","uspop16","usemp","usgdp","usdratio","ushhs")                                            # National variables
regvar_sets <- list(Population = paste0(prfx, "pop"), Households = paste0(prfx[1:2],"hhs"), 
                    Employment = paste0(prfx,"emp"), 
                    HouseholdSize = c(paste0(prfx[1:2],"hhsize"), paste0(prfx[2], "ushhsize")))   # Variable groupings to display together
natvar_sets <- list(Population = c(paste0(prfx[2:3], "uspop"), paste0(prfx[1:2], "uspop16")), 
                    Employment = paste0(prfx, "usemp"), 
                    GDP = paste0(prfx, "usgdp"), 
                    DepRatio = paste0(prfx[1:2],"usdratio"))

  
# Functions --------------------------------------------------------------
  logdiff <- function(xvar){
    ret <- c(diff(log(xvar),lag=1),NA)                                                             # Log first difference
    return(ret)
  }
  
  batch_plot <- function(dset, varsets, titles = NULL){
    dsplit <- lapply(varsets, function(x){dset[,c("d_year",..x)]}) %>%                             # Split the dataset to a list of datasets
              lapply(ts_long) %>% lapply(ts_ts)                                                    # Convert to time series
    ret <- mapply(function(j, m){
                            ts_ggplot(j, title = m) + xlab(NULL) + theme(legend.title = element_blank())
                          }, dsplit, titles, SIMPLIFY = FALSE)
    return(ret)
  }

# PSRC/EcoNW import ------------------------------------------------------
if(connect_to_elmer) {
  library(odbc)
  library(DBI)
  elmer_connection <- dbConnect(odbc::odbc(),                                                      # Create the db connection
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
  rm(elmer_connection, select_sql)
} else {
  eco_xrpt <- fread(eco_file)  %>% setkey("d_year") 
}
  
  eco_xrpt[, eco_hhsize := eco_pop/eco_hhs]
# load national series
  eco_usvars <- c("d_year", paste0("eco_", natvars[2:5]))
  eco_usxrpt <- fread(file = eco_usfile, header=TRUE) %>% 
                setnames(c("_date_", "pop_0", "e_0","gdpr_0","pctpopworkage1664"), eco_usvars) %>%
                .[,d_year:=year(d_year)] %>% setkey(d_year) %>% .[,..eco_usvars]
  
# Woods & Poole import ---------------------------------------------------
  wp_eco <- list()
  wp_files <- c("KG","KT","PI","SN") %>% paste0("2020\ Forecast\ Product/",.,"ECO.CSV")
  fread_wp <- function(filename){                                                                  # Function to read W&P -'ECO.CSV' files only
    inpath <- file.path(wp_dir, filename)
    ret <- fread(inpath, sep=",", nrows=116, header=TRUE, na.strings=c('\"n.a.\"'), skip=2, 
                 colClasses = c("character", rep("numeric", 82)), fill=TRUE) %>%
           transpose(keep.names="d_year", make.names=1) %>% .[,d_year:=as.integer(d_year)]
    return(ret)
  }
  wp_eco[1:4] <- lapply(wp_files,fread_wp)
  wp_psrc <- rbindlist(wp_eco, use.names = TRUE) %>% .[,lapply(.SD, sum, na.rm=TRUE), by=d_year]   # Aggregate to regional level
  wp_xrpt <- wp_psrc[,c(1:2,18,92)] %>% setkey("d_year") %>% setnames(c(2:4), paste0("wp_", regvars))
  wp_xrpt[, wp_hhsize := wp_pop/wp_hhs]
  wp_usfile <- "2020 Forecast Product/USECO.CSV"
  wp_rawus <- c("TOTAL POPULATION (in thousands)",
                "  TOTAL POPULATION AGE 65 YEARS and OVER (in thousands)",
                "  TOTAL POPULATION AGE 16 YEARS and OVER (in thousands)",
                "TOTAL EMPLOYMENT (in thousands of jobs)",
                "GROSS REGIONAL PRODUCT (in millions of 2012 dollars)",
                "TOTAL NUMBER of HOUSEHOLDS (in thousands)") 
  wp_us <- fread_wp(wp_usfile)                                                                     # Similar for National forecast
  wp_usxrpt <- wp_us[,c("d_year",..wp_rawus)] %>% setkey("d_year") %>% 
               .[,lapply(.SD, function(x) {y=x/1000}), by=d_year] %>%
               setnames(wp_rawus[1:3],c("wp_uspop","wp_uspop65","wp_uspop16")) %>%
               .[,wp_usdratio:= (wp_uspop16 - wp_uspop65)/wp_uspop] %>% .[,wp_uspop65:=NULL] %>%
               setnames(wp_rawus[4:6],c(paste0("wp_", c("usemp","usgdp","ushhs"))))
  wp_xrpt[wp_usxrpt, wp_ushhsize := i.wp_uspop/i.wp_ushhs, on = "d_year"]
  rm(wp_files, fread_wp, wp_eco, wp_usfile)

# PSEF import ------------------------------------------------------------
  psef_file <- "Annual_Forecast_0918.xls"
  psef_read <- function(file, psefrange, series_select){                                           # Function to read PSEF from network file
      ret <- read_excel(path.expand(file.path(psef_dir, file)), range=psefrange, col_names=TRUE) %>% setDT() %>% # using path.expand fixes a weird error on Mac
             transpose(keep.names="d_year", make.names=1) %>% setnames(series_select, names(series_select)) %>% 
             .[,d_year:=as.integer(d_year)] %>% .[,c("d_year", names(..series_select))] %>% setkey("d_year")
  }
  psef_series <- c("Population (thous.)","Employment (thous.)")                                      
  names(psef_series) <- c(paste0("psef_",regvars[1:2]))
  psef_xrpt <- psef_read(psef_file, "Region!A10:BH44", psef_series)                                # PSEF Regional
  
  psef_usseries <- c("Population (mils.)","Employment (mils.)","Gross Domestic Product (bils. $12)")
  names(psef_usseries) <- c(paste0("psef_",c("uspop","usemp","usgdp")))
  psef_usxrpt <- psef_read(psef_file, "United States!A10:BH30", psef_usseries)                     # PSEF National
  #rm(psef_file, psef_read, psef_series, psef_usseries)

# Combined dataset & statistical operations ------------------------------
  regnl <- psef_xrpt[wp_xrpt,on=.(d_year)] %>% .[eco_xrpt,on=.(d_year)] %>% .[d_year>=plot_start_year]        # Combine regional forecasts in one table
  natnl <- psef_usxrpt[wp_usxrpt,on=.(d_year)] %>% .[eco_usxrpt,on=.(d_year)] %>% 
    .[d_year>=plot_start_year]
  regnl_r8 <- copy(regnl) %>% .[,colnames(regnl[,-1]):=lapply(.SD,logdiff),.SDcols=!c("d_year")]   # Create rates (log first differences) dataset
  natnl_r8 <- copy(natnl) %>% .[,colnames(natnl[,-1]):=lapply(.SD,logdiff),.SDcols=!c("d_year")]
  regnl_plot <- batch_plot(regnl, regvar_sets, titles = paste("Regional totals", names(regvar_sets), sep = " - "))                                                   # Create plots (levels)
  natnl_plot <- batch_plot(natnl, natvar_sets, titles = paste("National totals", names(natvar_sets), sep = " - "))
  regnl_r8plot <- batch_plot(regnl_r8, regvar_sets, titles = paste("Regional first log diff", names(regvar_sets), sep = " - "))                                             # Create plots (rates)       
  natnl_r8plot <- batch_plot(natnl_r8, natvar_sets, titles = paste("National first log diff", names(natvar_sets), sep = " - "))

  
  if(!is.null(pdf_file)) pdf(pdf_file, width = 10, height = 6)
  # Display the specific plot
  do.call(grid.arrange, c(regnl_plot))   
  do.call(grid.arrange, c(regnl_r8plot))
  do.call(grid.arrange, c(natnl_plot))
  do.call(grid.arrange, c(natnl_r8plot))
  
  if(!is.null(pdf_file)) dev.off()