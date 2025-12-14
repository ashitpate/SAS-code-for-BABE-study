data PK_data;
ods graphics off;
    input Sub_id Period Seq $ Formulation $ Group Cmax AUC0_t;
    datalines;

;
run;

data PK_data;
    set PK_data;
    lnCmax = log(Cmax);
    lnAUC0_t = log(AUC0_t);
run;

proc glm data=PK_data;
    class Sub_id Seq Period Formulation Group;
    model lnCmax =
          Seq
          Group
          Seq*Group
          Sub_id(Seq*Group)
          Period
          Formulation;
    lsmeans Formulation / pdiff=control('R') cl alpha=0.10;
run;
quit;

proc glm data=PK_data;
    class Sub_id Seq Period Formulation Group;
    model lnAUC0_t =
          Seq
          Group
          Seq*Group
          Sub_id(Seq*Group)
          Period
          Formulation;
    lsmeans Formulation / pdiff=control('R') cl alpha=0.10;
run;
quit;

