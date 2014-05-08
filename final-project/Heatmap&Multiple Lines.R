
#heatmap and multiple lines

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
        palette = "Set1")(5),
      name = "Sales",
      limits = c(0,max),
      breaks = c(0,second ,max)
    )
  )
}

#heatmap
require(ggplot2)
require(grid)
require(scales)

# CREATE BASE PLOT ####################



max<-max(subset(subdata, variable == "676827184")$value)
p <- ggplot(
  subset(subdata, variable == "676827184"), 
  aes(x = Day, y =Month )
)

p <- p + geom_tile(
  aes(fill = value), 
  colour = "white"
)

p <- p + scale_prgn(max)
#p <- p + scale_months()
p <- p + scale_y_discrete(expand = c(0, 0))
p <- p + theme_heatmap()

p <- p + coord_polar()
p <- p + coord_fixed(ratio = 1)
print(p)









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

p <- ggplot(
  subset(subdata, variable == "676827184"), 
  aes(
    x = Day, 
    y = value, 
    group = factor(Month), 
    color = factor(Month)
  )
)

# CREATE MULTI-LINE PLOT ##############
p <- p + geom_line(alpha = 0.8)
p <- p + scale_colour_brewer(palette = "Set1")

# make it pretty
#p <- p + scale_months()
#p <- p + scale_deaths()
p <- p + theme_legend()
p <- p + theme_guide()


# squarify grid (1 month to 1000 deaths)
p <- p + coord_fixed(ratio = 1 / 10)

# CREATE FACET PLOT ###################
#p <- p + facet_wrap(~ Month, ncol = 2)
#p <- p + theme(legend.position = "none")

# CREATE STAR-LIKE PLOT ###############
p <- p + coord_polar()
print(p)





