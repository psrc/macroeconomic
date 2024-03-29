'THIS PROGRAM  CREATES A WORKFILE CONTAINING TWO SHEETS, IMPORTS HISTORICAL DATA FROM EXCEL INTO A SINGLE WORKFILE CONTAINING MULTIPLE SHEETS
close @wf

'Modify paths as necessary
cd "D:\Users\ehaswell\Dropbox (ECONW)\22798 PSRC MacroForecast and Revenue Update\2017 Forecast update\"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'CREATE WORKFILE WITH A MONTHLY, QUARTERLY, AND ANNUAL PAGE
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
WFCREATE PSRC2017 m 1970:01 2050:12
PAGERENAME Untitled Monthly

PAGECREATE (page="Quarterly") q 1970Q1 2050Q4
PAGERENAME Untitled Quarterly

PAGECREATE (page="Annual") a 1970 2050
PAGERENAME Untitled Annual


'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'THIRD, IMPORT ANNUAL DATA INTO WORKFILE & CREATE DISPLAY NAMES
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PAGESELECT Annual

'IMPORT COUNTY-LEVEL PERSONAL INCOME DATA INTO ANNUAL PAGE 
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Personal_Income!a3" @rename series01 year

kyp.displayname King Personal Income
byp.displayname Kitsap Personal Income
typ.displayname Peirce Personal Income
syp.displayname Snohomish Personal Income

pyp.displayname Puget Sound Personal Income

kyws.displayname King Wage & Salary Personal Income
byws.displayname Kitsap Wage & Salary Personal Income
tyws.displayname Peirce Wage & Salary Personal Income
syws.displayname Snohomish Wage & Salary Personal Income
pyws.displayname Puget Sound Wage & Salary Personal Income

'IMPORT WASHINGTON PERSONAL INCOME INTO QUARTERLY PAGE
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="State Personal Inc!a2" @rename series01 year

wyp.displayname WA Total Personal Income
wyws.displayname WA Wage & Salary Income 

'IMPORT KING COUNTY POPULATION DATA INTO QUARTERLY PAGE
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="King-POP HH!a2" @rename series01 year

kpop.displayname King County Population 
kpop0.displayname King Cty 0-4 Population
kpop20.displayname King Cty 20-64 Population 
kpop5.displayname King Cty 5-19 Population
kpop65.displayname King Cty 65+ Population
kpopgrqt.displayname King Cty Group Quarters Population
kpophse.displayname King Cty Household Population
kpophsesn.displayname King Cty Single-Family Population
kpophseml.displayname King Cty Multi-Family Population
khse.displayname King Cty Households
khsesn.displayname King Cty Single-Family Households
khseml.displayname King Cty Multi-Family Households
khsesz.displayname King Cty Household Size
khseszsn.displayname King Cty Household Size (Single-Family)
khseszml.displayname King Cty Household Size (Multi-Family)


'IMPORT KITSAP COUNTY POPULATION DATA INTO QUARTERLY PAGE
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Kitsap-POP HH!a2" @rename series01 year

bpop.displayname Kitsap County Population 
bpop0.displayname Kitsap Cty 0-4 Population
bpop20.displayname Kitsap Cty 20-64 Population 
bpop5.displayname Kitsap Cty 5-19 Population
bpop65.displayname Kitsap Cty 65+ Population 
bpopgrqt.displayname Kitsap Cty Group Quarters Population
bpophse.displayname Kitsap Cty Household Population
bpophsesn.displayname Kitsap Cty Single-Family Population
bpophseml.displayname Kitsap Cty Multi-Family Population
bhse.displayname Kitsap Cty Households
bhsesn.displayname Kitsap Cty Single-Family Households
bhseml.displayname Kitsap Cty Multi-Family Households
bhsesz.displayname Kitsap Cty Household Size
bhseszsn.displayname Kitsap Cty Household Size (Single Family)
bhseszml.displayname Kitsap Cty Household Size (Multi-Family)


'IMPORT PIERCE COUNTY POPULATION DATA INTO QUARTERLY PAGE
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Pierce-POP HH !a2" @rename series01 year

tpop.displayname Pierce County Population 
tpop0.displayname Pierce Cty 0-4 Population
tpop20.displayname Pierce Cty 20-64 Population 
tpop5.displayname Pierce Cty 5-19 Population
tpop65.displayname Pierce Cty 65+ Population
tpopgrqt.displayname Pierce Cty Group Quarters Population
tpophse.displayname Pierce Cty Household Population
tpophsesn.displayname Pierce Cty Single-Family Population
tpophseml.displayname Pierce  Cty Multi-Family Population
thse.displayname Pierce Cty Household Population
thsesn.displayname Pierce Cty Single-Family Households
thseml.displayname Pierce Cty Multi-Family Houeholds
thsesz.displayname Pierce Cty Household Size
thseszsn.displayname Pierce Cty Household Size (Singe-Family)
thseszml.displayname Pierce Cty Household Size (Mulit-Family)


'IMPORT SNOHOMISH COUNTY POPULATION DATA INTO QUARTERLY PAGE
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Snohomish-POP HH!a2" @rename series01 year

spop.displayname Snohomish County Population 
spop0.displayname Snohomish Cty 0-4 Population
spop20.displayname Snohomish Cty 20-64 Population 
spop5.displayname Snohomish Cty 5-19 Population
spop65.displayname Snohomish Cty 65+ Population
spopgrqt.displayname Snohomish Cty Group Quarters Population
spophse.displayname Snohomish Cty Household Population
spophsesn.displayname Snohomish Cty Single-Family Population
spophseml.displayname Snohomish Cty Multi-Family Population
shse.displayname Snohomish Cty Household Population
shsesn.displayname Snohomish Cty Single-Family Householdsf
shseml.displayname Snohomish Cty Multi-Family Households
shsesz.displayname Snohomish Cty Household Size
shseszsn.displayname Snohomish Cty Household Size (Single-Family)
shseszml.displayname Snohomish Cty Household Size (Multi-Family)

'IMPORT STATE-LEVEL POPULATION DATA INTO ANNUAL PAGE 
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="State POP!a2" @rename variable year

wpop0.displayname Washington State 0-4 Population
wpop5.displayname Washington State 5-19 Population
wpop20.displayname Washington State 20-64 Population
wpop65.displayname Washington State 65+ Population
wpop.displayname Washington State Total Population

'IMPORT MILITARY EMPLOYMENT (PRIOR SERIES WAS QUARTERLY)
import  "Regional data\PSRC_Macro_Trend\employment_final_ECO.xlsx" range="Military!b3" @smpl "1970 2015"
PNMIL.displayname Puget Sound Military Employment

