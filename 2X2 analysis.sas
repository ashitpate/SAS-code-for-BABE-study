
data PK_data;
 input Sub_id $ Sequence $ Formulation $ Period Cmax AUC;
    datalines;
/*type your data below this line*/
/*sample data for testing*/
001 TR T 1 15.2 120.3
001 TR R 2 10.5 98.7
002 RT R 1 14.6 123.1
002 RT T 2 11.8 95.4
003 TR T 1 16.5 130.2
003 TR R 2 12.3 105.4
;
run;
ods graphics off;

data PK_data;
    set PK_data;
    lnCmax = log(Cmax);
    lnAUC  = log(AUC);
run;

 ods output OverallANOVA= aov_Cmax;
proc glm data=PK_data;
    class Sub_id Sequence Period Formulation;
    model lnCmax =
          Sequence
          Sub_id(Sequence)
          Period
          Formulation;
    lsmeans Formulation / pdiff=control('R') cl alpha=0.10;
    title "Bioequivalence Analysis – Cmax"; 
run;
quit;

ods output OverallANOVA= aov_AUC;
proc glm data=PK_data;
    class Sub_id Sequence Period Formulation;
    model lnAUC =
          Sequence
          Sub_id(Sequence)
          Period
          Formulation;
    lsmeans Formulation / pdiff=control('R') cl alpha=0.10;
    title "Bioequivalence Analysis – AUC";
run;
quit;

data CV_Cmax;
    set aov_Cmax;
    if Source = "Error" then do;
        MSE = MS;
        CV_percent = sqrt(exp(MSE) - 1) * 100;
    end;
run;

data CV_Cmax_clean;
    set CV_Cmax;
    if not missing(MSE);  
run;

proc print data=CV_Cmax_clean noobs;
    var MSE CV_percent;
    title "INTRA-SUBJECT VARIABILITY OF Cmax";
run;

data CV_AUC;
    set aov_auc;
    if Source = "Error" then do;
        MSE = MS;
        CV_percent = sqrt(exp(MSE) - 1) * 100;
    end;
run;

data CV_AUC_clean;
    set CV_AUC;
    if not missing(MSE);  
run;

proc print data=CV_AUC_clean noobs;
    var MSE CV_percent;
    title "INTRA-SUBJECT VARIABILITY OF AUC";
run;




