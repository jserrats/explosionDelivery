fluidPage(
  # Application title
  titlePanel("Data Table"),
  
  p("First we have parsed all the data from the XML of Qualys in order to make it accessible and more readable"),
  
  DT::dataTableOutput("vulns"),
  hr(),
  
  titlePanel("Bar Plot"),
  p("Then we analized all the data and ploted it to compare the same variables between them"),
  selectInput("param","Parameter", choices=colnames(DF)),
  mainPanel(width = "100%", plotOutput("barPlot")),
  
  titlePanel("Word Cloud"),
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot"),
    )
  ),
  
  titlePanel("Localitzation of the IPs"),
  p("Finally we locate in the map the origin of the IPs in the data. This could be very usefull for example to know from where attacks come. With the working data set the the only host evaluated is Qualys's so we made a random IPs data set to show the functionality, just check the Fake data below."),
  leafletOutput(outputId = "mymap", height =800), # output the map
  checkboxInput("fakeData", "Fake Data", FALSE)
  
  
)