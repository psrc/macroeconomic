'******************************************************************************
'******************************************************************************
'************ PSRC LONG-TERM ECONOMIC & REVENUE FORECASTING MODELS ************
'******************************************************************************
'******************************************************************************

'THE EVIEWS FILE "IMPORT_HIST_DATA.PRG" CREATES THE FORECASTING DATABASE BASED 
'ON A COLLECTION OF EXCEL DATA FILES.


'*** CREATE PUGET SOUND WORKFORCE VARIABLE
SMPL 1970Q1 2040Q4
GENR kwkfc = kn/(1-kunrt)
GENR bwkfc = bn/(1-bunrt)
GENR twkfc = tn/(1-tunrt)
GENR swkfc = sn/(1-sunrt)
GENR pwkfc = kwkfc + bwkfc + twkfc + swkfc
GENR dpwkfc = log(pwkfc/pwkfc(-4))

'*** CREATE PUGET SOUND POPULATION VARIABLES
SMPL 1970Q1 2040Q4
GENR dppop0 = log(ppop0/ppop0(-4))
GENR dppop5 = log(ppop5/ppop5(-4))
GENR dppop20 = log(ppop20/ppop20(-4))
GENR dppop65 = log(ppop65/ppop65(-4))
GENR dppophse = log(ppophse/ppophse(-4))

'*** CREATE U.S. POPULATION VARIABLES
SMPL 1970Q1 2040Q4
GENR duspop = log(uspop/uspop(-4))
GENR duspop0 = log(uspop0/uspop0(-4))
GENR duspop5 = log(uspop5/uspop5(-4))
GENR duspop20 = log(uspop20/uspop20(-4))
GENR duspop65 = log(uspop65/uspop65(-4))

'*** CREATE AEROSPACE (BOEING) & MICROSOFT ECONOMIC DRIVER VARIABLES
SMPL 1970Q1 2040Q4
GENR dpnaer = log(pnaer/pnaer(-4))
SMPL if pnms=0
GENR pnms = 0.00001
SMPL 1970q1 2040q4
GENR dpnms = log(pnms/pnms(-4))

'*** CREATE MICROSOFT STOCK OPTION INCOME VARIABLE
SMPL 2006Q1 2040Q4
GENR dpystk = 0
SMPL if pystk=0
GENR pystk = 0.00001
SMPL 1970q1 2040q4
GENR dpystk = log(pystk/pystk(-1))

'*** CREATE DUMMY VARIABLES TO INDICATE MS DIVIDEN PAYOUT IN 2004Q4
SMPL 1970q1 2040q4
GENR dum_ms = 0
GENR dum_ms1 = 0
GENR dum_ms2 = 0
SMPL 2004Q4 2004Q4
GENR dum_ms1 = dum_ms1 + 1
GENR dum_ms = dum_ms + 1
SMPL 2005Q4 2005Q4
GENR dum_ms2 = dum_ms2 + 1
GENR dum_ms = dum_ms - 1

'*** COMPUTE US LABOR FORCE VARIABLE
SMPL 1970Q1 2040Q4
GENR uswkfc = e_0 / (1-ur_0)
GENR duswkfc = log(uswkfc/uswkfc(-4))

'*** EXTEND USPPI FUEL & RELATED COST INDEX VARIABLE
'*** NOTE: THIS SERIES WAS OBATINED FROM "FRED." IT IS NOT FORECAST BY EITHER
'*** RAY FAIR OR GLOBAL INSIGHT
SMPL 2006q3 2040q4
GENR ppi = ppi(-4)*exp(.04)


'GENERATE 1ST DIFFERENCE OF LOGS OF PUGET SOUND POP & HH VARIABLES
SMPL 1970Q1 2040Q4
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


'GENERATE 1ST DIFFERENCE OF LOGS OF FAIR US & WORLD VARIABLES
SMPL 1970Q1 2009Q4
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
GENR duspi = log(uspi_gi/uspi_gi(-4))


'*** GLOBAL INSIGHT DATA USED TO EXTEND RAY FAIR DATA BEYOND 2009
'*** CREATE 1ST DIFFERENCES OF GLOBAL INSIGHT VARIABLES
SMPL 2010Q1 2040Q4
GENR dy = 0.03
GENR dgdpn = log(usgdpn_gi / usgdpn_gi(-4))
GENR dgdpd = log(usgdpd_gi / usgdpd_gi(-4))
GENR dgdpr = log(usgdpr_gi / usgdpr_gi(-4))
GENR dpim = log(pim_gi/pim_gi(-4))
GENR dpex = log(pex_gi/pex_gi(-4))
GENR dm1 = log(m1_gi/m1_gi(-4))
GENR daaa = log(aaa_gi / aaa_gi(-4))
GENR dwldgdp = log(wldgdp_gi/wldgdp_gi(-4))
GENR dwf = log(uslabfc_gi/uslabfc_gi(-4))
GENR dresinv = log(usresinv_gi / usresinv_gi(-4))
'GENR dy = log(usy_gi / usy_gi(-4))
GENR de = log(usemp_gi / usemp_gi(-4))
GENR duspi = log(uspi_gi / uspi_gi(-4))
GENR drs = log(ustbill_gi / ustbill_gi(-4))

GENR dppi = dppi(-4)

'*** CREATE PERSONAL CONSUMPTION EXPENDITURE VARIABLE
SMPL 1970Q1 2040Q4
GENR dpce = log(usced00_gi / usced00_gi(-4))
GENR duscpi = log(uscpi82_gi / uscpi82_gi(-4))

'**************************************************
'ESTIMATE EXOGENOUG EQUATIONS FOR BOEING (PNAER) AND MICROSOFT (PNMS)
'**************************************************
SMPL 1970Q1 2040Q4
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
SMPL 2006Q2 2040Q4
GENR ms_trend = ms_trend(-4) + 2.5

