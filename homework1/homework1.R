# load the datasets
library(ggplot2) 
data(movies) 
data(EuStockMarkets)
#Filter out any rows that have a budget value less than or equal to 0 in the movies dataset.
movies<-subset(movies, movies$budge>0)
#Add a genre column to the movies dataset
genre <- rep(NA, nrow(movies))
count <- rowSums(movies[, 18:24])
genre[which(count > 1)] = "Mixed"
genre[which(count < 1)] = "None"
genre[which(count == 1 & movies$Action == 1)] = "Action"
genre[which(count == 1 & movies$Animation == 1)] = "Animation"
genre[which(count == 1 & movies$Comedy == 1)] = "Comedy"
genre[which(count == 1 & movies$Drama == 1)] = "Drama"
genre[which(count == 1 & movies$Documentary == 1)] = "Documentary"
genre[which(count == 1 & movies$Romance == 1)] = "Romance"
genre[which(count == 1 & movies$Short == 1)] = "Short"
movies$genre<-genre
movies$count<-count
#Transform the EuStockMarkets dataset to a time series
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Produce a scatterplot from the movies dataset in the ggplot2 package, 
#where budget is shown on the x-axis and rating is shown on the y-axis
p1<-ggplot(movies,aes(x=budget,y=rating))+
  geom_point(colour='red',size=3)+
  ggtitle("budget v/s rating")+
  xlab("budget")+
  ylab("rating")
print(p1)

#Count the number of action, adventure, etc. movies in the genre column of 
#the movies dataset. Show the results as a bar chart
p2<-ggplot(movies,aes(x=factor(genre),color=factor(genre),fill=factor(genre)))+
  geom_bar()+
  ggtitle("count of different movie types")+
  xlab("movie_type")+
  ylab("count")
print(p2)

#Use the genre column in the movies dataset to generate a small-multiples scatterplot using the facet_wrap() function such that 
#budget is shown on the x-axis and rating is shown on the y-axis
p3<-ggplot(movies)+
  geom_point(aes(x=budget,y=rating,colour=genre),size=1.5)+
  ggtitle("budget v/s rating for different movie type")+
  xlab("budget")+
  ylab("rating")+
  facet_wrap(~genre)
print(p3)

#Produce a multi-line chart from the eu dataset with time shown on the x-axis 
#and price on the y-axis

type<-as.data.frame(c(rep(colnames(eu)[1],length(eu$DAX)),rep(colnames(eu)[2],length(eu$SMI)),rep(colnames(eu)[3],length(eu$CAC)),rep(colnames(eu)[4],length(eu$FTSE))))
price<-as.data.frame(c(eu$DAX,eu$SMI,eu$CAC,eu$FTSE))
time<-as.data.frame(rep(eu$time,4))
mydata<-cbind(type,price,time)
colnames(mydata)<-c("type","price","time")

p4<- ggplot(mydata)+
  geom_line(aes(x=time,y=price, group=factor(type), color=factor(type)))+
  ggtitle("price for different stock")+
  xlab("time")+
  ylab("price")
print(p4)


