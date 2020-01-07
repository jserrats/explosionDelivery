library(shiny)

library(xml2)
x = read_xml('../WAS_Results_scan_18633864.xml')
results = xml_children(x)[[3]]
re= as_list(results)

# list containing the vul list section of the xml. Each entry is a different vuln
vl= re[["VULN_LIST"]]

# list of ports
ports = vector("numeric",length(vl))

for(i in 1:length(vl)){
  ports[i]<-strtoi(x = vl[[i]][[4]][[1]][[2]], base = 0L)
}


titles <- vector(mode="character", length=10)
for(i in 1:length(vl)){
  ports[i]<-strtoi(x = vl[[i]][[4]][[1]][[2]], base = 0L)
}

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Qualys report summary"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
      
    ),

    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)

server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    View(faithful$waiting)
    
    x <-ports 
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

shinyApp(ui = ui, server = server)