SMPL 1980Q1 2006Q1
EQUATION exog_boeing.ls dpnaer c  dgdpr(-1) dgdpr(-2) ma(7) 
SMPL 1990Q1 2006Q1
EQUATION exog_ms.ls dpnms c ms_grow dgdpr ms_trend*dgdpr 

MODEL model_exog
model_exog.merge exog_boeing
model_exog.merge exog_ms
'SHOW model_exog
SMPL 1990Q1 2040Q4
model_exog.solve

'UPDATE DEPENDENT VARS FROM LEVEL 1 WITH FORECAST VALUES
SMPL 2006Q2 2040Q4
GENR dpnaer = dpnaer_0 
GENR pnaer =pnaer(-1)*exp(dpnaer/4)
GENR dpnms = dpnms_0
GENR fcast = 1


'**************************************************
'ESTIMATE MODEL 1: TOTAL EMPLOYMENT; TOTAL PERSONAL INCOME; TOTAL 
'WAGE & SALARY INCOME; PUGET SOUND CPI
'**************************************************
SMPL 1970Q1 2040Q4
VAR MOD1.ls(h) 1 4 dpn dwyp dscpi  dwyws @ C dppi(-1) dppi(-2) dppi(-3) dppi(-4) dy(-1) dy(-2) dy(-3) dy(-4) dgdpd(-1) dgdpd(-2) dgdpd(-3) dgdpd(-4) duspi(-1) duspi(-2) duspi(-3) duspi(-4) dum_ms1 dum_ms2 dpnaer(-1) dpnaer(-2) dpnaer(-3) dpnaer(-4) 

'CREATE MODEL 1 FROM "MOD1" EQUATIONS
MODEL model_1
model_1.merge MOD1
'SHOW model_1
SMPL 1980Q1 2040Q4
model_1.solve

'UPDATE DEPENDENT VARS FROM LEVEL 1 WITH FORECAST VALUES
SMPL 2006Q1 2040Q4
GENR dpn = dpn_0
GENR dwyp = dwyp_0
GENR dscpi = dscpi_0
GENR dwyws = dwyws_0
SMPL 1970Q1 2040Q4

'UPDATE DEPENDENT VARS FROM LEVEL 1 WITH FORECAST VALUES
SMPL 1970Q1 2040Q4
GENR rs = rs_0
GENR rb = rb_0
GENR rm = rm_0
GENR ur = ur_0


'CONVERT (change in)  NOMINAL WASHINGTON PERSONAL INCOME INTO REAL
GENR dwyws00 = dwyws_0 - dpce
GENR dwyp00 = dwyp_0 - dpce


'************************************
'*** MODEL 1b FORECAST POPULATION ***
'************************************
SMPL 1970Q1 2040Q4
EQUATION e_dppop.ls dppop c duspop(-3) dpnms dppop(-1) dpnaer(-1) dpnaer dpn 

e_dppop.FORECAST dppop_0

SMPL 2006Q2 2040Q4
GENR dppop  = dppop_0



'**************************************************
'LEVEL 2 POPULATION-DEMOGRAPHIC EQUATIONS
'**************************************************
SMPL 1970Q1 2006Q1
EQUATION e2_dppop0.ls dppop0 c duspop0(-2) dppop(-2) dppop dppop(-3) dpnaer dpwkfc(-1) duspop0 duspop0(-3) dppop0(-1) 

EQUATION e2_dppop5.ls dppop5 c dppop(-3) dppop5(-1) dpnaer(-3) duspop20(-3) duspop5 duspop20 dppop dppop(-2) 

EQUATION e2_dppop20.ls dppop20 c duspop5(-3) dppop20(-1) dppop(-3) duspop0(-2) dpn dppop duspop20(-1) dppop65(-1) dpwkfc(-1) duspop20 duswkfc(-1) dppop(-2) 

EQUATION e2_dppop65.ls dppop65 c duspop65 dpnaer(-2) dppop65(-1) dppop(-3) dphse(-1) duswkfc(-3) duspop0 dpwkfc(-1) dppop dppop(-2) 

EQUATION e2_dphse.ls dphse c dppop5(-1) dppop(-3) dpnaer(-1) dphse(-1) dpnms(-1) duspop65(-3) duspop20(-1) dpwkfc(-1) dppop(-2) dppop 

EQUATION e2_dppophse.ls dppophse c duspop5(-1) dppop65(-1) dppop20(-1) dppophse(-1) dwyp00 dpnaer(-2) duspop65(-3) dppop0(-1) dpwkfc(-1) dpnms(-1) dppop(-1) dppop dphse(-1) 

EQUATION e2_dpwkfc.ls dpwkfc c dpn dpwkfc(-1) 'dpnaer dpnaer(-1) duspop0(-3) duspop20 duspop0

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM LEVEL 2 SYSTEM OF EQUATIONS

MODEL model_2
model_2.merge e2_dppop0
model_2.merge e2_dppop5
model_2.merge e2_dppop20
model_2.merge e2_dppop65
model_2.merge e2_dphse
model_2.merge e2_dppophse
model_2.merge e2_dpwkfc
'SHOW model_2
SMPL 1980Q1 2040Q4
model_2.solve

'EXTEND MODEL 2 VARS BASED ON FORECAST
SMPL 2005Q2 2040Q4
GENR dppop0   = dppop_0 
GENR dppop5   = dppop5_0 
GENR dppop20  = dppop20_0
GENR dppop65  = dppop65_0
GENR dphse    = dphse_0
GENR dppophse = dppophse_0
'GENR dpwkfc   = dpwkfc_0




