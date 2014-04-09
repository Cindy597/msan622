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
#on the y-axis, bubbles colored by Division, and bubbles sized by Murder. 
bubble_Plot<-function(localFrame,mysubset,bubble_size,vector_Division,vector_Region){
  if (vector_Division=="All"){
    sub_data<-mysubset
  }else{
    sub_data<-mysubset[mysubset$Division==vector_Division,]
  }
  if (nrow(sub_data)==0){
    p1<-ggplot(sub_data,aes(x=Life.Exp,y=Income,color=Division,size=Murder))+
      annotate("text",x=1,y=5,label="Sorry! The dataset for your selection perference is empty",colour='blue',size=9)
    return(p1)
  }else{
    sub_data <- sub_data[order(sub_data$Murder, decreasing = TRUE),]
    # Create bubble plot
    p1 <- ggplot(sub_data, aes(
      x = Life.Exp,
      y = Income,
      color = Division,
      size = Murder))
    # Give points some alpha to help with overlap/density
    # Can also "jitter" to reduce overlap but reduce accuracy
    p1 <- p1 + geom_point(alpha = 0.6, position = "jitter")
    #p<-p+labs(colour='Division',size='Murder')
    
    # Default size scale is by radius, force to scale by area instead
    # Optionally disable legends
    #p <- p + scale_size_area(max_size = 10, guide = "none")
    p1 <- p1 + scale_size_area(max_size = bubble_size)  
    # Tweak the plot limits
    p1 <- p1 + scale_x_continuous(
      limits = c(66.5, 74.5),
      expand = c(0, 0))  
    p1 <- p1 + scale_y_continuous(
      limits = c(2900, 7000),
      expand = c(0, 0))  
    # Modify the labels
    p1<- p1 + ggtitle("state Dataset")
    p1 <- p1 + labs(
      size = "Murder",
      x = "Life Expectation",
      y = "Income")  
    # Modify the legend settings
    #p <- p + theme(legend.title = element_blank())
    p1 <- p1 + theme(legend.direction = "vertical")
    #p <- p + theme(legend.position = c(0, 0))
    #p <- p + theme(legend.justification = c(0, 0))
    p1 <- p1 + theme(legend.background = element_blank())
    p1 <- p1 + theme(legend.key = element_blank())
    p1 <- p1 + theme(legend.text = element_text(size = 12, colour="blue"))
    p1 <- p1 + theme(legend.margin = unit(0, "pt"))  
    # Force the dots to plot larger in legend
    p1 <- p1 + guides(colour = guide_legend(override.aes = list(size = 8)))  
    # Indicate size is petal length
    p1 <- p1 + annotate(
      "text", x = 70.5, y = 6700,
      hjust = 0.5, color = "blue",
      label = "Circle area is proportional to 'Murder'.",size=8)
    return(p1)
  }
}

ScatterMatrix_Plot<-function(localFrame,mysubset,vector_Division,vector_Region){
  if (vector_Division=="All"){
    sub_data<-mysubset
  }else{
    sub_data<-mysubset[mysubset$Division==vector_Division,]
  }
  if (nrow(sub_data)==0){
    p1<-ggplot(sub_data,aes(x=Life.Exp,y=Income,color=Division,size=Murder))+
      annotate("text",x=1,y=5,label="Sorry! The dataset for your selection perference is empty",colour='blue',size=9)
    return(p1)
  }else{
    p2 <- ggpairs(sub_data, 
                  # Columns to include in the matrix
                  columns = 1:4,            
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
                  title = "State.x77 Scatterplot Matrix",
                  legends=FALSE
    )
    
    # Remove grid from plots along diagonal
    for (i in 1:4) {
      # Get plot out of matrix
      inner = getPlot(p2, i, i);
      
      # Add any ggplot2 settings you want
      inner = inner + theme(panel.grid = element_blank());
      
      # Put it back into the matrix
      p2 <- putPlot(p2, inner, i, i);
    }
    # Show the plot
    return(p2)
  }
}


ParallelCoordinate_Plot<-function(localFrame,mysubset,vector_Division,vector_Region){
  if (vector_Division=="All"){
    sub_data<-mysubset
  }else{
    sub_data<-mysubset[mysubset$Division==vector_Division,]
  }
  if (nrow(sub_data)==0){
    p1<-ggplot(sub_data,aes(x=Life.Exp,y=Income,color=Division,size=Murder))+
      annotate("text",x=1,y=5,label="Sorry! The dataset for your selection perference is empty",colour='blue',size=9)
    return(p1)
  }else{
    p3 <- ggparcoord(data =sub_data,                 
                     # Which columns to use in the plot
                     columns = 1:5,                 
                     # Which column to use for coloring data
                     groupColumn = 12,                 
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
    lab_x <- rep(1:4, times = 2) # 2 times, 1 for min 1 for max
    lab_y <- rep(c(min_y - pad_y, max_y + pad_y), each = 4)
    # Get min and max values from original dataset
    lab_z <- c(sapply(sub_data[, 1:4], min), sapply(sub_data[, 1:4], max))
    # Convert to character for use as labels
    lab_z <- as.character(lab_z)
    # Add labels to plot
    p3 <- p3 + annotate("text", x = lab_x, y = lab_y, label = lab_z, size = 3)
    # Display parallel coordinate plot
    return(p3)
  }
}


globalData <- loadData()
shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  
  mysubset <- reactive(
{
  if (length(input$vectorRegion)==4) {
    return( mysubset<-localFrame)
  }
  else {
    return(mysubset<-subset(localFrame,Region %in% input$vectorRegion)   )
  }
}
  )

output$BubblePlot<-renderPlot({
  BubblePlot<-bubble_Plot(
    localFrame,
    mysubset(),
    bubble_size=input$bubblesize,
    vector_Division=input$vectorDivision
  )
  print(BubblePlot)    
})

output$ScatterMatrixPlot<-renderPlot({
  ScatterMatrixPlot<-ScatterMatrix_Plot(
    localFrame,
    mysubset(),
    vector_Division=input$vectorDivision
  )
  print(ScatterMatrixPlot)    
})


output$ParallelCoordinatePlot<-renderPlot({
  ParallelCoordinatePlot<-ParallelCoordinate_Plot(
    localFrame,
    mysubset(),
    vector_Division=input$vectorDivision
  )
  print(ParallelCoordinatePlot)    
})
})


























