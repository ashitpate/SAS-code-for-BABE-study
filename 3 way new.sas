/* 3-Way Crossover Bioequivalence Analysis */
/* Comparisons: T1 vs R, T2 vs R, T (pooled T1+T2) vs R */

/* Input the data */
data pkdata;
input Sub_id $ Seq $ Period Formulation $ Cmax AUC;
datalines;
/*type your data below this line according to the input structure*/
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