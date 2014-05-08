loadData <- function(){
  data<-read.csv("merged_dress_sales.csv")
  colnames(data)<-c("Dress_ID","08/02","08/04","08/06","08/08","08/10","08/12","08/14","08/16",
                    "08/18","08/20","08/22","08/24","08/26","08/28","08/30","09/02","09/04",
                    "09/06","09/08","09/10","09/12","09/14","09/16","09/18","09/20","09/22",
                    "09/24","09/26","09/28","09/30","10/02","10/04","10/06","10/08","10/10","10/12","10/14",
                    "10/16","10/18","10/20","10/22","10/24","10/26","10/28","10/30","Style","Price",
                    "Rating","Size","Season","NeckLine","SleeveLength","waiseline","Material","FabricType",
                    "Decoration","Pattern.Type","Recommendation")
  return(data)
}


mydata<-loadData()
mydata<-na.omit(mydata)
ID<-as.data.frame(mydata[,1])
colnames(ID)<-"Dress_ID"
subdata<-cbind(ID,mydata[,47:ncol(mydata)])


subdata$Season<-as.character(mydata$Season)
subdata$Season[subdata$Season=="spring" | subdata$Season=="Spring"]<-"Spring"
subdata$Season[subdata$Season=="summer" | subdata$Season=="Summer"]<-"Summer"
subdata$Season[subdata$Season=="winter" | subdata$Season=="Winter" | subdata$Season=="NA" | subdata$Season==""]<-"Winter"
subdata$Season[subdata$Season=="Automn" | subdata$Season=="Autumn"]<-"Automn"



subdata$Price<-as.character(subdata$Price)
subdata$Price[subdata$Price=="low" | subdata$Price=="Low"]<-"Low"
subdata$Price[subdata$Price=="Average"]<-"Average"
subdata$Price[subdata$Price=="Medium"]<-"Medium"
subdata$Price[subdata$Price=="high" | subdata$Price=="High"]<-"High"
subdata$Price[subdata$Price=="very-high"]<-"Very-high"

mosaicplot(~Price + Season, data = subdata, color = 3:4,shade=TRUE,type=c("pearson"),main="Attributes Relationship Analysis")
library(vcd)
mosaic(~Price+Season, data = subdata,shade=TRUE,legend=TRUE,main="Dress Sales Attributes Analysis")



library(ggplot2)

p<-ggplot(subdata, aes(x = Price, y = Rating, fill = Season)) 
p<-p+geom_boxplot() 
p<-p+facet_wrap(~ Season, ncol =5)
print(p)







