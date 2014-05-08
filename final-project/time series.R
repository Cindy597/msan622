
#time series


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
subdata<-mydata[,1:46]
require(reshape2)
subdata<-melt(subdata,id="Dress_ID")
subdata<-subdata[order(subdata$Dress_ID),]
subdata<-as.data.frame(subdata)
subdata<-subdata[c("variable","Dress_ID","value")]
colnames(subdata)<-c("Time","variable","value")
Day<-as.data.frame(apply(as.data.frame(subdata$Time),1,function(x) as.POSIXlt(x,format="%m/%d")$mday))
colnames(Day)<-"Day"
Month<-as.data.frame(apply(as.data.frame(subdata$Time),1,function(x) as.POSIXlt(x,format="%m/%d")$mon+1))
colnames(Month)<-"Month"
Month[which(Month$Month==8),]<-"Aug"
Month[which(Month$Month==9),] <-"Sep"
Month[which(Month$Month==10),] <-"Oct"
subdata<-cbind(Day,Month,subdata)
subdata$value<-as.numeric(subdata$value)
head(subdata)




mysub1<-subset(subdata,variable=="1160536550")[,c(3,5)]
fit<-arima(ts(mysub1$value),order=c(15,0,1))
window<-7
x_range<-45+window
pred<-predict(fit,n.ahead=window)
maxy<-max(mysub1$value)+1/2*max(mysub1$value)
if (window==30){
  time_list<-as.data.frame(c("11/02","11/04", "11/06", "11/08", "11/10", "11/12", "11/14", "11/16", "11/18",
                             "11/20","11/22","11/24","11/26","11/28","11/30","12/02","12/04", "12/06", "12/08",
                             "12/10", "12/12", "12/14", "12/16", "12/18","12/20","12/22","12/24","12/26","12/28","12/30")
}
if (window==15){
  time_list<-as.data.frame(c("11/02","11/04", "11/06", "11/08", "11/10", "11/12", "11/14", "11/16", "11/18",
                             "11/20","11/22","11/24","11/26","11/28","11/30"))
}
colnames(time_list)<-"Time"
time<-as.data.frame(mysub1$Time)
colnames(time)<-"Time"
total<-rbind(time,time_list)
plot(mysub1$value,xaxt="n",xlab="Time",xlim=c(1,x_range),ylim=c(0,maxy),col="blue",type="l",ylab="Sales",main=list("Dress Sales Prediction"))
axis(side=1, at=total$Time, labels=total$Time)
lines(pred$pred,col="red")
lines(pred$pred+2*pred$se,col="red",lty=3)
lines(pred$pred-2*pred$se,col="red",lty=3)
















x=c(mysub1$value, pred$pred[1:length(pred$pred)])
y=seq(from=1, to=length(x), by=1)
new.t<- c(rep('data', 45), rep('pred', 70))
time.data<-data.frame(t=y, x=log(x), type=new.t)
time <- ggplot(time.data)
time<-time+geom_line(aes(y=x, x=t, color=type))



mysub1<-subset(subdata,variable=="618420156")[,c(3,5)]
fit<-arima(ts(mysub1$value),order=c(8,10,1))
window<-9
x_range<-45+window
pred<-predict(fit,n.ahead=window)
time_list<-as.data.frame(c("11/02","11/04", "11/06", "11/08", "11/10", "11/12", "11/14", "11/16", "11/18"))
colnames(time_list)<-"Time"
pred_list<-as.data.frame(as.numeric(pred$pred))
colnames(pred_list)<-"value"
pred<-cbind(time_list,pred_list)
total<-rbind(mysub1,pred)
maxy<-max(total$value)+1/4*max(total$value)
plot(total,xlim=c(1,x_range),ylim=c(0,maxy),col="blue",type="b",ylab="Sales")
lines(pred$pred,col="red")
lines(pred$pred+2*pred$se,col="red",lty=3)
lines(pred$pred-2*pred$se,col="red",lty=3)







