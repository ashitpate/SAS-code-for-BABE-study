/* 3-Way Crossover Bioequivalence Analysis */
/* Comparisons: T1 vs R, T2 vs R, T (pooled T1+T2) vs R */

/* Input the data */
data pkdata;
input Sub_id $ Seq $ Period Formulation $ Cmax AUC;
datalines;
1001 RT1T2 1 R 39.062 244.488
1001 RT1T2 2 T1 37.632 229.713
1001 RT1T2 3 T2 34.860 266.053
1002 T2RT1 1 T2 46.949 258.338
1002 T2RT1 2 R 49.524 298.841
1002 T2RT1 3 T1 44.237 284.811
1003 T1T2R 1 T1 44.958 273.772
1003 T1T2R 2 T2 25.427 257.915
1003 T1T2R 3 R 48.274 341.347
1004 T2RT1 1 T2 46.672 348.308
1004 T2RT1 2 R 40.711 366.825
1004 T2RT1 3 T1 51.764 470.030
1005 RT1T2 1 R 29.004 197.671
1005 RT1T2 2 T1 32.836 231.697
1005 RT1T2 3 T2 34.427 260.403
1006 T1T2R 1 T1 45.115 346.983
1006 T1T2R 2 T2 47.468 398.847
1006 T1T2R 3 R 36.390 375.960
1007 T2RT1 1 T2 40.388 431.943
1007 T2RT1 2 R 38.784 371.979
1007 T2RT1 3 T1 39.274 407.891
1008 T1T2R 1 T1 32.681 324.873
1008 T1T2R 2 T2 37.772 309.330
1008 T1T2R 3 R 36.189 373.942
1009 RT1T2 1 R 50.978 612.865
1009 RT1T2 2 T1 45.609 619.282
1009 RT1T2 3 T2 54.670 623.760
1010 RT1T2 1 R 39.103 293.238
1010 RT1T2 2 T1 46.897 307.030
1010 RT1T2 3 T2 54.711 399.103
1011 T2RT1 1 T2 32.290 358.835
1011 T2RT1 2 R 38.924 407.000
1011 T2RT1 3 T1 38.842 424.665
1012 T1T2R 1 T1 56.616 542.828
1012 T1T2R 2 T2 52.058 521.316
1012 T1T2R 3 R 58.425 532.118
1013 T2RT1 1 T2 54.516 462.876
1013 T2RT1 2 R 45.799 452.278
1013 T2RT1 3 T1 42.598 440.036
1014 T1T2R 1 T1 29.186 220.844
1014 T1T2R 2 T2 28.344 259.708
1014 T1T2R 3 R 29.042 308.099
1015 RT1T2 1 R 34.788 401.832
1015 RT1T2 2 T1 27.759 367.832
1015 RT1T2 3 T2 27.066 344.228
1016 RT1T2 1 R 63.804 406.757
1016 RT1T2 2 T1 60.722 369.489
1016 RT1T2 3 T2 49.360 378.036
1018 T1T2R 1 T1 60.384 587.209
1018 T1T2R 2 T2 59.356 580.096
1018 T1T2R 3 R 73.554 758.962
;
run;

/* Log-transform the PK parameters */
data pkdata_log;
set pkdata;
logCmax = log(Cmax);
logAUC = log(AUC);
run;

/* ============================================ */
/* ANALYSIS 1: T1 vs R                          */
/* ============================================ */

/* Create dataset for T1 vs R comparison */
data pk_t1r;
set pkdata_log;
if Formulation in ('T1', 'R');
run;

/* ANOVA for Cmax - T1 vs R */
proc mixed data=pk_t1r;
class Seq Sub_id Period Formulation;
model logCmax = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_cmax_t1r;
title 'Cmax Analysis: T1 vs R';
run;

/* ANOVA for AUC - T1 vs R */
proc mixed data=pk_t1r;
class Seq Sub_id Period Formulation;
model logAUC = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_auc_t1r;
title 'AUC Analysis: T1 vs R';
run;

/* ============================================ */
/* ANALYSIS 2: T2 vs R                          */
/* ============================================ */

