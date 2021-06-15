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
#  - BEA --- from 1990; release lags by (?)
#  - BLS --- from 1996; release lags by 5mo (employment), 2mo (cpi, unemployment)
#  - DOR --- file format changed in 2008 (note: url, xls/x not fully consistent)
#  - DOL --- categories shifted late 2016 aka consistent since 2017
#  - Census Population Projections --- Irregularly produced (2017 version here)
#  - Census ACS --- from 2005; release in December of following calendar year
#  - OFM --- release lags by (?)
#  - ESD --- from 1990; release lags by (?)
#
#  Must set environment variables BLS_KEY, BEA_KEY, CENSUS_API_KEY prior to execution 
#=-----------------------------------------------------------------------=

data_year <- 2019
countycode <- c("17","18","27","31")
psrc_fips <- c("033","035","053","061")
psrc_counties <- c("King","Kitsap","Pierce","Snohomish")
all_chunks <- list()

# Functions --------------------------------------------------------------

fetch_bls <- function(serieslist){
  bls_payload <- list("seriesid"=serieslist, "startyear"=1990, "endyear"=data_year,"registrationKey"=Sys.getenv("BLS_KEY"))
  delivery <- blsAPI(bls_payload, api_version=2, return_data_frame=TRUE) %>% setDT() %>% .[,periodName:=NULL] %>%
              setnames(c("year","period","value","seriesID"),c("d_year","d_month","d_value","series_id")) %>% 
              .[,`:=`(d_value=as.numeric(d_value), d_month=as.integer(str_sub(d_month,2,3)))] %>% setkey("d_year","d_month","series_id")
  return(delivery)
}

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
  opyears <- c(2017:dyear)
  psrc_counties <- c("17","18","27","31","40")                                                     # 40 is the statewide line
  dol_chunks <- list()
  read_dol <- function(opyear){
    fread(paste0("https://fortress.wa.gov/dol/vsd/vsdFeeDistribution/cache/", opyear,"C00-63.csv")) %>%
    .[get("Fuel Type") !="None" & str_sub(County,1,2) %in% psrc_counties] %>% .[,data_year:=..opyear]
  }
  dol_chunks <- lapply(opyears, read_dol)
  veh <- rbindlist(dol_chunks, use.names=TRUE) %>% setDT() %>% setnames(c("Fuel Type","County"),c("fuel_type","county")) %>% 
         .[,county:=str_sub(county,1,2)]
  return(veh)
}

fetch_dor <- function(dyear){
  require(data.table, httr, readxl)
  opyears <- c(2007:dyear)
  psrc_counties <- c("17","18","27","31")
  dor_chunks <- list()
  read_dor <- function(opyear){
    ref_set <- case_when(opyear==2019 ~c("R", "19", "vs","CAL"), TRUE ~c("r", toString(opyear), "VS", "Cal"))
    xl_type <- case_when(opyear %in% c(2008,2011,2012) ~".xls",TRUE ~".xlsx")
    url <- paste0("https://dor.wa.gov/sites/default/files/legacy/Docs/", ref_set[1],"eports/", opyear, "/lrtcal", ref_set[2], 
           "/TRS_RTL_", ref_set[3], "_TOT_COUNTY_",ref_set[4], opyear, xl_type)
    GET(url, write_disk(tf <- tempfile(fileext = xl_type)))
    ret <- read_excel(tf, range="A7:D45", col_names=FALSE, skip=6) %>% setDT() %>% .[...1 %in% psrc_counties,.(...1,...4)] %>%  
           setnames(c("series_id","d_value")) %>% .[, data_year:=opyear]
    unlink(tf)
    return(ret)
  }
  dor_chunks <- lapply(opyears, read_dor)
  sales <- rbindlist(dor_chunks, use.names=TRUE) %>% setDT()
  return(sales)
}

addQM <- function(dt0){
    dt0 %<>% .[,`:=`(d_quarter=0, d_month=0)]
}

addM <- function(dt0){
    dt0 %<>% .[,`:=`(d_month=0)]
}

query_ls <- function(conn, qlist){
  send_sql <- paste0(qlist, collapse=" ")
  rs <- dbSendQuery(conn, SQL(send_sql))
  dbClearResult(rs)
}

# BLS: unemployment (LAUS), CPI ------------------------------------------
unemp_series <- c(unlist(paste0("LAUCN53", psrc_fips,"0000000004")),                               # unemployment by county
                  unlist(paste0("LAUCN53", psrc_fips,"0000000006")))                               # labor force by county 
lookup_bls <- setDT(data.frame(fips=c("033", "035", "053", "061"), snum=c(123, 124, 125, 126), stringsAsFactors=FALSE))
all_chunks[[1]] <- fetch_bls(unemp_series) %>%                                          
                   .[,`:=`(series_id=str_sub(series_id,8,10), v=paste0("V", str_sub(series_id,-1L)))] %>%
                   pivot_wider(names_from = v, values_from=d_value, values_fill=0, values_fn=sum) %>% setDT() %>% .[,`:=`(d_value=V4/V6)] %>% 
                   .[,c("V4","V6"):=NULL] %>% .[lookup_bls, series_id:=snum, on =.(series_id=fips)]