'*** COMPUTE "EMPLOYMENT RATE" AND FORECAST
SMPL 1970Q1 2006Q1
GENR emprate = pn / pwkfc
GENR demprate = log(emprate / emprate(-4))
GENR dppop0_p = dppop0 - dppop
GENR dppop20_p = dppop20 - dppop
GENR dppop65_p = dppop65 - dppop
GENR work_trend = @trend
SMPL 2006Q2 2040Q4
GENR work_trend = work_trend(-1)
SMPL 1970Q1 2040Q4
GENR uslabfc = usemp_gi / (1-usur_gi/100)
GENR us_emprate = usemp_gi / uslabfc

SMPL 1970Q1 2006Q1
'EQUATION aaa_emprate.ls demprate c dpn trend dpn*trend demprate(-1) dppop0_p dppop20_p dppop65_p
EQUATION aaa_emprate.ls emprate  c us_emprate    'us_emprate*work_trend 'trend

SMPL 2006Q2 2040Q4
aaa_emprate.forecast emprate_0

SMPL 1970Q1 2006Q1
GENR emprate_0 = emprate
GENR pn_0 = pn
SMPL 2006Q2 2040Q4
GENR emprate_0 = emprate_0
GENR pn_0 = pn_0(-4) * exp(dpn_0)
GENR pwkfc_0 = pn_0/emprate_0
SMPL 1970Q1 2040Q4



'********************************************************
'LEVEL 3 OLS EQUATIONS---HIGHEST NAICS INDUSTRY SECTORS
'********************************************************
'GENERATE 1st DIFF OF LOGS FOR 2nd STAGE EQUATIONS
SMPL 1970Q1 2006Q1
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

SMPL 1970Q1 2006Q1
GENR mfg_b0 = 1
SMPL 2006Q2 2040Q4
GENR mfg_b0 = .5

SMPL 1970Q1 2006Q1

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
SMPL 1970Q1 2040Q4
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
'SHOW model_3
SMPL 1980Q1 2040Q4
model_3.solve

'EXTEND MODEL 3 VARS BASED ON FORECAST
SMPL 2006Q2 2040Q4
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

SMPL 1970Q1 2040Q4




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

SMPL 1990Q1 2006Q1
EQUATION e4_dpnwhtrd.ls dpnwhtrd c dpn dpnwhtrd(-1) 
EQUATION e4_dpnretrd.ls dpnretrd c dwyp00 dpn dpnaer dwyws00 dpnretrd(-1) 
EQUATION e4_dpntrn.ls dpntrn c dpn dpnaer(-1) dwyp00 dpntrn(-1) 

SMPL 1990Q1 2001Q4
EQUATION e4_dpnutil.ls dpnutil  dpnutil(-1) dpn(-1)
EQUATION e4_dpncom.ls dpncom dpn(-1) dpncom(-1) 

SMPL 1990Q1 2006Q1
EQUATION e4_dpnoinfo.ls dpnoinfo  dpnoinfo(-1) dwyws00(-1) 
EQUATION e4_dpneat.ls dpneat c dpn dpneat(-1) dppop65
EQUATION e4_dpneduc.ls dpneduc c dwyws00 dpneduc(-1)
EQUATION e4_dpnhlth.ls dpnhlth c dpnaer  dpnhlth(-1) dpnms dppop65  'dpn(-1)
EQUATION e4_dpnoservx.ls dpnoservx c dppop20(-1) dwyws00 dpnoservx(-1) 
EQUATION e4_dpngovseduc.ls dpngovseduc c dwyws00 dppop20 dpngovseduc(-1) 
EQUATION e4_dpngovleduc.ls dpngovleduc c dpn(-1) dwyws00 dpngovleduc(-1) 
EQUATION e4_dpngovosl.ls dpngovosl c dpngovosl(-1) dppop20 dwyws00(-1) 

SMPL 1990Q1 2040Q4

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
'SHOW model_4
SMPL 1995Q1 2040Q4
model_4.solve


'EXTEND MODEL 4 VARS BASED ON FORECAST
SMPL 2006Q2 2040Q4
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
SMPL 1970Q1 2040Q4




'**************************************************
'LEVEL 5 SYSTEM OF SUR EQUATIONS---NOTE: THESE DATA BEGIN IN 1990Q1
'**************************************************
'TAKE FIRST DIFFERENCES OF LOGS OF STAGE 5 VARIABLES
GENR dpnodur = log(pnodur/pnodur(-4))
GENR dpnndur = log(pnndur/pnndur(-4))
GENR dpnmil = log(pnmil/pnmil(-4))
GENR dpngovfed = log(pngovfed/pngovfed(-4))
GENR dppopgrqt = log(ppopgrqt/ppopgrqt(-4))
SMPL 1970Q1 2005Q1

SYSTEM system_5
system_5.append dpnodur = C(1) + C(2)*dpnmfg   + C(5)*dpnodur(-1) 
system_5.append dpnndur = C(10) + C(11)*dpnndur(-1) + C(12)*dgdpr(-1) 
system_5.append dpnmil = C(30) + C(31)*dpnmil(-1) + C(32)*dpnmil(-2) 
system_5.append dpngovfed = C(20) + C(21)*dpnmil + C(22)*dpngovfed(-1) 
system_5.append dppopgrqt = C(40) + C(41)*dppopgrqt(-1) + C(42)*dppop65 
system_5.ls
'SHOW system_5.results

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM LEVEL 6 SYSTEM OF EQUATIONS
MODEL model_5
model_5.merge system_5
'SHOW model_5
SMPL 1980Q1 2040Q4
model_5.solve

'EXTEND MODEL 5 VARS BASED ON FORECAST
SMPL 2006Q2 2040Q4
GENR dpnodur = dpnodur_0 
GENR dpnndur  = dpnndur_0
GENR dpnmil = dpnmil_0
GENR dpngovfed = dpngovfed_0
GENR dppopgrqt  = dppopgrqt_0
SMPL 1970Q1 2040Q4





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

