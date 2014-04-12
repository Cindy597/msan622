library(ggplot2)
library(shiny)
library(grid)
require(GGally)
library(reshape)
library(plyr)

#create a function for loading and transforming data
loadData <- function(){
  df <- data.frame(state.x77,
                   State = state.name,
                   Abbrev = state.abb,
                   Region = state.region,
                   Division = state.division)
  return(df)
}

#create a plot function to get bubble plot which has Life Expectation on the x-axis, Income
#on the y-axis, bubbles colored by Region, and bubbles sized by Murder. 
bubble_Plot<-function(sub_localFrame,localFrame,bubble_size,vector_Region_highlight,variables,color_theme){ 
  if(nrow(sub_localFrame)==0){
    p1<-ggplot(localFrame,aes(x=Illiteracy,y=Income,color=as.factor(Region),size=as.factor(Murder)))+
      annotate("text",x=1,y=5,label="Sorry! Please modify the Population and Income range you selected",colour='blue',size=6)
    return(p1)
  }else{
    if (length(variables)==2){
      mydata<-sub_localFrame[,variables]
      sub_data<-cbind(mydata,sub_localFrame$Region,sub_localFrame$Murder)
      colnames(sub_data)<-c("V1","V2","Region","Murder")
      sub_data<-as.data.frame(sub_data)
    }else if (length(variables)==1){
      mydata<-sub_localFrame[,variables]
      sub_data<-cbind(mydata,sub_localFrame$Region,sub_localFrame$Murder)
      colnames(sub_data)<-c("V1","Region","Murder")
      sub_data<-as.data.frame(sub_data)
    }else if(length(variables)==0){
      sub_data<-cbind(sub_localFrame$Region,sub_localFrame$Region,sub_localFrame$Murder)
      colnames(sub_data)<-c("V1","Region","Murder")
      sub_data<-as.data.frame(sub_data)    
    }
    if (length(variables)!=2){
      p1<-ggplot(sub_data,aes(x=V1,y=V1,color=Region,size=Murder))+
        annotate("text",x=1,y=5,label="Sorry! Please select two variables for Bubble plot",colour='blue',size=6)
      return(p1)
    }else{
        sub_data <- sub_data[order(sub_data$Murder, decreasing = TRUE),]
        # Create bubble plot
        if (max(sub_data$V1)>max(sub_data$V2)){
          p1 <- ggplot(sub_data, aes(
            x = V2,
            y = V1,
            color = Region,
            size = Murder))
          p1 <- p1 + geom_point(alpha = 0.6, position = "jitter")
          # Tweak the plot limits
          #print(c(min(sub_data$V1), max(sub_data$V1)))
          #print(c(min(sub_data$V2), max(sub_data$V2)))
          #print(c(min(sub_data$V2)-min(sub_data$V2)*5/100, max(sub_data$V2)+max(sub_data$V2)*5/100))
          #print(abs(max(sub_data$V2)-min(sub_data$V2))/2)
          p1 <- p1 + scale_x_continuous(
            limits = c(min(sub_data$V2)-min(sub_data$V2)*20/100, max(sub_data$V2)+max(sub_data$V2)*20/100),
            expand = c(0, 0))  
          p1 <- p1 + scale_y_continuous(
            limits = c(min(sub_data$V1)-min(sub_data$V1)*20/100, max(sub_data$V1)+max(sub_data$V1)*20/100),
            expand = c(0, 0))  
          p1 <- p1 + labs(
            size = "Murder",
            x = colnames(sub_localFrame)[variables[2]],
            y = colnames(sub_localFrame)[variables[1]]) 
          p1 <- p1 + annotate(
            "text", x = min(sub_data$V2), y = max(sub_data$V1)+max(sub_data$V1)*8/100,
            hjust = 0.01, color = "blue",
            label = "Circle area is proportional to 'Murder'.",size=6)
        }else{
          p1 <- ggplot(sub_data, aes(
            x = V1,
            y = V2,
            color = Region,
            size = Murder))
          p1 <- p1 + geom_point(alpha = 0.6, position = "jitter")
          # Tweak the plot limits
          p1 <- p1 + scale_x_continuous(
            limits = c(min(sub_data$V1)-min(sub_data$V1)*20/100, max(sub_data$V1)+max(sub_data$V1)*20/100),
            expand = c(0, 0))  
          p1 <- p1 + scale_y_continuous(
            limits = c(min(sub_data$V2)-min(sub_data$V2)*20/100, max(sub_data$V2)+max(sub_data$V2)*20/100),
            expand = c(0, 0)) 
          p1 <- p1 + labs(
            size = "Murder",
            x = colnames(sub_localFrame)[variables[1]],
            y = colnames(sub_localFrame)[variables[2]]) 
          p1 <- p1 + annotate(
            "text", x = min(sub_data$V1), y=max(sub_data$V2)+max(sub_data$V2)*8/100,
            hjust = 0.01, color = "blue",
            label = "Circle area is proportional to 'Murder'.",size=6)
        }
        # Give points some alpha to help with overlap/density
        # Can also "jitter" to reduce overlap but reduce accuracy    
        # Default size scale is by radius, force to scale by area instead
        p1 <- p1 + scale_size_area(max_size = 5*bubble_size)  
        # Modify the labels
        p1<- p1 + ggtitle("state Dataset") 
        # Modify the legend settings
        p1 <- p1 + theme(legend.direction = "vertical")
        p1 <- p1 + theme(legend.background = element_blank())
        p1 <- p1 + theme(legend.key = element_blank())
        p1 <- p1 + theme(legend.text = element_text(size = 12, colour="blue"))
        #p1 <- p1 + theme(legend.margin = unit(0, "pt"))  
        # Force the dots to plot larger in legend
        p1 <- p1 + guides(colour = guide_legend(override.aes = list(size = 8)))  
        # Indicate size is petal length
        palette<-brewer_pal(type="qual",palette=color_theme)(4)
        Region<-levels(sub_data$Region)
        palette[which(!Region %in% vector_Region_highlight)]<-"grey"
        p1<-p1+scale_color_manual(values=palette)    
        return(p1)
    }
  }
}



