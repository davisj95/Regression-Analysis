# Exam P Predicting
While the job ‘Actuary’ is frequently a top-rated job, it is incredibly difficult to pass the exams to become an Associate and Fellow. One of the entry-level exams is Exam P (on probability). It is a grueling three-hour multiple-choice exam meant to assess the student’s knowledge of the fundamental probability tools for quantitatively assessing risk. Our goal is to estimate the effect of GPA and test if the effect is statistically significant.

### About Our Data
Ours is a small set of self-reported passing/non-passing Exam P scores with university GPA. This data set can be found at http://grimshawville.byu.edu/ExamP.csv
### Prerequisites
 - A system running R or SAS (analysis will be done in both)
 - General knowledge of simple logistic regression models and the PROC REG statement in SAS
## EDA
We first want to create a table of the proportion of students who passed Exam P with GPA’s above and below 3.5. We then want to create side-by-side boxplots to show the distribution. In R we run the following code:
```
table(exam$GPA>=3.5, exam$ExamP)			      #Table of num of people who passed/failed
prop.table(table(exam$GPA>=3.5, exam$ExamP),margin=1)   #Prop. of people of passed/failed
boxplot(GPA~ExamP, data=exam)			      #Boxplot
```

Here is the same process in SAS
```
data examp;
     set examp;
     if GPA<3.5 then GPA35=“Below 3.5”;
     else GPA35=“Above 3.5”;
run;

proc freq data=examp;
     table GPA35*ExamP;
run;

proc sort data=examp;		/* Sort to make boxplot */
     by ExamP;
run;

proc boxplot data=examp
     plot GPA*ExamP;
run;
```
SAS produces the following table and boxplot:

![1](https://user-images.githubusercontent.com/45023513/54643963-cc35c280-4a5d-11e9-8f0f-004778d7a7c6.JPG)

![2](https://user-images.githubusercontent.com/45023513/54643962-cc35c280-4a5d-11e9-828b-71627d83e084.JPG)

Looking at the boxplots shows us that both boxplots have roughly the same max GPA, but the distribution of Passed is much smaller, where there was a wide range of student GPAs in the No Pass category.

## Analysis
We start by building our model. Our model is as follows:

ln⁡((P [Pass Exam P│GPA=gpa])/(P[Not Pass Exam P│GPA=gpa] )) = β<sub>0</sub> + β<sub>1</sub>*GPA

In R, this would look like:
```
out.exam <- glm(pass~GPA, data=exam, family=”binomial”) 
```
In SAS, there are two ways of doing this:
```
proc logistic data=examp descending plots(only)=(roc(id=obs) effect); /* Gives more info */
	model Passed=GPA / cl /*Confidence Interval= cl*/;
run;

proc genmod data=examp;						   /* Syntactically easier */
	model Passed = GPA / dist=binomial wald;
run;
```
 These are the reported parameter estimates and standard error from the model.

![3](https://user-images.githubusercontent.com/45023513/54643961-cc35c280-4a5d-11e9-8787-10e46df67259.JPG)

Looking at GPA, this tells us that β<sub>1</sub> = 2.2557, which means that for a one-point increase in GPA, the log odds increase 2.256. e2.2556 gives the percent change in your odds. In this case, e2.2556 =9.542, so for a one-point increase in GPA, we estimate that your odds increase 9.542x in passing Exam P.
## Is There a Statistically Significant GPA Effect?
To answer that, we decided to create a reduced model and run an ANOVA test to check for significance. This would get the Likelihood Ratio and provide a χ<sup>2</sup> test statistic and p-value. In R, this looked like the following :
```
reduced.exam <- glm(pass~+1, data=exam, family="binomial")
anova(reduced.exam, out.exam, test="Chisq")
```
In SAS, in the previous proc logistic statement, that is already done for us.

![4](https://user-images.githubusercontent.com/45023513/54643960-cc35c280-4a5d-11e9-910c-0ee75730008d.JPG)

For the Likelihood Ratio, we are provided with a p-value of 0.01055 making GPA statistically significant in predicting whether someone will pass or fail Exam P.
## Prediction Capabilities
 To test the strength of our model, we want to predict the probability of passing Exam P for a student with a 3.25 GPA and one with a 3.85 GPA. In R, it looks like this:
```
predict(out.exam, newdata = data.frame(GPA=c(3.25,3.85)), type = "response")
# This gives us probabilities of passing as 0.1691742 and 0.4407615
```
SAS is a little different. We basically have to treat the two observations like an addition to the data and rerun the proc logistic statement to let SAS fill in the blank.
```
data newobs;				/* Create new datatable */
	input Student ExamP $ GPA;
	datalines;
	47 . 3.25
	48 . 3.85
run;

data examp1;				/* Combine examp and newobs tables */
	set examp newobs;
run;

proc logistic data=examp1 descending plots(only)=(roc(id=obs) effect);  /* Run model */
	model Passed=GPA / cl;
	output out=pred p=phat;  /* Shows probability predictions */
run;

proc print data=pred (firstobs=46);
run;
```
Below is the output window for the last proc print statement:

![5](https://user-images.githubusercontent.com/45023513/54643959-cc35c280-4a5d-11e9-8703-0004e4c24d5a.JPG)

The phat numbers represent the probability that the student will pass Exam P based on their GPA. With a cutoff at 0.5, that would show that we predict both a 3.25 and 3.85 GPA will fail their test. Here is a graphic demonstrating the probability of passing based on GPA:

![6](https://user-images.githubusercontent.com/45023513/54643958-cc35c280-4a5d-11e9-83a2-c17148a9917f.JPG)

Keeping the cutoff at 0.5 may be a bit excessive because the model predicts that only if you have roughly a 3.95 GPA or better means you will pass the exam.
## Prediction Performance
To show how well our model performed, we need to create a ROC curve and compute the AUC.
In R, we use this code:
```
# ROC Curve
library(ROCR)
ROCRpred <- prediction(predict(out.exam, type='response'), exam$pass)
ROCRperf <- performance(ROCRpred, measure='tpr',x.measure='fpr')
plot(ROCRperf)
abline(0,1)

# AUC
performance(ROCRpred, measure="auc")
```
and SAS already provides this info in the proc logistic statement when we include the code
```
descending plots(only)=(roc(id=obs) effect);
```
and we get the following ROC Curve

![7](https://user-images.githubusercontent.com/45023513/54643957-cb9d2c00-4a5d-11e9-996e-886d1a5301a7.JPG)

What this shows is a plot of the true positive rate against the false positive rate. If we had a model that predicted perfectly, the blue line would go from (0,0) straight up to (0,1) and the over to (1,1) with an AUC = 1. Our model predicted decently well, with an AUC=0.7210, but to be able to improve our score, we need either more variables or more observations.

## Final Notes
While GPA is a decent predictor of whether someone will pass Exam P, there needs to be more data to improve our model. In the future, we could take a random sample of hundreds or thousands of students rather than 46 students, and ask for other information as well, such as ACT/SAT or time of year the test was taken. A strength of the model is that it uses few (1) explanatory variables to predict, meaning we wont overfit our data, but we will need more data.
