library(shiny)

# Create a shiny page.


shinyUI(
  navbarPage("Final Project",
             tabPanel("Search",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Search"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=3,
                                       h4("Select Preference"),     
                                       wellPanel(                              
                                         selectInput(
                                           "style", 
                                           "Style:", 
                                           choices=c("Casual","party","work","cute","Sexy","Brief","bohemian","vintage")
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
                                           choices= c("Summer","Spring","Automn","Winter")
                                         ),
                                         selectInput(
                                           "material", 
                                           "Material:", 
                                           choices= c("cotton","rayon","silk","lace","chiffonfabric","viscos","polyster","shiffon","null","cashmere")
                                         ),
                                         helpText("Note: There may not be a dress satisfy your perference due to the limited database,",
                                                  "however, for any preference you set to select a dress, the 'Recommendation' page will give you advice about whether this dress is recommended by other customers or not.",
                                                  "Please copy the Dress_ID you interested in to explore it in other pages.")
                                         
                                       )), 
                          #setup main panel
                          mainPanel(
                            #create a tab panel
                            tabsetPanel(
                              tags$head(tags$style("body {background-color: #ADD8E6; }")),
                              tabPanel('Sales',dataTableOutput("mytable")),
                              tabPanel('Features',dataTableOutput("mytable2")),
                              tabPanel('Recommendation',dataTableOutput("mytable3")),
                              tabPanel('Dress ID',tableOutput("Dress_ID"))
                            )
                          )
                        )
                      )
             ),
             
             tabPanel("Historical Sales Trend",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Dress Sales"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=3,
                                       h4("Select Preference"),     
                                       wellPanel(
                                         textInput(
                                           "DressID", 
                                           "Dress_ID:", 
                                           1160536550
                                         ),
                                         checkboxInput(
                                           "FACETPLOT", 
                                           "Facet Plot", 
                                           value=FALSE
                                         ),
                                         checkboxInput(
                                           "STARLIKEPLOT", 
                                           "STAR-LIKE PLOT", 
                                           value=FALSE
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
                              tabPanel("Multiple Line",
                                       plotOutput("MultipleLine",width = "100%", height = "450px")
                              )
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
                              sliderInput("monthrange", 
                                          "Month Range:",
                                          min = 4, 
                                          max = 10, 
                                          value = c(4,10)
                              ),
                              sliderInput("dayrange", 
                                          "Day Range for one month:",
                                          min = 2, 
                                          max = 30, 
                                          value = c(2,30)
                              ) 
                            )
                          ),
                          column(
                            4,
                            h4("Brushing:"),
                            wellPanel(
                              checkboxGroupInput(
                                "Month", 
                                "Month:", 
                                c('Apr','May',"Jun",'Jul','Aug','Sep','Oct'),
                                selected=c('Apr','May','Jun','Jul','Aug','Sep','Oct')
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
             tabPanel("Features Relationship Analysis",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Dress Sales"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=3,
                                       h4("Select Preference"),     
                                       wellPanel(selectInput(
                                         "xaxis", 
                                         "X-axis:", 
                                         choices=c("Price","Size","NeckLine","SleeveLength","waiseline")
                                       ),
                                       selectInput(
                                         "yaxis", 
                                         "Y-axis:", 
                                         choices=c("Size","Price","NeckLine","SleeveLength","waiseline")
                                       ),
                                       selectInput(
                                         "fillby", 
                                         "Fill by:", 
                                         choices=c("Season","Style","Price","Size","Material")
                                       )
                                       )
                                       
                          ), 
                          #setup main panel
                          mainPanel(width=9,
                                    #create a tab panel
                                    tabsetPanel(
                                      tags$head(tags$style("body {background-color: #ADD8E6; }")),
                                      #Add a tab for displaying the scatter plot
                                      tabPanel("Box Plot", plotOutput("BoxPlot",width = "100%", height = "450px")),
                                      tabPanel("Mosaic", plotOutput("MosaicPlot",width = "100%", height = "450px"))
                                    )
                          )
                        )
                      )
                    ),

             tabPanel("Prediction",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(
                        # These will take up the entire row.
                        pageWithSidebar(  
                          # Add title panel.
                          titlePanel("Dress Sales"),
                          
                          # Setup sidebar widgets.
                          sidebarPanel(width=3,
                                       h4("Select Preference"),     
                                       wellPanel(textInput(
                                         "future_time", 
                                         "Future time window (days):", 
                                         '10'
                                       ),
                                       textInput(
                                         "DressID", 
                                         "Dress_ID:", 
                                         1160536550
                                       )
                                       )
                                       
                          ), 
                          #setup main panel
                          mainPanel(
                            #create a tab panel
                            tabsetPanel(
                              tags$head(tags$style("body {background-color: #ADD8E6; }")),
                              #Add a tab for displaying the scatter plot
                              tabPanel("Time Series",
                                       column(9,plotOutput("TimeSeries2")),
                                       column(3,tableOutput("TimeSeries"))
                              ),
                              tabPanel("Random Forest for Prediction", plotOutput("RandomForest",width = "100%", height = "450px"))
                            )
                          )
                        )
                        )
                      ),
                        

             tabPanel("Recommendation",
                      # Note the use of a different page type. Think of this
                      # as a grid with rows and 12 columns.
                      fluidPage(titlePanel("DIY Dress Style"),
                                mainPanel(width=10,
                                          #create a tab panel
                                          tabsetPanel(
                                            tags$head(tags$style("body {background-color: #ADD8E6; }"))),
                                          fluidRow(
                                            column(3,
                                                   radioButtons("Season",label="Season",
                                                                      list('Automn','spring','summer','winter'))),
                                            
                                            column(3,
                                                   radioButtons("Price",label="Price",
                                                                      list('Average','high','low','Medium','very-high'))),
                                            column(3,
                                                   radioButtons("waiseline",label="waiseline",
                                                                      list('dropped','empire','natural','princess','null')
                                                                     ))),
                                          hr(),
                                          
                                          fluidRow(  
                                            column(3,
                                                   radioButtons("Size",label="Size",
                                                                      list('free','L','M','s',"XL"))),
                                            column(3, 
                                                   radioButtons("SleeveLength",label="SleeveLength",
                                                                      list('sleeveless','halfsleeve','full','capsleeves',
                                                                                   'short'))),  
                                            column(3,
                                                   radioButtons("NeckLine",label="NeckLine",
                                                                      list('o-neck','v-neck','boat-neck','bowneck',
                                                                                   'slash-neck','sweetheart'))),
                                            column(3,
                                                   selectInput("Material",label="Material",
                                                               choices=c('cotton','mix','knitting','lace',
                                                                         'silk','null',
                                                                         'rayon','nylon','other'))),
                                            
                                            column(3,
                                                   selectInput("Style",label="Style",
                                                               choices=c('Casual','Brief','bohemian','cute','fashion',
                                                                         'Flare','Novelty','OL','party','sexy'))),
                                            
                                            column(3, 
                                                   selectInput("FabricType",label="FabricType",
                                                               choices=c('chiffon','worsted','broadcloth','sattin',
                                                                         'jersey','dobby','poplin')
                                                   ))),
                                          hr(),
                                          fluidRow(
                                            column(3,
                                                   selectInput("Decoration",label="Decoration",
                                                               choices=c('null','beading','lace','bow',
                                                                         'sashes','pockets')
                                                   )),
                                            
                                            column(3,
                                                   selectInput("Pattern.Type",label="Pattern.Type",
                                                               choices=c('solid','null','print','animal',
                                                                         'striped','dot','plaid')
                                                   )),
                                            
                                            column(5,
                                                   sliderInput("Rating","Rating",
                                                               min=4.0,
                                                               max=5.0,
                                                               value=4.5,
                                                               step=0.1
                                                               
                                                               
                                                   ))),
                                          br(),
                                          
                                          tags$style(type='text/css','#text {background-color: rgba(255,255,0,0.40); color: red;}'), 
                                          tabPanel("Advice",verbatimTextOutput("text"))
                                          
                                          
                                )
                                
                      )
             )
  )
)



