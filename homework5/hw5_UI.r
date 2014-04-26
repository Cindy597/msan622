library(shiny)

# Create a shiny page.

  
shinyUI(
  # Note the use of a different page type. Think of this
  # as a grid with rows and 12 columns.
  fluidPage(
    # These will take up the entire row.
    pageWithSidebar(  
      # Add title panel.
      titlePanel("Seatbelts"),
      
      # Setup sidebar widgets.
      sidebarPanel(width=4,
                   h4("Select Preference"),     
                   wellPanel(checkboxGroupInput(
                           "variables", 
                           "Select Variables:", 
                           c("drivers","front","rear","DriversKilled","VanKilled"),
                           selected=c("front","rear","drivers")))
                                  
      ), 
      #setup main panel
      mainPanel(
        #create a tab panel
        tabsetPanel(
          tags$head(tags$style("body {background-color: #ADD8E6; }")),
          #Add a tab for displaying the scatter plot
          tabPanel("Area Chat", plotOutput("AreaChat",width = "100%", height = "450px")),
          tabPanel("Heatmap", plotOutput("Heatmap",width = "100%", height = "450px"))
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
          sliderInput("year_range", 
                      "Year Range:",
                      min = 1969, 
                      max = 1984, 
                      value = c(1970,1980)
          ),
          sliderInput("Distance_range", 
                      "Distance Range:",
                      min = 7685, 
                      max = 21626, 
                      value = c(7685,21626)
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
            selected="Accent"
          )
        )
      ),
      column(
        4,
        h4("Instruction:"),
        wellPanel(
          helpText("All three techniques are linked. 
                   Please select any setting preference to see the
                   changes of all three techniques")
           )
          )
        )
      )
    )



  
 