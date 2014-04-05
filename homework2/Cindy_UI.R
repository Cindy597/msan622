library(shiny)

# Create a shiny page.
shinyUI(
  # create a page with a sidebar for input.
  pageWithSidebar(  
    # Add title panel.
    titlePanel("IMDB Movie Ratings"),
    
    # Setup sidebar widgets.
    sidebarPanel(width=3,
                 h4("Select Preference"),     
                 wellPanel(
                   div(class="row",
                       div(class="span1"),
                       div(class="span4",radioButtons(
                         "vectormpaa", 
                         "MPAA Rating:", 
                         c("All", "NC-17","PG","PG-13","R"))),
                       div(class="span6",checkboxGroupInput(
                         "vectorgenre",
                         "Movie Genres:",
                         c("Action","Animation","Comedy","Drama","Documentary","Romance","Short"),
                         selected=NULL)))), 
                 
                 #Add a checkbox that allows the user to choose whether add regression line on scatter plot or not
                 checkboxInput("smooth","Smooth",TRUE),
                 
                 #Add a drop-down box that allows the user to choose the scatter plot will color by which variable
                 selectInput(
                   "colorby", 
                   "Color By:",
                   choices=c("mpaa","genre"),
                   selected="mpaa"),
                 
                 #Add a drop-down box that allows the user to change color schemes
                 selectInput(
                   "colorscheme", 
                   "Color Scheme:",
                   choices=c("Default","Accent","Set1","Set2","Set3","Dark2","Pastel1","Pastel2"),
                   selected="Default"),
                 
                 #Add a slider input from 1 to 10 that controls the size of the dots in the scatterplot
                 sliderInput("dotsize",
                             "Dot Size:",
                             min=1,
                             max=10,
                             value=4,
                             step=1),
                 #Add a slider input from 0.1 to 1.0 thay steps by 0.1 and controls the alpha value of the dots in scatter plot
                 sliderInput("dotalpha",
                             "Dot Alpha:",
                             min=0.1,
                             max=1,
                             value=0.8,
                             step=0.1)
    ), 
    
    #setup main panel
    mainPanel(
      #create a tab panel
      tabsetPanel(
        #Add a tab for displaying the scatter plot
        tabPanel("Scatter Plot", plotOutput("ScatterPlot",width = "100%", height = "400px")),
        #Add a tab for displaying the table
        tabPanel("Table",tableOutput("table"))
      )
    )
  )
)

