library(shiny)

# Define UI for application that draws a histogram
shinyUI
(
    fluidPage(
  
        # Application title
        titlePanel("Predict your child's height, from your and your partner's height"),
  
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
            sidebarPanel(
                sliderInput(
                    "userHeight",
                    "Your height in centimeters:",
                    min = 50,
                    max = 300,
                    value = 180,
                    step = 1
                ),
                radioButtons(
                    "userSex",
                    "Please specify your sex:",
                    c("Male" = "male", "Female" = "female"),
                    selected = "male"
                ),
                sliderInput(
                    "partnerHeight",
                    "Your partner's height in centimeters:",
                    min = 50,
                    max = 300,
                    value = 170,
                    step = 1
                ),
                radioButtons(
                    "partnerSex",
                    "Please specify your partner's sex:",
                    c("Male" = "male", "Female" = "female"),
                    selected = "female"
                )
            ),
            
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("parentChildPlot"),
                textOutput("pheight"),
                textOutput("cheight"),
                textOutput("status"),
                tags$head(tags$style("#status{color: red}"))
            )
        )
    )
)
