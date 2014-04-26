library(ggplot2)
library(shiny)
library(grid)
require(GGally)
library(reshape)
library(plyr)
require(scales)

#create a function for loading and transforming data
loadData <- function(){
  data(Seatbelts)
  times <- time(Seatbelts)
  years <- floor(times)
  years <- factor(years, ordered = TRUE)
  months <- factor(
    month.abb[cycle(times)],
    levels = month.abb,
    ordered = TRUE
  )
  deaths <- data.frame(
    year   = years,
    month  = months,
    time   = as.numeric(times),
    Seatbelts
  )
  return(deaths)
}


# FANCY PALETTE FOR HEATMAPS #######
# THEMES ####################

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
        "year", 
        override.aes = options
      )
    )
  )
}

# FANCY LABELER FOR FACET PLOTS #######

# This code drops the first label if it
# is an odd numbered facet.

count <- 1
fancy_label <- function(x) {
  count <<- count + 1
  if (count %% 2 == 0) { return(x) }
  else { return(c("", x[2:12])) }
}



# AREA CHART ##########################


AreaChat<-function(localFrame,sub_localFrame,variables,min,max,color_scheme){
  if (length(variables)==0){
    p1<-ggplot(localFrame,aes(x=month,y=year,color=as.factor(variable),size=as.factor(value)))+
      annotate("text",x=1,y=5,label="Sorry! Please select at least one variable for the area chat",colour='blue',size=6)
    return(p1)   
  }else{
    if(nrow(sub_localFrame)==0){
      p1<-ggplot(localFrame,aes(x=month,y=year,color=as.factor(variable),size=as.factor(value)))+
        annotate("text",x=1,y=5,label="Sorry! Please modify the Year, Month and Distance range you selected",colour='blue',size=6)
      return(p1)
    }else{ 
      sub_molten <- melt(
        sub_localFrame,
        id = c("year", "month", "time")
      )
      mymax<-as.numeric(max)-1+0.917
      p2 <- ggplot(sub_molten, aes(x = time, y = value))
      p2 <- p2 + geom_area(data =sub_molten,aes(group = variable,fill = variable,color =variable,
        # swap stacking order
        order = -as.numeric(variable)))
      # make it pretty
      p2 <- p2 + scale_x_continuous(
        name = "Year",
        # using 1980 will result in gap
        limits = c(min, mymax),
        expand = c(0, 0),
        # still want 1980 at end of scale
        breaks = c(seq(min, max, 1), mymax),
        labels = function(x) {ceiling(x)})
      p2 <- p2 +scale_y_continuous(
        name = "Deaths in Thousands",
        # set nice limits and breaks
        limits = c(0, 4500),
        expand = c(0, 0),
        breaks = seq(0, 4500, 2250),
        # reduce label space required
        labels = function(x) {paste0(x / 1000, 'k')})
      p2 <- p2 + theme_legend()
      # squarify grid (1 year to 1000 deaths)
      p2 <- p2 + coord_fixed(ratio = 1 / 1000)
      palette<-brewer_pal(type="qual",palette=color_scheme)(5)
      #Region<-levels(sub_data$Region)
      #palette[which(!Region %in% vector_Region_highlight)]<-"grey"
      p2<-p2+scale_fill_manual(values=palette) 
      return(p2)
    }
  }
}

Heatmap<-function(localFrame,sub_localFrame,variables,color_scheme){
  if (length(variables)!=1){
  p1<-ggplot(localFrame,aes(x=month,y=year,color=as.factor(variable),size=as.factor(value)))+
    annotate("text",x=1,y=5,label="Sorry! Please select only one variable for the Heatmap",colour='blue',size=6)
  return(p1)
  }else{ 
    sub_molten <- melt(
      sub_localFrame,
      id = c("year", "month", "time")
    )
    mymax<-as.numeric(max(sub_localFrame[,1]))
    mymax1<-as.integer(mymax/4)
    mymax2<-as.integer(mymax/2)
    mymax3<-as.integer(mymax*3/4)
    p3 <- ggplot(sub_molten, aes(x = month, y = year))
    p3 <- p3 + geom_tile(aes(fill = value), colour = "white")
    p3 <- p3 + scale_fill_gradientn(
      colours = brewer_pal(
        type = "div", 
        palette = color_scheme)(5),
      name = "Deaths",
      limits = c(0,mymax),
      breaks = c(0,mymax1,mymax2,mymax3,mymax)
    )
    p3 <- p3 + scale_x_discrete(name = "Month",expand = c(0, 0),
      # this is for faceting,
      # can be removed otherwise
      labels = fancy_label)
    p3 <- p3 + scale_y_discrete(expand = c(0, 0))
    p3 <- p3 + theme_heatmap()
    p3 <- p3 + coord_fixed(ratio = 1)
  return(p3)
  }
}



globalData <- loadData()
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  #print (head(localFrame))
  
  getVariable <- reactive({
    result<-NULL
    for (i in 1:length(input$variables)){
      result<-append(result,which(colnames(localFrame)==input$variables[i]))
    }
    return(result)
  })
  
  sub_localFrame<-reactive({
    variables<-  getVariable()
    sub_localFrame<-localFrame[which(localFrame$year>=input$year_range[1] &
                                      localFrame$year<=input$year_range[2] &
                                      localFrame$kms>=input$Distance_range[1]&
                                      localFrame$kms<=input$Distance_range[2]),] 
    mydata<-as.data.frame(sub_localFrame[,variables])
    mydata_new<-cbind(mydata,sub_localFrame$year,sub_localFrame$month,sub_localFrame$time)
    name_list<-c("year","month","time")
    colnames(mydata_new)<-append(colnames(mydata),name_list)
  return(mydata_new)
})


getHighlight <- reactive({
  sub_localFrame<-sub_localFrame()
  result <- levels(sub_localFrame$Region)
          if(length(input$vectorRegionhighlight) == 4) {
               return(result)
         }
          else {
  return(result[which(result %in% input$vectorRegionhighlight)])
         }
})


output$AreaChat<-renderPlot({
  AreaChat<-AreaChat(
    localFrame,
    sub_localFrame(),
    variables<-  getVariable(),
    min<-input$year_range[1],
    max<-input$year_range[2],
    color_scheme<-input$colorScheme
  )
  print(AreaChat)    
})

output$Heatmap<-renderPlot({
  Heatmap<-Heatmap(
    localFrame,
    sub_localFrame(),
    variables<-  getVariable(),
    color_scheme<-input$colorScheme
  )
  print(Heatmap)    
})
})




















