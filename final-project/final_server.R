library(ggplot2)
library(shiny)
library(grid)
require(GGally)
library(reshape)
library(plyr)
require(scales)
require(reshape2)
library(MASS)
library(randomForest)
library(gridExtra)

#create a function for loading and transforming data
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




#Create Heatmap

scale_months <- function() {
  return(
    scale_x_discrete(
      name = "Month",
      expand = c(0, 0),
      # this is for faceting,
      # can be removed otherwise
      labels = fancy_label
    )
  )
}

theme_heatmap <- function() {
  return (
    theme(
      axis.text.y = element_text(
        angle = 90,
        hjust = 0.5),
      axis.ticks = element_blank(),
      axis.title = element_blank(),
      legend.direction = "horizontal",
      legend.position = "bottom",
      panel.background = element_blank()
    )
  )
}

scale_prgn <- function(max) {
  second=1/2*max
  return(
    scale_fill_gradientn(
      colours = brewer_pal(
        type = "div", 
        palette = ColorScheme)(5),
      name = "Sales",
      limits = c(0,max),
      breaks = c(0,second ,max)
    )
  )
}

Heatmap<-function(localFrame,sub_localFrame,colorScheme,DressID){
  mydata<-sub_localFrame
  max<-max(subset(mydata, variable==DressID)$value)
  second=1/2*max
  p <- ggplot(
    subset(mydata, variable == DressID), 
    aes(x = Day, y =Month )
  )
  
  p <- p + geom_tile(
    aes(fill = value), 
    colour = "white"
  )
  
  p <- p + scale_fill_gradientn(
      colours = brewer_pal(
        type = "div", 
        palette = colorScheme)(3),
      name = "Sales",
      limits = c(0,max),
      breaks = c(0,second ,max)
    )
  #p <- p + scale_months()
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + theme_heatmap()
  
  p <- p + coord_polar()
  p <- p + coord_fixed(ratio =5)
  return(p)
}

# CREATE BASE PLOT ####################

theme_legend <- function() {
  return(
    theme(
      legend.direction = "horizontal",
      legend.position = c(1, 1),
      legend.justification = c(1, 1),
      legend.title = element_blank(),
      legend.background = element_blank(),
      legend.key = element_blank()
    )
  )
}

theme_guide <- function() {
  options = list(size = 2)  
  return(
    guides(
      colour = guide_legend(
        "month", 
        override.aes = options
      )
    )
  )
}


#Create Multiple lINE PLOT

MultipleLine<-function(localFrame,DressID,colorScheme){
  mydata<-na.omit(localFrame)
  subdata<-mydata[,1:46]
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
  p <- ggplot(
    subset(subdata, variable == DressID), 
    aes(
      x = Day, 
      y = value, 
      group = factor(Month), 
      color = factor(Month)
    )
  )
  
  # CREATE MULTI-LINE PLOT ##############
  p <- p + geom_line(alpha = 0.8)
  p <- p + scale_colour_brewer(palette = colorScheme)
  
  # make it pretty
  #p <- p + scale_months()
  #p <- p + scale_deaths()
  p <- p + theme_legend()
  p <- p + theme_guide()
  p <- p + ylab("Sales")
  
  
  # squarify grid (1 month to 1000 deaths)
  p <- p + coord_fixed(ratio = 1 / 10)
  
  # CREATE FACET PLOT ###################
  #p <- p + facet_wrap(~ Month, ncol = 2)
  #p <- p + theme(legend.position = "none")
  
  # CREATE STAR-LIKE PLOT ###############
  #p <- p + coord_polar()
  return(p)
}


