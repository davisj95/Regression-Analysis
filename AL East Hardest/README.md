# Is the American League East the Hardest?
Suppose you are asked by a long-time Orioles fan to investigate a possible conspiracy. The American
League East is considered the most competitive in MLB and a small market team like the Orioles often
feel they have a ‘harder’ path to the playoffs because they regularly play against better teams. To
investigate this ‘grass is always greener’ cliché, we will investigate if there is a statistically significant
difference between AL Divisions.

## Getting Started
We decided to pull data from the 2018 baseball season from ESPN using the following link:
http://espn.go.com/mlb/standings/_/season/2018. For simplicities sake, we copied the data from the
site rather than writing a web scraper. We also decided to focus on just the division and the run
differential, that way we could make a simple model.

### Prerequisites
- A system running R or SAS (analysis will be done in both)
- General knowledge of regression models and the PROC REG statement in SAS

## EDA
First, we want to have a table of summary statistics for wins and run.diff by division and create a
plot of run differential and wins with different colors for each division. In SAS, we just type the
following:
``` 
proc glm data=mlb; /* Statement to make a model */
   class division; /* This turns division into a factor variable */
   model wins = rundiff division / solution;
run;
```
Here is the same process in R
```
# Summary statistics by division
by(baseball$wins, baseball$division, mean)
by(baseball$run.diff, baseball$division, mean)
by(baseball$wins, baseball$division, sd)
by(baseball$run.diff, baseball$division, sd)

#scatterplot
plot(wins~run.diff, data=baseball, type="n")
points(wins~run.diff, data=subset(baseball, division=="East"),pch=19,col="orange")
points(wins~run.diff, data=subset(baseball, division=="Central"),pch=19,col="black")
points(wins~run.diff, data=subset(baseball, division=="West"),pch=19,col="red")
```

The following statistics and graph are produced:



We can see in the summary statistics that the mean wins by division doesn’t particularly stand out and that in the graph there is a general trend to the data where East and West are extremely similar, and Central is slightly below the two.
Through this quick process of finding summary statistics and plotting the points, we can’t see much proof to back up the statement that the AL East is the hardest, but there is more to do

## Expanded EDA
We start by fitting our model. Our model is as follows:

   Time = β<sub>0</sub> + β<sub>1</sub>*run.diff + β<sub>2</sub>*division + ε, ε ∼ N (0, σ<sup>2</sup>)

In SAS, the previous code block suffices. In R, it would be:
```
out1.baseball <- lm(wins~division+run.diff, data=baseball, x=TRUE, y=TRUE)
# Having x & y = true gives us the x and y matrices for the model
```

These are the reported parameter estimates and standard error from the model.

One observation to make is that the p-value for run differential is less than 0.0001, whereas the p-values for central and west aren’t significant. Another observation to make is even though there are three divisions we used in the model, division east is set to be the base, so the parameter estimate for division east is the parameter estimate for the intercept, and the estimates for divisions central and west are the differences from division east. To eliminate some of the ambiguity of the parameter estimates of each particular division, we can have a table like the following:
This lack of division east is also evident in the X matrix used to calculate these estimates
Because of this, it makes interpreting the data complicated.

## Model Reduction
A simple way to test whether division is necessary in prediction, we can create two models:
• a full model where we predict wins based on division and run differential
• a reduced model where we predict wins based solely on run differential

and we can run an ANOVA test to see if division is significant.

Since division has three levels, there are actually three models to estimate the different performances of each division:

* If division is “East”, the model is:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;𝑦 = 𝛽<sub>0</sub> + 𝛽<sub>1</sub> * (Central=0) + 𝛽<sub>2</sub> * (West=0) + 𝛽<sub>3</sub> * (run.diff) 
 
* If division is “West”, the model is:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;𝑦 = 𝛽<sub>0</sub> + 𝛽<sub>1</sub> * (Central=0) + 𝛽<sub>2</sub> * (West=1) + 𝛽<sub>3</sub> * (run.diff)
  
* If division is “Central”, the model is:&nbsp; 𝑦 = 𝛽<sub>0</sub> + 𝛽<sub>1</sub> * (Central=1) + 𝛽<sub>2</sub> * (West=0) + 𝛽<sub>3</sub> * (run.diff)
  
The reason for this is with the elimination of the division variable, we need to account only for the y-intercept (which uses the East division as a base) and the difference in run differential from the y-intercept. Thus the 𝛽𝛽̂I are represented as such:
𝛽𝛽̂0 =
y-intercept for East division
𝛽𝛽̂1 =
difference between Central and East for run differential
𝛽𝛽̂2 =
difference between West and East for run differential
𝛽𝛽̂3 =
partial slope of run differential
To show the performance of these reduced models and compare them, we plotted them onto one chart. I decided to do this in R, and ran the following block of code:

```
#AL East
plot(wins~run.diff, data=baseball, type="n")
points(wins~run.diff, data=subset(baseball, division=="East"),pch=19,col="blue")
abline(81.096918, 0.082029, col="blue")
#AL Central
points(wins~run.diff, data=subset(baseball, division=="Central"),pch=19,col="black")
abline(81.096918-0.168041, 0.082029, col="black")
#AL West
points(wins~run.diff, data=subset(baseball, division=="West"),pch=19,col="red")
abline(81.096918+0.138265, 0.082029, col="red")
```
And this graph was produced:



The blue points and line represent the East division, black represents the Central division, and red represents the West. As you can see, the regression lines are basically one on top of the other,
meaning that visually there is no difference in the way the models perform. No matter which division you are in, you could estimate a team’s performance based on any of the models and they will be extremely similar results
Even when the results are zoomed in as such, a difference is barely noticeable.



Finally, to test the significance using ANOVA, we can run this block of code in R:
```
#H0: no difference in mean wins between divisions
#Test H0: no division effect
reduced.baseball2 <- lm(wins~run.diff, data=baseball)
anova(reduced.baseball2, out2.baseball)
```
and we get



Since p>0.05, we can reject this Oriole fan’s hypothesis and conclude that division doesn’t have a significant effect of whether the team will win or not.

## Final Notes
While much of the chunks of code were performed in R, the above code for making the model in SAS gives us so much of this information for free. One of the tables that SAS gives for free is the Type III SS:



which shows us anyway that run differential is extremely significant, while division is not. The value 0.6172 for the division p-value matches the p-value in the above table ran in R.
