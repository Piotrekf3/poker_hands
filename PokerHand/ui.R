#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
    dashboardHeader(title = "Poker Hands"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Class probability", tabName = "classProbability", icon = icon("chart-pie"))
            
        )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "classProbability",
                    fluidRow(
                        box(width = 12, h1("Probability of certain poker hand"))  
                    ),
                    fluidRow(
                        box(width = 12, plotOutput("classProbability", height = 550))
                    ),
                    fluidRow(
                        box(width = 12, checkboxGroupInput("classes", "Pick classes:", choiceNames = 
                                                      c("0: Nothing in hand; not a recognized poker hand",
                                                        "1: One pair; one pair of equal ranks within five cards",
                                                        "2: Two pairs; two pairs of equal ranks within five cards",
                                                        "3: Three of a kind; three equal ranks within five cards",
                                                        "4: Straight; five cards, sequentially ranked with no gaps",
                                                        "5: Flush; five cards with the same suit",
                                                        "6: Full house; pair + different rank three of a kind",
                                                        "7: Four of a kind; four equal ranks within five cards",
                                                        "8: Straight flush; straight + flush",
                                                        "9: Royal flush; {Ace, King, Queen, Jack, Ten} + flush"),
                                                      choiceValues = c(
                                                          0, 1, 2, 3, 4, 5, 6, 7, 8, 9
                                                      )))
                    )
            )
        )
    )
))