SMPL 1980Q1 2040Q4

'CREATE MODEL FROM LEVEL 7 EQUATIONS
MODEL model_6
model_6.merge e6_dphsesn
model_6.merge e6_dphseml
model_6.merge e6_dppophsesn
model_6.merge e6_dppophseml
'SHOW model_6
SMPL 1980Q1 2040Q4
model_6.solve

'EXTEND MODEL "MISC" VARS BASED ON FORECAST
SMPL 2006Q2 2040Q4
GENR dphsesn  = dphsesn_0
GENR dphseml  = dphseml_0
GENR dppophsesn = dppophsesn_0
GENR dppophseml = dppophseml_0




'**************************************************
'LEVEL 6b OLS EQUATION---FORECAST BUILING PERMITS (LINEAR MODEL)
'**************************************************
SMPL 2006Q1 2040Q4
phse = phse(-4)*exp(dphse)

SMPL 1970Q1 2040Q4
EQUATION e7_dphs.ls phs phse(-4) (phse - phse(-4))/4 
e7_dphs.forecast phs_0



'**************************************************
'LEVEL 6c OLS EQUATION---FORECAST REGIONAL PERSONAL AND WAGE & SALARY INCOME
'**************************************************
SMPL 1970Q1 2040Q4
GENR pyp = kyp + byp + typ + syp
GENR pyws = kyws + byws + tyws + syws
GENR dpyp = log(pyp/pyp(-4))
GENR dpyws = log(pyws/pyws(-4))
SMPL 2006q2 2040q4
GENR dwyp =  dwyp_0

SMPL 1970q1 2040q4
EQUATION dpypeq.ls dpyp c dwyp 
EQUATION dpywseq.ls dpyws c dwyws


'CREATE MODEL FROM PUGET SOUND INCOME EQUATIONS
MODEL puget_inc
puget_inc.merge dpypeq
puget_inc.merge dpywseq
'SHOW puget_inc
SMPL 1980Q1 2040Q4
puget_inc.solve

'EXTEND MODEL "PUGET_INC" VARS BASED ON FORECAST
SMPL 2005Q1 2040Q4
GENR dpyp = dpyp_0 
GENR dpyws  = dpyws_0

'STOP



'***************************************************************************************
'************* WRITE OUT REGION LEVEL DATA TO EXCEL ******************
'***************************************************************************************
'HISTORICAL PERIOD
SMPL 1970Q1 2006Q1
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
SMPL 1971Q1 2006Q1
GENR scpi_0 = scpi_0(-4)*exp(dscpi)
SMPL 1970Q1 2006Q1
GENR pyp00 =pyp_0/usced00_GI
GENR pyws00 = pyws_0/usced00_GI
GENR pyoth00 = pyp00 - pyws00

GENR ppop_0 = ppop
GENR ppop0_0 = ppop0
GENR ppop5_0 = ppop5
GENR ppop20_0 = ppop20
GENR ppop65_0 = ppop65

GENR pypp00 = pyp00/ppop_0
GENR phs_0 = phs
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

'GENR dphs = dphs_0 
GENR dphsesn  = dphsesn_0
GENR dppophsesn = dppophsesn_0


'FORECAST PERIOD
SMPL 2006Q2 2040Q4
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
GENR pnmil_0 = pnmil_0(-4)*exp(dpnmil)

'*** AGGREGATE EMPLOYMENT SECTORS
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

SMPL 2005Q1 2040Q4
GENR pyp_0 = pyp_0(-4) * exp(dpyp)  
GENR pyws_0 = pyws_0(-4) * exp(dpyws)

'SMPL 2006Q1 2040Q4
'GENR pyp_0 = (pyp_0(-6) + pyp_0(-5) + pyp_0(-4) + pyp_0(-3))/4 * exp(dpyp)  
'GENR pyws_0 = (pyws_0(-6) + pyws_0(-5) + pyws_0(-4) + pyws_0(-3))/4 * exp(dpyws)

SMPL 2005Q1 2040Q4
'GENR scpi_0 = scpi_0(-4)*exp(dscpi)
GENR pyp00 =pyp_0/usced00_GI
GENR pyws00 = pyws_0/usced00_GI
GENR pyoth00 = pyp00 - pyws00

SMPL 2006Q1 2040Q4
GENR ppop_0 = ppop_0(-4)*exp(dppop)
GENR ppop0_0 = ppop0_0(-4)*exp(dppop0)
GENR ppop5_0 = ppop5_0(-4)*exp(dppop5)
GENR ppop20_0 = ppop20_0(-4)*exp(dppop20)
GENR ppop65_0 = ppop65_0(-4)*exp(dppop65)

SMPL 2005Q1 2040Q4
GENR pypp00 = pyp00/ppop_0

SMPL 2006Q1 2040Q4
GENR phs_0 = phs_0
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


'*** CONTROL AGE COHORT POPULATION GROWTH TO TOTAL POPULATION 
GENR adj_agepop = ppop_0 / (ppop0_0 + ppop5_0 + ppop20_0 + ppop65_0)
GENR ppop0_0  = ppop0_0  * adj_agepop
GENR ppop5_0  = ppop5_0  * adj_agepop 
GENR ppop20_0 = ppop20_0 * adj_agepop
GENR ppop65_0 = ppop65_0 * adj_agepop 

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



