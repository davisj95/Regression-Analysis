/* MLB AL East Toughest? */
/* Response Variable: Wins */
/* Explanatory Variables: Run Diff (Quantitative), Division (factor w/ levels East, Central, West)*/

/* Code -> Wins = RunDiff Division */
/* What's going on? Y matrix of Wins, X matrics of 1's, RunDiff, and 0/1 for Division */
/* Xbeta = beta0 = beta1*rundiff + beta2*0 + beta3*0 (base/comparison) */

data mlb;
	infile datalines delimiter="," dsd;
	input wins rundiff division $;
datalines;
108,229,"East"
100,182,"East"
90,70,"East"
73,-123,"East"
47,-270,"East"
91,170,"Central"
78,-37,"Central"
64,-166,"Central"
62,-192,"Central"
58,-195,"Central"
103,263,"West"
97,139,"West"
89,-34,"West"
80,-1,"West"
67,-111,"West"
run;

/* Model with parallel slopes (no interaction) */

proc glm data=mlb;
	class division;
	model wins = rundiff division / solution;
run;
/* Don't pay attention to Type 1 SS, only Type III */

/* Model with parallel slopes but more interpretable to show intercepts */
proc glm data=mlb;
	class division;
	model wins = rundiff division / solution noint;
run;

/* proc glm doesn't provide diagnostics, but we can do the equivalent in proc reg if we do the basis function expansion */

data mlb_big;
	set mlb;
	if division="East" then east=1;
		else east=0;
	if division="Central" then central=1;
		else central=0;
	if division="West" then west=1;
		else west=0;
run;

proc reg data = mlb_big;
	model wins = rundiff central west / r influence vif p;
	nodiveffect: test central=0, west=0;
run;
