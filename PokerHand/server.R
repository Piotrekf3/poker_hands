#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)

getValue <- function(keys, values) {
    result <- c()
    keys <- paste(keys)
    for(value in values) {
        if(any(startsWith(value, keys))) {
            result <- append(result, value)
        }
    }
    return(result)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    mydata = read.csv("training.data")
    colnames(mydata) <- c("S1", "C1", "S2", "C2", "S3", "C3", "S4", "C4", "S5", "C5", "CLASS")
    
    class_probability = reactive ({ mydata %>%
        group_by(CLASS) %>%
        summarise(n = n()) %>%
        mutate(freq = round(n / sum(n), 6))%>%
        filter(CLASS %in% input$classes) %>%
        mutate(CLASS = as.factor(getValue(input$classes, c("0: Nothing in hand; not a recognized poker hand",
                                   "1: One pair; one pair of equal ranks within five cards",
                                   "2: Two pairs; two pairs of equal ranks within five cards",
                                   "3: Three of a kind; three equal ranks within five cards",
                                   "4: Straight; five cards, sequentially ranked with no gaps",
                                   "5: Flush; five cards with the same suit",
                                   "6: Full house; pair + different rank three of a kind",
                                   "7: Four of a kind; four equal ranks within five cards",
                                   "8: Straight flush; straight + flush",
                                   "9: Royal flush; {Ace, King, Queen, Jack, Ten} + flush"))))    
        }) 
    

    
    output$classProbability <- renderPlot({
        ggplot(class_probability(), aes(x = CLASS, y = freq, fill = CLASS)) +
            geom_bar(stat = "identity", color = "white", width=1.5) +
            geom_text(aes(label=freq), vjust=1.6, color="white", size=3.5)+
            theme_void()
    })
    

})