smpl 1970Q1 2040Q4
WRITE 	 "J:\Projects\Forecasts\Regional\2010\ECO_2006\Master eView Model\OUT_DATA_region.xls" pn_0 pngoods_0 pnres_0 pncon_0 pnmfg_0 pnaer_0 pnodur_0 pnndur_0 pnserv_0 pntrd_0 pnwhtrd_0 pnretrd_0 pntrnutil_0 pntrn_0 pnutil_0 pninfo_0 pncom_0 pnoinfo_0 pnfin_0 pnprofbus_0 pnoserv_0 pneat_0 pneduc_0 pnhlth_0 pnoservx_0 pngov_0 pngovsl_0 pngovseduc_0 pngovleduc_0 pngovosl_0 pngovfed_0 pnmil_0 pur_0 pyp_0 pyp00 pyws00 pyoth00 pypp00 scpi_0 phs_0 ppop_0 ppop0_0 ppop5_0 ppop20_0 ppop65_0 ppopgrqt_0 ppophse_0 ppophsesn_0 ppophseml_0 phse_0 phsesn_0 phseml_0 phsesz_0 phseszsn_0 phseszml_0 usced00_GI


'STOP

'*******************************************************************************
'*** NOW CREATE COUNTY-LEVEL EMPLOYMENT, ECONOMIC, AND DEMOGRAPHIC FORECASTS ***
'*******************************************************************************

SMPL 1970Q1 2006Q1

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
SMPL 1970Q1 2006Q1
GENR dtnaer = log(tnaer2/tnaer2(-4))
GENR dsnaer = log(snaer/snaer(-4))
'GENR dbnaer = log(bnaer/bnaer(-4))


SMPL 1970Q1 2040Q4
'ESTIMATE SINGLE EQUATION COUNTY-LEVEL EMPLOYMENT
EQUATION cty_kn.ls dkn c dpn
EQUATION cty_bn.ls dbn c dpn
EQUATION cty_sn.ls dsn c dpn
EQUATION cty_tn.ls  dtn c dpn

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7" COUNTY-LEVEL EMPLOYMENT EQUATIONS
MODEL model_7
model_7.merge cty_kn
model_7.merge cty_bn
model_7.merge cty_sn
model_7.merge cty_tn
'SHOW model_7
SMPL 1980Q1 2040Q4
model_7.solve


'TAKE FIRST LOG DIFFERENCE OF GOODS AND SERVICE EMPLOYMENT
GENR dpngoods = log(pngoods_0 / pngoods_0(-4)) 
GENR dpnserv = log(pnserv_0 / pnserv_0(-4))


'COMPUTE TOTAL COUNTY EMPLOYMENT SHIFT SHARES
SMPL 1970Q1 2040Q4
genr shift_k = dkn_0 - dpn - dkn_0(-4) + dpn(-4)
genr shift_b = dbn_0 - dpn - dbn_0(-4) + dpn(-4)
genr shift_s = dsn_0 - dpn - dsn_0(-4) + dpn(-4)
genr shift_t = dtn_0 - dpn - dtn_0(-4) + dpn(-4)


'ESTIMATE COUNTY-LEVEL GOODS EQUATIONS
EQUATION cty_kngoods.ls dkngoods c dpngoods shift_k
EQUATION cty_bngoods.ls dbngoods c dpngoods shift_b
EQUATION cty_tngoods.ls dtngoods c dpngoods shift_t
EQUATION cty_sngoods.ls dsngoods c dpngoods shift_s

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7b" COUNTY-LEVEL GOODS EMPLOYMENT EQUATIONS
MODEL model_7b
model_7b.merge cty_kngoods
model_7b.merge cty_bngoods
model_7b.merge cty_sngoods
model_7b.merge cty_tngoods
'SHOW model_7b
SMPL 1980Q1 2040Q4
model_7b.solve



'ESTIMATE COUNTY-LEVEL AEROSPACE EQUATIONS
EQUATION cty_knaer.ls dknaer c dpnaer shift_k
'EQUATION cty_tnaer.ls dtnaer c dpnaer 'shift_t
EQUATION cty_snaer.ls dsnaer c dpnaer shift_s

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7c" COUNTY-LEVEL AEROSPACE EMPLOYMENT EQUATIONS
MODEL model_7c
model_7c.merge cty_knaer
model_7c.merge cty_snaer
'model_7c.merge cty_tnaer
'SHOW model_7c
SMPL 1980Q1 2040Q4
model_7c.solve



'ESTIMATE COUNTY-LEVEL SERVICE EQUATIONS
EQUATION cty_knserv.ls dknserv c dpnserv shift_k
EQUATION cty_bnserv.ls dbnserv c dpnserv shift_b
EQUATION cty_tnserv.ls dtnserv c dpnserv shift_t
EQUATION cty_snserv.ls dsnserv c dpnserv shift_s

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7d" COUNTY-LEVEL SERVICE EMPLOYMENT EQUATIONS
MODEL model_7d
model_7d.merge cty_knserv
model_7d.merge cty_bnserv
model_7d.merge cty_snserv
model_7d.merge cty_tnserv
'SHOW model_7d
SMPL 1980Q1 2040Q4
model_7d.solve




'ESTIMATE COUNTY-LEVEL PERSONAL INCOME EQUATIONS
SMPL 1970Q1 2040Q4
GENR dkyp = log(kyp/kyp(-4)) 
GENR dbyp = log(byp/byp(-4)) 
GENR dtyp = log(typ/typ(-4)) 
GENR dsyp = log(syp/syp(-4)) 

'EQUATION cty_kyp.ls dkyp c dpyp (dkyp(-1) - dpyp(-1) - dkyp(-2) + dpyp(-2))
'EQUATION cty_byp.ls dbyp c dpyp (dbyp(-1) - dpyp(-1) - dbyp(-2) + dpyp(-2))
'EQUATION cty_typ.ls dtyp c dpyp (dtyp(-1) - dpyp(-1) - dtyp(-2) + dpyp(-2))
'EQUATION cty_syp.ls dsyp c dpyp (dsyp(-1) - dpyp(-1) - dsyp(-2) + dpyp(-2))

