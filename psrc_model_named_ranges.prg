'***************************************************************************************
'***************************************************************************************
'**** PSRC LONG-TERM ECONOMIC & REVENUE FORECASTING MODELS ****
'***************************************************************************************
'***************************************************************************************

'THE EVIEWS FILE "IMPORT_HIST_DATA_2017.PRG" CREATES THE FORECASTING DATABASE BASED 
'ON A COLLECTION OF EXCEL DATA FILES AND THE FAIR MODEL EXTENSION.
close @wf

'Set suffix for saved files:
%save_suf="v6_smoothed_alt_v2"

'Modify paths as necessary
cd "D:\Users\ehaswell\Dropbox (ECONW)\22798 PSRC MacroForecast and Revenue Update\2017 Forecast update\"
wfopen psrc2017_smoothed

pageselect Monthly
smpl 1990m1 2017m5
'Info/com less important, per Jensen e-mail
'Adjustments allow model to run without additional modification
bncomu=@recode(bncomu=na,0,bncomu)
tncomu=@recode(tncomu=na,0,tncomu)
pncomu=@recode(pncomu=na,kncomu+sncomu,pncomu)
bnoinfou=@recode(bnoinfou=na,0,bnoinfou)
tnoinfou=@recode(tnoinfou=na,0,tnoinfou)
pnoinfou=@recode(pnoinfou=na,knoinfou+snoinfou,pnoinfou)

pageselect Quarterly

'*** CREATE PUGET SOUND WORKFORCE VARIABLE
SMPL s1970_end
GENR kwkfc = kn/(1-kunrt)
GENR bwkfc = bn/(1-bunrt)
GENR twkfc = tn/(1-tunrt)
GENR swkfc = sn/(1-sunrt)
GENR pwkfc = kwkfc + bwkfc + twkfc + swkfc
GENR dpwkfc = log(pwkfc/pwkfc(-4))

'*** CREATE PUGET SOUND POPULATION VARIABLES
SMPL s1970_end
GENR dppop0 = log(ppop0/ppop0(-4))
GENR dppop5 = log(ppop5/ppop5(-4))
GENR dppop20 = log(ppop20/ppop20(-4))
GENR dppop65 = log(ppop65/ppop65(-4))
GENR dppophse = log(ppophse/ppophse(-4))

'*** CREATE U.S. POPULATION VARIABLES
SMPL s1970_end
GENR duspop = log(uspop/uspop(-4))
GENR duspop0 = log(uspop0/uspop0(-4))
GENR duspop5 = log(uspop5/uspop5(-4))
GENR duspop20 = log(uspop20/uspop20(-4))
GENR duspop65 = log(uspop65/uspop65(-4))

'*** CREATE AEROSPACE (BOEING) & MICROSOFT ECONOMIC DRIVER VARIABLES

'Combine historic and forecast of aerospace employment
smpl @first 2017Q2
genr pnaer=pnaeru
smpl 2017Q3 @last
'pnaer=pnaer(-1)*(pnaerA/pnaerA(-1))
'Boeing strikes
smpl @all
genr boeing_strike_dum=@event("1997Q4")+@event("1995Q4")+@event("2000Q1")+@event("2005Q3")+@event("2008Q4")

smpl s1970_end
GENR dpnaer = log(pnaer/pnaer(-4))
SMPL if pnms=0
GENR pnms = 0.00001
SMPL s1970_end
GENR dpnms = log(pnms/pnms(-4))

'*** CREATE MICROSOFT STOCK OPTION INCOME VARIABLE
SMPL s4cast
GENR dpystk = 0
SMPL if pystk=0
GENR pystk = 0.00001
SMPL s1970_end
GENR dpystk = log(pystk/pystk(-1))

'*** CREATE DUMMY VARIABLES TO INDICATE MS DIVIDEN PAYOUT IN 2004Q4
SMPL s1970_end
GENR dum_ms = 0
GENR dum_ms1 = 0
GENR dum_ms2 = 0
SMPL 2004Q4 2004Q4
GENR dum_ms1 = dum_ms1 + 1
GENR dum_ms = dum_ms + 1
SMPL 2005Q4 2005Q4
GENR dum_ms2 = dum_ms2 + 1
GENR dum_ms = dum_ms - 1

'*** COMPUTE US LABOR FORCE VARIABLE & INDEX DEFLATOR TO REFERENCE YEARS
SMPL s1970_end
GENR uswkfc = e_0 / (1-ur_0)
GENR duswkfc = log(uswkfc/uswkfc(-4))
GENR uscpi82 = (ph_0 / 0.568222) '1983Q3 - Midpoint of 1982-1984
GENR usced00 = (ph_0 / 0.906840) '2000Q3


'GENERATE 1ST DIFFERENCE OF LOGS OF PUGET SOUND POP & HH VARIABLES
SMPL s1970_end
GENR dpn = log(pn/pn(-4))
GENR dwyp = log(wyp/wyp(-4))
GENR dwyws = log(wyws/wyws(-4))
GENR dscpi = log(scpi/scpi(-4))
GENR dphs = log(phs/phs(-4))
GENR dphss = log(phss/phss(-4))
GENR dppop = log(ppop/ppop(-4))
GENR dppop0 = log(ppop0/ppop0(-4))
GENR dppop5 = log(ppop5/ppop5(-4))
GENR dppop20 = log(ppop20/ppop20(-4))
GENR dppop65 = log(ppop65/ppop65(-4))
GENR dphse = log(phse/phse(-4))


'GENERATE 1ST DIFFERENCE OF LOGS OF FAIR VARIABLES
SMPL s1970_end
GENR dgdpr = log(gdpr_0/gdpr_0(-4))
GENR dgdpd = log(gdpd_0/gdpd_0(-4))
GENR dgdpn = dgdpr + dgdpd
GENR dpim = log(pim/pim(-4))
GENR dpex = log(pex_0/pex_0(-4))
GENR de = log(e_0/e_0(-4))
GENR dwf = log(wf_0/wf_0(-4))
GENR dm1 = log(m1_0/m1_0(-4))
GENR dppi = log(ppi/ppi(-4))
GENR dy = log(y_0/y_0(-4))
GENR drs = log(rs_0/rs_0(-4))
GENR duspi = log(yd_0/yd_0(-4))

GENR drm=log(rm_0/rm_0(-4))
GENR drb=log(rb_0/rb_0(-4))
GENR dur=log(ur_0/ur_0(-4))
GENR dph=log(ph_0/ph_0(-4))


'*** CREATE PERSONAL CONSUMPTION EXPENDITURE VARIABLE
SMPL s1970_end
GENR dpce = log(usced00 / usced00(-4))
GENR duscpi = log(uscpi82 / uscpi82(-4))

'**************************************************
'ESTIMATE EXOGENOUG EQUATIONS FOR BOEING (PNAER) MICROSOFT (PNMS)
'**************************************************
SMPL s1970_end
GENR ms_grow = 0
GENR ms_trend = @trend
SMPL 1990Q1 1992Q4
GENR ms_grow = ms_grow + 1
SMPL 1995Q1 1996Q4
GENR ms_grow = ms_grow + 1
SMPL 1998Q1 1998Q4
GENR ms_grow = ms_grow + 1
SMPL 2000Q1 2000Q4
GENR ms_grow = ms_grow + 1
SMPL s4cast
GENR ms_trend = ms_trend(-4) + 2.5
a
SMPL s1980_start
'Boeing equation is no longer necessary, as aerospace forecast is produced outside of the model
EQUATION exog_boeing.ls dpnaer c dgdpr(-1) dgdpr(-2) ma(7) 
SMPL s1990_start
EQUATION exog_ms.ls dpnms c ms_grow dgdpr ms_trend*dgdpr 

MODEL model_exog
model_exog.merge exog_boeing
model_exog.merge exog_ms
SMPL s1990_end
model_exog.solve


'UPDATE DEPENDENT VARS FROM LEVEL 1 WITH FORECAST VALUES
SMPL s4cast
GENR dpnms = dpnms_0


'**************************************************
'ESTIMATE MODEL 1: TOTAL EMPLOYMENT; TOTAL PERSONAL INCOME; TOTAL 
'WAGE & SALARY INCOME; PUGET SOUND CPI
'**************************************************
SMPL s1970_end
genr dduspop=log(duspop/duspop(-4))
rename yd_0 yd

'Generate population shares from OFM forecast through 2040
smpl @all
genr ppop_0=ppop
genr ppop0_0=ppop0
genr ppop5_0=ppop5
genr ppop20_0=ppop20
genr ppop65_0=ppop65
for %n 0 5 20 65
	genr dwpop{%n}=log(wpop{%n}/wpop{%n}(-4))
next

'Extend state through 2050 using US population forecast
for %n 0 5 20 65
	smpl 1972q1 2040Q4
	genr wpop{%n}_0=wpop{%n}
	equation eq_mp{%n}.ls dwpop{%n} c dwpop{%n}(-1) duspop{%n}(-1)
	smpl 2041Q1 2050Q4 	
	eq_mp{%n}.forecast dwpop{%n}_0
	genr dwpop{%n}=dwpop{%n}_0
	wpop{%n}_0=wpop{%n}_0(-4)*exp(dwpop{%n}_0)
next

smpl 1972Q1 2050Q4
genr wpop_0=wpop0_0+wpop5_0+wpop20_0+wpop65_0
genr dwpop_0=log(wpop_0/wpop_0(-4))

for %var phstarts sbe_ashpi yd
	genr d{%var}=log({%var}/{%var}(-4))
next

smpl @first 2017q2
VAR MOD1.ls(h) 1 2 dwyp dscpi dwyws @ C dppi(-1) dppi(-2) dppi(-3) dppi(-4) dy(-1) dy(-2) dy(-3) dy(-4) dgdpd(-1) dgdpd(-2) dgdpd(-3) dgdpd(-4) dpnaer(-1) dpnaer(-2) boeing_strike_dum de(-1) de(-2) de(-3) de(-4) demog_var(-1)