'IMPORT AEROSPACE FORECAST (PRIOR SERIES WAS QUARTERLY)
import  "Regional data\aerospace_FC.xlsx" range="Sheet1!c2" @smpl "1970 2050"
PNAER.displayname Puget Sound Aerospace Employment

'IMPORT ACS housing stock
import  "Regional data\Housing stock\acs_stock.xlsx" range="Sheet1!a1"
KSTOCK_ACS.displayname King County ACS Housing Units
BSTOCK_ACS.displayname Kitsap County ACS Housing Units
TSTOCK_ACS.displayname Pierce County ACS Housing Units
SSTOCK_ACS.displayname Snohomish County ACS Housing Units
PSTOCK_ACS.displayname Region ACS Housing Units

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'FOURTH, IMPORT ANNUAL REVENUE & VEHICLE INFO INTO WORKFILE & CREATE DISPLAY NAMES
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PAGESELECT Annual

'IMPORT COUNTY-LEVEL TAXABLE RETAIL SALES DATA INTO ANNUAL PAGE 
import  "Regional data\PSRC_Macro_Trend\revenue_final_ECO.xlsx" range="retail_sales_updated!a1:e47" @rename series01 year

KRETAIL.displayname King Taxable Retail Sales
BRETAIL.displayname Kitsap Taxable Retail Sales
SRETAIL.displayname Pierce Taxable Retail Sales
TRETAIL.displayname Snohomish Taxable Retail Sales

'IMPORT STATE-LEVEL FUEL SALES DATA INTO ANNUAL PAGE 
import  "Regional data\PSRC_Macro_Trend\revenue_final_ECO.xlsx" range="fuel_sales_updated!a1"

KFUEL.displayname King County Total Fuel Sold (thous. gallons)
BFUEL.displayname Kitsap County Total Fuel Sold (thous. gallons)
TFUEL.displayname Pierce County Total Fuel Sold (thous. gallons)
SFUEL.displayname Snohomish County Total Fuel Sold (thous. gallons)
WFUEL.displayname Washington State Total Fuel Sold (thous. gallons)

'IMPORT COUNTY- AND STATE-LEVEL VEHICLES BY CLASS DATA INTO ANNUAL PAGE 
import  "Regional data\PSRC_Macro_Trend\revenue_final_ECO.xlsx" range="vehicles by type_updated!a3"

KCAR.displayname King County Passenger Vehicles
KTRKGAS.displayname King County Gasoline Trucks
KTRKDIE.displayname King County Diesel Trucks
KOTHVEH.displayname King County Other Vehicles

BCAR.displayname King County Passenger Vehicles
BTRKGAS.displayname King County Gasoline Trucks
BTRKDIE.displayname King County Diesel Trucks
BOTHVEH.displayname King County Other Vehicles

TCAR.displayname King County Passenger Vehicles
TTRKGAS.displayname King County Gasoline Trucks
TTRKDIE.displayname King County Diesel Trucks
TOTHVEH.displayname King County Other Vehicles

SCAR.displayname Snohomish County Passenger Vehicles
STRKGAS.displayname Snohomish County Gasoline Trucks
STRKDIE.displayname Snohomish County Diesel Trucks
SOTHVEH.displayname Snohomish County Other Vehicles

WCAR.displayname Washington State Passenger Vehicles
WTRKGAS.displayname Washington State Gasoline Trucks
WTRKDIE.displayname Washington State Diesel Trucks
WOTHVEH.displayname Washington State Other Vehicles


'IMPORT COUNTY-LEVEL MVET DATA INTO ANNUAL PAGE 
'import  "Regional data\PSRC_Macro_Trend\revenue_final.xlsx" range="MVETs!a2"

'KMVET.displayname King County MVET Base Value
'BMVET.displayname Kistap County MVET Base Value
'TMVET.displayname Pierce County MVET Base Value
'SMVET.displayname Snohomish County MVET Base Value

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'FIFTH, IMPORT MONTHLY DATA INTO WORKFILE & CREATE DISPLAY NAMES
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PAGESELECT Monthly

'IMPORT COUNTY-LEVEL UNEMPLOYMENT RATE DATA INTO MONTHLY PAGE (TO DERIVE WORKFORCE NUMBERS) 
import  "Regional data\PSRC_Macro_Trend\unemployment_final_ECO.xlsx" range="unemployment!b4" @smpl "1970M1 2017M12"

kunrtu.displayname King Unemp Rate (not seasonally adjusted)
bunrtu.displayname Kitsap Unemp Rate (not seasonally adjusted)
tunrtu.displayname Pierce Unemp Rate (not seasonally adjusted)
sunrtu.displayname Snohomish Unemp Rate (not seasonally adjusted)


'IMPORT COUNTY-LEVEL BUILDING PERMIT DATA INTO MONTHLY PAGE 
import "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Building_permits!b3" @smpl "1970M1 2013M12"
khssu.displayname King single-family build permits
khsu.displayname King build permits, total units 
bhssu.displayname Kitsap single-family build permits 
bhsu.displayname Kitsap build permits, total units 
thsu.displayname Pierce single-family build permits
thsu.displayname Pierce build permits, total units
shssu.displayname Snohomish single-family build permits
shssu.displayname Snohomish build permits, total units

'IMPORT KING COUNTY EMPLOYMENT DATA INTO MONTHLY PAGE 
import  "Regional data\PSRC_Macro_Trend\employment_final_ECO.xlsx" range="King_update!b3" @smpl "1970M1 2017M5" @rename * *U