EQUATION cty_kyp.ls dkyp c dpyp 
EQUATION cty_byp.ls dbyp c dpyp 
EQUATION cty_typ.ls dtyp c dpyp 
EQUATION cty_syp.ls dsyp c dpyp 

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7e" COUNTY-LEVEL PERSONAL INCOME EQUATIONS
MODEL model_7e
model_7e.merge cty_kyp
model_7e.merge cty_byp
model_7e.merge cty_syp
model_7e.merge cty_typ
'SHOW model_7e
SMPL 1980Q1 2040Q4
model_7e.solve




'ESTIMATE COUNTY-LEVEL POPULATION EQUATIONS
SMPL 1970Q1 2040Q4
GENR dkpop = log(kpop/kpop(-4)) 
GENR dbpop = log(kpop/kpop(-4)) 
GENR dtpop = log(kpop/kpop(-4)) 
GENR dspop = log(kpop/kpop(-4)) 

EQUATION cty_kpop.ls dkpop c dppop (dkpop(-1) - dppop(-1) - dkpop(-2) + dppop(-2))
EQUATION cty_bpop.ls dbpop c dppop (dbpop(-1) - dppop(-1) - dbpop(-2) + dppop(-2))
EQUATION cty_tpop.ls dtpop c dppop (dtpop(-1) - dppop(-1) - dtpop(-2) + dppop(-2))
EQUATION cty_spop.ls dspop c dppop (dspop(-1) - dppop(-1) - dspop(-2) + dppop(-2))

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7f" COUNTY-LEVEL POPULATION EQUATIONS
MODEL model_7f
model_7f.merge cty_kpop
model_7f.merge cty_bpop
model_7f.merge cty_spop
model_7f.merge cty_tpop
'SHOW model_7f
SMPL 1980Q1 2040Q4
model_7f.solve



'ESTIMATE COUNTY-LEVEL HOUSEHOLD EQUATIONS
SMPL 1970Q1 2040Q4
GENR dkhse = log(khse/khse(-4)) 
GENR dbhse = log(bhse/bhse(-4)) 
GENR dthse = log(thse/thse(-4)) 
GENR dshse = log(shse/shse(-4)) 

EQUATION cty_khse.ls dkhse c dphse
EQUATION cty_bhse.ls dbhse c dphse 
EQUATION cty_thse.ls dthse c dphse 
EQUATION cty_shse.ls dshse c dphse 

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7g" COUNTY-LEVEL HOUSEHOLD EQUATIONS
MODEL model_7g
model_7g.merge cty_khse
model_7g.merge cty_bhse
model_7g.merge cty_shse
model_7g.merge cty_thse
'SHOW model_7g
SMPL 1980Q1 2040Q4
model_7g.solve



'ESTIMATE COUNTY-LEVEL SINGLE-FAMILY & MULIT-FAMILY HOUSEHOLD EQUATIONS
SMPL 1970Q1 2040Q4
GENR dkhsesn = log(khsesn/khsesn(-4)) 
GENR dbhsesn = log(bhsesn/bhsesn(-4)) 
GENR dthsesn = log(thsesn/thsesn(-4)) 
GENR dshsesn = log(shsesn/shsesn(-4)) 

GENR dkhseml = log(khseml/khseml(-4)) 
GENR dbhseml = log(bhseml/bhseml(-4)) 
GENR dthseml = log(thseml/thseml(-4)) 
GENR dshseml = log(shseml/shseml(-4)) 

'EQUATION cty_khsesn.ls dkhsesn c dphsesn (dkhsesn(-1) - dphsesn(-1) - dkhsesn(-2) + dphsesn(-2))
'EQUATION cty_bhsesn.ls dbhsesn c dphsesn (dbhsesn(-1) - dphsesn(-1) - dbhsesn(-2) + dphsesn(-2))
'EQUATION cty_thsesn.ls dthsesn c dphsesn (dthsesn(-1) - dphsesn(-1) - dthsesn(-2) + dphsesn(-2))
'EQUATION cty_shsesn.ls dshsesn c dphsesn (dshsesn(-1) - dphsesn(-1) - dshsesn(-2) + dphsesn(-2))

EQUATION cty_khsesn.ls dkhsesn c dphsesn 
EQUATION cty_bhsesn.ls dbhsesn c dphsesn 
EQUATION cty_thsesn.ls dthsesn c dphsesn 
EQUATION cty_shsesn.ls dshsesn c dphsesn 

EQUATION cty_khseml.ls dkhseml c dphseml 
EQUATION cty_bhseml.ls dbhseml c dphseml 
EQUATION cty_thseml.ls dthseml c dphseml 
EQUATION cty_shseml.ls dshseml c dphseml 

SMPL 1970Q1 2040Q4

'CREATE MODEL FROM "LEVEL 7h" COUNTY-LEVEL SINGLE-FAMILY HOUSEHOLD EQUATIONS
MODEL model_7h
model_7h.merge cty_khsesn
model_7h.merge cty_bhsesn
model_7h.merge cty_shsesn
model_7h.merge cty_thsesn
'SHOW model_7h
SMPL 1980Q1 2040Q4
model_7h.solve


'CREATE MODEL FROM "LEVEL 7i" COUNTY-LEVEL MULTI-FAMILY HOUSEHOLD EQUATIONS
MODEL model_7i
model_7i.merge cty_khseml
model_7i.merge cty_bhseml
model_7i.merge cty_shseml
model_7i.merge cty_thseml
'SHOW model_7i
SMPL 1980Q1 2040Q4
model_7i.solve


'STOP






SMPL 1970Q1 2006Q1
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


SMPL 2006Q2 2040Q4
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