model one
one.merge mod1
smpl 2016q1 2050q4
one.solve

'Housing
pageselect Annual
smpl @all
link phstarts
phstarts.linkto(c=s) Quarterly::phstarts
genr phstart_stock=phstarts/pstock_acs
genr delpstock_acs=pstock_acs-pstock_acs(-1)
genr dsbe_ashpi=log(sbe_ashpi/sbe_ashpi(-1))

ls delpstock_acs C phstarts(-2)
!stock_adjust=@coefs(2)

pageselect Quarterly
link pstock_acs
pstock_acs.linkto(c=c) Annual::pstock_acs

smpl @all
var pstarts.ls(h) 1 2 dphstarts dsbe_ashpi @ C dgdpr(-1) dyd(-1) dgdpr(-2) dyd(-2) dwyp_0(-1) dwyp_0(-2)
model starts
starts.merge pstarts

smpl 2017q3 @last
starts.solve
 
'Create forecast levels
for %var phstarts sbe_ashpi
	smpl @first 2017q2
	genr {%var}_0={%var}
	smpl 2017q3 @last
	{%var}_0={%var}_0(-4)*exp(d{%var}_0)
next
smpl @first 2016q4
genr pstock_acs_0=pstock_acs
smpl 2017q1 @last
pstock_acs_0=pstock_acs_0(-1)+phstarts_0*!stock_adjust
genr dpstock_acs_0=log(pstock_acs_0/pstock_acs_0(-4))

'Emploment, population
smpl @all

'CONVERT (change in) NOMINAL WASHINGTON PERSONAL INCOME INTO REAL
GENR dwyws00 = dwyws_0 - dpce
GENR dwyp00 = dwyp_0 - dpce

for %var wyws wyp
	smpl @first  2015q4
	genr {%var}_0={%var}
	smpl 2016q1 @last
	{%var}_0={%var}_0(-4)*exp(d{%var}_0)
next

pageselect Quarterly
smpl @all

'Note: We lose data through 1982Q2 because of shorter housing starts series
EQUATION MOD3b.ls dpn C dpnaer(-1) boeing_strike_dum dwyws_0(-1) dscpi_0(-1)  dgdpd(-1) de(-1) ar(1) ar(4) ar(5) ar(8)
MODEL model3
model3.merge MOD3b
smpl 2017q1 2050q4 'Consistent with end of some data series
model3.solve

smpl @first 2016q4
genr pn_0=pn
smpl 2017q1 2050q4
pn_0=pn_0(-4)*exp(dpn_0)

smpl @all
VAR MOD4A.ls 1 4 dppop dwpop_0 @ dpn_0(-1) dwyws_0(-1) dwyws_0(-2) dsbe_ashpi_0(-1) duspop(-1)
MODEL model4a
model4a.merge MOD4A
smpl 2017q1 2050q4
model4a.solve

smpl @first 2016q4
genr pn_0=pn
genr ppop_0=ppop
genr ppop20_0=ppop20

smpl 2017q1 2050q4
pn_0=pn_0(-4)*exp(dpn_0)
ppop_0=ppop_0(-4)*exp(dppop_0)

dpn=dpn_0 'Naming not consistently used below.
dscpi=dscpi_0

smpl 2016q1 2050q4
dwyp=dwyp_0
dwyws=dwyws_0

'UPDATE DEPENDENT VARS FROM LEVEL 1 WITH FORECAST VALUES
SMPL s1970_end
GENR rs = rs_0
GENR rb = rb_0
GENR rm = rm_0
GENR ur = ur_0


'**************************************************
'LEVEL 2 POPULATION-DEMOGRAPHIC EQUATIONS
'**************************************************
smpl 2017q1 @last
dppop=dppop_0

for %n 0 5 20 65
	smpl 1970Q1 2016Q4
	equation eq_dppop{%n}.ls dppop{%n} c dppop(-1) duspop{%n}(-1) dwpop{%n}(-1)
	genr ppop{%n}_0=ppop{%n}
	smpl 2017Q1 2050Q4
	eq_dppop{%n}.forecast dppop{%n}_0
	genr dppop{%n}=dppop{%n}_0
	genr ppop{%n}_0=ppop{%n}_0(-4)*exp(dppop{%n})
next

'*** CONTROL AGE COHORT POPULATION GROWTH TO TOTAL POPULATION 
smpl 2017q1 2050q4
GENR adj_agepop = ppop_0 / (ppop0_0 + ppop5_0 + ppop20_0 + ppop65_0)
GENR ppop0_0  = ppop0_0  * adj_agepop
GENR ppop5_0  = ppop5_0  * adj_agepop 
GENR ppop20_0 = ppop20_0 * adj_agepop
GENR ppop65_0 = ppop65_0 * adj_agepop 

'Ratio of pop. 20-64 change to employment change
smpl @all
genr del_pop2064=ppop20_0-ppop20_0(-4)
genr del_pop2064_new=del_pop2064
genr del_pn=pn_0-pn_0(-4)
genr popemprat=del_pop2064/del_pn
genr popemprat_new=popemprat

'PSRC scenario
'To "undo" the scenario, modify the code as indicated below (near the next "smpl @all").
smpl 2017q1 2030q4
popemprat_new=0.7
smpl 2031q1 2032q4
popemprat_new=0.8
smpl 2033q1 2036q4
popemprat_new=0.9
smpl 2037q1 2037q4
popemprat_new=0.95
smpl 2038q1 2038q4
popemprat_new=1	
smpl 2039q1 2040q4
popemprat_new=1.1
smpl 2041q1 2050q4
popemprat_new=1.2

'Adjust 20-64 pop. per PSRC scenario
smpl 2017q1 2050q4
del_pop2064_new=del_pn*popemprat_new

smpl @all
genr del_sum=0
smpl 2017q1 2050q4
'To "undo" the scenario, set del_sum=0 after the line below.
del_sum=del_sum(-4)+del_pop2064_new-del_pop2064

'Allocate across age groups
for %var ppop0 ppop5 ppop20 ppop65
	{%var}_0={%var}_0+(del_sum*{%var}_0/ppop_0)
next
ppop_0=ppop0_0+ppop5_0+ppop20_0+ppop65_0

for %var ppop ppop0 ppop5 ppop20 ppop65
	d{%var}_0=log({%var}_0/{%var}_0(-4))
next

smpl 1970q1 2016q4

EQUATION e2_dphse.ls dphse c dphse(-1) dphse(-2) dppop5(-1) dpn(-1) dsbe_ashpi_0(-1)	
EQUATION e2_dppophse.ls dppophse c dppop dppop(-1) dppophse(-1) dpn(-1) dsbe_ashpi_0(-1)
EQUATION e2_dpwkfc.ls dpwkfc c dpwkfc(-1) dpn dpn(-1) dsbe_ashpi_0(-4)
SMPL s1970_end

'CREATE MODEL FROM LEVEL 2 SYSTEM OF EQUATIONS
smpl 1970Q1 2050Q4

MODEL model_2
model_2.merge e2_dphse
model_2.merge e2_dppophse
model_2.merge e2_dpwkfc

'smpl 1980Q1 2050Q4
smpl 2017q1 2050q4
model_2.solve

'EXTEND MODEL 2 VARS BASED ON FORECAST
SMPL sQB4cast
GENR dphse    = dphse_0
GENR dppophse = dppophse_0

'*** COMPUTE "EMPLOYMENT RATE" AND FORECAST
SMPL s1970_start
GENR emprate = pn / pwkfc
GENR work_trend = @trend
SMPL s4cast
GENR work_trend = work_trend(-1)
SMPL s1970_end
GENR uslabfc = e_0 / (1-ur_0/100)
GENR us_emprate = e_0 / uslabfc

SMPL s1970_start
EQUATION aaa_emprate.ls emprate  c us_emprate

SMPL s4cast
aaa_emprate.forecast emprate_0

SMPL s1970_start
GENR emprate_0 = emprate
GENR pn_0 = pn
SMPL s4cast
GENR emprate_0 = emprate_0
GENR pn_0 = pn_0(-4) * exp(dpn_0)
GENR pwkfc_0 = pn_0/emprate_0
SMPL s1970_end


'********************************************************
'LEVEL 3 OLS EQUATIONS---HIGHEST NAICS INDUSTRY SECTORS
'********************************************************
'GENERATE 1st DIFF OF LOGS FOR 2nd STAGE EQUATIONS
SMPL s1970_start
GENR dpnres = log(pnres/pnres(-4))
GENR dpncon = log(pncon/pncon(-4))
GENR dpnmfg = log(pnmfg/pnmfg(-4))
GENR dpntrd = log(pntrd/pntrd(-4))
GENR dpntrnutil = log(pntrnutil/pntrnutil(-4))
GENR dpninfo = log(pninfo/pninfo(-4))
GENR dpnfin = log(pnfin/pnfin(-4))
GENR dpnprofbus = log(pnprofbus/pnprofbus(-4))
GENR dpnoserv = log(pnoserv/pnoserv(-4))
GENR dpngov = log(pngov/pngov(-4))

SMPL s1970_start
GENR mfg_b0 = 1
SMPL s4cast
GENR mfg_b0 = .5

SMPL s1970_start

EQUATION e3_dpnres.ls dpnres c dscpi dpnres(-1) 
EQUATION e3_dpncon.ls dpncon c dpn dppop dpim(-1) rb dscpi
EQUATION e3_dpnmfg.ls dpnmfg mfg_b0 dppop(-1) dwyws00 dpnmfg(-1) dpn(-1) dpn 
EQUATION e3_dpntrd.ls dpntrd c dwyp00  
EQUATION e3_dpntrnutil.ls dpntrnutil  dpntrnutil(-1) dpn 
EQUATION e3_dpninfo.ls dpninfo c dpn dpninfo(-1) 
EQUATION e3_dpnfin.ls dpnfin c dppop dpim dpn dpnfin(-1) 
EQUATION e3_dpnprofbus.ls dpnprofbus  dpex dpn dpnprofbus(-1) dpn(-1) dm1(-1) dscpi 
EQUATION e3_dpnoserv.ls dpnoserv c dwyws00 dpnoserv(-1) dpn(-1) dpn rb(-1) dpim 
EQUATION e3_dpngov.ls dpngov c dwyp00(-1) dpngov(-1) dpn

