#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("sizepoint",
                     "Point Size:",
                     min = 1,
                     max = 10,
                     value = 5)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      # generate bins based on input$bins from ui.R
      #x    <- faithful[, 2] 
      #bins <- seq(min(x), max(x), length.out = input$sizepoint + 1)
      
      # draw the histogram with the specified number of bins
      ggplot(faithful,aes(x=eruptions,y=waiting),colour = 'gray')+geom_point(size=input$sizepoint)
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