MultipleLine2<-function(localFrame,DressID,colorScheme){
  mydata<-na.omit(localFrame)
  subdata<-mydata[,1:46]
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
  p <- ggplot(
    subset(subdata, variable == DressID), 
    aes(
      x = Day, 
      y = value, 
      group = factor(Month), 
      color = factor(Month)
    )
  )
  
  # CREATE MULTI-LINE PLOT ##############
  p <- p + geom_line(alpha = 0.8)
  p <- p + scale_colour_brewer(palette = colorScheme)
  
  # make it pretty
  #p <- p + scale_months()
  #p <- p + scale_deaths()
  p <- p + theme_legend()
  p <- p + theme_guide()
  p <- p + ylab("Sales")
  
  
  # squarify grid (1 month to 1000 deaths)
  p <- p + coord_fixed(ratio = 1 / 10)
  
  # CREATE FACET PLOT ###################
  #p <- p + facet_wrap(~ Month, ncol = 2)
  #p <- p + theme(legend.position = "none")
  
  # CREATE STAR-LIKE PLOT ###############
  p <- p + coord_polar()
  return(p)
}




#CREATE BOX PLOT FOR ATTRIBUTES ANALYSIS

BoxPlot<-function(localFrame,xaxis,yaxis,fillby){
  mydata<-na.omit(localFrame)
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
  subdata$Price[subdata$Price=="very-high"]<-"Veryhigh"
  
  subdata$Size<-as.character(subdata$Size)
  subdata$Size[subdata$Size=="s" | subdata$Size=="S" | subdata$Size=="small"]<-"S"
  subdata$Size[subdata$Size=="M"]<-"M"
  subdata$Size[subdata$Size=="L"]<-"L"
  subdata$Size[subdata$Size=="XL"]<-"XL"
  subdata$Size[subdata$Size=="free"]<-"free"
  
  subdata$Style<-as.character(subdata$Style)
  subdata$Style[subdata$Style=="sexy" | subdata$Style=="Sexy"]<-"Sexy"
  subdata$Style[subdata$Style=="OL" | subdata$Style=="work"]<-"OL"
  
  
  index<-which(colnames(subdata)==xaxis)
  index<-append(index,which(colnames(subdata)==yaxis))
  index<-append(index,which(colnames(subdata)==fillby))
  subdata2<-subdata[,index]
  colnames(subdata2)<-c("V1","V2","V3")
        
  
  p<-ggplot(subdata2, aes(x =V1, y = V2)) 
  p<-p+geom_boxplot(aes(fill=factor(V3)))
  p<-p+geom_point(aes(color=factor(V3)))
  #p<-p+scale_colour_brewer(palette = colorScheme)
  #p<-p+scale_fill_brewer(palette = colorScheme)
  p<-p+facet_wrap(~V3, ncol =5)
  return(p)
}



#Created mosaic plot for attributes relationship analysis
MosaicPlot<-function(localFrame,xaxis,yaxis){
  mydata<-na.omit(localFrame)
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
  subdata$Price[subdata$Price=="very-high"]<-"Veryhigh"
  
  subdata$Size<-as.character(subdata$Size)
  subdata$Size[subdata$Size=="s" | subdata$Size=="S" | subdata$Size=="small"]<-"S"
  subdata$Size[subdata$Size=="M"]<-"M"
  subdata$Size[subdata$Size=="L"]<-"L"
  subdata$Size[subdata$Size=="XL"]<-"XL"
  subdata$Size[subdata$Size=="free"]<-"free"
  
  subdata$Style<-as.character(subdata$Style)
  subdata$Style[subdata$Style=="sexy" | subdata$Style=="Sexy"]<-"Sexy"
  subdata$Style[subdata$Style=="OL" | subdata$Style=="work"]<-"OL"
  
  
  index<-which(colnames(subdata)==xaxis)
  index<-append(index,which(colnames(subdata)==yaxis))
  subdata2<-subdata[,index]
  colnames(subdata2)<-c("V1","V2")
  print (mosaicplot(~V1 + V2, data = subdata2, color = 3:4,shade=TRUE,type=c("pearson"),main="Attributes Relationship Analysis"))
}
  

#Build arima time series model for prediction dress sales

