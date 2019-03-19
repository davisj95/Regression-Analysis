# Climate Change Analysis
### Introduction:
Climate scientists have long predicted that increasing levels of atmospheric carbon dioxide and other greenhouse gases would increase average global temperature because of the greenhouse effect. We wanted to find out what the correlation is between these greenhouse gases and the temperature.

Data of the global temperature was gathered from the Goddard Institute of Space Studies, a division of NASA, and data of co<sub>2</sub>, n<sub>2</sub>o, hcfc and sf<sub>6</sub> levels was collected from the Mauna Loa Observatory in Hawaii. This location was chosen because its high altitude is relatively unaffected by local climate and provides a more accurate reading of the different levels of greenhouse gases.

### EDA:
We first wanted to see what the correlation is between temperature and co<sub>2</sub>, and then with methane, which we computed to be 0.84146. Upon graphing the data, you can see that there is a general trend of where temperature increases as co<sub>2</sub> levels increase, but it isn’t a clear and perfectly straight line either, which confirms a correlation around what we computed (see Fig 1.1). With ch<sub>4</sub>, the correlation is slightly weaker, at 0.77523, and that can also be seen in the graph below (see Fig 1.2)



Analysis:
Our response variable is the temperature, with explanatory variables co2 and ch4. The corresponding model, parameter estimates, and standard error are as follows:
 
temp = β<sub>0</sub> + β<sub>2</sub>co<sub>2</sub> + β<sub>2</sub>ch<sub>4</sub> + ε, ε ∼ N (0, σ<sup>2</sup>) 







For this model, β<sub>1</sub> means that for a one ppm increase of co<sub>2</sub>, temperature will increase 0.747 degrees. Similarly, β<sub>2</sub> means that for a one ppb increase of ch4, temperature will increase 0.09661

Furthermore, both gases are statistically significant, with both p-values comfortably under 0.01. The table below shows those p-values, along with the confidence intervals for the estimates of β1 and β2.
Because these confidence intervals do not include 1 in the range, it reinforces the p-values showing that these gasses are statistically significant.









Additional Research:
While we saw that co<sub>2</sub> and ch<sub>4</sub> were statistically significant in predicting temperature, we wanted to test the other greenhouse gases of n<sub>2</sub>o, hcfc and sf<sub>6</sub>. We began again by calculating correlations between temperature and all the explanatory variables (see Fig 1.3).

Reading the cells across the top of the chart give us the correlations between temperature and co<sub>2</sub>, ch<sub>4</sub>, n<sub>2</sub>o, hcfc, and sf<sub>6</sub>, but a red flag is raised when looking at the correlations between the explanatory variables themselves. It shows that there could be some collinearity issues. 

That being said, we still fit the following model:

temp = β<sub>0</sub> + β<sub>1</sub>co<sub>2</sub> + β<sub>2</sub>ch<sub>4</sub> + β<sub>3</sub>n<sub>2</sub>o + β<sub>4</sub>hcfc + β<sub>5</sub>sf<sub>6</sub> + ε, ε ∼ N (0, σ<sup>2</sup>) 

and got the following parameter estimates and standard errors (See Fig 1.4)

		Fig 1.3


This is very different from what we computed earlier. co<sub>2</sub>, which was a variable that was once extremely influential now seems to show that a decrease in co2levels leads to an increase in temperature, which doesn’t make sense. One strong correlation that we wanted to plot that could interfere with our results is between sf<sub>6</sub> and n<sub>2</sub>o, which can be seen below in Fig 1.5




This correlation coefficient is 0.99882, which is an extremely strong correlation, and can lead to inflated influences of the variables and affect our model.

We calculated the Variance Inflation Factors and saw that ALL the variables had collinearity issues, in particular, the VIF of sf<sub>6</sub> and n<sub>2</sub>o were both over 400. If a score is over 5, it’s already worth considering taking out of the model. Even after going back to our original model, co<sub>2</sub> and ch<sub>4</sub> have VIF scores of 7. I decided to take out all of the greenhouse gases except for co2. I did that because we have more data with co2 than with any other greenhouse gas and wouldn’t have collinearity issues with other gases. Doing that shows that the β<sub>1</sub> estimate is 0.98, so for a 1 ppm increase in co<sub>2</sub> levels means a 0.98336 degree increase in temperature.

While several of the greenhouse gases proved to be statistically significant, we couldn’t use all of them because of collinearity issues, but co<sub>2</sub> does prove to be statistically significant and a great predictor of temperature.