'CREATE MODEL FROM LEVEL 3 EQUATIONS
SMPL s1970_end
MODEL model_3
model_3.merge e3_dpnres
model_3.merge e3_dpncon
model_3.merge e3_dpnmfg
model_3.merge e3_dpntrd
model_3.merge e3_dpntrnutil
model_3.merge e3_dpninfo
model_3.merge e3_dpnfin
model_3.merge e3_dpnprofbus
model_3.merge e3_dpnoserv
model_3.merge e3_dpngov
SMPL s1980_end
model_3.solve

'EXTEND MODEL 3 VARS BASED ON FORECAST
SMPL s4cast
GENR DPNRES = DPNRES_0
GENR DPNCON = DPNCON_0
GENR DPNMFG = DPNMFG_0
GENR DPNTRD =  DPNTRD_0
GENR DPNTRNUTIL =  DPNTRNUTIL_0
GENR DPNINFO = DPNINFO_0
GENR DPNFIN = DPNFIN_0
GENR DPNPROFBUS = DPNPROFBUS_0
GENR DPNOSERV = DPNOSERV_0
GENR DPNGOV =DPNGOV_0

SMPL s1970_end


'**********************************************************************
'LEVEL 4 SYSTEM OF SUR EQUATIONS---2ND-HIGHEST NAICS INDUSTRY SECTORS
'NOTE: THE DATA BEGIN IN 1990
'**********************************************************************
'GENERATE 1st DIFF OF LOGS FOR 4th STAGE EQUATIONS
GENR dpnwhtrd = log(pnwhtrd/pnwhtrd(-4))
GENR dpnretrd = log(pnretrd/pnretrd(-4))
GENR dpntrn = log(pntrn/pntrn(-4))
GENR dpnutil = log(pnutil/pnutil(-4))
GENR dpnoinfo = log(pnoinfo/pnoinfo(-4))
GENR dpncom = log(pncom/pncom(-4))
GENR dpneat = log(pneat/pneat(-4))
GENR dpneduc = log(pneduc/pneduc(-4))
GENR dpnhlth = log(pnhlth/pnhlth(-4))
GENR dpnoservx = log(pnoservx/pnoservx(-4))
GENR dpngovseduc = log(pngovseduc/pngovseduc(-4))
GENR dpngovleduc = log(pngovleduc/pngovleduc(-4))
GENR dpngovosl = log(pngovosl/pngovosl(-4))

SMPL s1990_start
EQUATION e4_dpnwhtrd.ls dpnwhtrd c dpn dpnwhtrd(-1) 
EQUATION e4_dpnretrd.ls dpnretrd c dwyp00 dpn dpnaer dwyws00 dpnretrd(-1) 
EQUATION e4_dpntrn.ls dpntrn c dpn dpnaer(-1) dwyp00 dpntrn(-1) 

SMPL 1990Q1 2001Q4
EQUATION e4_dpnutil.ls dpnutil  dpnutil(-1) dpn(-1)
EQUATION e4_dpncom.ls dpncom dpn(-1) dpncom(-1) 

SMPL s1990_start
EQUATION e4_dpnoinfo.ls dpnoinfo  dpnoinfo(-1) dwyws00(-1) 
EQUATION e4_dpneat.ls dpneat c dpn dpneat(-1) dppop65
EQUATION e4_dpneduc.ls dpneduc c dwyws00 dpneduc(-1)
EQUATION e4_dpnhlth.ls dpnhlth c dpnaer  dpnhlth(-1) dpnms dppop65  'dpn(-1)
EQUATION e4_dpnoservx.ls dpnoservx c dppop20(-1) dwyws00 dpnoservx(-1) 
EQUATION e4_dpngovseduc.ls dpngovseduc c dwyws00 dppop20 dpngovseduc(-1) 
EQUATION e4_dpngovleduc.ls dpngovleduc c dpn(-1) dwyws00 dpngovleduc(-1) 
EQUATION e4_dpngovosl.ls dpngovosl c dpngovosl(-1) dppop20 dwyws00(-1) 

SMPL s1990_end

'CREATE MODEL FROM LEVEL 4 SYSTEM OF EQUATIONS
MODEL model_4
model_4.merge e4_dpnwhtrd
model_4.merge e4_dpnretrd
model_4.merge e4_dpntrn
model_4.merge e4_dpnutil
model_4.merge e4_dpncom
model_4.merge e4_dpnoinfo
model_4.merge e4_dpneat
model_4.merge e4_dpneduc
model_4.merge e4_dpnhlth
model_4.merge e4_dpnoservx
model_4.merge e4_dpngovseduc
model_4.merge e4_dpngovleduc
model_4.merge e4_dpngovosl
SMPL s1995_end
model_4.solve


'EXTEND MODEL 4 VARS BASED ON FORECAST
SMPL s4cast
GENR dpnwhtrd = dpnwhtrd_0 
GENR dpnretrd  = dpnretrd_0
GENR dpntrn = dpntrn_0
GENR dpnoinfo = dpnoinfo_0
GENR dpncom  = dpncom_0
GENR dpneat  = dpneat_0
GENR dpneduc  = dpneduc_0
GENR dpnutil  = dpnutil_0
GENR dpnoservx  = dpnoservx_0
GENR dpnhlth  = dpnhlth_0
GENR dpngovseduc  = dpngovseduc_0
GENR dpngovleduc  = dpngovleduc_0
GENR dpngovosl  = dpngovosl_0
SMPL s1970_end


'**************************************************
'LEVEL 5 SYSTEM OF SUR EQUATIONS---NOTE: THESE DATA BEGIN IN 1990Q1
'**************************************************
'TAKE FIRST DIFFERENCES OF LOGS OF STAGE 5 VARIABLES
GENR dpnodur = log(pnodur/pnodur(-4))
GENR dpnndur = log(pnndur/pnndur(-4))
GENR dpnmil = log(pnmil/pnmil(-4))
GENR dpngovfed = log(pngovfed/pngovfed(-4))
GENR dppopgrqt = log(ppopgrqt/ppopgrqt(-4))
SMPL s1970_YRstart

SYSTEM system_5
system_5.append dpnodur = C(1) + C(2)*dpnmfg   + C(5)*dpnodur(-1) 
system_5.append dpnndur = C(10) + C(11)*dpnndur(-1) + C(12)*dgdpr(-1) 
system_5.append dpnmil = C(30) + C(31)*dpnmil(-1) + C(32)*dpnmil(-2) 
system_5.append dpngovfed = C(20) + C(21)*dpnmil + C(22)*dpngovfed(-1) 
system_5.append dppopgrqt = C(40) + C(41)*dppopgrqt(-1) + C(42)*dppop65 
system_5.ls

SMPL s1970_end

'CREATE MODEL FROM LEVEL 6 SYSTEM OF EQUATIONS
MODEL model_5
model_5.merge system_5
SMPL s1980_end
model_5.solve

'EXTEND MODEL 5 VARS BASED ON FORECAST
SMPL s4cast
GENR dpnodur = dpnodur_0 
GENR dpnndur  = dpnndur_0
GENR dpnmil = dpnmil_0
GENR dpngovfed = dpngovfed_0
GENR dppopgrqt  = dppopgrqt_0
SMPL s1970_end


'**************************************************
'LEVEL 6 OLS EQUATIONS---NOTE: THESE DATA BEGIN IN 1980Q1
'**************************************************
'TAKE FIRST DIFFERENCES OF LOGS OF STAGE 6 VARIABLES
GENR dphsesn = log(phsesn/phsesn(-4))
GENR dphseml  = log(phseml/phseml(-4))
GENR dppophsesn = log(ppophsesn/ppophsesn(-4))
GENR dppophseml = log(ppophseml/ppophseml(-4))

EQUATION e6_dppophsesn.ls dppophsesn c dppophse rm  
EQUATION e6_dppophseml.ls dppophseml c dppophse rm 
EQUATION e6_dphsesn.ls dphsesn c dphse dppophsesn(-1) rm 
EQUATION e6_dphseml.ls dphseml c dphse dppophseml(-1) rm 

SMPL s1980_end

'CREATE MODEL FROM LEVEL 7 EQUATIONS
MODEL model_6
model_6.merge e6_dphsesn
model_6.merge e6_dphseml
model_6.merge e6_dppophsesn
model_6.merge e6_dppophseml
SMPL s1980_end
model_6.solve

'EXTEND MODEL "MISC" VARS BASED ON FORECAST
SMPL s4cast
GENR dphsesn = dphsesn_0
GENR dphseml = dphseml_0
GENR dppophsesn = dppophsesn_0
GENR dppophseml = dppophseml_0


'**************************************************
'LEVEL 6b OLS EQUATION---FORECAST BUILDING PERMITS (LINEAR MODEL)
'**************************************************
SMPL s4cast
phse = phse(-4)*exp(dphse)

SMPL s1970_end
EQUATION e7_dphs.ls phs phse(-4) (phse - phse(-4))/4 
e7_dphs.forecast phs_0

'**************************************************
'LEVEL 6c OLS EQUATION---FORECAST REGIONAL PERSONAL AND WAGE & SALARY INCOME
'**************************************************
SMPL s1970_end
GENR pyp = kyp + byp + typ + syp
GENR pyws = kyws + byws + tyws + syws
GENR dpyp = log(pyp/pyp(-4))
GENR dpyws = log(pyws/pyws(-4))
SMPL s4cast
GENR dwyp = dwyp_0

