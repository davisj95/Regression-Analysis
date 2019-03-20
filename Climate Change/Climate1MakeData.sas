/* Climate Data (Permanent SAS dataset*/

/*Library for permanent SAS dataset*/

libname S381 "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381";

/* Global Temperature Data */
data temp1;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\GLB.Ts+dSST.txt" firstobs=9;
	input x1-x20;
	/* Note: The Lines between decades and the rows at the end need to be deleted */
	if x1^=.;
run;

/* Change data from monthly different rows to row for each month */
data temp2;
	set temp1;

	year=x1;
	temp=x2; month=1; output;
	temp=x3; month=2; output;
	temp=x4; month=3; output;
	temp=x5; month=4; output;
	temp=x6; month=5; output;
	temp=x7; month=6; output;
	temp=x8; month=7; output;
	temp=x9; month=8; output;
	temp=x10; month=9; output;
	temp=x11; month=10; output;
	temp=x12; month=11; output;
	temp=x13; month=12; output;

	keep year month temp;
run;

/* Remove missing values for global temperature */
data temp2;
	set temp2;
	if temp^=.;
run;

data co2;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\co2_mlo_surface-flask_1_ccgg_month.txt" firstobs=71;
	input site year month co2;
	drop site;
run;

data ch4;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\ch4_mlo_surface-flask_1_ccgg_month.txt" firstobs=71;
	input site year month ch4;
	drop site;
run;

data n2o;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\N2O.dat" firstobs=51;
	input year month n2o x y;
	drop x y;
run;

data hcfc;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\HCFC.dat" firstobs=51;
	input year month hcfc x y;
	drop x y;
run;

data sf6;
	infile "C:\Users\jacob\OneDrive\Documents\2. School\1. Winter 2019\STAT 381\SF6.dat" firstobs=51;
	input year month sf6 x y;
	drop x y;
run;

/* Merge into a single permanent SAS dataset */ 
data S381.climate1;
	merge temp2 co2 ch4 n2o hcfc sf6;
	by year month;
run;
