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
  colnames(data)<-c("Dress_ID","04/02","04/04","04/06","04/08","04/10","04/12","04/14","04/16",
                    "04/18","04/20","04/22","04/24","04/26","04/28","04/30",
                    "05/02","05/04","05/06","05/08","05/10","05/12","05/14","05/16",
                    "05/18","05/20","05/22","05/24","05/26","05/28","05/30",
                    "06/02","06/04","06/06","06/08","06/10","06/12","06/14","06/16",
                    "06/18","06/20","06/22","06/24","06/26","06/28","06/30",
                    "07/02","07/04","07/06","07/08","07/10","07/12","07/14","07/16",
                    "07/18","07/20","07/22","07/24","07/26","07/28","07/30",
                    "08/02","08/04","08/06","08/08","08/10","08/12","08/14","08/16",
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
    aes(x = Day, y=factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct')))
  )
  
  p <- p + geom_tile(
    aes(fill = value), 
    colour = "white"
  )
  
  p <- p + scale_fill_gradientn(
    colours = brewer_pal(
      type = "div", 
      palette = colorScheme)(5),
    name = "Sales",
    limits = c(0,max),
    breaks = c(0,second ,max)
  )
  p <- p + scale_y_discrete(expand = c(0, 0))
  p <- p + theme_heatmap()
  
  p <- p + coord_polar()
  p <- p + coord_fixed(ratio =2)
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

MultipleLine<-function(localFrame,sub_localFrame,DressID,colorScheme,FACET,STARLIKE,Brush,month_highlight){
  mydata<-sub_localFrame
  if (STARLIKE=='TRUE'){
    p <- ggplot(
      subset(mydata, variable == DressID), 
      aes(
        x = Day, 
        y = value, 
        group = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct')), 
        color = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct'))
      )
    )
    
    # CREATE MULTI-LINE PLOT ##############
    p <- p + geom_line(alpha = 0.8)
    #brush
    mymonth<-levels(factor(sub_localFrame$Month))
    palette<-brewer_pal(type="qual",palette=colorScheme)(7)
    palette[which(!mymonth %in% month_highlight)]<-"grey"
    p<-p+scale_color_manual(values=palette)
    

    
    # make it pretty
    p <- p + theme_legend()
    p <- p + theme_guide()
    p <- p + ylab("Sales")
    
    
    # squarify grid (1 month to 1000 deaths)
    p <- p + coord_fixed(ratio = 1 / 10)
    p <- p + coord_polar()
  }else if (FACET=='TRUE'){
    p <- ggplot(
      subset(mydata, variable == DressID), 
      aes(
        x = Day, 
        y = value, 
        group = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct')), 
        color = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct'))
      )
    )
    
    # CREATE MULTI-LINE PLOT ##############
    p <- p + geom_line(alpha = 0.8)
   
    #brush
    mymonth<-levels(factor(sub_localFrame$Month))
    palette<-brewer_pal(type="qual",palette=colorScheme)(7)
    palette[which(!mymonth %in% month_highlight)]<-"grey"
    p<-p+scale_color_manual(values=palette)
    
    # make it pretty
    p <- p + theme_legend()
    p <- p + theme_guide()
    p <- p + ylab("Sales")
    
    
    # squarify grid (1 month to 1000 deaths)
    p <- p + coord_fixed(ratio = 1 / 10)
    p <- p + facet_wrap(~ Month, ncol = 3)
    p <- p + theme(legend.position = "none")
    
  }else{
    p <- ggplot(
      subset(mydata, variable == DressID), 
      aes(
        x = Day, 
        y = value, 
        group = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct')), 
        color = factor(Month,levels=c('Apr','May',"Jun",'Jul','Aug','Sep','Oct'))
      )
    )
    
    # CREATE MULTI-LINE PLOT ##############
    p <- p + geom_line(alpha = 0.8)
    #brush
    mymonth<-levels(factor(sub_localFrame$Month))
    palette<-brewer_pal(type="qual",palette=colorScheme)(7)
    palette[which(!mymonth %in% month_highlight)]<-"grey"
    p<-p+scale_color_manual(values=palette)
    
    
    # make it pretty
    p <- p + theme_legend()
    p <- p + theme_guide()
    p <- p + ylab("Sales")
    
    
    # squarify grid (1 month to 1000 deaths)
    p <- p + coord_fixed(ratio = 1 / 10)
  }
  return(p)
}




#CREATE BOX PLOT FOR ATTRIBUTES ANALYSIS

BoxPlot<-function(localFrame,xaxis,fillby){
  mydata<-na.omit(localFrame)
  ID<-as.data.frame(mydata[,1])
  colnames(ID)<-"Dress_ID"
  subdata<-cbind(ID,mydata[,108:ncol(mydata)-1])
  
  subdata$Season<-as.character(mydata$Season)
  subdata$Season[subdata$Season=="spring" | subdata$Season=="Spring"]<-"Spring"
  subdata$Season[subdata$Season=="summer" | subdata$Season=="Summer"]<-"Summer"
  subdata$Season[subdata$Season=="winter" | subdata$Season=="Winter" | subdata$Season=="NA" | subdata$Season==""]<-"Winter"
  subdata$Season[subdata$Season=="Automn" | subdata$Season=="Autumn"]<-"Automn"
  
  subdata$Price<-as.character(subdata$Price)
  subdata$Price[subdata$Price=="low" | subdata$Price=="Low"]<-"Low"
  subdata$Price[subdata$Price=="Medium"]<-"Medium"
  subdata$Price[subdata$Price=="Average"]<-"Average"
  subdata$Price[subdata$Price=="high" | subdata$Price=="High"]<-"High"
  subdata$Price[subdata$Price=="very-high"]<-"V-high"
  
  subdata$Size<-as.character(subdata$Size)
  subdata$Size[subdata$Size=="s" | subdata$Size=="S" | subdata$Size=="small"]<-"S"
  subdata$Size[subdata$Size=="M"]<-"M"
  subdata$Size[subdata$Size=="L"]<-"L"
  subdata$Size[subdata$Size=="XL"]<-"XL"
  subdata$Size[subdata$Size=="free"]<-"free"
  
  subdata$waiseline <-as.character(subdata$waiseline)
  subdata$waiseline[subdata$waiseline=="dropped"]<-"dropped"
  subdata$waiseline[subdata$waiseline=="empire"]<-"empire"
  subdata$waiseline[subdata$waiseline=="natural"]<-"natural"
  subdata$waiseline[subdata$waiseline=="princess"]<-"princess"
  subdata$waiseline[subdata$waiseline=="null"]<-"null"
  
  subdata$SleeveLength<-as.character(subdata$SleeveLength)
  subdata$SleeveLength[subdata$SleeveLength=="sleevless" |subdata$SleeveLength=="sleeevless" | 
                         subdata$SleeveLength=="sleeveless" | subdata$SleeveLength=="sleveless"]<-"none"
  subdata$SleeveLength[subdata$SleeveLength=="halfsleeve" |subdata$SleeveLength=="half" ]<-"half"
  subdata$SleeveLength[subdata$SleeveLength=="full"]<-"full"
  subdata$SleeveLength[subdata$SleeveLength=="capsleeves" |subdata$SleeveLength=="cap-sleeves"]<-"cap"
  subdata$SleeveLength[subdata$SleeveLength=="short"]<-"short"
  subdata$SleeveLength[subdata$SleeveLength=="urndowncollor" |subdata$SleeveLength=="butterfly" |subdata$SleeveLength=="NULL" |
                         subdata$SleeveLength=="Petal" | subdata$SleeveLength=="thressqatar" | subdata$SleeveLength=="threequarter"| 
                         subdata$SleeveLength=="threequater"]<-"other"
  
  
  subdata$NeckLine<-as.character(subdata$NeckLine)
  subdata$NeckLine[subdata$NeckLine=="o-neck"]<-"o"
  subdata$NeckLine[subdata$NeckLine=="v-neck"]<-"v"
  subdata$NeckLine[subdata$NeckLine=="boat-neck"]<-"boat"
  subdata$NeckLine[subdata$NeckLine=="bowneck"]<-"bow"
  subdata$NeckLine[subdata$NeckLine=="ruffled" |subdata$NeckLine=="Scoop" |
                     subdata$NeckLine=="open" | subdata$NeckLine=="mandarin-collor" | subdata$NeckLine=="slash-neck" |
                     subdata$NeckLine=="Sweetheart"|subdata$NeckLine=="turndowncollor" | subdata$NeckLine=="peterpan-collor"]<-"other"
  
  
  
  index<-which(colnames(subdata)==xaxis)
  index<-append(index,which(colnames(subdata)=="Rating"))
  index<-append(index,which(colnames(subdata)==fillby))
  subdata2<-subdata[,index]
  colnames(subdata2)<-c("V1","Rating","Fillby")
  
  
  p<-ggplot(subdata2, aes(x =V1, y = Rating)) 
  p<-p+geom_boxplot(aes(fill=factor(Fillby)))
  p<-p+geom_point(aes(color=factor(Fillby)))
  #p<-p+scale_colour_brewer(palette = colorScheme)
  #p<-p+scale_fill_brewer(palette = colorScheme)
  p<-p+facet_wrap(~Fillby, ncol =5)
  return(p)
}



#Created mosaic plot for attributes relationship analysis
MosaicPlot<-function(localFrame,xaxis,yaxis){
  mydata<-na.omit(localFrame)
  ID<-as.data.frame(mydata[,1])
  colnames(ID)<-"Dress_ID"
  subdata<-cbind(ID,mydata[,108:ncol(mydata)-1])
  
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
  
  subdata$waiseline <-as.character(subdata$waiseline)
  subdata$waiseline[subdata$waiseline=="dropped"]<-"dropped"
  subdata$waiseline[subdata$waiseline=="empire"]<-"empire"
  subdata$waiseline[subdata$waiseline=="natural"]<-"natural"
  subdata$waiseline[subdata$waiseline=="princess"]<-"princess"
  subdata$waiseline[subdata$waiseline=="null"]<-"null"
  
  subdata$SleeveLength<-as.character(subdata$SleeveLength)
  subdata$SleeveLength[subdata$SleeveLength=="sleevless" |subdata$SleeveLength=="sleeevless" | 
                         subdata$SleeveLength=="sleeveless" | subdata$SleeveLength=="sleveless"]<-"none"
  subdata$SleeveLength[subdata$SleeveLength=="halfsleeve" |subdata$SleeveLength=="half" ]<-"half"
  subdata$SleeveLength[subdata$SleeveLength=="full"]<-"full"
  subdata$SleeveLength[subdata$SleeveLength=="capsleeves" |subdata$SleeveLength=="cap-sleeves"]<-"cap"
  subdata$SleeveLength[subdata$SleeveLength=="short"]<-"short"
  subdata$SleeveLength[subdata$SleeveLength=="urndowncollor" |subdata$SleeveLength=="butterfly" |subdata$SleeveLength=="NULL" |
                         subdata$SleeveLength=="Petal" | subdata$SleeveLength=="thressqatar" | subdata$SleeveLength=="threequarter"| 
                         subdata$SleeveLength=="threequater"]<-"other"
  
  
  subdata$NeckLine<-as.character(subdata$NeckLine)
  subdata$NeckLine[subdata$NeckLine=="o-neck"]<-"o"
  subdata$NeckLine[subdata$NeckLine=="v-neck"]<-"v"
  subdata$NeckLine[subdata$NeckLine=="boat-neck"]<-"boat"
  subdata$NeckLine[subdata$NeckLine=="bowneck"]<-"bow"
  subdata$NeckLine[subdata$NeckLine=="ruffled" |subdata$NeckLine=="Scoop" |
                     subdata$NeckLine=="open" | subdata$NeckLine=="mandarin-collor" | subdata$NeckLine=="slash-neck" |
                     subdata$NeckLine=="Sweetheart"|subdata$NeckLine=="turndowncollor" | subdata$NeckLine=="peterpan-collor"]<-"other"
  
  
  
  index<-which(colnames(subdata)==xaxis)
  index<-append(index,which(colnames(subdata)==yaxis))
  subdata2<-subdata[,index]
  colnames(subdata2)<-c("V1","V2")
  print (mosaicplot(~V1 + V2, data = subdata2, color = 3:4,shade=TRUE,type=c("pearson"),main="Attributes Relationship Analysis"))
}


#Build arima time series model for prediction dress sales


HWplot<-function(ts_object,  n.ahead=n.ahead,  CI=.95,  error.ribbon='green', line.size=1){
  hw_object<-HoltWinters(ts_object)
  forecast<-predict(hw_object,  n.ahead=n.ahead,  prediction.interval=T,  level=CI)
  for_values<-data.frame(time=round(time(forecast),  3),  value_forecast=as.data.frame(forecast)$fit,  dev=as.data.frame(forecast)$upr-as.data.frame(forecast)$fit)
  fitted_values<-data.frame(time=round(time(hw_object$fitted),  3),  value_fitted=as.data.frame(hw_object$fitted)$xhat)
  actual_values<-data.frame(time=round(time(hw_object$x),  3),  Actual=c(hw_object$x))
  graphset<-merge(actual_values,  fitted_values,  by='time',  all=TRUE)
  graphset<-merge(graphset,  for_values,  all=TRUE,  by='time')
  graphset[is.na(graphset$dev),  ]$dev<-0 
  graphset$Fitted<-c(rep(NA,  NROW(graphset)-(NROW(for_values) + NROW(fitted_values))),  fitted_values$value_fitted,  for_values$value_forecast)
  graphset.melt<-melt(graphset[, c('time', 'Actual', 'Fitted')], id='time')
  p<-ggplot(graphset.melt,  aes(x=time,  y=value)) + geom_ribbon(data=graphset, aes(x=time, y=Fitted, ymin=Fitted-dev,  ymax=Fitted + dev),  alpha=.2,  fill=error.ribbon) + geom_line(aes(colour=variable), size=line.size) + geom_vline(x=max(actual_values$time),  lty=2) + xlab('Time') + ylab('Value') + theme(legend.position='bottom') + scale_colour_hue('')
  return(p)
}

TimeSeries2<-function(localFrame,sub_localFrame,window,DressID){
  print (window)
  if (window==""){
    window=10
  }else{
    window=window
  }
  subdata<-sub_localFrame
  mysub1<-subset(subdata,variable==DressID)
  graph<-HWplot(ts(mysub1$value,frequency=15),n.ahead=window)
  graph <- graph + scale_colour_brewer("Legend", palette = 'Set1')
  graph <- graph + scale_x_discrete(breaks=1:11,labels=c("04/02","05/02","06/02","07/02","08/02","09/02","10/02","11/02","12/02","01/02","02/02"))
  # add a title
  graph <- graph + labs(title="Holt-Winters Prediction")
  # change the x scale a little
  # change the y-axis title
  graph <- graph + ylab("Sales")
  # change the colour of the lines
  print(graph) 
}


#built RandomForest model to find out inportant variables for predicting whether a dress should be recommended or not

RandomForest<-function(localFrame){
  data<-na.omit(localFrame)
  data<-data[!(is.na(data$Season) | data$Season==""), ]
  data<-data[!(is.na(data$Material) | data$Material=="" |data$Material==" "), ]
  mydata<-data
  mydata<-mydata[,107:ncol(mydata)]
  
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
  mydata$Style[mydata$Style=='sexy' | mydata$Style=='Sexy' ]<-10
  mydata$Style[mydata$Style=='vintage']<-11
  mydata$Style[mydata$Style=='work']<-12
  
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
  return(modelpure)
}



globalData <- loadData()
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  #print (head(localFrame))
  
  
  sub_localFrame<-reactive({
    mymonth<-input$monthrange
    #print(mymonth)
    myday<-input$dayrange
    #print(myday)
    min_month<-mymonth[1]
    max_month<-mymonth[2]  
    min_day<-myday[1]
    max_day<-myday[2]                          
    localFrame<-globalData
    mydata<-na.omit(localFrame)
    subdata<-mydata[,1:106]
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
    if (min_month==4 & max_month==5){ 
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
    }else if (min_month==4 & max_month==6){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
    }else if (min_month==4 & max_month==7){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
    }else if (min_month==4 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==4 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
    }else if (min_month==4 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==5 & max_month==6){
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
    }else if (min_month==5 & max_month==7){
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
    }else if (min_month==5 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==5 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
    }else if (min_month==5 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==5),] <-"May"
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==6 & max_month==7){
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
    }else if (min_month==6 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==6 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
    }else if (min_month==6 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==7 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==7 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
    }else if (min_month==7 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==7),] <-"Jul" 
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"  
    }else if (min_month==8 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"      
    }else if (min_month==8 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==9 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame$Month==9),] <-"Sep"
      sub_localFrame$Month[which(sub_localFrame$Month==10),] <-"Oct"
    }else if (min_month==4 & max_month==4){
      sub_localFrame$Month[which(sub_localFrame$Month==4),]<-"Apr"
    }else if (min_month==5 & max_month==5){
      sub_localFrame$Month[which(sub_localFrame$Month==5),]<-"May"
    }else if (min_month==6 & max_month==6){
      sub_localFrame$Month[which(sub_localFrame$Month==6),]<-"Jun"
    }else if (min_month==7 & max_month==7){
      sub_localFrame$Month[which(sub_localFrame$Month==7),]<-"Jul"
    }else if (min_month==8 & max_month==8){
      sub_localFrame$Month[which(sub_localFrame$Month==8),]<-"Aug"
    }else if (min_month==9 & max_month==9){
      sub_localFrame$Month[which(sub_localFrame$Month==9),]<-"Sep"
    }else if (min_month==10 & max_month==10){
      sub_localFrame$Month[which(sub_localFrame==10),] <-"Oct"
    }   
    sub_localFrame<-cbind(Day,sub_localFrame$Month,mysub)
    colnames(sub_localFrame)<-c("Day","Month","Time","variable","value")
    return(sub_localFrame)
  })
  
  
  getHighlight <- reactive({
    sub_localFrame<-sub_localFrame()
    result <- levels(factor(sub_localFrame$Month))
    if(length(input$Month) == 7) {
      return(result)
    }
    else {
      return(result[which(result %in% input$Month)])
    }
  })
  
  
  output$mytable=renderDataTable({
    localFrame[,1:106]  
  })
  output$mytable2=renderDataTable({
    ID<-as.data.frame(localFrame[,1])
    colnames(ID)<-"Dress_ID"
    subdata<-cbind(ID,localFrame[,108:ncol(localFrame)-1])   
  })
  output$mytable3=renderDataTable({
    ID<-as.data.frame(localFrame[,1])
    colnames(ID)<-"Dress_ID"
    subdata<-cbind(ID,localFrame[,ncol(localFrame)])
    subdata<-as.data.frame(subdata)
    colnames(subdata)<-c("Dress_ID","Recommendation ('yes=1', 'no'=0)")
    subdata
  })
  output$Dress_ID<-renderTable({
    mydata<-na.omit(localFrame)
    ID<-as.data.frame(mydata[,1])
    colnames(ID)<-"Dress_ID"
    subdata<-cbind(ID,mydata[,107:ncol(mydata)])
    subdata1<-subset(subdata,Style==input$style & Size==input$size & Price==input$price & Season==input$season & Material==input$material)
    Dress_ID<-as.data.frame(subdata1$Dress_ID)
    colnames(Dress_ID)<-"Dress_ID"
    print(Dress_ID)
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
  
  FACET<-reactive({
    FACET<-input$FACETPLOT
    return(FACET)
  })
  STARLIKE<-reactive({
    STARLIKE<-input$STARLIKEPLOT
    return(STARLIKE)
  })
    
  
  output$MultipleLine<-renderPlot({
    MultipleLine<-MultipleLine(
      localFrame,
      sub_localFrame(),
      DressID<-input$DressID,
      colorScheme<-input$colorScheme,
      FACET<-FACET(),
      STARLIKE<-STARLIKE(),
      Brush<-input$Brush,
      month_highlight<-getHighlight()
    )
    print(MultipleLine)        
  })
  output$BoxPlot<-renderPlot({
    BoxPlot<-BoxPlot(
      localFrame,
      xaxis<-input$xaxis,
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
    DressID<-input$DressID
    subdata<-sub_localFrame()
    window<-input$future_time
    if (window==""){
      window=10
    }else{
      window=window
    }
    mysub1<-subset(subdata,variable==DressID)[,c(3,5)]
    hw_object<-HoltWinters(ts(mysub1$value,frequency=15))
    forecast<-predict(hw_object,  n.ahead=window,  prediction.interval=T,  level=.95)
    value_forecast<-as.data.frame(forecast)$fit
    finalTable<-as.data.frame(value_forecast)
    colnames(finalTable)<-"Predicted_Sales"
    print(finalTable)
  })  
  output$TimeSeries2<-renderPlot({
    TimeSeries2<-TimeSeries2(
      localFrame,
      sub_localFrame(),
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
  output$text<-renderText({
    modelpure<-RandomForest(localFrame)
    Season<-input$Season
    Price<-input$Price
    waiseline<-input$waiseline
    Size<-input$Size
    SleeveLength<-input$SleeveLength
    NeckLine<-input$NeckLine
    Material<-input$Material
    Style<-input$Style
    FabricType<-input$FabricType
    Decoration<-input$Decoration
    Pattern.Type<-input$Pattern.Type
    Rating<-input$Rating
    
    if (Season=="Automn"){
      'Season'<-2
    }else if(Season=="spring"){
      'Season'<-1
    }else if(Season=="summer"){
      'Season'<-3
    }else if(Season=="winter"){
      'Season'<-4
    }
     
    if (Price=="Average"){
      'Price'<-1
    }else if(Price=="high"){
      'Price'<-2
    }else if(Price=="low"){
      'Price'<-3
    }else if(Price=="Medium"){
      'Price'<-4
    }else if(Price=="very-high"){
      'Price'<-5
    }

    
   if (waiseline=="dropped"){
     'waiseline'<-1
   }else if (waiseline=="empire"){
     'waiseline'<-2
   }else if (waiseline=="natural"){
     'waiseline'<-3
   }else if (waiseline=="princess"){
     'waiseline'<-4
   }else if (waiseline=="null"){
     'waiseliine'<-5
   }
   
   if (Size=="free"){
     'Size'<-1
   }else if (Size=="L"){
     'Size'<-2
   }else if (Size=="M"){
     'Size'<-3
   }else if (Size=="s"){
     'Size'<-4
   }else if (Size=="XL"){
     'Size'<-5
   }
   

   if (Style=='bohemian'){
     'Style'<-1
   }else if (Style=='Brief'){
     'Style'<-2
   }else if (Style=='Casual'){
     'Style'<-3
   }else if (Style=='cute'){
     'Style'<-4
   }else if (Style=='fashion'){
     'Style'<-5
   }else if (Style=='Flare'){
     'Style'<-6
   }else if (Style=='Novelty'){
     'Style'<-7
   }else if (Style=='OL'){
     'Style'<-8
   }else if (Style=='party'){
     'Style'<-9
   }else if (Style=='sexy'){
     'Style'<-10
   }
   
   
   
  if (Material=="mix"){
    'Material'<-1
  }else if (Material=="cotton"){
    'Material'<-2
  }else if (Material=="knitting"){
    'Material'<-3
  }else if (Material=="lace"){
    'Material'<-4
  }else if (Material=="silk"){
    'Material'<-5
  }else if (Material=="null"){
    'Material'<-6
  }else if (Material=="rayon"){
    'Material'<-10
  }else if (Material=="nylon"){
    'Material'<-14
  }else if (Material=="other"){
    'Material'<-21
  }
  
  
  
  if (SleeveLength=="sleevless"){
    'SleeveLength'<-1
  }else if (SleeveLength=="halfsleeve"){
    'SleeveLength'<-2
  }else if (SleeveLength=="full"){
    'SleeveLength'<-3
  }else if (SleeveLength=="capsleeves"){
    'SleeveLength'<-4
  }else if (SleeveLength=="short"){
    'SleeveLength'<-5
  }
 

 if (NeckLine=="o-neck"){
   'NeckLine'<-1
 }else if (NeckLine=="v-neck"){
   'NeckLine'<-2
 }else if (NeckLine=="boat-neck"){
   'NeckLine'<-3
 }else if (NeckLine=="bowneck"){
   'NeckLine'<-4
 }else if (NeckLine=="slash-neck"){
   'NeckLine'<-5
 }else if (NeckLine=="Sweetheart"){
   'NeckLine'<-6
 }
 
 
 
 if (FabricType=="chiffon"){
   'FabricType'<-1
 }else if (FabricType=="null"){
   'FabricType'<-2
 }else if (FabricType=="worsted"){
   'FabricType'<-3
 }else if (FabricType=="broadcloth"){
   'FabricType'<-4
 }else if (FabricType=="sattin"){
   'FabricType'<-5
 }else if (FabricType=="jersey"){
   'FabricType'<-6
 }else if (FabricType=="dobby"){
   'FabricType'<-7
 }else if(FabricType=="poplin"){
   'FabricType'<-10
 }
 
 
 
 if (Decoration=='null'){
   'Decoration'<-1
 }else if (Decoration=="beading"){
   'Decoration'<-2
 }else if (Decoration=="lace"){
   'Decoration'<-3
 }else if (Decoration=="bow"){
   'Decoration'<-4
 }else if (Decoration=="sashes"){
   'Decoration'<-5
 }else if (Decoration== "pockets"){
   'Decoration'<-10
 }
 
 
 if (Pattern.Type=="solid"){
   'Pattern.Type'<-1
 }else if (Pattern.Type=="null"){
   'Pattern.Type'<-2
 }else if (Pattern.Type=="print"){
   'Pattern.Type'<-4
 }else if (Pattern.Type=="animal"){
   'Pattern.Type'<-5
 }else if (Pattern.Type=="striped"){
   'Pattern.Type'<-6
 }else if (Pattern.Type== "dot"){
   'Pattern.Type'<-7
 }else if (Pattern.Type=="plaid"){
   'Pattern.Type'<-8
 }
 
    new_point<-as.data.frame(cbind('Style'= 1,'Price','Rating','waiseline','Size','Season','Material','SleeveLength','Neckline','FabricType','Decoration','Pattern.Type'))
    if (as.numeric(predict(modelpure,new_point,predict.all=TRUE)$individual[500])==1){
      paste("Congraulations! Your selected dress type is recommended by other customers.")
    }else{
      paste ("Sorry! Your selected dress type is not recommended by other customers. Try again!")
    }
  })
})

























