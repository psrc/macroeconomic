library(tidyverse)
library(magrittr)
library(data.table)
library(odbc)
library(DBI)
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

prfx <- c("eco_","wp_","psef_")                                                                    # Prefixes for individual forecasts
regvars <- c("pop","emp","hhs")                                                                    # Regional variables
natvars <- c("uspop","uspop16","usemp","usgdp","ushhs")                                            # National variables
regvar_sets <- list(paste0(prfx, "pop"),paste0(prfx[1:2],"hhs"),paste0(prfx,"emp"))                # Variable groupings to show together
natvar_sets <- list(paste0(prfx[2:3], "uspop"),paste0(prfx, "usemp"),paste0(prfx, "usgdp"))

# Functions --------------------------------------------------------------
  logdiff <- function(xvar){
    ret <- c(diff(log(xvar),lag=1),NA)                                                             # Log first difference
    return(ret)
  }
  
  batch_plot <- function(dset, varsets){
    dsplit <- lapply(varsets, function(x){dset[,c("d_year",..x)]}) %>%                             # Split the dataset to a list of datasets
              lapply(ts_long) %>% lapply(ts_ts)                                                    # Convert to time series
    ret <- lapply(dsplit, ts_ggplot)                                                               # Plot
    return(ret)
  }

# PSRC/EcoNW import ------------------------------------------------------
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
  
  eco_usfile <- paste0("J:/Projects/Forecasts/Regional/2017/e.Final_forecast/",
                       "Raw_Output/Final/Eviews workfiles/fm_smoothed.csv")                          # National series exported from eViews workfile
  eco_usxrpt <- fread(eco_usfile, header=TRUE) %>% 
                setnames(c("_date_","pop_0", "e_0","gdpr_0"),c("d_year", paste0("eco_",regvars))) %>% 
                .[,d_year:=year(d_year)] %>% setkey(d_year) %>% .[,.(d_year, eco_uspop16, eco_usemp, eco_usgdp)]
  rm(elmer_connection, select_sql, eco_usfile)

# Woods & Poole import ---------------------------------------------------
  wp_eco <- list()
  wp_files <- c("KG","KT","PI","SN") %>% paste0("2020 Forecast Product/",.,"ECO.CSV")
  fread_wp <- function(filename){                                                                  # Function to read W&P -'ECO.CSV' files only
    wp_dir <- "J:/Projects/Forecasts/Regional/WoodsPooleProducts/"
    inpath <- paste0(wp_dir, filename)
    ret <- fread(inpath, sep=",", nrows=116, header=TRUE, na.strings=c('\"n.a.\"'), skip=2, 
                 colClasses = c("character", rep("numeric", 82)), fill=TRUE) %>%
           transpose(keep.names="d_year", make.names=1) %>% .[,d_year:=as.integer(d_year)]
    return(ret)
  }
  wp_eco[1:4] <- lapply(wp_files,fread_wp)
  wp_psrc <- rbindlist(wp_eco, use.names = TRUE) %>% .[,lapply(.SD, sum, na.rm=TRUE), by=d_year]   # Aggregate to regional level
  wp_xrpt <- wp_psrc[,c(1:2,18,92)] %>% setkey("d_year") %>% setnames(c(2:4), paste0("wp_", regvars))
  
  wp_usfile <- "2020 Forecast Product/USECO.CSV"
  wp_us <- fread_wp(wp_usfile)                                                                     # Similar for National forecast
  wp_usxrpt <- wp_us[,c(1:2,11,18,88,93)] %>% setkey("d_year") %>% 
               setnames(c(2:6),c(paste0("wp_", natvars))) %>%
               .[,lapply(.SD, function(x) {y=x/1000}), by=d_year]
  rm(wp_files, fread_wp, wp_eco, wp_usfile)

# PSEF import ------------------------------------------------------------
  psef_file <- "Annual_Forecast_0918.xls"
  psef_read <- function(file, psefrange, series_select){                                           # Function to read PSEF from network file
      psef_dir <- "J:/Projects/Forecasts/Regional/PSEFProducts/"
      ret <- read_excel(paste0(psef_dir, file), range=psefrange, col_names=TRUE) %>% setDT() %>% 
             transpose(keep.names="d_year", make.names=1) %>% setnames(series_select, names(series_select)) %>% 
             .[,d_year:=as.integer(d_year)] %>% .[,c("d_year", names(..series_select))] %>% setkey("d_year")
  }
  psef_series <- c("Population (thous.)","Employment (thous.)")                                      
  names(psef_series) <- c("psef_",regvars[1:2])
  psef_xrpt <- psef_read(psef_file, "Region!A10:BH44", psef_series)                                # PSEF Regional
  
  psef_usseries <- c("Population (mils.)","Employment (mils.)","Gross Domestic Product (bils. $12)")
  names(psef_usseries) <- c(paste0("psef_",natvars[1,3:4]))
  psef_usxrpt <- psef_read(psef_file, "United States!A10:BH30", psef_usseries)                     # PSEF National
  #rm(psef_file, psef_read, psef_series, psef_usseries)

# Combined dataset & statistical operations ------------------------------
  regnl <- psef_xrpt[wp_xrpt,on=.(d_year)] %>% .[eco_xrpt,on=.(d_year)] %>% .[d_year>=2015]        # Combine regional forecasts in one table
  natnl <- psef_usxrpt[wp_usxrpt,on=.(d_year)] %>% .[eco_usxrpt,on=.(d_year)] %>% 
    .[d_year>=2015]
  regnl_rates <- regnl[,colnames(regnl[,-1]):=lapply(.SD,logdiff),.SDcols=!c("d_year")]            # Create rates (log first differences) dataset
  natnl_rates <- natnl[,colnames(natnl[,-1]):=lapply(.SD,logdiff),.SDcols=!c("d_year")]
  regnl_plot <- batch_plot(regnl, regvar_sets)                                                     # Create plots (levels)
  natnl_plot <- batch_plot(natnl, natvar_sets)
  regnl_rate_plot <- batch_plot(regnl_rates, regvar_sets)                                          # Create plots (rates)       
  natnl_rate_plot <- batch_plot(natnl_rates, natvar_sets)

  do.call(grid.arrange, c(regnl_plot))                                                             # Display the specific plot
  do.call(grid.arrange, c(natnl_plot))
  do.call(grid.arrange, c(regnl_rate_plot))
  do.call(grid.arrange, c(natnl_rate_plot))