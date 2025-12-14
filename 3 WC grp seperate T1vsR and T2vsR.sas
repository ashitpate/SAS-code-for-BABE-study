data pkdata;
input Sub_id $ Seq $ Period Formulation $ Group Cmax;
datalines;
/*THIS IS THE SAMPLE DATA FOR TESTING PURPOSES ONLY*/
01 T2RT1 1 T2 1 82.45
01 T2RT1 2 R  1 59.88
01 T2RT1 3 T1 1 67.92
02 T1T2R 1 T1 1 91.34
02 T1T2R 2 T2 1 84.76
02 T1T2R 3 R  1 99.58
03 T1T2R 1 T1 1 88.12
03 T1T2R 2 T2 1 81.44
03 T1T2R 3 R  1 79.63
04 T2RT1 1 T2 1 51.29
04 T2RT1 2 R  1 46.17
04 T2RT1 3 T1 1 70.88
05 T2RT1 1 T2 1 127.84
05 T2RT1 2 R  1 97.52
05 T2RT1 3 T1 1 134.06
06 T1T2R 1 T1 1 45.16
06 T1T2R 2 T2 1 58.91
06 T1T2R 3 R  1 92.38
07 RT1T2 1 R  1 69.45
07 RT1T2 2 T1 1 60.77
07 RT1T2 3 T2 1 89.14
08 RT1T2 1 R  1 93.82
08 RT1T2 2 T1 1 85.69
08 RT1T2 3 T2 1 88.02
09 T1T2R 1 T1 1 59.88
09 T1T2R 2 T2 1 71.64
09 T1T2R 3 R  1 86.47
10 T1T2R 1 T1 2 54.36
10 T1T2R 2 T2 2 66.12
10 T1T2R 3 R  2 118.94
11 RT1T2 1 R  2 92.81
11 RT1T2 2 T1 2 71.45
11 RT1T2 3 T2 2 101.76
12 T2RT1 1 T2 2 85.37
12 T2RT1 2 R  2 82.94
12 T2RT1 3 T1 2 88
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