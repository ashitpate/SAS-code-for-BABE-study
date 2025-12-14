data PK_data;
ods graphics off;
    input Sub_id Period Seq $ Formulation $ Group Cmax AUC0_t;
    datalines;
/*type your data below this line*/
/*sample data for testing*/
001 1 RT R 1 10.5 98.7
001 2 RT T 1 15.2 120.3
002 1 TR T 2 11.8 95.4
002 2 TR R 2 14.6 123.1
003 1 RT R 1 12.3 105.4
003 2 RT T 1 16.5 130.2

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