SMPL 2005Q1 2040Q4
GENR adj_kyp = adj_kyp(-4) * exp(dkyp_0)
GENR adj_byp = adj_byp(-4) * exp(dbyp_0)
GENR adj_typ = adj_typ(-4) * exp(dtyp_0)
GENR adj_syp = adj_syp(-4) * exp(dsyp_0)

SMPL 2006Q2 2040Q4
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


SMPL 1970Q1 2040Q4

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
GENR adj_kyp00 = adj_kyp / usced00_GI
GENR adj_byp00 = adj_byp / usced00_GI
GENR adj_typ00 = adj_typ / usced00_GI
GENR adj_syp00 = adj_syp / usced00_GI

'DERIVE COUNTY-LEVEL REAL PER CAPITA PERSONAL INCOME
GENR adj_kypp00 = adj_kyp00 / adj_kpop
GENR adj_bypp00 = adj_byp00 / adj_bpop
GENR adj_typp00 = adj_typ00 / adj_tpop
GENR adj_sypp00 = adj_syp00 / adj_spop


'*** WRITE OUT COUNTY FORECAST TO EXCEL WORKBOOK

smpl 1970Q1 2040Q4
WRITE "J:\Projects\Forecasts\Regional\2010\ECO_2006\Master eView Model\OUT_DATA_counties.xls" adj_kn adj_kngoods adj_knaer adj_knserv adj_kyp adj_kyp00 adj_kypp00 adj_kpop adj_khse adj_khsesn adj_khseml adj_bn adj_bngoods adj_bnserv adj_byp adj_byp00 adj_bypp00 adj_bpop adj_bhse adj_bhsesn adj_bhseml adj_tn adj_tngoods adj_tnaer adj_tnserv adj_typ adj_typ00 adj_typp00 adj_tpop adj_thse adj_thsesn adj_thseml adj_sn adj_sngoods adj_snaer adj_snserv adj_syp adj_syp00 adj_sypp00 adj_spop adj_shse adj_shsesn adj_shseml








'*********************************************************
'******************* REVENUE FORECAST ********************
'*********************************************************
SMPL 1970Q1 2040Q4
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
SMPL 1970Q1 2006Q1
GENR wyp_0 = wyp
SMPL 2006Q2 2040Q4
GENR wyp_0 = wyp_0(-4) * exp(dwyp)
SMPL 1970Q1 2040Q4
GENR wyp_0 = wyp_0 / usced00_GI
GENR wyp00 = wyp_0 / usced00_GI
GENR dwyp00 = log(wyp_0 / wyp_0(-4))
GENR dwyphh00 = dwyp00 - dphse
EQUATION rev_dwfuel.ls dwfuel dwfuel(-1) dppi dwyphh00 dphse @trend 'dwpop 'dphse 'dphsesz
SMPL 1980q1 2040q4
rev_dwfuel.FORECAST dwfuel_0

'**************************************************************************
'SECOND FORECAST REGIONAL-LEVEL & COUNTY-LEVEL RETAIL SALES
'**************************************************************************
SMPL 1970Q1 2006Q1
EQUATION rev_dpretail.ls dpretail c dpyp  'dpretail(-1) dpyp 
SMPL 1980q1 2040q4
rev_dpretail.FORECAST dpretail_0

SMPL 1970Q1 2006Q1
EQUATION rev_dkretail.ls dkretail c dpretail_0 dkpop_0
EQUATION rev_dbretail.ls dbretail c dpretail_0 dbpop_0 
EQUATION rev_dtretail.ls dtretail c dpretail_0 dtpop_0 
EQUATION rev_dsretail.ls dsretail c dpretail_0 dspop_0 

SMPL 1980q1 2040q4
rev_dkretail.FORECAST dkretail_0
rev_dbretail.FORECAST dbretail_0
rev_dtretail.FORECAST dtretail_0
rev_dsretail.FORECAST dsretail_0

'**************************************************************************
'THIRD PROJECT TOTAL VEHICLES IN REGION & DISAGGREGATE VEHICLES BY CLASS
'**************************************************************************
SMPL 1970Q1 2040Q4

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

GENR dphsesz = dppop - dphse
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
SMPL 2006q1 2040q4
GENR pvehic = pvehic(-4) * exp(0.121*dpyphh00 + 0.859*dphse   + 0.734*dphsesz)
GENR kvehic = kvehic(-4) * exp(0.121*dkyphh00 + 0.859*dkhse_0 + 0.734*dkhsesz)
GENR bvehic = bvehic(-4) * exp(0.121*dbyphh00 + 0.859*dbhse_0 + 0.734*dbhsesz)
GENR tvehic = tvehic(-4) * exp(0.121*dtyphh00 + 0.859*dthse_0 + 0.734*dthsesz)
GENR svehic = svehic(-4) * exp(0.121*dsyphh00 + 0.859*dshse_0 + 0.734*dshsesz)

'ESTIMATE VAR MODEL OF REGIONAL VEHICLS 
SMPL 1970Q1 2005Q4
VAR carvar.ls(h) 1 4 dpcar dptrkgas dptrkdies dpothveh @ C 'trend 

'CREATE MODEL FROM "carvar" VAR MODEL
MODEL carvar_mod
carvar_mod.merge carvar
'SHOW carvar_mod
SMPL 1980Q1 2040Q4
carvar_mod.solve


'ESTIMATE VAR MODEL OF COUNTY VEHICLS 
'SMPL 1970Q1 2005Q4
'GENR dpvehic = log(pvehic / pvehic(-4))
'VAR cty_carvar.ls(h) 1 2 dkvehic dbvehic dtvehic dsvehic @ c  dpvehic

'CREATE MODEL FROM "cty_carvar" VAR MODEL
'MODEL cty_carvar_mod
'cty_carvar_mod.merge cty_carvar
'SHOW cty_carvar_mod
'SMPL 1980Q1 2040Q4
'cty_carvar_mod.solve

