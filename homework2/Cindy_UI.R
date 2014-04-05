library(ggplot2)
library(shiny)
library(scales)

#create a function for loading and transforming data
loadData <- function(){
  data("movies", package = "ggplot2")
  head(movies)
  #Filter out any rows that do not have a valid budget value greater than 0
  movies<-subset(movies, movies$budget>0)
  #Filter out any rows that do not have a valid MPAA rating in the mpaa column
  movies<-subset(movies,as.character(movies$mpaa)!="")
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
  movies$budget<-movies$budget/1000000
  return(movies)
}

#create a plot function to get scatter plot which has budget on the x-axis, IMDB rating 
#on the y-axis, and dots colored by the mpaa rating
myPlot<-function(localFrame,genredata,vector_mpaa,dot_size,dot_alpha,color_scheme,check_smooth,color_by){
  if (nrow(genredata)==0){
    p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
      +ggtitle("Sorry! Dataset is empty"))
    return (p)
  }else{
    if (color_by =="mpaa"){
      if (vector_mpaa=="All"){
        sub_movies<-genredata 
      } else{
        sub_movies<-genredata[as.character(genredata$mpaa)==vector_mpaa,]
      }
      if (color_scheme=="Default"){
        if(check_smooth==T){
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(mpaa)),size=dot_size,alpha=dot_alpha)+
            geom_smooth(method=lm)+
            scale_x_continuous(labels = dollar)+
            labs(colour='MPAA')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))
          return(p1)
        }else{
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(mpaa)),size=dot_size,alpha=dot_alpha)+
            scale_x_continuous(labels = dollar)+
            labs(colour='MPAA')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))
          return(p1)      
        }
      } else{
        if (check_smooth==T){
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(mpaa)),size=dot_size,alpha=dot_alpha)+
            geom_smooth(method=lm)+
            scale_x_continuous(labels = dollar)+
            labs(colour='MPAA')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))+
            scale_color_brewer(palette = color_scheme)
          return(p1)  
        }else{
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(mpaa)),size=dot_size,alpha=dot_alpha)+
            scale_x_continuous(labels = dollar)+
            labs(colour='MPAA')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))+
            scale_color_brewer(palette = color_scheme)
          return(p1)
        }
      }
    }else{
      if (vector_mpaa=="All"){
        sub_movies<-genredata 
      } else{
        sub_movies<-genredata[as.character(genredata$mpaa)==vector_mpaa,]
      }
      if (color_scheme=="Default"){
        if(check_smooth==T){
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(genre)),size=dot_size,alpha=dot_alpha)+
            geom_smooth(method=lm)+
            scale_x_continuous(labels = dollar)+
            labs(colour='Genre')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))
          return(p1)
        }else{
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(genre)),size=dot_size,alpha=dot_alpha)+
            scale_x_continuous(labels = dollar)+
            labs(colour='Genre')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))
          return(p1)      
        }
      } else{
        if (check_smooth==T){
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(genre)),size=dot_size,alpha=dot_alpha)+
            geom_smooth(method=lm)+
            scale_x_continuous(labels = dollar)+
            labs(colour='Genre')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))+
            scale_color_brewer(palette = color_scheme)
          return(p1)  
        }else{
          p1<-ggplot(sub_movies,aes(x=budget,y=rating))+
            geom_point(aes(colour=factor(genre)),size=dot_size,alpha=dot_alpha)+
            scale_x_continuous(labels = dollar)+
            labs(colour='Genre')+
            ggtitle("Movie Rating versus Budget")+
            xlab("Budget (in Million)")+
            ylab("Rating")+
            theme(text = element_text(size = 15, colour = "blue"))+
            scale_color_brewer(palette = color_scheme)
          return(p1)
        }
      }
    }
  }
}

globalData <- loadData()

shinyServer(function(input, output) {
  
  cat("Press \"ESC\" to exit...\n")
  localFrame <- globalData  
  
  genre_data <- reactive(
{
  if (length(input$vectorgenre)==0) {
    return( genredata<-localFrame)
  }
  else {
    return(genredata<-subset(localFrame,genre %in% input$vectorgenre)   )
  }
}
  )
output$table<-renderTable({
  if (input$vectormpaa=="All"){
    mydata<-genre_data()
    return(mydata[,c(1,2,4,5,17,18,19,20,21,22,23,24,25)])
  } else{
    data<-genre_data()
    mydata<-data[as.character(data$mpaa)==input$vectormpaa,]
    return(mydata[,c(1,2,4,5,17,18,19,20,21,22,23,24,25)])
  }
},include.rownames = FALSE)

output$ScatterPlot<-renderPlot({
  ScatterPlot<-myPlot(
    localFrame,
    genre_data(),
    vector_mpaa=input$vectormpaa,
    dot_size=input$dotsize,
    dot_alpha=input$dotalpha,
    color_scheme=input$colorscheme,
    check_smooth=input$smooth,
    color_by=input$colorby
  )
  print(ScatterPlot)    
})
})


