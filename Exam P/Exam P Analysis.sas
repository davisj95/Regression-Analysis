/* Exam P */
*Binary - Two level factor;
*Logistic Regression log P(y=1)/P(y=0) = b0 + b1x1;

data examp;
	infile datalines dlm=",";
	input Student ExamP $ GPA;
	datalines;
2,No Pass,3.42
3,No Pass,3.93
4,No Pass,3.41
5,No Pass,3.75
6,Passed,3.18
7,No Pass,2.76
8,No Pass,3.68
9,No Pass,3.11
10,Passed,3.77
11,No Pass,3.06
12,No Pass,3.89
13,No Pass,3.28
14,Passed,3.82
15,No Pass,2.8
16,No Pass,3.45
17,No Pass,3.75
18,No Pass,3.7
19,No Pass,2.61
20,No Pass,3.17
21,Passed,3.93
22,No Pass,2.94
23,No Pass,2.49
24,No Pass,3.77
25,No Pass,2.7
26,Passed,3.4
27,No Pass,3.87
28,No Pass,2.55
29,Passed,3.81
30,No Pass,1.92
31,No Pass,2.79
32,No Pass,3.42
33,Passed,3.91
34,No Pass,3.94
35,Passed,3.6
36,Passed,3.89
37,No Pass,3.66
38,No Pass,3.02
39,Passed,3.87
40,No Pass,3.92
41,No Pass,3.27
42,Passed,3.32
43,Passed,3.52
44,No Pass,3.75
45,No Pass,3.87
46,No Pass,2.67
run;

data examp;
	set examp;
	if GPA<3.5 then GPA35="Below 3.5";
	else GPA35="Above 3.5";
run;

proc freq data=examp;
	table GPA35*ExamP;
run;

/* Boxplot */
proc sort data=examp;
	by ExamP;
run;

proc boxplot data=examp;
	plot GPA*ExamP;
run;

/* Analysis */
/* Model: log(P(Pass|GPA)/P(No Pass | GPA)) = beta0 + beta1 GPA 
   Convert response variable to Y=0 or 1
*/

data examp;
	set examp;
	if ExamP="Passed" then Passed=1;
	else Passed=0;
run;

proc logistic data=examp descending plots(only)=(roc(id=obs) effect);
	model Passed=GPA / cl /*Confidence Interval= cl*/;
run;

proc genmod data=examp;
	model Passed = GPA / dist=binomial wald;
run;
/* 
b1hat=2.256 means that for a 1 pt increase in GPA, the logodds increase 2.256
exp(2.256) gives percent change in your odds=9.542 -> for a 1 pt increase in GPA,
we estimate a 10 times increase in the odds of passing exam P
*/

/* Predict prob of passing with 3.25 GPA and 3.85 */
data newobs;
	input Student ExamP $ GPA;
	datalines;
	47 . 3.25
	48 . 3.85
run;
data examp1;
	set examp newobs;
run;

proc logistic data=examp1 descending plots(only)=(roc(id=obs) effect);
	model Passed=GPA / cl;
	output out=pred p=phat;
run;

proc print data=pred (firstobs=46);
run;