SMPL s1970_end
EQUATION dpypeq.ls dpyp c dwyp 
EQUATION dpywseq.ls dpyws c dwyws

'CREATE MODEL FROM PUGET SOUND INCOME EQUATIONS
MODEL puget_inc
puget_inc.merge dpypeq
puget_inc.merge dpywseq
SMPL s1980_end
puget_inc.solve

'EXTEND MODEL "PUGET_INC" VARS BASED ON FORECAST
SMPL sQB4cast
GENR dpyp = dpyp_0 
GENR dpyws = dpyws_0


'***************************************************************************************
'************* WRITE OUT REGION LEVEL DATA TO EXCEL ******************
'***************************************************************************************
'HISTORICAL PERIOD
SMPL s1970_start
GENR pn_0 = pn
GENR pngoods_0 = pngoods
GENR pnres_0 = pnres
GENR pncon_0 = pncon
GENR pnmfg_0 = pnmfg
GENR pnaer_0 = pnaer
GENR pnodur_0 = pnodur
GENR pnndur_0 = pnndur
GENR pnserv_0 = pnserv
GENR pntrd_0 = pntrd
GENR pnwhtrd_0 = pnwhtrd
GENR pnretrd_0 = pnretrd
GENR pntrnutil_0 = pntrnutil
GENR pntrn_0 = pntrn
GENR pnutil_0 = pnutil
GENR pninfo_0 = pninfo
GENR pncom_0 = pncom
GENR pnoinfo_0 = pnoinfo
GENR pnfin_0 = pnfin
GENR pnprofbus_0 = pnprofbus
GENR pnoserv_0 = pnoserv
GENR pneat_0 = pneat
GENR pneduc_0 = pneduc
GENR pnhlth_0 = pnhlth
GENR pnoservx_0 = pnoservx
GENR pngov_0 = pngov
GENR pngovsl_0 = pngovsl
GENR pngovseduc_0 = pngovseduc
GENR pngovleduc_0 = pngovleduc
GENR pngovosl_0 = pngovosl
GENR pngovfed_0 = pngovfed
GENR pnmil_0 = pnmil

'********** ECONOMIC & DEMOGRAPHIC VARIABLES 
GENR pwkfc_0 = pwkfc
GENR pur_0 = 1 - emprate_0
GENR pyp_0 = pyp  
GENR pyws_0 = pyws
SMPL 1970Q1 1970Q4
GENR scpi_0 = scpi
SMPL s1971_start 'Necessary?
GENR scpi_0 = scpi_0(-4)*exp(dscpi) 'Necessary?
SMPL s1970_start
GENR pyp00 =pyp_0/usced00
GENR pyws00 = pyws_0/usced00
GENR pyoth00 = pyp00 - pyws00

GENR ppop_0 = ppop
GENR ppop0_0 = ppop0
GENR ppop5_0 = ppop5
GENR ppop20_0 = ppop20
GENR ppop65_0 = ppop65

GENR pypp00 = pyp00/ppop_0
GENR ppopgrqt_0 = ppopgrqt
GENR ppophse_0 = ppophse
GENR ppophsesn_0 = ppophsesn
GENR ppophseml_0 = ppophseml
GENR phse_0 = phse
GENR phsesn_0 = phsesn
GENR phseml_0 = phseml
GENR phsesz_0 = ppophse_0/phse_0
GENR phseszsn_0 = ppophsesn_0/phsesn_0
GENR phseszml_0 = ppophseml_0/phseml_0
GENR dphsesn  = dphsesn_0
GENR dppophsesn = dppophsesn_0

'FORECAST PERIOD
SMPL s4cast
GENR pn_0 = pn_0(-4)*exp(dpn)
GENR pnres_0 = pnres_0(-4)*exp(dpnres)
GENR pncon_0 = pncon_0(-4)*exp(dpncon)
GENR pnmfg_0 = pnmfg_0(-4)*exp(dpnmfg)
GENR pnaer_0 = pnaer_0(-4)*exp(dpnaer)
GENR pnodur_0 = pnodur_0(-4)*exp(dpnodur)
GENR pnndur_0 = pnndur_0(-4)*exp(dpnndur)
GENR pntrd_0 = pntrd_0(-4)*exp(dpntrd)
GENR pnwhtrd_0 = pnwhtrd_0(-4)*exp(dpnwhtrd)
GENR pnretrd_0 = pnretrd_0(-4)*exp(dpnretrd)
GENR pntrnutil_0 = pntrnutil_0(-4)*exp(dpntrnutil)
GENR pntrn_0 = pntrn_0(-4)*exp(dpntrn)
GENR pnutil_0 = pnutil_0(-4)*exp(dpnutil)
GENR pninfo_0 = pninfo_0(-4)*exp(dpninfo)
GENR pncom_0 = pncom_0(-4)*exp(dpncom)
GENR pnoinfo_0 = pnoinfo_0(-4)*exp(dpnoinfo)
GENR pnfin_0 = pnfin_0(-4)*exp(dpnfin)
GENR pnprofbus_0 = pnprofbus_0(-4)*exp(dpnprofbus)
GENR pnoserv_0 = pnoserv_0(-4)*exp(dpnoserv)
GENR pneat_0 = pneat_0(-4)*exp(dpneat)
GENR pneduc_0 = pneduc_0(-4)*exp(dpneduc)
GENR pnhlth_0 = pnhlth_0(-4)*exp(dpnhlth)
GENR pnoservx_0 = pnoservx_0(-4)*exp(dpnoservx)
GENR pngov_0 = pngov_0(-4)*exp(dpngov)
GENR pngovseduc_0 = pngovseduc_0(-4)*exp(dpngovseduc)
GENR pngovleduc_0 = pngovleduc_0(-4)*exp(dpngovleduc)
GENR pngovosl_0 = pngovosl_0(-4)*exp(dpngovosl)
GENR pngovfed_0 = pngovfed_0(-4)*exp(dpngovfed)

smpl 2016q1 @last
GENR pnmil_0 = pnmil_0(-4)*exp(dpnmil_0)

'*** AGGREGATE EMPLOYMENT SECTORS
SMPL s4cast
GENR pngoods_0 = pnres_0 + pncon_0 + pnmfg_0 
GENR pnserv_0 = pntrd_0 + pntrnutil_0 + pninfo_0 + pnfin_0 + pnprofbus_0 + pnoserv_0 + pngov_0

'*** CONTROL GOODS & SERVICES TO TOTAL EMPLOYMENT
GENR adj_totemp = pn_0 / (pnserv_0 + pngoods_0)
GENR pngoods_0 = pngoods_0 * adj_totemp  
GENR pnserv_0 = pnserv_0 * adj_totemp

'*** CONTROL GOODS SECTORS TO TOTAL GOODS EMPLOYMENT
GENR adj_goodsemp = (pngoods_0 - pnmfg_0) / (pnres_0 + pncon_0)  
GENR pnres_0 = pnres_0 * adj_goodsemp 
GENR pncon_0 = pncon_0 * adj_goodsemp
GENR pnmfg_0 = pnmfg_0

'*** CONTROL MANUFACTURING SECTORS TO TOTAL MANUFACTURING EMPLOYMENT
GENR adj_manemp = (pnmfg_0 - pnaer_0) / (pnodur_0 + pnndur_0)
GENR pnaer_0  = pnaer_0  
GENR pnodur_0 = pnodur_0 * adj_manemp
GENR pnndur_0 = pnndur_0 * adj_manemp

'*** CONTROL SERVICE SECTORS TO TOTAL SERVICE EMPLOYMENT
GENR adj_servemp = pnserv_0 / (pntrd_0 + pntrnutil_0 + pninfo_0 + pnfin_0 + pnprofbus_0 + pnoserv_0 + pngov_0)
GENR pntrd_0 =     pntrd_0 * adj_servemp 
GENR pntrnutil_0 = pntrnutil_0 * adj_servemp
GENR pninfo_0 =    pninfo_0 * adj_servemp
GENR pnfin_0 =     pnfin_0 * adj_servemp 
GENR pnprofbus_0 = pnprofbus_0 * adj_servemp
GENR pnoserv_0 =   pnoserv_0 * adj_servemp
GENR pngov_0 =     pngov_0 * adj_servemp 

'*** CONTROL WHOLESALE & RETAIL TO TOTAL TRADE EMPLOYMENT
GENR adj_trdemp = pntrd_0 / (pnwhtrd_0 + pnretrd_0)
GENR pnwhtrd_0 =  pnwhtrd_0 * adj_trdemp
GENR pnretrd_0 =  pnretrd_0 * adj_trdemp 

'*** CONTROL TRANS-WAREHOUSE & UTILITIES TO TOTAL TRANS-WARE-UTIL EMPLOYMENT
GENR adj_trnutilemp = pntrnutil_0 / (pntrn_0 + pnutil_0)
GENR pntrn_0 =  pntrn_0 * adj_trnutilemp
GENR pnutil_0 = pnutil_0 * adj_trnutilemp 

'*** CONTROL TELECOM & OTHER INFO TO TOTAL INFORMATION EMPLOYMENT
GENR adj_infoemp = pninfo_0 / (pncom_0 + pnoinfo_0)
GENR pncom_0 =   pncom_0 * adj_infoemp
GENR pnoinfo_0 = pnoinfo_0 * adj_infoemp 

'*** CONTROL EAT&DRINK, EDUC-SERV, HEALTH, & OSERVX TO TOTAL OTHER SERVICES EMPLOYMENT
GENR adj_oservemp = pnoserv_0 / (pneat_0 + pneduc_0 + pnhlth_0 + pnoservx_0)
GENR pneat_0 =    pneat_0 * adj_oservemp
GENR pneduc_0 =   pneduc_0 * adj_oservemp 
GENR pnhlth_0 =   pnhlth_0 * adj_oservemp 
GENR pnoservx_0 = pnoservx_0 * adj_oservemp 

