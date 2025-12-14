data PK_data;
ods graphics off;
    infile datalines dlm=',' dsd truncover;
    length Sub_id $10 Sequence $2 Formulation $1;

    input Sub_id $ Sequence $ 
          T_Cmax R_Cmax
          T_AUC  R_AUC;
    if Sequence='TR' then do;

        Period = 1;
        Formulation = 'T';
        Cmax = T_Cmax;
        AUC  = T_AUC;
        output;
        
        Period = 2;
        Formulation = 'R';
        Cmax = R_Cmax;
        AUC  = R_AUC;
        output;
    end;
   
    else if Sequence='RT' then do;
     
        Period = 1;
        Formulation = 'R';
        Cmax = R_Cmax;
        AUC  = R_AUC;
        output;

        Period = 2;
        Formulation = 'T';
        Cmax = T_Cmax;
        AUC  = T_AUC;
        output;
    end;
datalines;
/*type your data below this line*/
/*PROVIDED BELOW IS SAMPLE DATA FOR TESTING*/
1001, RT, 1590.014, 1466.174, 57506.381, 55577.08
1002, TR, 1829.327, 2349.051, 57962.568, 63732.551
1003, RT, 2134.751, 1987.432, 69234.567, 62345.678
1004, TR, 1750.123, 1600.456, 61234.789, 59876.543
1005, RT, 1400.567, 1500.678, 51234.123, 52345.234
1006, TR, 2000.890, 2100.345, 70234.456, 72345.567
1007, RT, 1700.234, 1650.123, 61234.345, 60234.456
1008, TR, 1800.456, 1900.789, 63234.567, 64234.678
1009, RT, 1600.345, 1550.234, 58234.456, 57234.567
;
run;

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
ods output OverallANOVA = aov_auc;
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