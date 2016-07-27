/* We have no training data. We need to gues the label!!! */

%let path=	/gpfs/user_home/sergiu/test; 
libname TEST "&path";
PROC IMPORT DATAFILE="/gpfs/user_home/sergiu/test/sample.csv"
		    OUT=TEST.kaggle
		    DBMS=CSV
		    REPLACE;
RUN;

PROC PRINT DATA=TEST.kaggle; RUN;

/**performing sort on sample dataset**/
title "Original Kaggle sample data";
proc univariate data=TEST.kaggle;
 var label;
run;
/**working on bootstraping**/
title "Bootstraping dataset";
proc univariate data=TEST.bootsamp;
 var label;
run;

proc means data=TEST.kaggle;
var label;
run;

/* Bootstrap distribution of the sample mean.  data from kaggle 
and is provided only the sample data and 
need to boostrap the data to be able to generate dataset
*/
%let DSName = TEST.kaggle;
%let VarName = label;
%let alpha = 0.05;  /* significance; (1-alpha)100% conf limits */

proc iml;
use &DSName;
read all var {&VarName} into x;
close &DSName;

/* Resample B times from the data (with replacement) 
   to form B bootstrap samples. */
B = 100;                          /* number of bootstrap samples */
call randseed(12345);
xBoot = Sample(x, B||nrow(x));     /* each column is a resample */

/* Compute the statistic on each bootstrap resample */   
s = T( mean(xBoot) );              /* mean of each resample     */
title "Bootstrap distribution of the mean";
if num(symget("SYSVER"))>=9.4 then do;
   call Histogram(s) density="Kernel"; /* graph bootstrap distrib  */
end; 

Mean = mean(x);                    /* sample mean of original data  */
/* Analyze the bootstrap distribution */
MeanBoot = s[:];                   /* a. mean of bootstrap dist     */
StdErrBoot = std(s);               /* b. estimate of std error      */
prob = &alpha/2 || 1-&alpha/2;     /* lower/upper percentiles       */
call qntl(CIBoot, s, prob);        /* c. quantiles of bootstrap dist*/
pct = putn(1-&alpha, "PERCENT5.");

print Mean MeanBoot StdErrBoot 
      (CIBoot`)[c=("Lower "+pct+" CL" || "Upper "+pct+" CL")];
quit;
title;

/* By the Central Limit Theorem, the sampling distribution of
   the mean is approximately normally distributed. 
   If desired, compare the bootstrap estimates with 
   estimates of the SEM and CLM that assume normality. */