'*** CONTROL GOVERNMENT SECTORS TO TOTAL GOVERNMENT EMPLOYMENT
GENR adj_govemp = pngov_0 / (pngovseduc_0 + pngovleduc_0 + pngovosl_0 + pngovfed_0)
GENR pngovseduc_0 = pngovseduc_0 * adj_govemp
GENR pngovleduc_0 = pngovleduc_0 * adj_govemp 
GENR pngovosl_0 =   pngovosl_0 * adj_govemp 
GENR pngovfed_0 =   pngovfed_0 * adj_govemp 
GENR pngovsl_0 = pngovseduc_0 + pngovleduc_0 + pngovosl_0

'********** ECONOMIC & DEMOGRAPHIC VARIABLES 
GENR pwkfc_0 = pwkfc_0(-4)*exp(dpwkfc)
GENR pur_0 = 1 - emprate_0
GENR scpi_0 = scpi_0(-4)*exp(dscpi)

SMPL sQB4cast
GENR pyp_0 = pyp_0(-4) * exp(dpyp)  
GENR pyws_0 = pyws_0(-4) * exp(dpyws)

SMPL sQB4cast
GENR pyp00 =pyp_0/usced00
GENR pyws00 = pyws_0/usced00
GENR pyoth00 = pyp00 - pyws00

SMPL sQB4cast
GENR pypp00 = pyp00/ppop_0

SMPL s4cast
GENR ppopgrqt_0 = ppopgrqt_0(-4)*exp(dppopgrqt)
GENR ppophse_0 = ppophse_0(-4)*exp(dppophse)
GENR ppophsesn_0 = ppophsesn_0(-4)*exp(dppophsesn)
GENR ppophseml_0 = ppophseml_0(-4)*exp(dppophseml)
GENR phse_0 = phse_0(-4)*exp(dphse)
GENR phsesn_0 = phsesn_0(-4)*exp(dphsesn)
GENR phseml_0 = phseml_0(-4)*exp(dphseml)
GENR phsesz_0 = ppophse_0/phse_0

'*** CONTROL HH & GROUP QUARTERS POPULATION GROWTH TO TOTAL POPULATION 
GENR adj_pop = ppop_0 / (ppophse_0 + ppopgrqt_0)
GENR ppophse_0 = ppophse_0 * adj_pop
GENR ppopgrqt_0 = ppopgrqt_0 * adj_pop 
GENR phse_0=ppophse_0/phsesz_0

'*** CONTROL SINGLE & MULTI HH AND HH POPULATION GROWTH TO TOTAL HH AND HH POPULATION 
GENR adj_phse = phse_0 / (phsesn_0 + phseml_0)
GENR phsesn_0 = phsesn_0 * adj_phse
GENR phseml_0 = phseml_0 * adj_phse 
GENR adj_ppophse = ppophse_0 / (ppophsesn_0 + ppophseml_0)
GENR ppophsesn_0 = ppophsesn_0 * adj_ppophse
GENR ppophseml_0 = ppophseml_0 * adj_ppophse 

'*** CREATE PERSSONS PER HOUSEHOLD VARIABLES
GENR phseszsn_0 = ppophsesn_0/phsesn_0
GENR phseszml_0 = ppophseml_0/phseml_0

rename PSTOCK_ACS_0 housing_stock

'Rebase scpi, etc.
smpl @all
for %var scpi_0
	{%var}={%var}/1.944 '2003Q3 SCPI
next
smpl 2017q3 @last
sbe_ashpi=sbe_ashpi(-4)*exp(dsbe_ashpi_0)
rename sbe_ashpi hpi

wfsave region_out_{%save_suf}

SMPL s1970_end
%name="Regional model\OUT_DATA_region_"+%save_suf+".xls"
WRITE  %name pn_0 pngoods_0 pnres_0 pncon_0 pnmfg_0 pnaer_0 pnodur_0 pnndur_0 pnserv_0 pntrd_0 pnwhtrd_0 pnretrd_0 pntrnutil_0 pntrn_0 pnutil_0 pninfo_0 pncom_0 pnoinfo_0 pnfin_0 pnprofbus_0 pnoserv_0 pneat_0 pneduc_0 pnhlth_0 pnoservx_0 pngov_0 pngovsl_0 pngovseduc_0 pngovleduc_0 pngovosl_0 pngovfed_0 pnmil_0 pur_0 pyp_0 pyp00 pyws00 pyoth00 pypp00 scpi_0 phs_0 ppop_0 ppop0_0 ppop5_0 ppop20_0 ppop65_0 ppopgrqt_0 ppophse_0 ppophsesn_0 ppophseml_0 phse_0 phsesn_0 phseml_0 phsesz_0 phseszsn_0 phseszml_0 usced00 housing_stock

'*******************************************************************************
'*** NOW CREATE COUNTY-LEVEL EMPLOYMENT, ECONOMIC, AND DEMOGRAPHIC FORECASTS ***
'*******************************************************************************
'Fix some population series (totals updated; age group totals not updated in early years)
pageselect Annual
smpl @all
for %var k b t s
	genr {%var}ratio={%var}pop/({%var}pop0+{%var}pop5+{%var}pop20+{%var}pop65)
	for %age 0 5 20 65
		genr {%var}pop{%age}={%var}ratio*{%var}pop{%age}
	next
next

pageselect Quarterly
SMPL s1970_start

'TAKE FIRST DIFFERENCES OF LOGS OF COUNTY-LEVEL VARIABLES
GENR dkn = log(kn/kn(-4))
GENR dbn = log(bn/bn(-4))
GENR dtn = log(tn/tn(-4))
GENR dsn = log(sn/sn(-4))
GENR dknserv = log(knserv/knserv(-4))
GENR dbnserv = log(bnserv/bnserv(-4))
GENR dtnserv = log(tnserv/tnserv(-4))
GENR dsnserv = log(snserv/snserv(-4))
GENR dkngoods = log(kngoods/kngoods(-4))
GENR dbngoods = log(bngoods/bngoods(-4))
GENR dsngoods = log(sngoods/sngoods(-4))
GENR dtngoods = log(tngoods/tngoods(-4))

GENR dknaer = log(knaer/knaer(-4))
GENR tnaer2 = tnaer
SMPL if tnaer2 = 0
GENR tnaer2 = 0.00001
SMPL s1970_start
GENR dtnaer = log(tnaer2/tnaer2(-4))
GENR dsnaer = log(snaer/snaer(-4))
'GENR dbnaer = log(bnaer/bnaer(-4))

SMPL s1970_end
'ESTIMATE SINGLE EQUATION COUNTY-LEVEL EMPLOYMENT
EQUATION cty_kn.ls dkn c dpn
EQUATION cty_bn.ls dbn c dpn
EQUATION cty_sn.ls dsn c dpn
EQUATION cty_tn.ls  dtn c dpn

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7" COUNTY-LEVEL EMPLOYMENT EQUATIONS
MODEL model_7
model_7.merge cty_kn
model_7.merge cty_bn
model_7.merge cty_sn
model_7.merge cty_tn
SMPL s1980_end
model_7.solve

'TAKE FIRST LOG DIFFERENCE OF GOODS AND SERVICE EMPLOYMENT
GENR dpngoods = log(pngoods_0 / pngoods_0(-4)) 
GENR dpnserv = log(pnserv_0 / pnserv_0(-4))

'COMPUTE TOTAL COUNTY EMPLOYMENT SHIFT SHARES
SMPL s1970_end
genr shift_k = dkn_0 - dpn - dkn_0(-4) + dpn(-4)
genr shift_b = dbn_0 - dpn - dbn_0(-4) + dpn(-4)
genr shift_s = dsn_0 - dpn - dsn_0(-4) + dpn(-4)
genr shift_t = dtn_0 - dpn - dtn_0(-4) + dpn(-4)

'ESTIMATE COUNTY-LEVEL GOODS EQUATIONS
EQUATION cty_kngoods.ls dkngoods c dpngoods shift_k
EQUATION cty_bngoods.ls dbngoods c dpngoods shift_b
EQUATION cty_tngoods.ls dtngoods c dpngoods shift_t
EQUATION cty_sngoods.ls dsngoods c dpngoods shift_s

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7b" COUNTY-LEVEL GOODS EMPLOYMENT EQUATIONS
MODEL model_7b
model_7b.merge cty_kngoods
model_7b.merge cty_bngoods
model_7b.merge cty_sngoods
model_7b.merge cty_tngoods
SMPL s1980_end
model_7b.solve

'ESTIMATE COUNTY-LEVEL AEROSPACE EQUATIONS
EQUATION cty_knaer.ls dknaer c dpnaer shift_k
'EQUATION cty_tnaer.ls dtnaer c dpnaer 'shift_t
EQUATION cty_snaer.ls dsnaer c dpnaer shift_s

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7c" COUNTY-LEVEL AEROSPACE EMPLOYMENT EQUATIONS
MODEL model_7c
model_7c.merge cty_knaer
model_7c.merge cty_snaer
'model_7c.merge cty_tnaer
SMPL s1980_end
model_7c.solve

'ESTIMATE COUNTY-LEVEL SERVICE EQUATIONS
EQUATION cty_knserv.ls dknserv c dpnserv shift_k
EQUATION cty_bnserv.ls dbnserv c dpnserv shift_b
EQUATION cty_tnserv.ls dtnserv c dpnserv shift_t
EQUATION cty_snserv.ls dsnserv c dpnserv shift_s

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7d" COUNTY-LEVEL SERVICE EMPLOYMENT EQUATIONS
MODEL model_7d
model_7d.merge cty_knserv
model_7d.merge cty_bnserv
model_7d.merge cty_snserv
model_7d.merge cty_tnserv
SMPL s1980_end
model_7d.solve

