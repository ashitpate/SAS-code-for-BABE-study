data pkdata;
input Sub_id $ Seq $ Period Formulation $ Cmax AUC;
datalines;
/*type your data below this line according to the input structure*/
001 T1RT2 1 R 150 1200
;
run;

data pkdata_log;
set pkdata;
logCmax = log(Cmax);
logAUC = log(AUC);
run;

data pk_t1r;
set pkdata_log;
if Formulation in ('T1', 'R');
run;

data pk_t2r;
set pkdata_log;
if Formulation in ('T2', 'R');
run;

ods output Estimates=est_cmax_t1r LSMeans=lsm_cmax_t1r Diffs=diff_cmax_t1r 
           CovParms=cov_cmax_t1r;
proc mixed data=pk_t1r;
class Seq Sub_id Period Formulation;
model logCmax = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T1 vs R' Formulation 1 -1;
title 'Cmax Analysis: T1 vs R';
run;

ods output Estimates=est_cmax_t2r LSMeans=lsm_cmax_t2r Diffs=diff_cmax_t2r
           CovParms=cov_cmax_t2r;
proc mixed data=pk_t2r;
class Seq Sub_id Period Formulation;
model logCmax = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T2 vs R' Formulation 1 -1;
title 'Cmax Analysis: T2 vs R';
run;


ods output Estimates=est_auc_t1r LSMeans=lsm_auc_t1r Diffs=diff_auc_t1r
           CovParms=cov_auc_t1r;
proc mixed data=pk_t1r;
class Seq Sub_id Period Formulation;
model logAUC = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T1 vs R' Formulation 1 -1;
title 'AUC Analysis: T1 vs R';
run;

ods output Estimates=est_auc_t2r LSMeans=lsm_auc_t2r Diffs=diff_auc_t2r
           CovParms=cov_auc_t2r;
proc mixed data=pk_t2r;
class Seq Sub_id Period Formulation;
model logAUC = Seq Period Formulation / ddfm=kr;
random Sub_id(Seq);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T2 vs R' Formulation 1 -1;
title 'AUC Analysis: T2 vs R';
run;


data cv_calculations;
length Analysis $20 Comparison $10;

set cov_cmax_t1r(where=(CovParm='Residual') in=a)
    cov_cmax_t2r(where=(CovParm='Residual') in=b)
    cov_auc_t1r(where=(CovParm='Residual') in=c)
    cov_auc_t2r(where=(CovParm='Residual') in=d);

MSE = Estimate;
CV_percent = sqrt(exp(MSE) - 1) * 100;
if a then do; Analysis = 'Cmax'; Comparison = 'T1 vs R'; end;
else if b then do; Analysis = 'Cmax'; Comparison = 'T2 vs R'; end;
else if c then do; Analysis = 'AUC'; Comparison = 'T1 vs R'; end;
else if d then do; Analysis = 'AUC'; Comparison = 'T2 vs R'; end;
keep Analysis Comparison MSE CV_percent;
run;

proc print data=cv_calculations noobs label;
var Analysis Comparison MSE CV_percent;
label Analysis = 'Parameter'
      Comparison = 'Comparison'
      MSE = 'Residual MSE'
      CV_percent = 'CV%';
format CV_percent 8.2 MSE 8.6;
title 'Within-Subject Coefficient of Variation (CV%)';
run;