all_chunks[[2]] <- fetch_bls("CUURS49DSA0") %>% .[, series_id:=105]                                # consumer price index CPI-U Seattle-Bellevue-Everett MSA
rm(unemp_series, lookup_bls)

# BEA: personal income, wages & salary -----------------------------------
bea_chunks <- list()
bea_chunks[[1]] <- fetch_bea("CAINC4", 10, psrc_fips) %>% .[,series_id:=paste0(geo,"p")]           # personal income by county
bea_chunks[[2]] <- fetch_bea("CAINC4", 50, psrc_fips) %>% .[,series_id:=paste0(geo,"w")]           # wage  &  salary by county
bea_chunks[[3]] <- fetch_bea("CAINC4", 10, "000")     %>% .[,series_id:=paste0("000","p")]         # personal income - statewide
bea_chunks[[4]] <- fetch_bea("CAINC4", 50, "000")     %>% .[,series_id:=paste0("000","w")]         # wage  &  salary - statewide
lookup_bea <- setDT(data.frame(fipser=c(paste0(c(unlist(psrc_fips),"000"),"p"), paste0(c(unlist(psrc_fips),"000"),"w")), snum=c(1:4,9,5:8,10), stringsAsFactors=FALSE))
all_chunks[[3]] <- rbindlist(bea_chunks, use.names=TRUE) %>% .[lookup_bea, series_id:=snum, on =.(series_id=fipser)] %>% .[,geo:=NULL]
rm(bea_chunks, lookup_bea)

# DOR: retail sales ------------------------------------------------------
lookup_dor <- setDT(data.frame(countycode=..countycode, snum=c(16:19), stringsAsFactors=FALSE))
all_chunks[[4]] <- fetch_dor(data_year) %>% .[lookup_dor, series_id:=snum, on=.(series_id=countycode)] # taxable retail sales by county

# DOL: vehicle counts ----------------------------------------------------
truck_types <- c("Combination Farm","Combination Non Farm","Commercial","Farm","Logging","Tow Truck",
                 "Truck","Fixed Load","Medium Electric Truck","Neighborhood Electric Truck")
auto_types <- c("Passenger Vehicle","Medium Electric Passenger","Neighborhood Electric Passenger")
key_cols <- c("data_year", "county", "fuel_type")
lookup_dol <- matrix(25:44,ncol=4,nrow=4,byrow=FALSE) %>% as.data.frame()
lookup_dol[5,] <- c(41,42,43,44)
colnames(lookup_dol) <- c("auto","gtruck","dtruck","other")
lookup_dol[,"county"] <- c(unlist((countycode)),"40")
dol_chunks <-list()
dol <- fetch_dol(data_year) %>% .[,c(..key_cols, ..truck_types, ..auto_types, "Total")] %>%        # vehicle counts by county and type
       .[, fuel_type:=case_when(fuel_type=="non-Gas Powered" ~"heavy",TRUE ~"light")]
dol_chunks[[1]] <- dol[,c(..key_cols, ..truck_types)] %>% pivot_longer(cols=all_of(truck_types), names_to="veh_type", values_to="d_value") %>% 
                setDT() %>% setkeyv(key_cols) %>% .[,.(d_value=sum(d_value)), by=key(.)] %>%
                .[.(fuel_type="light", lookup_dol), series_id:=gtruck, on=.(county, fuel_type)] %>%
                .[.(fuel_type="heavy", lookup_dol), series_id:=dtruck, on=.(county, fuel_type)]
dol_chunks[[2]] <- dol[,c(..key_cols, ..auto_types)] %>% pivot_longer(cols=all_of(auto_types), names_to="veh_type", values_to="d_value") %>% 
                setDT() %>% .[,fuel_type:="light"] %>% setkeyv(key_cols) %>% .[,.(d_value=sum(d_value)), by=key(.)] %>%
                .[lookup_dol, series_id:=auto, on =.(county)]
non_other <- rbindlist(dol_chunks, use.names=TRUE) %>% setkeyv(key_cols[1:2]) %>% .[,.(all_else=sum(d_value)), by=key(.)]
dol_chunks[[3]] <- dol[,c(..key_cols, "Total")] %>% setkeyv(key_cols[1:2]) %>% .[,.(Total=sum(Total)), by=key(.)] %>%
                   non_other[., nomatch=0] %>% .[,`:=`(d_value=Total - all_else, fuel_type="irrelevant")] %>% .[,c("Total","all_else"):=NULL] %>%
                   .[lookup_dol, series_id:=other, on =.(county)]  
all_chunks[[5]] <- rbindlist(dol_chunks, use.names=TRUE)
rm(truck_types, auto_types, key_cols, dol_chunks, lookup_dol, dol)