'ESTIMATE COUNTY-LEVEL PERSONAL INCOME EQUATIONS
SMPL s1970_end
GENR dkyp = log(kyp/kyp(-4)) 
GENR dbyp = log(byp/byp(-4)) 
GENR dtyp = log(typ/typ(-4)) 
GENR dsyp = log(syp/syp(-4)) 

EQUATION cty_kyp.ls dkyp c dpyp 
EQUATION cty_byp.ls dbyp c dpyp 
EQUATION cty_typ.ls dtyp c dpyp 
EQUATION cty_syp.ls dsyp c dpyp 

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7e" COUNTY-LEVEL PERSONAL INCOME EQUATIONS
MODEL model_7e
model_7e.merge cty_kyp
model_7e.merge cty_byp
model_7e.merge cty_syp
model_7e.merge cty_typ
SMPL s1980_end
model_7e.solve

'ESTIMATE COUNTY-LEVEL POPULATION EQUATIONS
SMPL s1970_end

GENR dkpop = log(kpop/kpop(-4)) 
GENR dbpop = log(bpop/bpop(-4)) 
GENR dtpop = log(tpop/tpop(-4)) 
GENR dspop = log(spop/spop(-4)) 

EQUATION cty_kpop.ls dkpop c dppop (dkpop(-1) - dppop(-1)) (dkpop(-2) + dppop(-2))
EQUATION cty_bpop.ls dbpop c dppop (dbpop(-1) - dppop(-1)) (dbpop(-2) + dppop(-2))
EQUATION cty_tpop.ls dtpop c dppop (dtpop(-1) - dppop(-1)) (dtpop(-2) + dppop(-2))
EQUATION cty_spop.ls dspop c dppop (dspop(-1) - dppop(-1)) (dspop(-2) + dppop(-2))

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7f" COUNTY-LEVEL POPULATION EQUATIONS
MODEL model_7f
model_7f.merge cty_kpop
model_7f.merge cty_bpop
model_7f.merge cty_spop
model_7f.merge cty_tpop
smpl 2017q1 2050q4
model_7f.solve


'ESTIMATE COUNTY-LEVEL HOUSEHOLD EQUATIONS
SMPL s1970_end
GENR dkhse = log(khse/khse(-4)) 
GENR dbhse = log(bhse/bhse(-4)) 
GENR dthse = log(thse/thse(-4)) 
GENR dshse = log(shse/shse(-4)) 

EQUATION cty_khse.ls dkhse c dphse
EQUATION cty_bhse.ls dbhse c dphse 
EQUATION cty_thse.ls dthse c dphse 
EQUATION cty_shse.ls dshse c dphse 

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7g" COUNTY-LEVEL HOUSEHOLD EQUATIONS
MODEL model_7g
model_7g.merge cty_khse
model_7g.merge cty_bhse
model_7g.merge cty_shse
model_7g.merge cty_thse
SMPL s1980_end
model_7g.solve


'ESTIMATE COUNTY-LEVEL SINGLE-FAMILY & MULIT-FAMILY HOUSEHOLD EQUATIONS
SMPL s1970_end
GENR dkhsesn = log(khsesn/khsesn(-4)) 
GENR dbhsesn = log(bhsesn/bhsesn(-4)) 
GENR dthsesn = log(thsesn/thsesn(-4)) 
GENR dshsesn = log(shsesn/shsesn(-4)) 

GENR dkhseml = log(khseml/khseml(-4)) 
GENR dbhseml = log(bhseml/bhseml(-4)) 
GENR dthseml = log(thseml/thseml(-4)) 
GENR dshseml = log(shseml/shseml(-4)) 

EQUATION cty_khsesn.ls dkhsesn c dphsesn 
EQUATION cty_bhsesn.ls dbhsesn c dphsesn 
EQUATION cty_thsesn.ls dthsesn c dphsesn 
EQUATION cty_shsesn.ls dshsesn c dphsesn 

EQUATION cty_khseml.ls dkhseml c dphseml
EQUATION cty_bhseml.ls dbhseml c dphseml
EQUATION cty_thseml.ls dthseml c dphseml
EQUATION cty_shseml.ls dshseml c dphseml

SMPL s1970_end

'CREATE MODEL FROM "LEVEL 7h" COUNTY-LEVEL SINGLE-FAMILY HOUSEHOLD EQUATIONS
MODEL model_7h
model_7h.merge cty_khsesn
model_7h.merge cty_bhsesn
model_7h.merge cty_shsesn
model_7h.merge cty_thsesn
SMPL s1980_end
model_7h.solve

'CREATE MODEL FROM "LEVEL 7i" COUNTY-LEVEL MULTI-FAMILY HOUSEHOLD EQUATIONS
MODEL model_7i
model_7i.merge cty_khseml
model_7i.merge cty_bhseml
model_7i.merge cty_shseml
model_7i.merge cty_thseml
SMPL s1980_end
model_7i.solve


SMPL s1970_start
GENR adj_kn = kn
GENR adj_bn = bn
GENR adj_sn = sn
GENR adj_tn = tn

GENR adj_kngoods = kngoods
GENR adj_bngoods = bngoods
GENR adj_sngoods = sngoods
GENR adj_tngoods = tngoods

GENR adj_knaer = knaer
'GENR adj_bnaer = bnaer
GENR adj_snaer = snaer
GENR adj_tnaer = tnaer

GENR adj_knserv = knserv
GENR adj_bnserv = bnserv
GENR adj_snserv = snserv
GENR adj_tnserv = tnserv

GENR adj_kyp = kyp
GENR adj_byp = byp
GENR adj_typ = typ
GENR adj_syp = syp

GENR adj_kpop = kpop
GENR adj_bpop = bpop
GENR adj_tpop = tpop
GENR adj_spop = spop

GENR adj_khse = khse
GENR adj_bhse = bhse
GENR adj_thse = thse
GENR adj_shse = shse

GENR adj_khsesn = khsesn
GENR adj_bhsesn = bhsesn
GENR adj_thsesn = thsesn
GENR adj_shsesn = shsesn

GENR adj_khseml = khseml
GENR adj_bhseml = bhseml
GENR adj_thseml = thseml
GENR adj_shseml = shseml


SMPL s4cast
GENR adj_kn= adj_kn(-4) * exp(dkn_0)
GENR adj_bn= adj_bn(-4) * exp(dbn_0)
GENR adj_sn= adj_sn(-4) * exp(dsn_0)
GENR adj_tn= adj_tn(-4) * exp(dtn_0)

GENR adj_kngoods= adj_kngoods(-4) * exp(dkngoods_0)
GENR adj_bngoods= adj_bngoods(-4) * exp(dbngoods_0)
GENR adj_sngoods= adj_sngoods(-4) * exp(dsngoods_0)
GENR adj_tngoods= adj_tngoods(-4) * exp(dtngoods_0)

GENR adj_knaer= adj_knaer(-4) * exp(dknaer_0)
'GENR adj_bnaer= adj_bnaer(-4) * exp(dbnaer_0)
GENR adj_snaer= adj_snaer(-4) * exp(dsnaer_0)
GENR adj_tnaer=  adj_tnaer(-4) 

GENR adj_knserv= adj_knserv(-4) * exp(dknserv_0)
GENR adj_bnserv= adj_bnserv(-4) * exp(dbnserv_0)
GENR adj_snserv= adj_snserv(-4) * exp(dsnserv_0)
GENR adj_tnserv=  adj_tnserv(-4) * exp(dtnserv_0)

SMPL sQB4cast
GENR adj_kyp = adj_kyp(-4) * exp(dkyp_0)
GENR adj_byp = adj_byp(-4) * exp(dbyp_0)
GENR adj_typ = adj_typ(-4) * exp(dtyp_0)
GENR adj_syp = adj_syp(-4) * exp(dsyp_0)

SMPL s4cast
GENR adj_kpop = adj_kpop(-4) * exp(dkpop_0)
GENR adj_bpop = adj_bpop(-4) * exp(dbpop_0)
GENR adj_tpop = adj_tpop(-4) * exp(dtpop_0)
GENR adj_spop = adj_spop(-4) * exp(dspop_0)

GENR adj_khse = adj_khse(-4) * exp(dkhse_0)
GENR adj_bhse = adj_bhse(-4) * exp(dbhse_0)
GENR adj_thse = adj_thse(-4) * exp(dthse_0)
GENR adj_shse = adj_shse(-4) * exp(dshse_0)

GENR adj_khsesn = adj_khsesn(-4) * exp(dkhsesn_0)
GENR adj_bhsesn = adj_bhsesn(-4) * exp(dbhsesn_0)
GENR adj_thsesn = adj_thsesn(-4) * exp(dthsesn_0)
GENR adj_shsesn = adj_shsesn(-4) * exp(dshsesn_0)

GENR adj_khseml = adj_khseml(-4) * exp(dkhseml_0)
GENR adj_bhseml = adj_bhseml(-4) * exp(dbhseml_0)
GENR adj_thseml = adj_thseml(-4) * exp(dthseml_0)
GENR adj_shseml = adj_shseml(-4) * exp(dshseml_0)


SMPL s1970_end

'COUNTY TOTAL EMPLOYMENT FORECAST ADJUST
GENR adj_n = pn_0/(adj_kn + adj_bn + adj_sn + adj_tn)
GENR adj_kn = adj_kn*adj_n
GENR adj_bn = adj_bn*adj_n
GENR adj_sn = adj_sn*adj_n
GENR adj_tn = adj_tn*adj_n


'COUNTY GOODS EMPLOYMENT FORECAST ADJUST
GENR adj_ngoods = pngoods_0/(adj_kngoods + adj_bngoods + adj_sngoods + adj_tngoods)
GENR adj_kngoods = adj_kngoods*adj_ngoods
GENR adj_bngoods = adj_bngoods*adj_ngoods
GENR adj_sngoods = adj_sngoods*adj_ngoods
GENR adj_tngoods = adj_tngoods*adj_ngoods


