Final Project
==============================

| **Name**  | CAN JIN |
|----------:|:-------------|
| **Email** | cjin7@dons.usfca.edu |


## Instructions##

The following packages must be installed prior to running this code:
- `ggplot2`
- `shiny`
- `grid`
- `GGally`
- `reshape`
- `plyr`
- `scales`
- `reshape2`
- `MASS`
- `randomForest`
- `gridExtra`


To run this code, please enter the following commands in R:
```
library(shiny)
shiny::runGitHub('msan622', 'Cindy597', subdir='final-project')
```

## Discussion ##

## Dataset ##
My dataset is about dress sales for 550 different types of dresses distinguished by `Dress ID`. The dataset includes
historical sales records from 2013/04/02 to 2013/12/30, and several features, for example 'style', 'price', 'size' and so on.
And there is a binary variable called 'Recommendation' to indicate whether a dress is recommended for other
customers or friends.

The following is a three-sample subset to show what my dataset looks like:

![IMAGE](sample1.png)

![IMAGE](sample2.png)


My dataset preparation:

First, I merged the `Dress Sales.csv` and `Attribute Dataset.csv` together, since one of them includes numerical 
data, another includes categorical data, and both of them are useful for my visualization.

Second, I kicked out some useless columns in my dataset.

The code used for cleaning this dataset is shown below:
```
Dress_sales<-read.csv("/Users/cindy/Desktop/Dress Sales.csv", header=T, sep=",", quote="\"", na.strings="\\N")
Dresses_Attribute<-read.csv("/Users/cindy/Desktop/Attribute DataSet.csv", header=T, sep=",", quote="\"", na.strings="\\N")
mytotal<-merge(Dress_sales,Dresses_Attribute,by="Dress_ID") 
mytotal<-mytotal[,-c(25:36)]
write.csv(mytotal,file='merged_dress_sales.csv')

```


## Overview ##

My shiny interface is developed for customer or managers to analyze sales trend of their interested dresses, explore insights about
features relationship, predict further sales trend of a specific dress, and finally get advice about whether a dress style designed by themselves will be recommended by 
other customers. The shiny interface includes five parts: `Search engine`, `Historical Sales Trend`, `Relationship Analysis`, `Prediction`, and `Recommendation`.

* The first page --- `Search engine` is just for customers or managers to find historical record for a specific dress by `Dress_ID` or its 
features, for example season, price, and so on. In addition, they can search for dresses which are satisfy their own preference.

* The second page --- `Historical Sales Trend` is for customers or managers to find out the trend of a specific dress.
In detail, there are two plots --- Heatmap and Multiple Line to show the big picture of 
sales trend for different dresses distinguished by `Dress ID`.

* The third page --- `Relationship Analysis` is for analyzing the relationship between features. This page is for managers to explore which features have
effect on the sales or price of a specific dress. Also, bar plot can address more detailed information by comparing several 
different dress types.

* The fourth page --- `Prediction`  is for predicting dress sales by time series and predict whether a dress will be recommended for other customers (by the binary 
variable 'recommend', its value is 0 or 1) by random forest. Manegers can set up their preference about time (days) to see the predicted sales trend for further 
31 days (1 month) or other time window. Also, managers or users also can see which variables are important for prediction whether a dress will be recommended or not 
based on the importance outpout of random forest model.

* The fifth page --- `Recommendation` provides advice for customers to 'DIY' their dress style by setting up very detailed preference information. A warning message or a 
congratulation message will show up to indicate whether their selected dress style is recommended by other customers based on the prediction　result of a Random Forest Model.

Overall, my shiny interface provide comprehensive functions for customers or manegers to explored detailed information about their interested dresses. What's more, 
the interface give advice for them to make better decision by modeling and prediction.


## Techniques ##

Technique One --- Heatmap

* Reason for choosing this technique: 
  The majority of my dataset is historical sales record for different types of dresses. A basic business 
question I want to figure out is what is the trend of sales for a specific dress type. Heatmap is a good idea to see the big picture of a dress types' 
sales trend by month and day.  Heatmap helped me to examine the relationship between two variables. 
For example, when I used `day` as x axis and `month` as y axis, I found out some buckets which have higher sales(Red buckets).

![IMAGE](Tech1.png)














