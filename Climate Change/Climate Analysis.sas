LIBNAME S381 'C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381';

Data Climate;
	set S381.climate1;
run;
/* ------------------------------------------------------------------------------ */
/* EDA */

/* Compute the Correlation Coefficient of temp and co2 */
proc corr data=S381.climate1;
	var temp co2;
run;

proc gplot data=S381.climate1;
	plot temp*co2;
run;

/* Correlation coefficient of temp and methane */
proc corr data=S381.climate1;
	var temp ch4;
run;

/* Scatterplot for above correlation */
proc gplot data=S381.climate1;
	plot temp*ch4;
run;
/* ------------------------------------------------------------------------------ */

/* Analysis */

proc reg data=S381.climate1;
	model temp = co2 ch4 / clb r;
run;

/* Part 2: EDA*/
/* Compute the Correlation Coefficient of temp and all other variables */
proc corr data=S381.climate1;
	var temp co2 ch4 n2o hcfc sf6;
run;

/* Part 2: Analysis */
/* Fit Model */
proc reg data=S381.climate1;
	model temp = co2 ch4 n2o hcfc sf6/ clb r;
run; 

/* Colinearity Issues */
proc gplot data=S381.climate1;
	plot sf6*n2o;
run;

proc reg data=S381.climate1;
	model temp = co2/ clb r vif;
run; 
