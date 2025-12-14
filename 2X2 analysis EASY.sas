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
1001, RT, 1590.014, 1466.174, 57506.381, 55577.08
1002, TR, 1829.327, 2349.051, 57962.568, 63732.551
1003, TR, 1544.022, 1800.901, 54213.355, 63617.47
1004, RT, 2184.476, 2098.764, 60517.372, 55456.898
1005, RT, 2285.12, 2131.781, 73506.739, 75534.709
1006, TR, 1963.133, 2359.691, 68302.998, 70615.507
1007, TR, 2898.858, 3592.713, 103644.795, 116583.326
1008, RT, 2639.479, 3374.857, 82273.43, 83682.975
1009, RT, 2023.088, 1741.052, 72343.043, 63254.84
1010, TR, 2957.318, 2849.392, 76395.879, 73329.919
1011, TR, 1683.358, 2900.991, 55752.848, 66660.092
1012, RT, 2152.239, 2857.388, 75701.472, 73010.202
1013, TR, 1858.09, 2585.516, 59201.084, 64298.052
1014, RT, 2871.607, 3064.478, 107763.733, 107361.143
1015, TR, 1501.142, 2663.775, 67618.906, 85469.551
1016, RT, 2047.586, 2655.084, 74830.55, 71274.697
1017, TR, 1959.963, 2268.167, 54956.271, 62214.334
1018, RT, 1873.78, 2160.116, 59959.525, 54922.14
1019, TR, 1766.004, 2203.851, 59556.279, 66183.846
1020, RT, 1989.955, 2709.608, 90356.252, 83728.141
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