# Census population projections ------------------------------------------
all_chunks[[6]] <- getCensus(name = "popproj/pop", vintage = 2017,                                 # national population projections by age (single year); irregular update
                   vars = c("SEX","RACE","SCENARIO","AGE","HISP","DATE_CODE","POP"), region = "us:*", key=Sys.getenv("CENSUS_API_KEY")) %>% 
                   setDT() %>% .[,`:=`(d_year=as.integer(DATE_CODE)+2007, d_value=as.integer(POP), series_id=118+case_when(age<5~0,age<20~1,age<65~2,TRUE~3))] %>% 
                   .[SCENARIO=="M" & RACE==0 & HISP==0 & SEX==0 & AGE !=999,] %>% .[,c("AGE","SCENARIO","RACE","HISP","SEX","DATE_CODE","POP","us"):=NULL] %>% 
                   setkey(series_id, d_year) %>% .[,.(sum(d_value)), by=key(.)]

# Washington OFM population estimates ------------------------------------
# GET("https://ofm.wa.gov/sites/default/files/public/dataresearch/pop/asr/sade/ofm_pop_age_sex_postcensal_2010_2020_s.xlsx", 
#     write_disk(tf <- tempfile(fileext = ".xlsx")))
# lookup_ofm <- setDT(data.frame(fips=psrc_fips, county_name=psrc_counties))
# ofm <- read_excel(tf, range="Population!R4C2:R452C183", col_names=TRUE) %>% setDT() %>% .[Filter==1 & County %in% psrc_counties,] %>% 
#        .[,c("Filter","Jurisdiction"):=NULL] %>% pivot_longer(-c("County"), names_to="data_year", values_to="population") %>% 
#        .[str_sub(.$data_year,-1)=="n",] %>% .[lookup_ofm,]
# ofm$data_year <- str_sub(str_squish(ofm$data_year),1,4)
# ofm$population <- as.integer(ofm$population)
# unlink(tf)
# 
# "https://ofm.wa.gov/sites/default/files/public/dataresearch/pop/asr/projections/ofm_pop_age_sex_race_projections_2010_to_2040.xlsx"
# "https://ofm.wa.gov/sites/default/files/public/dataresearch/pop/asr/projections/ofm_pop_age_sex_race_projections_2010_to_2040_s.xlsx"
# "https://ofm.wa.gov/sites/default/files/public/dataresearch/pop/asr/sade/ofm_pop_age_sex_postcensal_2010_2020_s.xlsx"

# ESD: Employment (WA-QB, QCEW) -------------------------------------------
# GET(paste0("https://esdorchardstorage.blob.core.windows.net/esdwa/Default/ESDWAGOV/labor-market-info/Libraries/Economic-reports/",
#            "Washington-employment-estimates/WA-QB-historical-NSA-all%20areas.xlsx"), 
#     write_disk(tf <- tempfile(fileext = ".xlsx")))

# Fuel consumption --------------------------------------------------------
# This may be a lot easier manually. 
#GET(paste0("https://ofm.wa.gov/sites/default/files/public/budget/info/transpo/March",as.character(data_year + 1),"VolumnII.pdf"), 
#    write_disk(tf <- tempfile(fileext = ".pdf")))

# Export updated values and merge w/ Sockeye db ---------------------------
mapply(addQM, all_chunks[3:6], simplify=FALSE)                                                     # Add empty quarter or month columns to make each dataset consistent
mapply(addM,  all_chunks[1:2], simplify=FALSE)
input_all <- rbindlist(all_chunks, use.names=TRUE)                                                 # Combine into one

sockeye_connection <- dbConnect(odbc::odbc(),                                                      # Create the db connection
                                driver = 'SQL Server',
                                server = 'AWS-PROD-SQL\\Sockeye',
                                database = "macroeconomic_inputs",
                                trusted_connection = "yes",
                                port = 1433)
table_id <- Id(schema = "stg", table = "inputs_update")
dbWriteTable(sockeye_connection, table_id, input_all, overwrite = TRUE)                            # Write staging table
merge_sql <- paste("MERGE INTO dbo.macro_trend_facts WITH (HOLDLOCK) AS target",                   # This updates existing values AND inserts any new ones
                      "USING stg.inputs_update AS source",
                      "ON target.d_year=source.d_year AND target.d_quarter=source.d_quarter AND target.d_month=source.d_month",
                        "AND target.series_id = source.series_id",
                   "WHEN MATCHED THEN UPDATE SET target.d_value=source.d_value",
                   "WHEN NOT MATCHED BY TARGET THEN INSERT (d_year, d_quarter, d_month, series_id, d_value)",
                      "VALUES (source.d_year, source.d_quarter, source.d_month, source.series_id, source.d_value);")
query_ls(sockeye_connection, merge_sql)                                                            # Execute the query
query_ls(sockeye_connection, "DROP TABLE stg.inputs_update")                                       # Clean up
dbDisconnect(elmer_connection)
#rm(all_chunks, input_all, sockeye_connection, merge_sql)                                          # Clean up