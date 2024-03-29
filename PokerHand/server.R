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

shinyServer(function(input, output) {
    mydata = read.csv("training.data")
    colnames(mydata) <- c("S1", "C1", "S2", "C2", "S3", "C3", "S4", "C4", "S5", "C5", "CLASS")
    
    class_probability <- reactive ({ mydata %>%
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
    
    cardValue <- round(colMeans(mydata), 2)
    
    cardValue <- data.frame(cardNumber = as.factor(c(1, 2, 3, 4, 5)), value = cardValue[c("C1", "C2", "C3", "C4", "C5")])
    
    output$cardValue <- renderPlot({
        ggplot(cardValue, aes(x = cardNumber, y = value, fill = cardNumber)) +
            geom_bar(stat = "identity", color = "white", width=0.8) +
            geom_text(aes(label=value), vjust=1.6, color="white", size=3.5)
    })
    
    suit <- c(mydata$S1, mydata$S2, mydata$S3, mydata$S4, mydata$S5)
    
    suitsCount <- as.data.frame(table(suit))
    suitsCount$suit <- as.factor(c("Hearts", "Spades", "Diamonds", "Clubs"))
    
    output$suitsCount <- renderPlot({
        ggplot(suitsCount, aes(x = suit, y = Freq, fill = suit)) +
            geom_bar(stat = "identity", color = "white", width=0.8) +
            geom_text(aes(label=Freq), vjust=1.6, color="white", size=3.5)
    })
    
    output$firstCardScatter <- renderPlot({
        ggplot(mydata, aes(x=C1, y=S1)) + geom_point()
    })
})