GENR dpvehic = log(pvehic / pvehic(-4))



'**************************************************************************************
'ESTIMATE REGIONAL PER VEHICEL GROWTH RATE MODEL
'**************************************************************************************
SMPL 1970q1 2040q4
GENR pmvet = kmvet + bmvet + tmvet + smvet
GENR dpmvet = log(pmvet/pmvet(-4))
GENR dkmvet = log(kmvet/kmvet(-4))
GENR dbmvet = log(bmvet/bmvet(-4))
GENR dtmvet = log(tmvet/tmvet(-4))
GENR dsmvet = log(smvet/smvet(-4))
GENR duscpi = log(uscpi82_gi/uscpi82_gi(-4))
GENR dusced00 = log(usced00_GI/usced00_GI(-4))
GENR dpmvet00 = dpmvet - dusced00 - dpvehic
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
SMPL 2000q1 2040Q4
GENR mvet_trend = mvet_trend(-4) + 0.50


SMPL 1980q1 2040q4
EQUATION rev_pmvet.ls dpmvet00 c dusced00 end_mvet mvet_trend 
'EQUATION rev_kmvet.ls dkmvet00 c dusced00 end_mvet mvet_trend 
'EQUATION rev_bmvet.ls dbmvet00 c dusced00 end_mvet mvet_trend 
'EQUATION rev_tmvet.ls dtmvet00 c dusced00 end_mvet mvet_trend 
'EQUATION rev_smvet.ls dsmvet00 c dusced00 end_mvet mvet_trend 

SMPL 1980q1 2040q4
rev_pmvet.FORECAST dpmvet00_0
'rev_kmvet.FORECAST dkmvet00_0
'rev_bmvet.FORECAST dbmvet00_0
'rev_tmvet.FORECAST dtmvet00_0
'rev_smvet.FORECAST dsmvet00_0






'***********************************
'*** CREATE RETAIL SALES VARIABLES
'***********************************
SMPL 1970q1 2005q4
GENR wfuel_0 = wfuel
SMPL 2006q1 2040q4
GENR wfuel_0 = wfuel_0(-4) * exp(dwfuel_0)


'***********************************
'*** CREATE RETAIL SALES VARIABLES
'***********************************
SMPL 1970q1 2005q4
GENR pretail_0 = pretail
GENR kretail_0 = kretail
GENR bretail_0 = bretail
GENR tretail_0 = tretail
GENR sretail_0 = sretail

SMPL 2006q1 2040q4
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
SMPL 	1970q1 2005q4
GENR pcar_0 = pcar
GENR ptrkgas_0 = ptrkgas
GENR ptrkdies_0 = ptrkdies
GENR pothveh_0 = pothveh
'GENR kvehic_0 = kvehic
'GENR bvehic_0 = bvehic
'GENR tvehic_0 = tvehic
'GENR svehic_0 = svehic


SMPL 2006Q1 2040Q4
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

SMPL 1970Q1 2040Q4
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

' SET 2004Q4 MVET VALUES TO THE AVG VALUE FROM RTID PROJECT  
'SMPL 1999Q4 1999Q4
'GENR k_grth = log(13948172000 / kmvet_0)/5
'GENR b_grth = k_grth
'GENR t_grth = log( 4892505000 / tmvet_0)/5
'GENR s_grth = log( 4556887000 / smvet_0)/5

SMPL 2000Q1 2004Q4
GENR kmvet_0 = kmvet_0(-4) * exp(.01)
GENR bmvet_0 = bmvet_0(-4) * exp(.02)
GENR tmvet_0 = tmvet_0(-4) * exp(.02)
GENR smvet_0 = smvet_0(-4) * exp(.02)
GENR pmvet_0 = kmvet_0 + bmvet_0 + tmvet_0 + smvet_0

SMPL 2005Q1 2040Q4
GENR dkvehic = log(kvehic / kvehic(-4))
GENR dbvehic = log(bvehic / bvehic(-4))
GENR dtvehic = log(tvehic / tvehic(-4))
GENR dsvehic = log(svehic / svehic(-4))

SMPL 2005Q1 2040Q4
GENR pmvet_0 = pmvet_0(-4) * exp(dpmvet00_0 + dpvehic + dusced00)
GENR kmvet_0 = kmvet_0(-4) * exp(dpmvet00_0 + dkvehic + dusced00)
GENR bmvet_0 = bmvet_0(-4) * exp(dpmvet00_0 + dbvehic + dusced00)
GENR tmvet_0 = tmvet_0(-4) * exp(dpmvet00_0 + dtvehic + dusced00)
GENR smvet_0 = smvet_0(-4) * exp(dpmvet00_0 + dsvehic + dusced00)


SMPL 1980Q1 2040Q4
'***CONTROL COUNTY PER-VEHICLE MVET GROWTH TO REGIONAL TOTAL
GENR pmvet_adj = (pmvet_0) / (kmvet_0 + bmvet_0 + tmvet_0 + smvet_0)
GENR kmvet_0 = kmvet_0 * pmvet_adj
GENR bmvet_0 = bmvet_0 * pmvet_adj
GENR tmvet_0 = tmvet_0 * pmvet_adj
GENR smvet_0 = smvet_0 * pmvet_adj


'*** WRITE OUT REVENUE FORECAST TO EXCEL WORKBOOK

smpl 1970Q1 2040Q4
WRITE "J:\Projects\Forecasts\Regional\2010\ECO_2006\Master eView Model\OUT_REVENUE2.xls" pretail_0 kretail_0 bretail_0 tretail_0 sretail_0   pvehic pcar_0 ptrkgas_0 ptrkdies_0 pothveh_0    kvehic_0 bvehic_0 tvehic_0 svehic_0   pmvet_0 kmvet_0 bmvet_0 tmvet_0 smvet_0   wfuel_0