/* Create dataset for T2 vs R comparison */
data pk_t2r;
set pkdata_log;
if Formulation in ('T2', 'R');
run;

/* ANOVA for Cmax - T2 vs R */
proc mixed data=pk_t2r;
class Seq Sub_id Period Formulation;
model logCmax = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_cmax_t2r;
title 'Cmax Analysis: T2 vs R';
run;

/* ANOVA for AUC - T2 vs R */
proc mixed data=pk_t2r;
class Seq Sub_id Period Formulation;
model logAUC = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_auc_t2r;
title 'AUC Analysis: T2 vs R';
run;

/* ============================================ */
/* ANALYSIS 3: T (pooled T1 + T2) vs R          */
/* ============================================ */

/* Create pooled Test formulation */
data pk_tr;
set pkdata_log;
if Formulation in ('T1', 'T2') then Formulation = 'T';
run;

/* ANOVA for Cmax - T vs R */
proc mixed data=pk_tr;
class Seq Sub_id Period Formulation;
model logCmax = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_cmax_tr;
title 'Cmax Analysis: T (pooled) vs R';
run;

/* ANOVA for AUC - T vs R */
proc mixed data=pk_tr;
class Seq Sub_id Period Formulation;
model logAUC = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control('R') cl alpha=0.1;
ods output Diffs=diff_auc_tr;
title 'AUC Analysis: T (pooled) vs R';
run;

/* ============================================ */
/* CREATE FINAL SUMMARY TABLE                   */
/* ============================================ */

/* Process Cmax T1 vs R */
data cmax_t1r_result;
set diff_cmax_t1r;
if Formulation='T1' and _Formulation='R';
Comparison = 'T1 vs R';
Parameter = 'Cmax';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Process AUC T1 vs R */
data auc_t1r_result;
set diff_auc_t1r;
if Formulation='T1' and _Formulation='R';
Comparison = 'T1 vs R';
Parameter = 'AUC';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Process Cmax T2 vs R */
data cmax_t2r_result;
set diff_cmax_t2r;
if Formulation='T2' and _Formulation='R';
Comparison = 'T2 vs R';
Parameter = 'Cmax';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Process AUC T2 vs R */
data auc_t2r_result;
set diff_auc_t2r;
if Formulation='T2' and _Formulation='R';
Comparison = 'T2 vs R';
Parameter = 'AUC';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Process Cmax T vs R */
data cmax_tr_result;
set diff_cmax_tr;
if Formulation='T' and _Formulation='R';
Comparison = 'T (pooled) vs R';
Parameter = 'Cmax';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Process AUC T vs R */
data auc_tr_result;
set diff_auc_tr;
if Formulation='T' and _Formulation='R';
Comparison = 'T (pooled) vs R';
Parameter = 'AUC';
GMR = exp(Estimate) * 100;
Lower_90CI = exp(Lower) * 100;
Upper_90CI = exp(Upper) * 100;
if Lower_90CI >= 80 and Upper_90CI <= 125 then BE_Conclusion = 'Bioequivalent';
else BE_Conclusion = 'Not Bioequivalent';
keep Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
run;

/* Combine all results */
data final_summary;
set cmax_t1r_result
    auc_t1r_result
    cmax_t2r_result
    auc_t2r_result
    cmax_tr_result
    auc_tr_result;
format GMR Lower_90CI Upper_90CI 8.2;
run;

/* Print final summary table */
proc print data=final_summary noobs label;
title 'BIOEQUIVALENCE SUMMARY - 90% CONFIDENCE INTERVALS';
title2 'Geometric Mean Ratios (%) with 90% CI';
title3 'Acceptance Criteria: 80.00% - 125.00%';
var Comparison Parameter GMR Lower_90CI Upper_90CI BE_Conclusion;
label Comparison = 'Comparison'
      Parameter = 'Parameter'
      GMR = 'GMR (%)'
      Lower_90CI = 'Lower 90% CI'
      Upper_90CI = 'Upper 90% CI'
      BE_Conclusion = 'Conclusion';
run;

title;