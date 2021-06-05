library(tidyverse)
library(magrittr)
library(data.table)
library(bea.R)
library(blsAPI)
library(odbc)
library(DBI)
library(readxl)
library(httr)
library(censusapi)

#-=======================================================================-
#   Data development procedure for Macroeconomic Forecast Model inputs
#-=======================================================================-
#  combines data from:
#  - BEA --- from 1990; release lags by 
#  - BLS --- from 1996; release lags by 5mo (employment), 2mo (cpi, unemployment)
#  - DOR --- file format changed in 2008 (note: url, xls/x not fully consistent)
#  - DOL --- categories shifted late 2016 aka consistent since 2017
#
#  Must set environment variables BLS_KEY, BEA_KEY prior to execution 
#=-----------------------------------------------------------------------=

data_year <- 2019
psrc_fips <- c("033","035","053","061")
psrc_counties <- c("King","Kitsap","Pierce","Snohomish")

# Functions --------------------------------------------------------------

fetch_bea <- function(tblname,linecode, fipsgeo){
  require(bea.R)
  fipsg <- paste0("53", fipsgeo, collapse=",")
  bea_payload <- list(
    "UserID" = Sys.getenv("BEA_KEY"),
    "Method" = "GetData",
    "datasetname" = "Regional",
    "TableName" = tblname,
    "Linecode" = linecode,
    "Geofips" = fipsg,
    "Frequency" = "Q",
    "Year" = "ALL",
    "ResultFormat" = "json"
  );
  ser <- beaGet(bea_payload, asWide=FALSE) %>% setDT() %>% 
         .[,.(GeoFips, TimePeriod, DataValue)] %>% setnames(c("geo", "data_year", "value"))
  return(ser)
}

fetch_dol <- function(dyear){
  require(data.table)
  opyear <- dyear
  counter <- 1
  psrc_counties <- c("17","18","27","31")
  dol_chunks <- list()
  while(opyear > 2016){
    dol_chunks[[counter]] <- fread(paste0("https://fortress.wa.gov/dol/vsd/vsdFeeDistribution/cache/", opyear,"C00-63.csv")) %>%
                             .[get("Fuel Type") !="None" & str_sub(County,1,2) %in% psrc_counties] %>% .[,data_year:=opyear]
    opyear  <- opyear  - 1
    counter <- counter + 1
    }
  veh <- rbindlist(dol_chunks, use.names=TRUE)
  return(veh)
}

fetch_dor <- function(dyear){
  require(data.table, httr, readxl)
  opyear <- dyear
  counter <- 1
  psrc_counties <- c("17","18","27","31")
  dor_chunks <- list()
  while(opyear > 2007){
    ref_set <- case_when(opyear==2019 ~c("R", "19", "vs","CAL"), TRUE ~c("r", toString(opyear), "VS", "Cal"))
    xl_type <- case_when(opyear %in% c(2008,2011,2012) ~".xls",TRUE ~".xlsx")
    url <- paste0("https://dor.wa.gov/sites/default/files/legacy/Docs/", ref_set[1],"eports/", opyear, "/lrtcal", ref_set[2], 
           "/TRS_RTL_", ref_set[3], "_TOT_COUNTY_",ref_set[4], opyear, xl_type)
    GET(url, write_disk(tf <- tempfile(fileext = xl_type)))
    dor_chunks[[counter]] <- read_excel(tf, range="A7:D45", col_names=FALSE, skip=6) %>% setDT() %>% .[...1 %in% psrc_counties,.(...1,...4)] %>%  
                             setnames(c("county_id","sales_value")) %>% .[, data_year:=opyear]
    unlink(tf)
    opyear  <- opyear  - 1
    counter <- counter + 1
  }
  sales <- rbindlist(dor_chunks, use.names=TRUE)
  return(sales)
}

# BLS: employment (CES), unemployment (LAUS), CPI ------------------------
bls_payload <- list("seriesid"= c(unlist(paste0("LAUCN53", psrc_fips,"0000000004")),               # unemployment by county
                                  unlist(paste0("LAUCN53", psrc_fips,"0000000006")),               # labor force by county
                                 "CUURS49DSA0"),                                                   # consumer price index CPI-U Seattle-Bellevue-Everett MSA
                    "startyear"=1990, "endyear"=data_year,"registrationKey"=Sys.getenv("BLS_KEY")) # 1990 is earliest available
bls <- blsAPI(bls_payload, api_version=2, return_data_frame=TRUE) %>% setDT(bls_series) %>% setnames("year", "data_year") %>%
       .[, `:=`(county_id=str_sub(seriesID,8,10), series=paste0("var", str_sub(seriesID,-1L)), data_quarter=(as.integer(str_sub(period,2,3))%/%4+1))] %>% 
       .[, mean(as.integer(value)), by=.(county_id, series, data_year, data_quarter)] %>% setkey(county_id, data_year, data_quarter) %>%
       # pivot_wider(names_from=series, values_from=V1) %>% .[, lapply(.SD, sum, na.rm=TRUE), by=key(.)]
rm(bls_payload)

# BEA: personal income, wages & salary -----------------------------------
bea_chunks <- list()
bea_chunks[[1]] <- fetch_bea("CAINC4", 10, psrc_fips) %>% .[,series:="pinc"]                       # personal income by county
bea_chunks[[2]] <- fetch_bea("CAINC4", 50, psrc_fips) %>% .[,series:="wage"]                       # wage  &  salary by county
bea_chunks[[3]] <- fetch_bea("CAINC4", 10, "000")     %>% .[,series:="pinc"]                       # personal income - statewide
bea_chunks[[4]] <- fetch_bea("CAINC4", 50, "000")     %>% .[,series:="wage"]                       # wage  &  salary - statewide
bea <- rbindlist(bea_chunks, use.names=TRUE) # %>% pivot_wider(names_from=series, values_from=values)
rm(bea_chunks)

# DOR: retail sales ------------------------------------------------------
dor <- fetch_dor(data_year)                                                                        # taxable retail sales by county
                                     
# DOL: vehicle counts ----------------------------------------------------
dol <- fetch_dol(data_year)                                                                        # vehicle counts by county and type

# Census population projections ------------------------------------------
popproj <- getCensus(name = "popproj/pop", vintage = 2017,                                         # national population projections by age (single year)
           vars = c("SEX","RACE","SCENARIO","AGE","HISP","DATE_CODE","POP"), region = "us:*", key=Sys.getenv("CENSUS_API_KEY")) %>% 
           setDT() %>% .[,year:=(as.integer(DATE_CODE)+2007)] %>% .[SCENARIO=="M" & RACE==0 & HISP==0 & SEX==0 & AGE !=999,] %>% 
           .[,c("SCENARIO","RACE","HISP","SEX","us"):=NULL]

# Washington OFM population estimates ------------------------------------
GET("https://ofm.wa.gov/sites/default/files/public/dataresearch/pop/april1/hseries/ofm_april1_postcensal_estimates_pop_1960-present.xlsx", 
    write_disk(tf <- tempfile(fileext = ".xlsx")))
ofm <- read_excel(tf, range="Population!R4C2:R452C183", col_names=TRUE) %>% setDT() %>% .[Filter==1 & County %in% psrc_counties,] %>% 
       .[,c("Filter","Jurisdiction"):=NULL] %>% pivot_longer(-c("County"), names_to="data_year", values_to="population") %>% 
       .[str_sub(.$data_year,-1)=="n",]
ofm$data_year <- str_sub(str_squish(ofm$data_year),1,4)
ofm$population <- as.integer(ofm$population)
unlink(tf)