TimeSeries2<-function(localFrame,window,DressID){
  mydata<-na.omit(localFrame)
  subdata<-mydata[,1:46]
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
  #head(subdata)
  
  mysub1<-subset(subdata,variable==DressID)[,c(3,5)]
  fit<-arima(ts(mysub1$value),order=c(15,0,1))
  x_range<-45+window
  pred<-predict(fit,n.ahead=window)
  maxy<-max(mysub1$value)+1/2*max(mysub1$value)
  if (window==30){
    time_list<-as.data.frame(c("11/02","11/04", "11/06", "11/08", "11/10", "11/12", "11/14", "11/16", "11/18",
                               "11/20","11/22","11/24","11/26","11/28","11/30","12/02","12/04", "12/06", "12/08",
                               "12/10", "12/12", "12/14", "12/16", "12/18","12/20","12/22","12/24","12/26","12/28","12/30"))
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
}


#built RandomForest model to find out inportant variables for predicting whether a dress should be recommended or not

RandomForest<-function(localFrame){
  data<-na.omit(localFrame)
  data<-data[!(is.na(data$Season) | data$Season==""), ]
  data<-data[!(is.na(data$Material) | data$Material=="" |data$Material==" "), ]
  mydata<-data
  mydata<-mydata[,47:ncol(mydata)]

  ############ change variables to nuericcal
  mydata$Style<-as.character(mydata$Style)
  mydata$Style[mydata$Style=='bohemian']<-1
  mydata$Style[mydata$Style=='Brief']<-2
  mydata$Style[mydata$Style=='Casual']<-3
  mydata$Style[mydata$Style=='cute']<-4
  mydata$Style[mydata$Style=='fashion']<-5
  mydata$Style[mydata$Style=='Flare']<-6
  mydata$Style[mydata$Style=='Novelty']<-7
  mydata$Style[mydata$Style=='OL']<-8
  mydata$Style[mydata$Style=='party']<-9
  mydata$Style[mydata$Style=='sexy']<-10
  mydata$Style[mydata$Style=='Sexy']<-11
  mydata$Style[mydata$Style=='vintage']<-12
  mydata$Style[mydata$Style=='work']<-13
  
  mydata$Price<-as.character(mydata$Price)
  mydata$Price[mydata$Price=="Average"]<-1
  mydata$Price[mydata$Price=="high" | mydata$Price=="High"]<-2
  mydata$Price[mydata$Price=="low" | mydata$Price=="Low"]<-3
  mydata$Price[mydata$Price=="Medium"]<-4
  mydata$Price[mydata$Price=="very-high"]<-5
  
  mydata$waiseline <-as.character(mydata$waiseline)
  mydata$waiseline[mydata$waiseline=="dropped"]<-1
  mydata$waiseline[mydata$waiseline=="empire"]<-2
  mydata$waiseline[mydata$waiseline=="natural"]<-3
  mydata$waiseline[mydata$waiseline=="princess"]<-4
  mydata$waiseline[mydata$waiseline=="null"]<-5
   
  mydata$Size<-as.character(mydata$Size)
  mydata$Size[mydata$Size=="free"]<-1
  mydata$Size[mydata$Size=="L"]<-2
  mydata$Size[mydata$Size=="M"]<-3
  mydata$Size[mydata$Size=="s" |mydata$Size=="S" |mydata$Size=="small" ]<-4
  mydata$Size[mydata$Size=="XL"]<-5
  
  mydata$Season<-as.character(mydata$Season)
  mydata$Season[mydata$Season=="Automn" | mydata$Season=="Autumn"]<-1
  mydata$Season[mydata$Season=="spring" | mydata$Season=="Spring"]<-2
  mydata$Season[mydata$Season=="summer" | mydata$Season=="Summer"]<-3
  mydata$Season[mydata$Season=="winter" | mydata$Season=="Winter"]<-4
  mydata$Season[mydata$Season=="NA"]<-5
  
  mydata$Material<-as.character(mydata$Material)
  mydata$Material[mydata$Material=="mix"]<-1
  mydata$Material[mydata$Material=="cotton"]<-2
  mydata$Material[mydata$Material=="knitting"]<-3
  mydata$Material[mydata$Material=="lace"]<-4
  mydata$Material[mydata$Material=="silk" | mydata$Material=="milksilk"]<-5
  mydata$Material[mydata$Material=="null"]<-6
  mydata$Material[mydata$Material=="chiffonfabric"]<-7
  mydata$Material[mydata$Material=="viscos"]<-8
  mydata$Material[mydata$Material=="polyster"]<-9
  mydata$Material[mydata$Material=="rayon"]<-10
  mydata$Material[mydata$Material=="cashmere"]<-11
  mydata$Material[mydata$Material=="microfiber"]<-12
  mydata$Material[mydata$Material=="acrylic"]<-13
  mydata$Material[mydata$Material=="nylon"]<-14
  mydata$Material[mydata$Material=="wool"]<-15
  mydata$Material[mydata$Material=="modal"]<-16
  mydata$Material[mydata$Material=="model"]<-17
  mydata$Material[mydata$Material=="spandex"]<-18
  mydata$Material[mydata$Material=="linen"]<-19
  mydata$Material[mydata$Material=="lycra"]<-20
  mydata$Material[mydata$Material=="other"]<-21  
  
  mydata$SleeveLength<-as.character(mydata$SleeveLength)
  mydata$SleeveLength[mydata$SleeveLength=="sleevless" | mydata$SleeveLength=="sleeevless" | 
                        mydata$SleeveLength=="sleeveless" | mydata$SleeveLength=="sleveless"]<-1
  mydata$SleeveLength[mydata$SleeveLength=="halfsleeve" |mydata$SleeveLength=="half" ]<-2
  mydata$SleeveLength[mydata$SleeveLength=="full"]<-3
  mydata$SleeveLength[mydata$SleeveLength=="capsleeves" | mydata$SleeveLength=="cap-sleeves"]<-4
  mydata$SleeveLength[mydata$SleeveLength=="short"]<-5
  mydata$SleeveLength[mydata$SleeveLength=="thressqatar" | mydata$SleeveLength=="threequarter"| mydata$SleeveLength=="threequater" ]<-6
  mydata$SleeveLength[mydata$SleeveLength=="urndowncollor" |mydata$SleeveLength=="butterfly" |mydata$SleeveLength=="NULL" |
                        mydata$SleeveLength=="Petal" ]<-7
   
  mydata$NeckLine<-as.character(mydata$NeckLine)
  mydata$NeckLine[mydata$NeckLine=="o-neck"]<-1
  mydata$NeckLine[mydata$NeckLine=="v-neck"]<-2
  mydata$NeckLine[mydata$NeckLine=="boat-neck"]<-3
  mydata$NeckLine[mydata$NeckLine=="bowneck"]<-4
  mydata$NeckLine[mydata$NeckLine=="slash-neck"]<-5
  mydata$NeckLine[mydata$NeckLine=="Sweetheart"]<-6
  mydata$NeckLine[mydata$NeckLine=="turndowncollor"]<-7
  mydata$NeckLine[mydata$NeckLine=="peterpan-collor"]<-8
  mydata$NeckLine[mydata$NeckLine=="ruffled" |mydata$NeckLine=="Scoop" |
                    mydata$NeckLine=="open" | mydata$NeckLine=="mandarin-collor"]<-9
  
  mydata$FabricType<-as.character(mydata$FabricType)
  mydata$FabricType[mydata$FabricType=="chiffon"]<-1
  mydata$FabricType[mydata$FabricType=="null"]<-2
  mydata$FabricType[mydata$FabricType=="worsted"]<-3
  mydata$FabricType[mydata$FabricType=="broadcloth"]<-4
  mydata$FabricType[mydata$FabricType=="sattin"]<-5
  mydata$FabricType[mydata$FabricType=="jersey"]<-6
  mydata$FabricType[mydata$FabricType=="dobby"]<-7
  mydata$FabricType[mydata$FabricType=="shiffon"]<-8
  mydata$FabricType[mydata$FabricType=="knitting" | mydata$FabricType=="knitted"]<-9
  mydata$FabricType[mydata$FabricType=="poplin"]<-10
  mydata$FabricType[mydata$FabricType=="terry" | mydata$FabricType=="wollen" | mydata$FabricType=="organza" |
                      mydata$FabricType=="Corduroy" |mydata$FabricType=="tulle" | mydata$FabricType=="other"]<-11
  
  
  mydata$Decoration<-as.character(mydata$Decoration)
  mydata$Decoration[mydata$Decoration=='null']<-1
  mydata$Decoration[mydata$Decoration=="beading"]<-2
  mydata$Decoration[mydata$Decoration=="lace"]<-3
  mydata$Decoration[mydata$Decoration=="bow"]<-4
  mydata$Decoration[mydata$Decoration=="sashes"]<-5
  mydata$Decoration[mydata$Decoration=="hollowout"]<-6
  mydata$Decoration[mydata$Decoration=="ruffles"]<-7
  mydata$Decoration[mydata$Decoration=="sequined"]<-8
  mydata$Decoration[mydata$Decoration=="applique"]<-9
  mydata$Decoration[mydata$Decoration== "pockets"]<-10
  mydata$Decoration[mydata$Decoration=="feathers"]<-11
  mydata$Decoration[mydata$Decoration=="draped" |mydata$Decoration=="tassel"| mydata$Decoration=="flowers" |
                      mydata$Decoration=="none" | mydata$Decoration=="crystal"| mydata$Decoration=="plain"|
                      mydata$Decoration=="embroidary" | mydata$Decoration=="rivet" | mydata$Decoration=="cascading"|
                      mydata$Decoration=="pearls"]<-12
  
  mydata$Pattern.Type<-as.character(mydata$Pattern.Type)
  mydata$Pattern.Type[mydata$Pattern.Type=="solid"]<-1
  mydata$Pattern.Type[mydata$Pattern.Type=="null"]<-2
  mydata$Pattern.Type[mydata$Pattern.Type=="patchwork"]<-3
  mydata$Pattern.Type[mydata$Pattern.Type=="print"]<-4
  mydata$Pattern.Type[mydata$Pattern.Type=="animal"]<-5
  mydata$Pattern.Type[mydata$Pattern.Type=="striped"]<-6
  mydata$Pattern.Type[mydata$Pattern.Type== "dot"]<-7
  mydata$Pattern.Type[mydata$Pattern.Type=="plaid"]<-8
  mydata$Pattern.Type[mydata$Pattern.Type== "leopard" | mydata$Pattern.Type== "none" | mydata$Pattern.Type== "geometric"]<-9 
  
  data_new<-mydata
  data_new<-na.omit(data_new)
  
  for (i in 1:ncol(data_new)){
    data_new[,i]<- as.numeric(data_new[,i])
  }
  
  modelpure <- randomForest(as.factor(Recommendation) ~., data=data_new,importance=TRUE, ntree=500,sampsize=nrow(data_new), nodesize=1)
  imp<-importance(modelpure,type=1)
  print (varImpPlot(modelpure,main=" Average Importance plots",col="purple"))
}



globalData <- loadData()
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  #print (head(localFrame))
  
  
  sub_localFrame<-reactive({
    mymonth<-input$monthrange
    print(mymonth)
    myday<-input$dayrange
    print(myday)
    min_month<-mymonth[1]
    max_month<-mymonth[2]  
    min_day<-myday[1]
    max_day<-myday[2]                          
    localFrame<-globalData
    mydata<-na.omit(localFrame)
    subdata<-mydata[,1:46]
    subdata<-melt(subdata,id="Dress_ID")
    subdata<-subdata[order(subdata$Dress_ID),]
    subdata<-as.data.frame(subdata)
    subdata<-subdata[c("variable","Dress_ID","value")]
    colnames(subdata)<-c("Time","variable","value")
    Day<-as.data.frame(apply(as.data.frame(subdata$Time),1,function(x) as.POSIXlt(x,format="%m/%d")$mday))
    colnames(Day)<-"Day"
    Month<-as.data.frame(apply(as.data.frame(subdata$Time),1,function(x) as.POSIXlt(x,format="%m/%d")$mon+1))
    colnames(Month)<-"Month"
    subdata<-cbind(Day,Month,subdata)
    subdata$value<-as.numeric(subdata$value)

    sub_localFrame<-subdata[which(subdata$Month>=min_month &
                                       subdata$Month<=max_month &
                                       subdata$Day>=min_day&
                                       subdata$Day<=max_day),]
    sub_localFrame<-as.data.frame(sub_localFrame)
    
    Day<-sub_localFrame[,1]
    mysub<-sub_localFrame[,3:5]
    sub_localFrame$Month<-as.data.frame(sub_localFrame$Month)
    if (min_month==8 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"      
    }else if (min_month==8 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==9 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==8 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==9 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==9),]<-"Sep"
    }else if (min_month==10 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame==10),] <-"Oct"
    }   
    sub_localFrame<-cbind(Day,sub_localFrame$Month,mysub)
    colnames(sub_localFrame)<-c("Day","Month","Time","variable","value")
    print(sub_localFrame[1:10,])
    
    return(sub_localFrame)
  })
  
   
  output$mytable=renderDataTable({
    localFrame[,1:46]  
  })
  output$mytable2=renderDataTable({
    ID<-as.data.frame(localFrame[,1])
    colnames(ID)<-"Dress_ID"
    subdata<-cbind(ID,localFrame[,47:ncol(localFrame)])
    
  })
  output$Heatmap<-renderPlot({
    Heatmap<-Heatmap(
      localFrame,
      sub_localFrame(),
      colorScheme<-input$colorScheme,
      DressID<-input$DressID
    )
    print(Heatmap)        
  })
  output$MultipleLine<-renderPlot({
    MultipleLine<-MultipleLine(
      localFrame,
      DressID<-input$DressID,
      colorScheme<-input$colorScheme
    )
    print(MultipleLine)        
  })
  output$MultipleLine2<-renderPlot({
    MultipleLine2<-MultipleLine2(
      localFrame,
      DressID<-input$DressID,
      colorScheme<-input$colorScheme
    )
    print(MultipleLine2)        
  })
  output$BoxPlot<-renderPlot({
    BoxPlot<-BoxPlot(
      localFrame,
      xaxis<-input$xaxis,
      yaxis<-input$yaxis,
      fillby<-input$fillby
      #colorScheme<-input$colorScheme
    )
    print(BoxPlot)        
  })
  output$MosaicPlot<-renderPlot({
    MosaicPlot<-MosaicPlot(
      localFrame,
      xaxis<-input$xaxis,
      yaxis<-input$yaxis
    )
    print(MosaicPlot)        
  })  
  
  output$TimeSeries<-renderTable({
    mydata<-na.omit(localFrame)
    subdata<-mydata[,1:46]
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
    
    DressID<-input$DressID
    window<-input$future_time
    mysub1<-subset(subdata,variable==DressID)[,c(3,5)]
    fit<-arima(ts(mysub1$value),order=c(8,0,1))
    pred<-predict(fit,n.ahead=window)
    finalTable<-as.data.frame(pred$pred)
    colnames(finalTable)<-"Predicted_Sales"
    print(finalTable)
  })  
  output$TimeSeries2<-renderPlot({
    TimeSeries2<-TimeSeries2(
      localFrame,
      window<-input$future_time,
      DressID<-input$DressID
    )
    print(TimeSeries2)        
  })  
  output$RandomForest<-renderPlot({
    RandomForest<-RandomForest(
      localFrame
    )
    print(RandomForest)        
  })  
})

