'COUNTY AEROSPACE EMPLOYMENT FORECAST ADJUST
GENR adj_naer = pnaer_0/(adj_knaer + adj_snaer + adj_tnaer)
GENR adj_knaer = adj_knaer*adj_naer
'GENR adj_bnaer = adj_bnaer*adj_naer
GENR adj_snaer = adj_snaer*adj_naer
GENR adj_tnaer = adj_tnaer*adj_naer


'COUNTY SERVICE EMPLOYMENT FORECAST ADJUST
GENR adj_nserv = pnserv_0/(adj_knserv + adj_bnserv + adj_snserv + adj_tnserv)
GENR adj_knserv = adj_knserv*adj_nserv
GENR adj_bnserv = adj_bnserv*adj_nserv
GENR adj_snserv = adj_snserv*adj_nserv
GENR adj_tnserv = adj_tnserv*adj_nserv


'WITHIN COUNTY GOODS & SREVICE EMPLOYMENT
GENR adj_kngoods = adj_kn / pn_0 * pngoods_0
GENR adj_knserv =  adj_kn / pn_0 * pnserv_0

GENR adj_bngoods = adj_bn / pn_0 * pngoods_0
GENR adj_bnserv =  adj_bn / pn_0 * pnserv_0

GENR adj_tngoods = adj_tn / pn_0 * pngoods_0
GENR adj_tnserv =  adj_tn / pn_0 * pnserv_0

GENR adj_sngoods = adj_sn / pn_0 * pngoods_0
GENR adj_snserv =  adj_sn / pn_0 * pnserv_0


'COUNTY PERSONAL INCOME FORECAST ADJUST
GENR adj_yp = pyp_0/(adj_kyp + adj_byp + adj_typ + adj_syp)
GENR adj_kyp = adj_kyp*adj_yp
GENR adj_byp = adj_byp*adj_yp
GENR adj_typ = adj_typ*adj_yp
GENR adj_syp = adj_syp*adj_yp

'COUNTY POPULATION FORECAST ADJUST
GENR adj_pop = ppop_0/(adj_kpop + adj_bpop + adj_tpop + adj_spop)
GENR adj_kpop = adj_kpop*adj_pop
GENR adj_bpop = adj_bpop*adj_pop
GENR adj_tpop = adj_tpop*adj_pop
GENR adj_spop = adj_Spop*adj_pop

'COUNTY HOUSEHOLS FORECAST ADJUST
GENR adj_hse = phse_0/(adj_khse + adj_bhse + adj_shse + adj_thse)
GENR adj_khse = adj_khse*adj_hse
GENR adj_bhse = adj_bhse*adj_hse
GENR adj_thse = adj_thse*adj_hse
GENR adj_shse = adj_shse*adj_hse

'COUNTY SINGLE-FAMILY HOUSEHOLDS FORECAST ADJUST
GENR adj_hsesn = phsesn_0/(adj_khsesn + adj_bhsesn + adj_shsesn + adj_thsesn)
GENR adj_khsesn = adj_khsesn*adj_hsesn
GENR adj_bhsesn = adj_bhsesn*adj_hsesn
GENR adj_thsesn = adj_thsesn*adj_hsesn
GENR adj_shsesn = adj_shsesn*adj_hsesn

'COUNTY MULTI-FAMILY HOUSEHOLDS FORECAST ADJUST
GENR adj_hseml = phseml_0/(adj_khseml + adj_bhseml + adj_shseml + adj_thseml)
GENR adj_khseml = adj_khseml*adj_hseml
GENR adj_bhseml = adj_bhseml*adj_hseml
GENR adj_thseml = adj_thseml*adj_hseml
GENR adj_shseml = adj_shseml*adj_hseml

'DERIVE COUNTY-LEVEL REAL PERSONAL INCOME
GENR adj_kyp00 = adj_kyp / usced00
GENR adj_byp00 = adj_byp / usced00
GENR adj_typ00 = adj_typ / usced00
GENR adj_syp00 = adj_syp / usced00

'DERIVE COUNTY-LEVEL REAL PER CAPITA PERSONAL INCOME
GENR adj_kypp00 = adj_kyp00 / adj_kpop
GENR adj_bypp00 = adj_byp00 / adj_bpop
GENR adj_typp00 = adj_typ00 / adj_tpop
GENR adj_sypp00 = adj_syp00 / adj_spop


'*** WRITE OUT COUNTY FORECAST TO EXCEL WORKBOOK

SMPL s1970_end
%name="Regional model\OUT_DATA_counties_"+%save_suf+".xls"
WRITE %name adj_kn adj_kngoods adj_knaer adj_knserv adj_kyp adj_kyp00 adj_kypp00 adj_kpop adj_khse adj_khsesn adj_khseml adj_bn adj_bngoods adj_bnserv adj_byp adj_byp00 adj_bypp00 adj_bpop adj_bhse adj_bhsesn adj_bhseml adj_tn adj_tngoods adj_tnaer adj_tnserv adj_typ adj_typ00 adj_typp00 adj_tpop adj_thse adj_thsesn adj_thseml adj_sn adj_sngoods adj_snaer adj_snserv adj_syp adj_syp00 adj_sypp00 adj_spop adj_shse adj_shsesn adj_shseml


'*********************************************************
'******************* REVENUE FORECAST ********************
'*********************************************************
SMPL s1970_end
GENR pretail = kretail + bretail + tretail + sretail
GENR dpretail = log(pretail/pretail(-4))
GENR dkretail = log(kretail/kretail(-4))
GENR dbretail = log(bretail/bretail(-4))
GENR dtretail = log(tretail/tretail(-4))
GENR dsretail = log(sretail/sretail(-4))

GENR dwfuel = log(wfuel/wfuel(-4))

GENR dwpop = log(wpop/wpop(-4))

GENR pcar = kcar + bcar + tcar + scar
GENR ptrkgas = ktrkgas + btrkgas + ttrkgas + strkgas 
GENR ptrkdie = ktrkdie + btrkdie + ttrkdie + strkdie
GENR pothveh = kothveh + bothveh + tothveh + sothveh


'FIRST FORECAST STATE-LEVEL GALLONS OF FUEL (NOTE: GAS & DIESEL ARE TAXED THE SAME)
SMPL s1970_start
GENR wyp_0 = wyp
SMPL s4cast
GENR wyp_0 = wyp_0(-4) * exp(dwyp)
SMPL s1970_end
GENR wyp_0 = wyp_0 / usced00
GENR wyp00 = wyp_0 / usced00
GENR dwyp00 = log(wyp_0 / wyp_0(-4))
GENR dwyphh00 = dwyp00 - dphse
EQUATION rev_dwfuel.ls dwfuel dwfuel(-1) dppi dwyphh00 dphse @trend
SMPL s1980_end
rev_dwfuel.FORECAST dwfuel_0

'**************************************************************************
'SECOND FORECAST REGIONAL-LEVEL & COUNTY-LEVEL RETAIL SALES
'**************************************************************************
SMPL s1970_start
EQUATION rev_dpretail.ls dpretail c dpyp
SMPL s1980_end
rev_dpretail.FORECAST dpretail_0

SMPL s1970_start
EQUATION rev_dkretail.ls dkretail c dpretail_0 dkpop_0
EQUATION rev_dbretail.ls dbretail c dpretail_0 dbpop_0 
EQUATION rev_dtretail.ls dtretail c dpretail_0 dtpop_0 
EQUATION rev_dsretail.ls dsretail c dpretail_0 dspop_0 

SMPL s1980_end
rev_dkretail.FORECAST dkretail_0
rev_dbretail.FORECAST dbretail_0
rev_dtretail.FORECAST dtretail_0
rev_dsretail.FORECAST dsretail_0

'**************************************************************************
'THIRD PROJECT TOTAL VEHICLES IN REGION & DISAGGREGATE VEHICLES BY CLASS
'**************************************************************************
SMPL s1970_end

GENR dpyp00 = log(pyp00 / pyp00(-4))
GENR dkyp00 = log(adj_kyp00 / adj_kyp00(-4))
GENR dbyp00 = log(adj_byp00 / adj_byp00(-4))
GENR dtyp00 = log(adj_typ00 / adj_typ00(-4))
GENR dsyp00 = log(adj_syp00 / adj_syp00(-4))

GENR dpyphh00 = dpyp00 - dphse
GENR dkyphh00 = dkyp00 - dkhse_0
GENR dbyphh00 = dbyp00 - dbhse_0
GENR dtyphh00 = dtyp00 - dthse_0
GENR dsyphh00 = dsyp00 - dshse_0

'Note that regional HH size variables are based on total population
GENR dphsesz = dppophse - dphse
GENR dkhsesz = dkpop_0 - dkhse_0
GENR dbhsesz = dbpop_0 - dbhse_0
GENR dthsesz = dtpop_0 - dthse_0
GENR dshsesz = dspop_0 - dshse_0

GENR kvehic = kcar + ktrkgas + ktrkdie + kothveh
GENR bvehic = bcar + btrkgas + btrkdie + bothveh
GENR tvehic = tcar + ttrkgas + ttrkdie + tothveh
GENR svehic = scar + strkgas + strkdie + sothveh
GENR dkvehic = log(kvehic / kvehic(-4))
GENR dbvehic = log(bvehic / bvehic(-4))
GENR dtvehic = log(tvehic / tvehic(-4))
GENR dsvehic = log(svehic / svehic(-4))

GENR pvehic = kvehic + bvehic + tvehic + svehic
GENR pcar = kcar + bcar + tcar + scar
GENR ptrkgas = ktrkgas + btrkgas + ttrkgas + strkgas
GENR ptrkdies = ktrkdie + btrkdie + ttrkdie + strkdie
GENR pothveh = kothveh + bothveh + tothveh + sothveh
GENR dpcar = log(pcar/pcar(-4))
GENR dptrkgas = log(ptrkgas / ptrkgas(-4))
GENR dptrkdies = log(ptrkdies / ptrkdies(-4))
GENR dpothveh = log(pothveh / pothveh(-4))

