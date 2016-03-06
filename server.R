library(shiny)
library(UsingR)
library(ggplot2)

fit <- lm(sheight~fheight,data=father.son)

in2cm <- function(inches) {inches/0.39370}

cm2in <- function(cm) {cm * 0.39370}

getChildHeight <- function(lmfit, newData) {
    predict(lmfit, data.frame(fheight = c(newData)), interval = "prediction")
}


getParentHeight <- function (uSex, pSex, uHeight, pHeight)
{
    if (uSex == 'female' && pSex == 'male') {
        fheight <- uHeight * 1.08;
        mheight <- pHeight;
    }
    else {
        fheight <- pHeight * 1.08;
        mheight <- uHeight;
    }
    
    midHeight <- mean(c(mheight,fheight))
    midHeight
}

# Define server logic required to draw a histogram
shinyServer
( 
    function(input, output) {
        
        midHeight <- reactive({as.numeric(getParentHeight(input$userSex,input$partnerSex, 
                                               input$userHeight, input$partnerHeight))})
        childHeightPrediction <- reactive({getChildHeight(fit, cm2in(midHeight()))})
        childHeight <- reactive({as.numeric(round(in2cm(childHeightPrediction()[1]), 1))})
        stdError <- reactive({as.numeric(round(in2cm(childHeightPrediction()[1] - 
                                                     childHeightPrediction()[2]),1))})
        
        output$parentChildPlot <- renderPlot({
            
            g <- ggplot(father.son, aes(x = in2cm(fheight), y = in2cm(sheight))) + 
                 geom_point(alpha = 0.2, size = 3) + xlab("Parents' adjusted average height (cm)") +
                 ylab("Child's height (cm)") + 
                 geom_smooth(method = "lm", se=TRUE, color="black", formula = y ~ x)
            
            if (input$userSex != input$partnerSex) {
                g <- g + geom_vline(xintercept=c(midHeight()), linetype="dotted", col="red", size = 1) +
                     geom_hline(yintercept = c(childHeight()), linetype = "dotted", col="red", size = 1) +
                     geom_point(aes(x = midHeight(), y = childHeight()), col = 'red', size = 3)
            }
            
            g
        })
        
        output$pheight <- renderText({
            paste("Parents' adjusted average height: ", midHeight(), " cm.")
        })
        
        output$cheight <- renderText({
            
            if (input$userSex != input$partnerSex) {
                output <- paste("Predicted child's height: ", childHeight(), " +/- ", stdError(), " cm.")
            }
            else {
                output <- paste("Unfortunately script doesn't work for same sex couples.")
            }

            output
        })
        
        output$status <- renderText({
            
            if (((midHeight() < 150) || (midHeight() > 192)) && (input$userSex != input$partnerSex)) {
                message <- paste("PREDICTION UNRELIABLE, IT IS OUTSIDE OF THE DATA CLOUD!")
            }
            else {
                message <- paste("")
            }
            
            message
        })
    }
)
