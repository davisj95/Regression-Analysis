data cdat;
	infile"C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\4Cdata.txt";
	input Carat Color $ Clarity $ Cert $ Price;
run;

data cdat;
	set cdat;
	lCar = log(Carat);
	lPri = log(Price);
run;

proc corr data=cdat;
	var Carat Price;
	var lCar lPri;
run;
/* The Correlation between lCar and lPri = 0.97 > Carat and Price = 0.94 */

proc gplot data=cdat;
	plot Carat*Price;
	plot lCar*lPri;
run;
/* lCar&lPri plots produce a better grouped cluster of data - data is less "Curved" */
/* This makes lCar&lPri better for creating a model */

/* Analysis */
/* Model: ln(Price) = beta0 + beta1*ln(Carat)+epsilon, epsilon~N(0,sigma^2) */
proc reg data=cdat;
	model lPri = lCar / clb r;
run; 

proc reg data=cdat;
	model Price = Carat / clb r;
run;