'APPLY X-SECTIONAL COEFFICIENTS FROM MONORAIL PROJECT
'SMPL s4cast
smpl 2017Q1 2050Q4
GENR pvehic = pvehic(-4) * exp(0.121*dpyphh00 + 0.859*dphse   + 0.734*dphsesz)
GENR kvehic = kvehic(-4) * exp(0.121*dkyphh00 + 0.859*dkhse_0 + 0.734*dkhsesz)
GENR bvehic = bvehic(-4) * exp(0.121*dbyphh00 + 0.859*dbhse_0 + 0.734*dbhsesz)
GENR tvehic = tvehic(-4) * exp(0.121*dtyphh00 + 0.859*dthse_0 + 0.734*dthsesz)
GENR svehic = svehic(-4) * exp(0.121*dsyphh00 + 0.859*dshse_0 + 0.734*dshsesz)

'ESTIMATE VAR MODEL OF REGIONAL VEHICLS 
SMPL s1970_start
VAR carvar.ls(h) 1 4 dpcar dptrkgas dptrkdies dpothveh @ C

'CREATE MODEL FROM "carvar" VAR MODEL
MODEL carvar_mod
carvar_mod.merge carvar
SMPL s1980_end
carvar_mod.solve

GENR dpvehic = log(pvehic / pvehic(-4))


'**************************************************************************************
'ESTIMATE REGIONAL PER VEHICLE GROWTH RATE MODEL
'**************************************************************************************
SMPL s1970_end
GENR pmvet = kmvet + bmvet + tmvet + smvet
GENR dpmvet = log(pmvet/pmvet(-4))
GENR dkmvet = log(kmvet/kmvet(-4))
GENR dbmvet = log(bmvet/bmvet(-4))
GENR dtmvet = log(tmvet/tmvet(-4))
GENR dsmvet = log(smvet/smvet(-4))
GENR duscpi = log(uscpi82/uscpi82(-4))
GENR dusced00 = log(usced00/usced00(-4))
GENR dpmvet00 = dpmvet - dusced00- dpvehic
GENR dkmvet00 = dkmvet - dusced00 - dkvehic
GENR dbmvet00 = dbmvet - dusced00 - dbvehic
GENR dtmvet00 = dtmvet - dusced00 - dtvehic
GENR dsmvet00 = dsmvet - dusced00 - dsvehic

'CREATE DUMMY VARIABLE FOR 1999---LAST YEAR OF STATEWIDE MVET
GENR end_mvet = 0
SMPL 1999q1 1999q4
GENR end_mvet = end_mvet + 1

SMPL 1980q1 1999q4
GENR mvet_trend = @trend
SMPL s2000_end
GENR mvet_trend = mvet_trend(-4) + 0.50


SMPL s1980_end
'EQUATION rev_pmvet.ls dpmvet00 c dusced00 end_mvet mvet_trend 
'EQUATION rev_kmvet.ls dkmvet00 c dusced00 end_mvet mvet_trend 'Not used in 2014
'EQUATION rev_bmvet.ls dbmvet00 c dusced00 end_mvet mvet_trend 'Not used in 2014 
'EQUATION rev_tmvet.ls dtmvet00 c dusced00 end_mvet mvet_trend 'Not used in 2014
'EQUATION rev_smvet.ls dsmvet00 c dusced00 end_mvet mvet_trend 'Not used in 2014

SMPL s1980_end
'rev_pmvet.FORECAST dpmvet00_0
'rev_kmvet.FORECAST dkmvet00_0 'Not used in 2014
'rev_bmvet.FORECAST dbmvet00_0 'Not used in 2014
'rev_tmvet.FORECAST dtmvet00_0 'Not used in 2014
'rev_smvet.FORECAST dsmvet00_0 'Not used in 2014


'***********************************
'*** CREATE RETAIL SALES VARIABLES
'***********************************
SMPL s1970_start
GENR wfuel_0 = wfuel
'SMPL s4cast
SMPL 2017Q1 2050Q4
GENR wfuel_0 = wfuel_0(-4) * exp(dwfuel_0)


'***********************************
'*** CREATE RETAIL SALES VARIABLES
'***********************************
SMPL s1970_start
GENR pretail_0 = pretail
GENR kretail_0 = kretail
GENR bretail_0 = bretail
GENR tretail_0 = tretail
GENR sretail_0 = sretail

'SMPL s4cast
smpl 2016Q1 2050Q4
GENR pretail_0 = pretail_0(-4) * exp(dpretail_0)
GENR kretail_0 = kretail_0(-4) * exp(dkretail_0)
GENR bretail_0 = bretail_0(-4) * exp(dbretail_0)
GENR tretail_0 = tretail_0(-4) * exp(dtretail_0)
GENR sretail_0 = sretail_0(-4) * exp(dsretail_0)

'***CONTROL COUNTY RETAIL SALES TO REGIONAL LEVEL
GENR retail_adj = pretail_0 / (kretail_0 + bretail_0 + tretail_0 + sretail_0)
GENR kretial_0 = kretail_0 * retail_adj
GENR bretial_0 = bretail_0 * retail_adj
GENR tretial_0 = tretail_0 * retail_adj
GENR sretial_0 = sretail_0 * retail_adj


'***********************************
'*** CREATE VEHICLE VARIABLES
'***********************************
SMPL s1970_start
GENR pcar_0 = pcar
GENR ptrkgas_0 = ptrkgas
GENR ptrkdies_0 = ptrkdies
GENR pothveh_0 = pothveh
'GENR kvehic_0 = kvehic
'GENR bvehic_0 = bvehic
'GENR tvehic_0 = tvehic
'GENR svehic_0 = svehic

'SMPL s4cast
smpl 2017Q1 2050Q4
GENR pcar_0 = pcar_0(-4) * exp(dpcar_0)
GENR ptrkgas_0 = ptrkgas_0(-4) * exp(dptrkgas_0)
GENR ptrkdies_0 = ptrkdies_0(-4) * exp(dptrkdies_0)
GENR pothveh_0 = pothveh_0(-4) * exp(dpothveh_0)
'GENR kvehic_0 = kvehic_0(-4) * exp(dkvehic_0)
'GENR bvehic_0 = bvehic_0(-4) * exp(dbvehic_0)
'GENR tvehic_0 = tvehic_0(-4) * exp(dtvehic_0)
'GENR svehic_0 = svehic_0(-4) * exp(dsvehic_0)

'***CONTROL REGIONAL & COUNTY VEHICLE TYPES TO TOTAL
GENR pveh_adj = pvehic / (pcar_0 + ptrkgas_0 + ptrkdies_0 + pothveh_0)
GENR pcar_0 = pcar_0 * pveh_adj
GENR ptrkgas_0 = ptrkgas_0 * pveh_adj
GENR ptrkdies_0 = ptrkdies_0 * pveh_adj
GENR pothveh_0 = pothveh_0 * pveh_adj

SMPL s1970_end
GENR ctyveh_adj = pvehic / (kvehic + bvehic + tvehic + svehic)
GENR kvehic_0 = kvehic * ctyveh_adj
GENR bvehic_0 = bvehic * ctyveh_adj
GENR tvehic_0 = tvehic * ctyveh_adj
GENR svehic_0 = svehic * ctyveh_adj

SMPL 1980q1 1999q4
GENR pmvet_0 = pmvet
GENR kmvet_0 = kmvet
GENR bmvet_0 = bmvet
GENR tmvet_0 = tmvet
GENR smvet_0 = smvet

SMPL 2000Q1 2004Q4
GENR kmvet_0 = kmvet_0(-4) * exp(.01)
GENR bmvet_0 = bmvet_0(-4) * exp(.02)
GENR tmvet_0 = tmvet_0(-4) * exp(.02)
GENR smvet_0 = smvet_0(-4) * exp(.02)
GENR pmvet_0 = kmvet_0 + bmvet_0 + tmvet_0 + smvet_0

SMPL s2005_end
GENR dkvehic = log(kvehic / kvehic(-4))
GENR dbvehic = log(bvehic / bvehic(-4))
GENR dtvehic = log(tvehic / tvehic(-4))
GENR dsvehic = log(svehic / svehic(-4))

SMPL s2005_end
'GENR pmvet_0 = pmvet_0(-4) * exp(dpmvet00_0 + dpvehic + dusced00)
'GENR kmvet_0 = kmvet_0(-4) * exp(dpmvet00_0 + dkvehic + dusced00)
'GENR bmvet_0 = bmvet_0(-4) * exp(dpmvet00_0 + dbvehic + dusced00)
'GENR tmvet_0 = tmvet_0(-4) * exp(dpmvet00_0 + dtvehic + dusced00)
'GENR smvet_0 = smvet_0(-4) * exp(dpmvet00_0 + dsvehic + dusced00)


SMPL s1980_end
'***CONTROL COUNTY PER-VEHICLE MVET GROWTH TO REGIONAL TOTAL
'GENR pmvet_adj = (pmvet_0) / (kmvet_0 + bmvet_0 + tmvet_0 + smvet_0)
'GENR kmvet_0 = kmvet_0 * pmvet_adj
'GENR bmvet_0 = bmvet_0 * pmvet_adj
'GENR tmvet_0 = tmvet_0 * pmvet_adj
'GENR smvet_0 = smvet_0 * pmvet_adj


'*** WRITE OUT REVENUE FORECAST TO EXCEL WORKBOOK

SMPL s1970_end
%name="Regional model\\OUT_REVENUE2_"+%save_suf+".xls"
WRITE %name pretail_0 kretail_0 bretail_0 tretail_0 sretail_0   pvehic pcar_0 ptrkgas_0 ptrkdies_0 pothveh_0    kvehic_0 bvehic_0 tvehic_0 svehic_0   pmvet_0 kmvet_0 bmvet_0 tmvet_0 smvet_0   wfuel_0

wfsave psrc2017_out_FINAL