ScatterMatrix_Plot<-function(sub_localFrame,localFrame,bubble_size,vector_Region_highlight,variables,color_theme){
  if(nrow(sub_localFrame)==0){
    p2<-ggplot(localFrame,aes(x=Illiteracy,y=Income,color=as.factor(Region),size=as.factor(Murder)))+
      annotate("text",x=1,y=5,label="Sorry! Please modify the Population and Income range you selected",colour='blue',size=6)
    return(p2)
  }else{
     if(length(variables)==0){
        sub_data<-cbind(sub_localFrame$Region,sub_localFrame$Region,sub_localFrame$Murder)
        colnames(sub_data)<-c("V1","Region","Murder")
        sub_data<-as.data.frame(sub_data)    
      }
      if (length(variables)<2){
        p2<-ggplot(sub_data,aes(x=V1,y=V1,color=as.factor(Region),size=as.factor(Murder)))+
          annotate("text",x=1,y=5,label="Sorry! Please select at least two variables for Scatter Matrix plot",colour='blue',size=6)
        return(p2)
      }else{
        mydata<-sub_localFrame[,variables]
        sub_data<-cbind(mydata,sub_localFrame$Region)
        colnames(sub_data)<-append(colnames(mydata),"Region")
        p2 <- ggpairs(sub_data, 
                      # Columns to include in the matrix
                      columns =1:(ncol(sub_data)-1),            
                      # What to include above diagonal
                      # list(continuous = "points") to mirror
                      # "blank" to turn off
                      upper = "blank",             
                      # What to include below diagonal
                      lower = list(continuous = "points"),             
                      # What to include in the diagonal
                      diag = list(continuous = "density"),             
                      # How to label inner plots
                      # internal, none, show
                      axisLabels = "none",             
                      # Other aes() parameters
                      colour = "Region",
                      title = "State Scatterplot Matrix",
                      legends=FALSE
        )
        
        # Remove grid from plots along diagonal
        for (i in 1:(ncol(sub_data)-1)) {
          # Get plot out of matrix
          inner = getPlot(p2, i, i);
          
          # filter
          palette<-brewer_pal(type="qual",palette=color_theme)(4)
          Region<-levels(sub_data$Region)
          palette[which(!Region %in% vector_Region_highlight)]<-"grey"
          inner<-inner+scale_color_manual(values=palette) 
          inner = inner + theme(panel.grid = element_blank());
          
          # Put it back into the matrix
          p2 <- putPlot(p2, inner, i, i);
        }
        
        #filter from plots along non-diagonal
        for (i in 1:(ncol(sub_data)-1)){
          for (j in 1:(ncol(sub_data)-1)){
            if (i!=j){
              inner=getPlot(p2,i,j);
              palette<-brewer_pal(type="qual",palette=color_theme)(4)
              Region<-levels(sub_data$Region)
              palette[which(!Region %in% vector_Region_highlight)]<-"grey"
              inner<-inner+scale_color_manual(values=palette) 
              inner<-inner+geom_point(size=bubble_size)
              # Put it back into the matrix
              p2 <- putPlot(p2, inner, i, j);
            }
          }
        }

   # Show the plot
     return(p2)
    }
  }
}