KNU.displayname King: Wage & Salary Employment (not season adj)
KNGOODSU.displayname King: Goods Producing Employment (not season adj)
KNRESU.displayname King: Natural Res. & Mining Employment (not season adj)
KNCONU.displayname King: Construction Employment (not season adj)
KNMFGU.displayname King: Manufacturing Employment (not season adj)
KNAERU.displayname King: Aerospace Employment (not season adj)
KNODURU.displayname King: Oth Durable Goods Employment (not season adj)
KNNDURU.displayname King: Non-durable Goods Employment (not season adj)
KNSERVU.displayname King: Service Producing Employment (not season adj)
KNTRDU.displayname King: Whole & Retail Trade Employment (not season adj)
KNWHTRDU.displayname King: Wholesale Trade Employment (not season adj)
KNRETRDU.displayname King: Retail Trade Employment (not season adj)
KNTRNUTILU.displayname King: Trans, Ware, & Util Employment (not season adj)
KNTRNU.displayname King: Trans & Wharehouse Employment (not season adj)
KNUTILU.displayname King: Utilities Employment (not season adj)
KNINFOU.displayname King: Information Employment (not season adj)
KNCOMU.displayname King: Telecommunications Employment (not season adj)
KNOINFOU.displayname King: Other Information Employment (not season adj)
KNFINU.displayname King: Financial Activities Employment (not season adj)
KNPROFBUSU.displayname King: Prof & Bus Services Employment (not season adj)
KNOSERVU.displayname King: Other Services Employment (not season adj)
KNEATU.displayname King: Food Serve & Drink Places Employment (not season adj)
KNEDUCU.displayname King: Educ Services Employment (not season adj)
KNHLTHU.displayname King: Health Services Employment (not season adj)
KNOSERVXU.displayname King: Other "Other Employment" (not season adj)
KNGOVU.displayname King: Government Employment (not season adj)
KNGOVSLU.displayname King: State & Local Employment (not season adj)
KNGOVSEDUCU.displayname King: State Education Employment (not season adj)
KNGOVLEDUCU.displayname King: Local Education Employment (not season adj)
KNGOVOSLU.displayname King: Other State & Local Employment (not season adj)
KNGOVFEDU.displayname King: Federal Civilian Employment (not season adj)


'IMPORT KITSAP COUNTY EMPLOYMENT DATA INTO MONTHLY PAGE 
import  "Regional data\PSRC_Macro_Trend\employment_final_ECO.xlsx" range="Kitsap_update!b3" @smpl "1970M1 2017M5" @rename * *U

BNU.displayname Kitsap: Wage & Salary Employment (not season adj)
BNGOODSU.displayname Kitsap: Goods Producing Employment (not season adj)
BNRESU.displayname Kitsap: Natural Res. & Mining Employment (not season adj)
BNCONU.displayname Kitsap: Construction Employment (not season adj)
BNMFGU.displayname Kitsap: Manufacturing Employment (not season adj)
BNAERU.displayname Kitsap: Aerospace Employment (not season adj)
BNODURU.displayname Kitsap: Oth Durable Goods Employment (not season adj)
BNNDURU.displayname Kitsap: Non-durable Goods Employment (not season adj)
BNSERVU.displayname Kitsap: Service Producing Employment (not season adj)
BNTRDU.displayname Kitsap: Whole & Retail Trade Employment (not season adj)
BNWHTRDU.displayname Kitsap: Wholesale Trade Employment (not season adj)
BNRETRDU.displayname Kitsap: Retail Trade Employment (not season adj)
BNTRNUTILU.displayname Kitsap: Trans, Ware, & Util Employment (not season adj)
BNTRNU.displayname Kitsap: Trans & Wharehouse Employment (not season adj)
BNUTILU.displayname Kitsap: Utilities Employment (not season adj)
BNINFOU.displayname Kitsap: Information Employment (not season adj)
BNCOMU.displayname Kitsap: Telecommunications Employment (not season adj)
BNOINFOU.displayname Kitsap: Other Information Employment (not season adj)
BNFINU.displayname Kitsap: Financial Activities Employment (not season adj)
BNPROFBUSU.displayname Kitsap: Prof & Bus Services Employment (not season adj)
BNOSERVU.displayname Kitsap: Other Services Employment (not season adj)
BNEATU.displayname Kitsap: Food Serve & Drink Places Employment (not season adj)
BNEDUCU.displayname Kitsap: Educ Services Employment (not season adj)
BNHLTHU.displayname Kitsap: Health Services Employment (not season adj)
BNOSERVXU.displayname Kitsap: Other "Other Employment" (not season adj)
BNGOVU.displayname Kitsap: Government Employment (not season adj)
BNGOVSLU.displayname Kitsap: State & Local Employment (not season adj)
BNGOVSEDUCU.displayname Kitsap: State Education Employment (not season adj)
BNGOVLEDUCU.displayname Kitsap: Local Education Employment (not season adj)
BNGOVOSLU.displayname Kitsap: Other State & Local Employment (not season adj)
BNGOVFEDU.displayname Kitsap: Federal Civilian Employment (not season adj)


'IMPORT PIERCE COUNTY EMPLOYMENT DATA INTO MONTHLY PAGE 
import  "Regional data\PSRC_Macro_Trend\employment_final_ECO.xlsx" range="Pierce_update!b3" @smpl "1970M1 2017M5" @rename * *U

TNU.displayname Pierce: Wage & Salary Employment (not season adj)
TNGOODSU.displayname Pierce: Goods Producing Employment (not season adj)
TNRESU.displayname Pierce: Natural Res. & Mining Employment (not season adj)
TNCONU.displayname Pierce: Construction Employment (not season adj)
TNMFGU.displayname Pierce: Manufacturing Employment (not season adj)
TNAERU.displayname Pierce: Aerospace Employment (not season adj)
TNODURU.displayname Pierce: Oth Durable Goods Employment (not season adj)
TNNDURU.displayname Pierce: Non-durable Goods Employment (not season adj)
TNSERVU.displayname Pierce: Service Producing Employment (not season adj)
TNTRDU.displayname Pierce: Whole & Retail Trade Employment (not season adj)
TNWHTRDU.displayname Pierce: Wholesale Trade Employment (not season adj)
TNRETRDU.displayname Pierce: Retail Trade Employment (not season adj)
TNTRNUTILU.displayname Pierce: Trans, Ware, & Util Employment (not season adj)
TNTRNU.displayname Pierce: Trans & Wharehouse Employment (not season adj)
TNUTILU.displayname Pierce: Utilities Employment (not season adj)
TNINFOU.displayname Pierce: Information Employment (not season adj)
TNCOMU.displayname Pierce: Telecommunications Employment (not season adj)
TNOINFOU.displayname Pierce: Other Information Employment (not season adj)
TNFINU.displayname Pierce: Financial Activities Employment (not season adj)
TNPROFBUSU.displayname Pierce: Prof & Bus Services Employment (not season adj)
TNOSERVU.displayname Pierce: Other Services Employment (not season adj)
TNEATU.displayname Pierce: Food Serve & Drink Places Employment (not season adj)
TNEDUCU.displayname Pierce: Educ Services Employment (not season adj)
TNHLTHU.displayname Pierce: Health Services Employment (not season adj)
TNOSERVXU.displayname Pierce: Other "Other Employment" (not season adj)
TNGOVU.displayname Pierce: Government Employment (not season adj)
TNGOVSLU.displayname Pierce: State & Local Employment (not season adj)
TNGOVSEDUCU.displayname Pierce: State Education Employment (not season adj)
TNGOVLEDUCU.displayname Pierce: Local Education Employment (not season adj)
TNGOVOSLU.displayname Pierce: Other State & Local Employment (not season adj)
TNGOVFEDU.displayname Pierce: Federal Civilian Employment (not season adj)


