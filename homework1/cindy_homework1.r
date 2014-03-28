__author__='Can(Cindy) Jin'

# Optional: please fill in your working directory to keep the generated plots 
setwd("/Users/cindy/Desktop")

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

#Transform the EuStockMarkets dataset to a time series
eu <- transform(data.frame(EuStockMarkets), time = time(EuStockMarkets))

#Plot1:
#Produce a scatterplot from the movies dataset in the ggplot2 package, 
#where budget is shown on the x-axis and rating is shown on the y-axis
movies$budget<-movies$budget/1000000
p1<-ggplot(movies,aes(x=budget,y=rating))+
  geom_point(aes(colour=factor(genre)),size=2.5)+
  labs(colour='Genre')+
  ggtitle("Movie Rating versus Budget")+
  xlab("Budget (Million)")+
  ylab("Rating")+
  theme(text = element_text(size = 15, colour = "blue"))
print(p1)
ggsave("hw1-scatter.png",p1,width=10,height=6, dpi=500)



#Plot2
#Count the number of action, adventure, etc. movies in the genre column of 
#the movies dataset. Show the results as a bar chart
#created a new movie dataset based on decreasing 'genre' levels, in order to plot decreasing bar chat
my_movies<- within(movies, genre <- factor(genre, levels=names(sort(table(genre), decreasing=TRUE))))
p2<-ggplot(my_movies,aes(x=genre))+
  geom_bar(binwidth=1,fill="#56B4E9")+
  ggtitle("Count of Movies by Genre")+
  xlab("Movie Genre")+
  ylab("Count")+
  theme(text = element_text(size = 16, colour = "black"),axis.text = element_text(colour = "red"))
print(p2)
ggsave("hw1-bar.png",p2,width=10,height=6, dpi=500)



#Plot3
#Use the genre column in the movies dataset to generate a small-multiples scatterplot using the facet_wrap() function such that 
#budget is shown on the x-axis and rating is shown on the y-axis
p3<-ggplot(movies)+
  geom_point(aes(x=budget,y=rating,colour=genre),size=2.0)+
  ggtitle("Budget versus Rating by Genre")+
  xlab("Budget (Million)")+
  ylab("Rating")+
  facet_wrap(~genre,nrow=3)+
  theme(text = element_text(size = 15, colour = "black"),axis.text = element_text(colour = "red"),legend.text=element_text(size=9))
print(p3)
ggsave("hw1-multiples.png",p3,width=10,height=6, dpi=500)



#Plot4
#Produce a multi-line chart from the eu dataset with time shown on the x-axis 
#and price on the y-axis
index<-as.data.frame(c(rep(colnames(eu)[1],length(eu$DAX)),rep(colnames(eu)[2],length(eu$SMI)),rep(colnames(eu)[3],length(eu$CAC)),rep(colnames(eu)[4],length(eu$FTSE))))
price<-as.data.frame(c(eu$DAX,eu$SMI,eu$CAC,eu$FTSE))
time<-as.data.frame(rep(eu$time,4))
mydata<-cbind(index,price,time)
colnames(mydata)<-c("index","price","time")

p4<- ggplot(mydata)+
  geom_line(aes(x=time,y=price, group=factor(index), color=factor(index)),size=0.8)+
  ggtitle("Stock Price Trend for 4 Different Indexes ")+
  labs(colour='Index')+
  xlab("Time")+
  ylab("Price")+
  theme(text = element_text(size = 15, colour = "blue"), legend.text=element_text(size=17,colour="red"))
print(p4)
ggsave("hw1-multiline.png",p4,width=10,height=6, dpi=500)


