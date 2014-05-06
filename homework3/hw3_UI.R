library(shiny)

# Create a shiny page.
shinyUI(
  # create a page with a sidebar for input.
  pageWithSidebar(  
    # Add title panel.
    titlePanel("State"),
    
    # Setup sidebar widgets.
    sidebarPanel(width=3,
                 h4("Select Preference"),     
                 wellPanel(
                   div(class="row",
                       div(class="span1"),
                       div(class="span4",radioButtons(
                         "vectorDivision", 
                         "Division:", 
                         c("All", "New England","Middle Atlantic","South Atlantic","East South Central","West South Central","East North Central","Mountain","Pacific","East North Central"))),
                       div(class="span6",checkboxGroupInput(
                         "vectorRegion",
                         "Region:",
                         c("Northeast","South","North Central","West"),
                         selected=c("Northeast","South","North Central","West"))))), 

                 
                 #Add a slider input from 1 to 10 that controls the size of the dots in the scatterplot
                 sliderInput("bubblesize",
                             "Bubble Size:",
                             min=5,
                             max=20,
                             value=10,
                             step=5)
    ), 
    
    #setup main panel
    mainPanel(
      #create a tab panel
      tabsetPanel(
        #Add a tab for displaying the scatter plot
        tabPanel("Bubble Plot", plotOutput("BubblePlot",width = "100%", height = "450px")),
        tabPanel("ScatterMatrix Plot", plotOutput("ScatterMatrixPlot",width = "100%", height = "450px")),
        tabPanel("ParallelCoordinate Plot", plotOutput("ParallelCoordinatePlot",width = "100%", height = "450px"))
      )
    )
  )
)