ParallelCoordinate_Plot<-function(sub_localFrame,localFrame,bubble_size,vector_Region_highlight,variables,color_theme){
  if(nrow(sub_localFrame)==0){
    p3<-ggplot(localFrame,aes(x=Illiteracy,y=Income,color=as.factor(Region),size=as.factor(Murder)))+
      annotate("text",x=1,y=5,label="Sorry! Please modify the Population and Income range you selected",colour='blue',size=6)
    return(p3)
  }else{
    if(length(variables)==0){
      sub_data<-cbind(sub_localFrame$Region,sub_localFrame$Region,sub_localFrame$Murder)
      colnames(sub_data)<-c("V1","Region","Murder")
      sub_data<-as.data.frame(sub_data)    
    }
    if (length(variables)<2){
      p3<-ggplot(sub_data,aes(x=V1,y=V1,color=as.factor(Region),size=as.factor(Murder)))+
        annotate("text",x=1,y=5,label="Sorry! Please select at least two variables for Parallel Coordinate plot",colour='blue',size=6)
      return(p3)
    }else{
      mydata<-sub_localFrame[,variables]
      sub_data<-cbind(mydata,sub_localFrame$Region)
      colnames(sub_data)<-append(colnames(mydata),"Region")
      sub_data<-as.data.frame(sub_data)
      p3 <- ggparcoord(data =sub_data,                 
                       # Which columns to use in the plot
                       columns = 1:(ncol(sub_data)-1),                 
                       # Which column to use for coloring data
                       groupColumn = ncol(sub_data),                 
                       # Allows order of vertical bars to be modified
                       order = "anyClass",               
                       # Do not show points
                       showPoints = TRUE,                
                       # Turn on alpha blending for dense plots
                       alphaLines = 0.6,                
                       # Turn off box shading range
                       shadeBox = NULL,               
                       # Will normalize each column's values to [0, 1]
                       scale = "uniminmax" # try "std" also
      )
      # Start with a basic theme
      p3 <- p3 + theme_minimal()
      # Decrease amount of margin around x, y values
      p3 <- p3 + scale_y_continuous(expand = c(0.02, 0.02))
      p3 <- p3 + scale_x_discrete(expand = c(0.02, 0.02))
      # Remove axis ticks and labels
      p3 <- p3 + theme(axis.ticks = element_blank())
      p3 <- p3 + theme(axis.title = element_blank())
      p3 <- p3 + theme(axis.text.y = element_blank())
      # Clear axis lines
      p3 <- p3 + theme(panel.grid.minor = element_blank())
      p3 <- p3 + theme(panel.grid.major.y = element_blank())
      # Darken vertical lines
      p3 <- p3 + theme(panel.grid.major.x = element_line(color = "#bbbbbb"))
      # Move label to bottom
      p3 <- p3 + theme(legend.position = "bottom")
      # Figure out y-axis range after GGally scales the data
      min_y <- min(p3$data$value)
      max_y <- max(p3$data$value)
      pad_y <- (max_y - min_y) * 0.1
      # Calculate label positions for each veritcal bar
      lab_x <- rep(1:(ncol(sub_data)-1), times = 2) # 2 times, 1 for min 1 for max
      lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = ncol(sub_data)-1)
      # Get min and max values from original dataset
      lab_z <- c(sapply(sub_localFrame[, 1:(ncol(sub_data)-1)], min), sapply(sub_localFrame[, 1:(ncol(sub_data)-1)], max))
      # Convert to character for use as labels
      lab_z <- as.character(lab_z)
      # Add labels to plot
      p3 <- p3 + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 3)
      palette<-brewer_pal(type="qual",palette=color_theme)(4)
      Region<-levels(sub_data$Region)
      palette[which(!Region %in% vector_Region_highlight)]<-"grey"
      p3<-p3+scale_color_manual(values=palette) 
      p3<-p3+geom_point(size=bubble_size)
      # Display parallel coordinate plot
      return(p3)
    }
  }
}
    


globalData <- loadData()
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  
sub_localFrame<-reactive({
  sub_localFrame<-localFrame[which(localFrame$Population>=input$population_range[1] &
                                     localFrame$Population<=input$population_range[2] &
                                     localFrame$Income>=input$income_range[1]&
                                     localFrame$Income<=input$income_range[2]),]
  return(sub_localFrame)
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


getVariable <- reactive({
  sub_localFrame<-sub_localFrame()
  result <- colnames(sub_localFrame)
  if (length(input$variables)==2){
    result<-NULL
    result<-append(which(colnames(sub_localFrame)==input$variables[1]), which(colnames(sub_localFrame)==input$variables[2]))
    return(result)
  }else{
    result<-NULL
    for (i in 1:length(input$variables)){
      result<-append(result,which(colnames(sub_localFrame)==input$variables[i]))
    }
    return(result)
  }
})



output$BubblePlot<-renderPlot({
  BubblePlot<-bubble_Plot(
    sub_localFrame(),
    localFrame,
    bubble_size=input$bubblesize,
    getHighlight(),
    variables=getVariable(),
    color_theme=input$colorScheme
  )
  print(BubblePlot)    
})

output$ScatterMatrixPlot<-renderPlot({
  ScatterMatrixPlot<-ScatterMatrix_Plot(
    sub_localFrame(),
    localFrame,
    bubble_size=input$bubblesize,
    getHighlight(),
    variables=getVariable(),
    color_theme=input$colorScheme
  )
  print(ScatterMatrixPlot)    
})


output$ParallelCoordinatePlot<-renderPlot({
  ParallelCoordinatePlot<-ParallelCoordinate_Plot(
    sub_localFrame(),
    localFrame,
    bubble_size=input$bubblesize,
    getHighlight(),
    variables=getVariable(),
    color_theme=input$colorScheme
  )
  print(ParallelCoordinatePlot)    
})
})


