'IMPORT SNOHOMISH COUNTY EMPLOYMENT DATA INTO MONTHLY PAGE 
import  "Regional data\PSRC_Macro_Trend\employment_final_ECO.xlsx" range="Snohomish_update!b3" @smpl "1970M1 2017M5" @rename * *U
SNU.displayname Snohomish: Wage & Salary Employment (not season adj)
SNGOODSU.displayname Snohomish: Goods Producing Employment (not season adj)
SNRESU.displayname Snohomish: Natural Res. & Mining Employment (not season adj)
SNCONU.displayname Snohomish: Construction Employment (not season adj)
SNMFGU.displayname Snohomish: Manufacturing Employment (not season adj)
SNAERU.displayname Snohomish: Aerospace Employment (not season adj)
SNODURU.displayname Snohomish: Oth Durable Goods Employment (not season adj)
SNNDURU.displayname Snohomish: Non-durable Goods Employment (not season adj)
SNSERVU.displayname Snohomish: Service Producing Employment (not season adj)
SNTRDU.displayname Snohomish: Whole & Retail Trade Employment (not season adj)
SNWHTRDU.displayname Snohomish: Wholesale Trade Employment (not season adj)
SNRETRDU.displayname Snohomish: Retail Trade Employment (not season adj)
SNTRNUTILU.displayname Snohomish: Trans, Ware, & Util Employment (not season adj)
SNTRNU.displayname Snohomish: Trans & Wharehouse Employment (not season adj)
SNUTILU.displayname Snohomish: Utilities Employment (not season adj)
SNINFOU.displayname Snohomish: Information Employment (not season adj)
SNCOMU.displayname Snohomish: Telecommunications Employment (not season adj)
SNOINFOU.displayname Snohomish: Other Information Employment (not season adj)
SNFINU.displayname Snohomish: Financial Activities Employment (not season adj)
SNPROFBUSU.displayname Snohomish: Prof & Bus Services Employment (not season adj)
SNOSERVU.displayname Snohomish: Other Services Employment (not season adj)
SNEATU.displayname Snohomish: Food Serve & Drink Places Employment (not season adj)
SNEDUCU.displayname Snohomish: Educ Services Employment (not season adj)
SNHLTHU.displayname Snohomish: Health Services Employment (not season adj)
SNOSERVXU.displayname Snohomish: Other "Other Employment" (not season adj)
SNGOVU.displayname Snohomish: Government Employment (not season adj)
SNGOVSLU.displayname Snohomish: State & Local Employment (not season adj)
SNGOVSEDUCU.displayname Snohomish: State Education Employment (not season adj)
SNGOVLEDUCU.displayname Snohomish: Local Education Employment (not season adj)
SNGOVOSLU.displayname Snohomish: Other State & Local Employment (not season adj)
SNGOVFEDU.displayname Snohomish: Federal Civilian Employment (not season adj)

'Import potential tech. series
import  "Regional data\tech_series.xlsx" range="pntech_naics.csv!b1" @smpl "1990M1 2016M09"
import  "Regional data\tech_series.xlsx" range="pntech_sic.csv!b1" @smpl "1975M1 2000M12"
import "Regional data\tech_series.xlsx" range="Monthly_out!b2" @smpl "1975M1 2024M12"

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'FIFTH, IMPORT QUARTERLY DATA INTO WORKFILE AND CREATE DISPLAY NAMES
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
PAGESELECT Quarterly

'IMPORT SEATTLE CPI INTO QUARTERLY PAGE 
import  "Regional data\PSRC_Macro_Trend\economic_final_ECO.xlsx" range="Seattle_CPI!b2" @smpl "1970M1 2017M1"

scpi.displayname Seattle CPI 1982-84=1.0

'IMPORT EXOGENOUS PUGET SOUND DATA INTO QUARTERLY PAGE
READ(t=xls, c2, s=Sheet1) "Regional data\PSRC_Macro_Trend\PugetSound_EXOG.xls" 2

PNMS.displayname Puget Sound Microsoft Employment
PYSTK.displayname Puget Sound Stock Option (MILLIONS OF $)

'IMPORT Case-Shiller HPI from FRED
import  "Regional data\Case-Shiller-HPI.xlsx" range="SEXRNSA_quarterly.csv!b1" @smpl "1990Q1 2017Q2"
SEXRNSA.displayname Case-Shiller HPI

'IMPORT all-sales HPI from FRED (Seattle-Bellevue-Everett MSAD)
import  "Regional data\All_sales-HPI.xlsx" range="Quarterly!b1" @smpl "1975Q3 2017Q2"
SBE_ASHPI.displayname Seattle-Bellevue-Tacoma All-sales HPI

'IMPORT Housing starts
import  "Regional data\Housing_starts.xlsx" range="Sheet2!b1" @smpl "1982Q1 2017Q2"
PHSTARTS.displayname Regional housing starts
KHSTARTS.displayname King County housing starts
BHSTARTS.displayname Kitsap County housing starts
THSTARTS.displayname Pierce County housing starts
SHSTARTS.displayname Snohomish County housing starts

