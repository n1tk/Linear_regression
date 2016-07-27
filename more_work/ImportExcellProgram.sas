/** Import an XLSX file.  **/
%let path=	/gpfs/user_home/sergiu/DATAREG; 
libname HW2REG "&path";
PROC IMPORT DATAFILE="/gpfs/user_home/sergiu/DATAREG/Table B19.xlsx"
		    OUT=HW2REG.B19
		    DBMS=XLSX
		    REPLACE;
RUN;

proc arima data = 
/** Print the results. **/

PROC PRINT DATA=HW2REG.B19; RUN;


/** Get VIFs and colinearity diagnosis **/

ods rtf;
proc reg data=HW2REG.B19;
      model y= x2 x3 x4 x5 x6 x7 x8 x9 x10 /vif collin;
run;
ods rtf close; 

/** Since intercept is also involve I run to find out what the mean was for each variable **/

proc means data = HW2REG.B19;
var x2 x3 x4 x5 x6 x7 x8 x9 x10;
run;

/** multicolinearity diagnosis for our dataset corrb prints the variance-covariance matrix of the estimated coeficients in correlation form**/

ods rtf;
proc reg data=HW2REG.B19;
      model y= x2 x3 x4 x5 x6 x7 x8 x9 x10 /corrb vif collin;
run;
ods rtf close;

/** with removed x5 because has highest VIF **/
ods rtf;
proc reg data=HW2REG.B19;
      model y= x2 x3 x4 x6 x7 x8 x9 x10 /corrb vif collin;
run;
ods rtf close;

/**centering the  predictors using means **/

data HW2REG.B19;
set HW2REG.B19;
x2c = x2 -3.8165;
x3c = x3 - 95.1250;
x4c = x4 - 7.2922;
x5c = x5 - 4.3422;
x6c = x6 - 1.7703;
x7c = x7 - 2.5719;
x8c = x8 - 0.3706;
x9c = x9 - 14.4687;
x10c = x10 - 0.0517;
run;

proc print data=HW2REG.B19;
run;
/** run the model with centered variables **/

odf rtf;
proc reg data= HW2REG.B19;
model y = x2c x3c x4c x5c x6c x7c x8c x9c x10c /corrb vif collin;
run;
odf rtf close;

ods rtf;
proc corr data=HW2REG.B19;
      var x2 x3 x4 x6 x7 x8 x9 x10;
run;
ods rtf close;



PROC IMPORT DATAFILE="/gpfs/user_home/sergiu/DATAREG/data-prob-4-18.XLS"
		    OUT=HW2REG.B4_18
		    DBMS=xls
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=HW2REG.B4_18; RUN;

PROC IMPORT DATAFILE="/gpfs/user_home/sergiu/DATAREG/data-table-B10.XLS"
		    OUT=HW2REG.B10
		    DBMS=xls
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=HW2REG.B10; RUN;


PROC IMPORT DATAFILE="/gpfs/user_home/sergiu/DATAREG/data-table-B11.XLS"
		    OUT=HW2REG.B11
		    DBMS=xls
		    REPLACE;
RUN;

/** Print the results. **/

PROC PRINT DATA=HW2REG.B11; RUN;

