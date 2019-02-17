/*Data*/
data peas;
	input parent offspring;
	datalines;
	0.21 0.1726
	0.20 0.1707
	0.19 0.1637
	0.18 0.1640
	0.17 0.1613
	0.16 0.1617
	0.15 0.1598
run;

/*EDA*/
proc corr data=peas;
	var parent offspring;
run;
/*Very strong positive correlation that diameter is a trait inherited from parents*/
/*Plot: To designate we hypothesize as a causal relationship, parent is on the horizontal axis and offspring is on the vertical axis*/

proc gplot data=peas;
	plot offspring*parent / haxis="Diameter of Parent Pea"
							vaxis="Diameter of Offspring Pea";
run;

/* Analysis */
/* Model: offspring = beta0 + beta1*parent + epsilon, epsilon~N(0,sigma2) */
proc reg data=peas;
	model offspring = parent / clb r;
run;

/*
95% CI for E(offspring|parent=0.2)
95% PI for parent=0.18
*/

/* Trick SAS into producing predictions by adding rows to the dataset */
data newobs;
	input parent offspring;
	datalines;
	0.20 .
	0.18 .
run;
data peas1;
	set peas newobs;
run;
proc reg data=peas1;
	model offspring = parent / clm cli;
run;