'IMPORT NATIONAL DATA (DERIVED FROM FAIR MODEL) INTO QUARTERLY WORKPAGE

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'IMPORT QUARTERLY U.S. NATIONAL FORECAST DATA (FROM FAIR MODEL) AND POPULATION (CENSUS) INTO WORKFILE 
'''''''''''''''''''''''''''''''''''''''''''''''''''f''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'For "unsmoothed" output, set smoothing factor to zero in the Fair extension code.
WFOPEN "National model\fm_psrc_smoothed"
PAGESELECT Untitled
smpl 1970Q1 2050Q4
for %var gdpr_0 gdpd_0 pim pex_0 ph_0 e_0 wf_0 m1_0 ur_0 rs_0 rb_0 rm_0 ihh_0 y_0 yd_0 OLDAGEDR1664Q YOUTHDR16Q PCTPOPWORKAGE1664 DEMOG_VAR
	copy fm_psrc_smoothed::Untitled\{%var} PSRC2017::Quarterly\{%var}
next
close fm_psrc_smoothed

'Note: Construction of these population series could be done in the Fair extension code.
'Splice in updated Census estimtes for 2000-2016 and adjusted projections 2017-2050
PAGESELECT Annual
import "Input data\census_population.xls" range="US series 2000-2050!a1:f52"
for %var USPOP0 USPOP5 USPOP20 USPOP65 USPOP
	copy(c=c, smpl="2000 2016") Annual\{%var} Quarterly\
next

'Adjust for mid-year estimates and extend endpoints
for %var USPOP0 USPOP5 USPOP20 USPOP65 USPOP
	smpl 2000Q1 2050Q4
	genr {%var}={%var}(+2)
	'Extend final mid-year estimate to the end of the calendar year
	smpl 2050Q3 2050Q4
	genr {%var}={%var}(-1)*{%var}(-1)/{%var}(-2)
next

'Read 1950Q1-199Q4 quarterly data from Census series previously assembled 
PAGESELECT Quarterly
import(mode=u)  "Input data\US_Population.xls" range="USPOP_1970-2050!a1" @smpl "1970q1 2000q3"


'Label national variables
GDPR_0.displayname US GDP B2009$
GDPD_0.displayname GDP price deflator
PIM.displayname Price Deflator for Imports
PEX_0.displayname Price Deflator for Exports
PH_0.displayname Consumer Expenditure Deflator
E_0.displayname Total Employ, Civilian & Military, Millions
WF_0.displayname Avg Hourly Earnings, excludes OT in farming
M1_0.displayname Money Supply, End of Quarter
UR_0.displayname Civilian Unemployment Rate
RS_0.displayname 3-Month T-bill Rate, Percentage Points
RB_0.displayname Bond Rate, Percentage Points
RM_0.displayname Mortgage Rate, Percentage Points
IHH_0.displayname Residential Investment by Households B2009$
Y_0.displayname Total Production by F1, NN, and FA Businesses B2009$
YD_0.displayname Disposable Income (Personal Income) B$

'IMPORT PPI "FUEL & RELATED PRODUCTS & POWER" INDEX (OBTAINED FROM "FRED"; EXTENDED USING EIA GASOLINE PRICE FORECAST)
PAGESELECT Quarterly
READ(t=xls, c2, s=USPPI_fuel_quarterly.xls) "Regional data\PSRC_Macro_Trend\USPPI_fuel_quarterly.xls" 1

PPI.displayname USPPI Fuel & Related (1982=100)

uspop0.displayname US population 0-4
uspop5.displayname US population 5-19
uspop20.displayname US population 20-64
uspop65.displayname US population 65+
uspop.displayname US population total


'CREATE REGION-WIDE "HIGH-LEVEL" VARIABLES & THEN QUARTERIZE THEM

PAGESELECT Monthly
genr pnu = knu + bnu + snu + tnu
genr pngoodsu = kngoodsu + bngoodsu + sngoodsu + tngoodsu
genr pnservu = knservu + bnservu + snservu + tnservu
genr phsu = khsu + bhsu + shsu + thsu
genr phssu = khssu + bhssu + shssu + thssu
genr pnaeru = knaeru + bnaeru + snaeru + tnaeru

genr pnresu = knresu + bnresu + snresu + tnresu
genr pnconu = knconu + bnconu + snconu + tnconu
genr pnmfgu = knmfgu + bnmfgu + snmfgu + tnmfgu
genr pntrdu = kntrdu + bntrdu + sntrdu + tntrdu
genr pntrnutilu = kntrnutilu + bntrnutilu + sntrnutilu + tntrnutilu
genr pninfou = kninfou + bninfou + sninfou + tninfou
genr pnfinu = knfinu + bnfinu + snfinu + tnfinu
genr pnprofbusu = knprofbusu + bnprofbusu + snprofbusu + tnprofbusu
genr pnoservu = knoservu + bnoservu + snoservu + tnoservu
genr pngovu = kngovu + bngovu + sngovu + tngovu

genr pnoduru = knoduru + bnoduru + snoduru + tnoduru
genr pnnduru = knnduru + bnnduru + snnduru + tnnduru
genr pnwhtrdu = knwhtrdu + bnwhtrdu + snwhtrdu + tnwhtrdu
genr pnretrdu = knretrdu + bnretrdu + snretrdu + tnretrdu
genr pntrnu = kntrnu + bntrnu + sntrnu + tntrnu
genr pnutilu = knutilu + bnutilu + snutilu + tnutilu
genr pncomu = kncomu + bncomu + sncomu + tncomu
genr pnoinfou = knoinfou + bnoinfou + snoinfou + tnoinfou
genr pneatu = kneatu + bneatu + sneatu + tneatu
genr pneducu = kneducu + bneducu + sneducu + tneducu
genr pnhlthu = knhlthu + bnhlthu + snhlthu + tnhlthu
genr pnoservxu = knoservxu + bnoservxu + snoservxu + tnoservxu
genr pngovslu = kngovslu + bngovslu + sngovslu + tngovslu
genr pngovseducu = kngovseducu + bngovseducu + sngovseducu + tngovseducu
genr pngovleducu = kngovleducu + bngovleducu + sngovleducu + tngovleducu
genr pngovoslu = kngovoslu + bngovoslu + sngovoslu + tngovoslu
genr pngovfedu = kngovfedu + bngovfedu + sngovfedu + tngovfedu


PAGESELECT Annual
'Aggregate housing starts to annual
for %r p k b t s
	link {%r}hstarts
	{%r}hstarts.linkto(c=sum) Quarterly::{%r}hstarts
next

'Annualize SBE all-sales HPI
link sbe_ashpi
sbe_ashpi.linkto(c=mean) Quarterly::sbe_ashpi

'Annualize Case-Shiller
link sexrnsa
sexrnsa.linkto(c=mean) Quarterly::sexrnsa

PAGESELECT Quarterly
link pn
pn.linkto Monthly::pnu 
link pngoods
pngoods.linkto Monthly::pngoodsu 
link pnserv
pnserv.linkto Monthly::pnservu 
link phs
phs.linkto(c=sum) Monthly::phsu 
link phss
phss.linkto(c=sum) Monthly::phssu 

link pnres 
pnres.linkto Monthly::pnresu 
link pncon
pncon.linkto Monthly::pnconu 
link pnmfg
pnmfg.linkto Monthly::pnmfgu 
link pntrd 
pntrd.linkto Monthly::pntrdu 
link pntrnutil
pntrnutil.linkto Monthly::pntrnutilu 
link pninfo 
pninfo.linkto Monthly::pninfou 
link pnfin 
pnfin.linkto Monthly::pnfinu 
link pnprofbus 
pnprofbus.linkto Monthly::pnprofbusu 
link pnoserv 
pnoserv.linkto Monthly::pnoservu 
link pngov 
pngov.linkto Monthly::pngovu 

link pnodur
pnodur.linkto Monthly::pnoduru 
link pnndur
pnndur.linkto Monthly::pnnduru 
link pnwhtrd
pnwhtrd.linkto Monthly::pnwhtrdu
link pnretrd
pnretrd.linkto Monthly::pnretrdu
link pntrn
pntrn.linkto Monthly::pntrnu 
link pnutil
pnutil.linkto Monthly::pnutilu 
link pncom
pncom.linkto Monthly::pncomu 
link pnoinfo
pnoinfo.linkto Monthly::pnoinfou
link pneat
pneat.linkto Monthly::pneatu
link pneduc
pneduc.linkto Monthly::pneducu
link pnhlth
pnhlth.linkto Monthly::pnhlthu
link pnoservx
pnoservx.linkto Monthly::pnoservxu
link pnoinfo
pnoinfo.linkto Monthly::pnoinfou
link pngovsl
pngovsl.linkto Monthly::pngovslu
link pngovseduc
pngovseduc.linkto Monthly::pngovseducu
link pngovleduc
pngovleduc.linkto Monthly::pngovleducu
link pngovosl
pngovosl.linkto Monthly::pngovoslu
link pngovfed
pngovfed.linkto Monthly::pngovfedu

link ptech_sic
ptech_sic.linkto Monthly::ptech_sic
link pntech_naics
pntech_naics.linkto Monthly::pntech_naics
link n4541
n4541.linkto Monthly::n4541
link n454
n454.linkto Monthly::n454
link n44_45
n44_45.linkto Monthly::n44_45

link pnmil
pnmil.linkto(c=c) Annual::pnmil

link pnaeru
pnaeru.linkto Monthly::pnaeru
'link pnaerA
'pnaerA.linkto(c=c) Annual::pnaer
'Aerospace v2
import  "Regional data\AeroExog_v2.xlsx" range="AeroExog_v2.csv!a1" @smpl "1970Q1 2050Q4"
PNAER.displayname Puget Sound Aerospace Employment


link kyp
kyp.linkto(c=c) Annual::kyp
link byp
byp.linkto(c=c) Annual::byp
link typ
typ.linkto(c=c) Annual::typ
link syp
syp.linkto(c=c) Annual::syp
link wyp
wyp.linkto(c=c) Annual::wyp
link kyws
kyws.linkto(c=c) Annual::kyws
link byws
byws.linkto(c=c) Annual::byws
link tyws
tyws.linkto(c=c) Annual::tyws
link syws
syws.linkto(c=c) Annual::syws
link wyws
wyws.linkto(c=c) Annual::wyws

kyp.displayname King County Personal Income (quarterized)
byp.displayname Kitsap County Personal Income (quarterized)
typ.displayname Pierce County Personal Income (quarterized)
syp.displayname Snohomish County Personal Income (quarterized)
wyp.displayname Washington State Personal Income (quarterized)
kyws.displayname King County Wage & Salary Personal Income (quarterized)
byws.displayname Kitsap County Wage & Salary Personal Income (quarterized)
tyws.displayname Pierce County Wage & Salary Personal Income (quarterized)
syws.displayname Snohomish County Wage & Salary Personal Income (quarterized)
wyws.displayname Washington State Wage & Salary Personal Income (quarterized)

link wpop0
wpop0.linkto(c=c) Annual::wpop0
link wpop5
wpop5.linkto(c=c) Annual::wpop5
link wpop20
wpop20.linkto(c=c) Annual::wpop20
link wpop65
wpop65.linkto(c=c) Annual::wpop65
link wpop
wpop.linkto(c=c) Annual::wpop

wpop0.displayname Washington State 0-4 Population
wpop5.displayname Washington State 5-19 Population
wpop20.displayname Washington State 20-64 Population
wpop65.displayname Washington State 65+ Population
wpop.displayname Washington State Total Population

link kpop0
kpop0.linkto(c=c) Annual::kpop0
link kpop5
kpop5.linkto(c=c) Annual::kpop5
link kpop20
kpop20.linkto(c=c) Annual::kpop20
link kpop65
kpop65.linkto(c=c) Annual::kpop65
link kpop
kpop.linkto(c=c) Annual::kpop
link kpopgrqt
kpopgrqt.linkto(c=c) Annual::kpopgrqt
link kpophse
kpophse.linkto(c=c) Annual::kpophse
link kpophsesn
kpophsesn.linkto(c=c) Annual::kpophsesn
link kpophseml
kpophseml.linkto(c=c) Annual::kpophseml
link khse
khse.linkto(c=c) Annual::khse
link khsesn
khsesn.linkto(c=c) Annual::khsesn
link khseml
khseml.linkto(c=c) Annual::khseml
link khsesz
khsesz.linkto(c=c) Annual::khsesz
link khseszsn
khseszsn.linkto(c=c) Annual::khseszsn
link khseszml
khseszml.linkto(c=c) Annual::khseszml
kpop.displayname King County Population 
kpop0.displayname King Cty 0-4 Population
kpop20.displayname King Cty 20-64 Population 
kpop5.displayname King Cty 5-19 Population
kpop65.displayname King Cty 65+ Population
kpopgrqt.displayname King Cty Group Quarters Population
kpophse.displayname King Cty Household Population
kpophsesn.displayname King Cty Single-Family Population
kpophseml.displayname King Cty Multi-Family Population
khse.displayname King Cty Households
khsesn.displayname King Cty Single-Family Households
khseml.displayname King Cty Multi-Family Households
khsesz.displayname King Cty Household Size
khseszsn.displayname King Cty Household Size (Single-Family)
khseszml.displayname King Cty Household Size (Multi-Family)

link bpop0
bpop0.linkto(c=c) Annual::bpop0
link bpop5
bpop5.linkto(c=c) Annual::bpop5
link bpop20
bpop20.linkto(c=c) Annual::bpop20
link bpop65
bpop65.linkto(c=c) Annual::bpop65
link bpop
bpop.linkto(c=c) Annual::bpop
link bpopgrqt
bpopgrqt.linkto(c=c) Annual::bpopgrqt
link bpophse
bpophse.linkto(c=c) Annual::bpophse
link bpophsesn
bpophsesn.linkto(c=c) Annual::bpophsesn
link bpophseml
bpophseml.linkto(c=c) Annual::bpophseml
link bhse
bhse.linkto(c=c) Annual::bhse
link bhsesn
bhsesn.linkto(c=c) Annual::bhsesn
link bhseml
bhseml.linkto(c=c) Annual::bhseml
link bhsesz
bhsesz.linkto(c=c) Annual::bhsesz
link bhseszsn
bhseszsn.linkto(c=c) Annual::bhseszsn
link bhseszml
bhseszml.linkto(c=c) Annual::bhseszml
bpop.displayname Kitsap County Population 
bpop0.displayname Kitsap Cty 0-4 Population
bpop20.displayname Kitsap Cty 20-64 Population 
bpop5.displayname Kitsap Cty 5-19 Population
bpop65.displayname Kitsap Cty 65+ Population 
bpopgrqt.displayname Kitsap Cty Group Quarters Population
bpophse.displayname Kitsap Cty Household Population
bpophsesn.displayname Kitsap Cty Single-Family Population
bpophseml.displayname Kitsap Cty Multi-Family Population
bhse.displayname Kitsap Cty Households
bhsesn.displayname Kitsap Cty Single-Family Households
bhseml.displayname Kitsap Cty Multi-Family Households
bhsesz.displayname Kitsap Cty Household Size
bhseszsn.displayname Kitsap Cty Household Size (Single Family)
bhseszml.displayname Kitsap Cty Household Size (Multi-Family)

link tpop0
tpop0.linkto(c=c) Annual::tpop0
link tpop5
tpop5.linkto(c=c) Annual::tpop5
link tpop20
tpop20.linkto(c=c) Annual::tpop20
link tpop65
tpop65.linkto(c=c) Annual::tpop65
link tpop
tpop.linkto(c=c) Annual::tpop
link tpopgrqt
tpopgrqt.linkto(c=c) Annual::tpopgrqt
link tpophse
tpophse.linkto(c=c) Annual::tpophse
link tpophsesn
tpophsesn.linkto(c=c) Annual::tpophsesn
link tpophseml
tpophseml.linkto(c=c) Annual::tpophseml
link thse
thse.linkto(c=c) Annual::thse
link thsesn
thsesn.linkto(c=c) Annual::thsesn
link thseml
thseml.linkto(c=c) Annual::thseml
link thsesz
thsesz.linkto(c=c) Annual::thsesz
link thseszsn
thseszsn.linkto(c=c) Annual::thseszsn
link thseszml
thseszml.linkto(c=c) Annual::thseszml
tpop.displayname Pierce County Population 
tpop0.displayname Pierce Cty 0-4 Population
tpop20.displayname Pierce Cty 20-64 Population 
tpop5.displayname Pierce Cty 5-19 Population
tpop65.displayname Pierce Cty 65+ Population
tpopgrqt.displayname Pierce Cty Group Quarters Population
tpophse.displayname Pierce Cty Household Population
tpophsesn.displayname Pierce Cty Single-Family Population
tpophseml.displayname Pierce Cty Multi-Family Population
thse.displayname Pierce Cty Households
thsesn.displayname Pierce Cty Single-Family Households
thseml.displayname Pierce Cty Multi-Family Households
thsesz.displayname Pierce Cty Household Size
thseszsn.displayname Pierce Cty Household Size (Single-Family)
thseszml.displayname Pierce Cty Household Size (Multi-Family)

link spop0
spop0.linkto(c=c) Annual::spop0
link spop5
spop5.linkto(c=c) Annual::spop5
link spop20
spop20.linkto(c=c) Annual::spop20
link spop65
spop65.linkto(c=c) Annual::spop65
link spop
spop.linkto(c=c) Annual::spop
link spopgrqt
spopgrqt.linkto(c=c) Annual::spopgrqt
link spophse
spophse.linkto(c=c) Annual::spophse
link spophsesn
spophsesn.linkto(c=c) Annual::spophsesn
link spophseml
spophseml.linkto(c=c) Annual::spophseml
link shse
shse.linkto(c=c) Annual::shse
link shsesn
shsesn.linkto(c=c) Annual::shsesn
link shseml
shseml.linkto(c=c) Annual::shseml
link shsesz
shsesz.linkto(c=c) Annual::shsesz
link shseszsn
shseszsn.linkto(c=c) Annual::shseszsn
link shseszml
shseszml.linkto(c=c) Annual::shseszml
spop.displayname Snohomish County Population 
spop0.displayname Snohomish Cty 0-4 Population
spop20.displayname Snohomish Cty 20-64 Population 
spop5.displayname Snohomish Cty 5-19 Population
spop65.displayname Snohomish Cty 65+ Population
spopgrqt.displayname Snohomish Cty Group Quarters Population
spophse.displayname Snohomish Cty Household Population
spophsesn.displayname Snohomish Cty Single-Family Population
spophseml.displayname Snohomish Cty Multi-Family Population
shse.displayname Snohomish Cty Households
shsesn.displayname Snohomish Cty Single-Family Households
shseml.displayname Snohomish Cty Multi-Family Households
shsesz.displayname Snohomish Cty Household Size
shseszsn.displayname Snohomish Cty Household Size (Single-Family)
shseszml.displayname Snohomish Cty Household Size (Multi-Family)

link kretail
kretail.linkto(c=c) Annual::kretail
link bretail
bretail.linkto(c=c) Annual::bretail
link tretail
tretail.linkto(c=c) Annual::tretail
link sretail
sretail.linkto(c=c) Annual::sretail
KRETAIL.displayname King Taxable Retail Sales
BRETAIL.displayname Kitsap Taxable Retail Sales
SRETAIL.displayname Pierce Taxable Retail Sales
TRETAIL.displayname Snohomish Taxable Retail Sales


link kfuel
kfuel.linkto(c=c) Annual::kfuel
link bfuel
bfuel.linkto(c=c) Annual::bfuel
link tfuel
tfuel.linkto(c=c) Annual::tfuel
link sfuel
sfuel.linkto(c=c) Annual::sfuel
link wfuel
wfuel.linkto(c=c) Annual::wfuel
KFUEL.displayname King County Total Fuel Sold (thous. gallons)
BFUEL.displayname Kitsap County Total Fuel Sold (thous. gallons)
TFUEL.displayname Pierce County Total Fuel Sold (thous. gallons)
SFUEL.displayname Snohomish County Total Fuel Sold (thous. gallons)
WFUEL.displayname Washington State Total Fuel Sold (thous. gallons)


link kcar
kcar.linkto(c=c) Annual::kcar
link ktrkgas
ktrkgas.linkto(c=c) Annual::ktrkgas
link ktrkdie
ktrkdie.linkto(c=c) Annual::ktrkdie
link kothveh
kothveh.linkto(c=c) Annual::kothveh
KCAR.displayname King County Passenger Vehicles
KTRKGAS.displayname King County Gasoline Trucks
KTRKDIE.displayname King County Diesel Trucks
KOTHVEH.displayname King County Other Vehicles

link bcar
bcar.linkto(c=c) Annual::bcar
link btrkgas
btrkgas.linkto(c=c) Annual::btrkgas
link btrkdie
btrkdie.linkto(c=c) Annual::btrkdie
link bothveh
bothveh.linkto(c=c) Annual::bothveh
BCAR.displayname King County Passenger Vehicles
BTRKGAS.displayname King County Gasoline Trucks
BTRKDIE.displayname King County Diesel Trucks
BOTHVEH.displayname King County Other Vehicles

link tcar
tcar.linkto(c=c) Annual::tcar
link ttrkgas
ttrkgas.linkto(c=c) Annual::ttrkgas
link ttrkdie
ttrkdie.linkto(c=c) Annual::ttrkdie
link tothveh
tothveh.linkto(c=c) Annual::tothveh
TCAR.displayname King County Passenger Vehicles
TTRKGAS.displayname King County Gasoline Trucks
TTRKDIE.displayname King County Diesel Trucks
TOTHVEH.displayname King County Other Vehicles

link scar
scar.linkto(c=c) Annual::scar
link strkgas
strkgas.linkto(c=c) Annual::strkgas
link strkdie
strkdie.linkto(c=c) Annual::strkdie
link sothveh
sothveh.linkto(c=c) Annual::sothveh
SCAR.displayname Snohomish County Passenger Vehicles
STRKGAS.displayname Snohomish County Gasoline Trucks
STRKDIE.displayname Snohomish County Diesel Trucks
SOTHVEH.displayname Snohomish County Other Vehicles

link wcar
wcar.linkto(c=c) Annual::wcar
link wtrkgas
wtrkgas.linkto(c=c) Annual::wtrkgas
link wtrkdie
wtrkdie.linkto(c=c) Annual::wtrkdie
link wothveh
wothveh.linkto(c=c) Annual::wothveh
WCAR.displayname Washington State Passenger Vehicles
WTRKGAS.displayname Washington State Gasoline Trucks
WTRKDIE.displayname Washington State Diesel Trucks
WOTHVEH.displayname Washington State Other Vehicles


link kmvet
kmvet.linkto(c=c) Annual::kmvet
link bmvet
bmvet.linkto(c=c) Annual::bmvet
link tmvet
tmvet.linkto(c=c) Annual::tmvet
link smvet
smvet.linkto(c=c) Annual::smvet
KMVET.displayname King County MVET Base Value
BMVET.displayname Kistap County MVET Base Value
TMVET.displayname Pierce County MVET Base Value
SMVET.displayname Snohomish County MVET Base Value


link kunrt
kunrt.linkto Monthly::kunrtu
link bunrt
bunrt.linkto Monthly::bunrtu
link tunrt
tunrt.linkto Monthly::tunrtu
link sunrt
sunrt.linkto Monthly::sunrtu
kunrt.displayname King County Unemp Rate (not seasonally adjusted)
bunrt.displayname Kitsap County Unemp Rate (not seasonally adjusted)
tunrt.displayname Pierce County Unemp Rate (not seasonally adjusted)
sunrt.displayname Shohomish County Unemp Rate (not seasonally adjusted)


genr ppop = bpop + kpop + spop + tpop
genr ppop0 = bpop0 + kpop0 + spop0 + tpop0
genr ppop5 = bpop5 + kpop5 + spop5 + tpop5
genr ppop20 = bpop20 + kpop20 + spop20 + tpop20 
genr ppop65 = bpop65 + kpop65 + spop65 + tpop65 
genr ppop = bpop + kpop + spop + tpop
genr phse = bhse + khse + shse + thse

genr ppopgrqt = bpopgrqt + kpopgrqt + spopgrqt + tpopgrqt
genr ppophse = bpophse +kpophse +spophse + tpophse
genr ppophsesn = bpophsesn + kpophsesn + spophsesn + tpophsesn
genr ppophseml = bpophseml + kpophseml + spophseml + tpophseml
genr phsesn = bhsesn + khsesn + shsesn + thsesn
genr phseml = bhseml + khseml + shseml + thseml


'QUARTERIZE VARIABLES NEEDED FOR COUNTY-LEVEL FORECASTS
link kn
kn.linkto Monthly::knu
link bn
bn.linkto Monthly::bnu
link sn
sn.linkto Monthly::snu
link tn
tn.linkto Monthly::tnu

link kngoods
kngoods.linkto Monthly::kngoodsu
link bngoods
bngoods.linkto Monthly::bngoodsu
link sngoods
sngoods.linkto Monthly::sngoodsu
link tngoods
tngoods.linkto Monthly::tngoodsu


link knserv
knserv.linkto Monthly::knservu
link bnserv
bnserv.linkto Monthly::bnservu
link snserv
snserv.linkto Monthly::snservu
link tnserv
tnserv.linkto Monthly::tnservu


link knaer
knaer.linkto Monthly::knaeru
link bnaer
bnaer.linkto Monthly::bnaeru
link snaer
snaer.linkto Monthly::snaeru
link tnaer
tnaer.linkto Monthly::tnaeru


'*** SET SAMPLE RANGES FOR REFERENCE IN MODEL -- Adjust as necessary
'*** BECAUSE SOME DATA SERIES ARE LESS CURRENT, MODEL FILE CURRENTLY USES MORE HARD-CODED SAMPLE STATEMENTS THAN BEFORE
SAMPLE s1970_start 1970q1 2016q4
SAMPLE s1971_start 1971q1 2017q1
SAMPLE s1990_start 1990Q1 2013Q4
SAMPLE s1980_end 1980Q1 2050Q4
SAMPLE s1990_end 1990Q1 2050Q4
SAMPLE s1995_end 1995Q1 2050Q4
SAMPLE s2000_end 2000q1 2050Q4
SAMPLE s2005_end 2005Q1 2050Q4
SAMPLE s1970_end 1970Q1 2050Q4
SAMPLE s1971_end 1971Q1 2050Q4
SAMPLE s1970_YRstart 1970Q1 2017Q2 'Started 1970Q4 in prior version
SAMPLE sQB4cast 2016Q1 2050Q4 'This was 2013Q1 in prior version.
SAMPLE s4cast 2017Q1 2050Q4 'This was 2014Q1 in prior version

wfsave psrc2017_smoothed
wfclose psrc2017_smoothed


