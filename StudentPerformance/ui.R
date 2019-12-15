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

shinyUI(dashboardPage(
    dashboardHeader(title = "Students math results"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Final grade", tabName = "finalGrade", icon = icon("chart-bar")),
            menuItem("Correlation", tabName = "correlation", icon = icon("circle")),
            menuItem("School", tabName = "school", icon = icon("school")),
            menuItem("Final grade factors", tabName = "finalGradeFactors", icon = icon("user-graduate"))
            
        )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "finalGrade",
                    fluidRow(
                        box(width = 12, sliderInput(inputId = "bins",
                                                    label = "Number of bins:",
                                                    min = 2,
                                                    max = 20,
                                                    value = 10)
                            
                        )
                    ),
                    fluidRow(
                        box(width = 12, plotOutput("finalGrade", height = 350))
                    ),
                    fluidRow(
                        box(width = 12, plotOutput("finalGradeBox", height = 350))
                    )
            ),
            tabItem(tabName = "correlation",
                    fluidRow(
                        box(width = 12, plotOutput("correlation", height = 550))
                    )
            ),
            tabItem(tabName = "school",
                    fluidRow(
                        box(width = 6, plotOutput("schoolSex", height = 350)),
                        box(width = 6, plotOutput("schoolSup", height = 350))
                    ),
                    fluidRow(
                        box(width = 6, plotOutput("schoolAddress", height = 350)),
                        box(width = 6, plotOutput("schoolGrade", height = 350))
                    )
                  
  
            ),
            tabItem(tabName = "finalGradeFactors",
                    fluidRow(
                        box(width = 6, plotOutput("finalGradeFailures", height = 350)),
                        box(width = 6, plotOutput("finalGradeHigher", height = 350))
                    )
                    
            )
        )
    )
))

