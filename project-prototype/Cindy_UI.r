library(shiny)

# Create a shiny page.

  
shinyUI(
  navbarPage("Final Project",
             tabPanel("Historical Sales Trend",
              # Note the use of a different page type. Think of this
              # as a grid with rows and 12 columns.
              fluidPage(
                # These will take up the entire row.
                pageWithSidebar(  
                  # Add title panel.
                  titlePanel("Dress Sales"),
                  
                  # Setup sidebar widgets.
                  sidebarPanel(width=4,
                               h4("Select Preference"),     
                               wellPanel(selectInput(
                                       "style", 
                                       "Style:", 
                                       choices=c("party","casual","work","cute","sexy","brief","bohemian","vintage")
                                      ),
                                      selectInput(
                                        "price", 
                                        "Price:", 
                                        choices= c("Low","Average","Medium","high","very-high")
                                      ),
                                      selectInput(
                                        "size", 
                                        "Size:", 
                                        choices= c("free","S","M","L")
                                      ),
                                      selectInput(
                                        "season", 
                                        "Season:", 
                                        choices= c("Spring","Summer","Automn","Winter")
                                      ),
                                      selectInput(
                                        "material", 
                                        "Material:", 
                                        choices= c("cotton","rayon","silk","lace","chiffonfabric","viscos","polyster","shiffon","null","cashmere")
                                      )
                                      )
                                              
                  ), 
                  #setup main panel
                  mainPanel(
                    #create a tab panel
                    tabsetPanel(
                      tags$head(tags$style("body {background-color: #ADD8E6; }")),
                      #Add a tab for displaying the scatter plot
                      tabPanel("Heatmap", plotOutput("Heatmap",width = "100%", height = "450px")),
                      tabPanel("Multiple Line", plotOutput("Multiple Line",width = "100%", height = "450px"))
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
                    h4("Filtering:"),
                    # Adds a panel with a grey background.
                    wellPanel(
                      # Place inputs inside the panel.
                      sliderInput("month_range", 
                                  "Month Range:",
                                  min = 8, 
                                  max = 10, 
                                  value = c(8,10)
                      ),
                      sliderInput("day_range", 
                                  "Day Range for one month:",
                                  min = 2, 
                                  max = 31, 
                                  value = c(2,31)
                      ) 
                    )
                  ),
                  column(
                    4,
                    h4("Brushing:"),
                    wellPanel(
                      radioButtons(
                        "brush",
                        "Brush by:",
                        c("Price",
                          "Season",
                          "Material",
                          "Style"),
                        selected="Price"
                      )
                    )
                  ),
                  column(
                    4,
                    h4("Color Setting:"),
                    wellPanel(
                      radioButtons(
                        "colorScheme",
                        "Color Scheme:",
                        c("Accent",
                          "Set1",
                          "Pastel1",
                          "Dark2"),
                        selected="Accent"
                      ))
                    )
                  )
                )
              ),
             tabPanel("Relationship Analysis",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Dress Sales"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=4,
                                       h4("Select Preference"),     
                                       wellPanel(selectInput(
                                         "x-axis", 
                                         "X-axis:", 
                                         choices=c("Price","Style","Low","Size","Material","Rating")
                                       ),
                                       selectInput(
                                         "y-axis", 
                                         "Y-axis:", 
                                         choices=c("Style","Price","Low","Size","Material","Rating")
                                       )
                                       )
                                       
                          ), 
                          #setup main panel
                          mainPanel(
                            #create a tab panel
                            tabsetPanel(
                              tags$head(tags$style("body {background-color: #ADD8E6; }")),
                              #Add a tab for displaying the scatter plot
                              tabPanel("Parallel Coordinate", plotOutput("Parallel Coordinate",width = "100%", height = "450px")),
                              tabPanel("Scatter Matrix", plotOutput("Scatter Matrix",width = "100%", height = "450px"))
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
                            h4("Filtering:"),
                            # Adds a panel with a grey background.
                            wellPanel(
                              # Place inputs inside the panel.
                              sliderInput("month_range", 
                                          "Month Range:",
                                          min = 8, 
                                          max = 10, 
                                          value = c(8,10)
                              ),
                              sliderInput("day_range", 
                                          "Day Range for one month:",
                                          min = 2, 
                                          max = 31, 
                                          value = c(2,31)
                              ) 
                            )
                          ),
                          column(
                            4,
                            h4("Brushing:"),
                            wellPanel(
                              radioButtons(
                                "brush",
                                "Brush by:",
                                c("Price",
                                  "Season",
                                  "Material",
                                  "Style"),
                                selected="Price"
                              )
                            )
                          ),
                          column(
                            4,
                            h4("Color Setting:"),
                            wellPanel(
                              radioButtons(
                                "colorScheme",
                                "Color Scheme:",
                                c("Accent",
                                  "Set1",
                                  "Pastel1",
                                  "Dark2"),
                                selected="Accent"
                              ))
                          )
                        )
                      )
             ),
             tabPanel("Trend Prediction",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Dress Sales"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=4,
                                       h4("Select Preference"),     
                                       wellPanel(numericInput(
                                         "future_time", 
                                         "Future time window (days):", 
                                         10
                                       ),
                                       selectInput(
                                         "style", 
                                         "Style:", 
                                         choices=c("party","casual","work","cute","sexy","brief","bohemian","vintage")
                                       ),
                                       selectInput(
                                         "price", 
                                         "Price:", 
                                         choices= c("Low","Average","Medium","high","very-high")
                                       )
                                       )
                                       
                          ), 
                          #setup main panel
                          mainPanel(
                            #create a tab panel
                            tabsetPanel(
                              tags$head(tags$style("body {background-color: #ADD8E6; }")),
                              #Add a tab for displaying the scatter plot
                              tabPanel("Time Series Sales Prediction", plotOutput("time series",width = "100%", height = "450px")),
                              tabPanel("Random Forest for Prediction", plotOutput("random forest",width = "100%", height = "450px"))
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
                            h4("Filtering Historical Data:"),
                            # Adds a panel with a grey background.
                            wellPanel(
                              # Place inputs inside the panel.
                              sliderInput("month_range", 
                                          "Month Range:",
                                          min = 8, 
                                          max = 10, 
                                          value = c(8,10)
                              ),
                              sliderInput("day_range", 
                                          "Day Range for one month:",
                                          min = 2, 
                                          max = 31, 
                                          value = c(2,31)
                              ) 
                            )
                          ),
                          column(
                            4,
                            h4("Brushing:"),
                            wellPanel(
                              radioButtons(
                                "brush",
                                "Brush by:",
                                c("Price",
                                  "Season",
                                  "Material",
                                  "Style"),
                                selected="Price"
                              )
                            )
                          ),
                          column(
                            4,
                            h4("Color Setting:"),
                            wellPanel(
                              radioButtons(
                                "colorScheme",
                                "Color Scheme:",
                                c("Accent",
                                  "Set1",
                                  "Pastel1",
                                  "Dark2"),
                                selected="Accent"
                              ))
                          )
                        )
                      )
             )
  )
)



  
 