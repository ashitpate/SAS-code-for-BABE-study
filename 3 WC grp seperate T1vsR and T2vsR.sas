data pkdata;
input Sub_id $ Seq $ Period Formulation $ Group Cmax;
datalines;
1001 T2RT1 1 T2 1 79.109
1001 T2RT1 2 R  1 61.317
1001 T2RT1 3 T1 1 65.091
1002 T1T2R 1 T1 1 88.613
1002 T1T2R 2 T2 1 87.135
1002 T1T2R 3 R  1 102.006
1004 T1T2R 1 T1 1 85.828
1004 T1T2R 2 T2 1 78.869
1004 T1T2R 3 R  1 77.818
1006 T2RT1 1 T2 1 48.721
1006 T2RT1 2 R  1 44.209
1006 T2RT1 3 T1 1 72.733
1007 T2RT1 1 T2 1 130.26
1007 T2RT1 2 R  1 95.357
1007 T2RT1 3 T1 1 131.631
1008 T1T2R 1 T1 1 43.48
1008 T1T2R 2 T2 1 56.467
1008 T1T2R 3 R  1 94.746
1009 RT1T2 1 R  1 67.022
1009 RT1T2 2 T1 1 58.388
1009 RT1T2 3 T2 1 86.029
1010 RT1T2 1 R  1 96.786
1010 RT1T2 2 T1 1 87.225
1010 RT1T2 3 T2 1 85.133
1012 T1T2R 1 T1 1 57.431
1012 T1T2R 2 T2 1 69.217
1012 T1T2R 3 R  1 83.866
1013 T1T2R 1 T1 2 52.2
1013 T1T2R 2 T2 2 63.555
1013 T1T2R 3 R  2 120.755
1014 RT1T2 1 R  2 90.473
1014 RT1T2 2 T1 2 68.979
1014 RT1T2 3 T2 2 104.284
1015 T2RT1 1 T2 2 82.492
1015 T2RT1 2 R  2 84.459
1015 T2RT1 3 T1 2 86.12
1016 T2RT1 1 T2 2 102.813
1016 T2RT1 2 R  2 91.063
1016 T2RT1 3 T1 2 93.372
1018 T1T2R 1 T1 2 119.537
1018 T1T2R 2 T2 2 146.835
1018 T1T2R 3 R  2 99.671
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
class Seq Sub_id Period Group Formulation;
model logCmax = Group Seq Group*Seq Formulation Period(Group);
random Sub_id(Seq*Group);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T1 vs R' Formulation 1 -1;
title 'Cmax Analysis: T1 vs R';
run;

proc mixed data=pk_t2rr;
class Seq Sub_id Period Group Formulation;
model logCmax = Group Seq Group*Seq Formulation Period(Group);
random Sub_id(Seq*Group);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T2 vs R' Formulation 1 -1;
title 'Cmax Analysis: T2 vs R';
run;