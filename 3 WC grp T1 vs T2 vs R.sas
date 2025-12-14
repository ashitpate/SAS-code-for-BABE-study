data pkdata;
input Sub_id $ Seq $ Period Formulation $ Group Cmax;
datalines;
/*type your data below this line according to the input structure*/
;
run;

data pkdata_log;
set pkdata;
logCmax = log(Cmax);
run;

proc mixed data=pkdata_log;
class Seq Sub_id Period Group Formulation;
model logCmax = Group Seq Group*Seq Formulation Period(Group);
random Sub_id(Seq*Group);
lsmeans Formulation / pdiff=control("R") cl alpha=0.10;
estimate 'T1 / R' Formulation 1 0 -1 / cl alpha=0.10;
estimate 'T2 / R' Formulation 0 1 -1 / cl alpha=0.10;
title 'TEST';
run;
