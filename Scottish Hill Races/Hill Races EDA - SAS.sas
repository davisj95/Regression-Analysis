/* Scottish Hill Races (1984 records)                */
/* Tab-delimited data on the StatSci website         */

filename webhills url "http://www.statsci.org/data/general/hills.txt";

/* Atkinsons dataset */
data hillraces;
	infile webhills firstobs=2 delimiter='09'x;
	length race $15;
	input race $ distance climb time;
run;

/* EDA */
proc corr data=hillraces;
	var time distance climb;
run;

/* Scatterplots */

proc gplot data=hillraces;
	plot time*distance;
run;

proc gplot data=hillraces;
	plot time*climb;
run;

/* Analysis */
proc reg data=hillraces;
	model time = distance climb / r influence vif;
run;

* Histogram of Residuals in R because it's easier;

proc univariate data=hillraces;
	histogram time;
run;

proc print data=hillraces; 
run;
*Kildcon Hill is obs #21, which isn't flagged by Stu Res or Cook's D;
*Knock Hill is obs #18, which is flagged by both Stu Res and Cook's D;
*Ben Nevis is obs #31, which isn't flagged by Stu Res or Cook's D;
*Moffat Chase is obs #35, which isn't flagged by Stu Res or Cook's (0.052) Influential: Good/Bad:;
*Lairig Ghru is obs #11, which is NOT flagged by Stu Res but IS by Cook's D Influential: Good/Bad:;

data subhill;
	set hillraces;
	Label = race;
	if race not in ("KildconHill", "KnockHill", "BenNevis", "MoffatChase", "LairigGhru") then Label=" ";
run;

proc sgplot data=subhill;
	scatter x=time y=time / datalabel=Label;
run;
