library(shiny)

# Create a shiny page.

  
shinyUI(
  navbarPage("Dress",
             tabPanel("Historical Sales Trend",
              fluidPage(
                # These will take up the entire row.
                pageWithSidebar(                    
                  # Setup sidebar widgets.
                  sidebarPanel(width=4,
                               h4("Select Preference"),     
                               wellPanel(
                                 div(class="row",
                                     div(class="span1"),
                                     div(class="span4",checkboxGroupInput(
                                       "variables", 
                                       "Select Variables:", 
                                       c("Population","Income","Illiteracy","Life.Exp","Murder","HS.Grad","Frost"),
                                       selected=c("Illiteracy","Income"))),
                                     div(class="span6",checkboxGroupInput(
                                       "vectorRegionhighlight",
                                       "Brushing:",
                                       c("Northeast","South","North Central","West"),
                                       selected=c("Northeast","South","North Central","West"))))), 
                               
                               
                               #Add a slider input from 1 to 10 that controls the size of the dots in the scatterplot
                               sliderInput("bubblesize",
                                           "Bubble/Point Size:",
                                           min=2,
                                           max=4,
                                           value=3,
                                           step=1)
                  ), 
                  #setup main panel
                  mainPanel(
                    #create a tab panel
                    tabsetPanel(
                      tags$head(tags$style("body {background-color: #ADD8E6; }")),
                      #Add a tab for displaying the scatter plot
                      tabPanel("Bubble Plot", plotOutput("BubblePlot",width = "100%", height = "450px")),
                      tabPanel("ScatterMatrix Plot", plotOutput("ScatterMatrixPlot",width = "100%", height = "450px")),
                      tabPanel("ParallelCoordinate Plot", plotOutput("ParallelCoordinatePlot",width = "100%", height = "450px"))
                    )
                  )
                ),
             
                # Add an horizontal line divider.
                hr(),
                # If you want to specify columns, you need to first
                # explicitly create a row.
                fluidRow(
                  # Now we can create a column, which can span
                  # multiple columns (out of 12) if we want.
                  column(
                    # Number of columns to span.
                    4,
                    # Elements to place into this column.
                    h4("Filtering"),
                    # Adds a panel with a grey background.
                    wellPanel(
                      # Place inputs inside the panel.
                      sliderInput("population_range", 
                                  "Population Range:",
                                  min = 365, 
                                  max = 21198, 
                                  value = c(400,20000)
                      ),
                      sliderInput("income_range", 
                                  "Income Range:",
                                  min = 3098, 
                                  max = 6315, 
                                  value = c(3100,6300)
                      )          
                    )
                  ),
                  column(
                    4,
                    h4("Color Settings"),
                    wellPanel(
                      radioButtons(
                        "colorScheme",
                        "Color Scheme:",
                        c("Accent",
                          "Set1",
                          "Pastel1",
                          "Dark2"),
                        selected="Set1"
                      )
                    )
                  ),
                  column(
                    4,
                    h4("Instruction:"),
                    wellPanel(
                      helpText("1.All three techniques are linked. 
                               Please select any setting preference to see the
                               changes of all three techniques;       
                               2.Please select reasonable Population and Income
                               range to avoid error;
                               3.Please only select two variables for Bubble Plot;
                               4.Please select at least two variables for ScatterMatrix 
                               and ParallelCoordinate Plots")
                       )
            )
          )
        )
      )
  　)
　)



  
 