#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(polycor)
library(corrplot)
library(reshape2)
library(ggplot2)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    mydata <- read.table(
        "student.csv", sep = ";",
        header = TRUE
    )
    
    x <- mydata$G3
    bins <- reactive({seq(min(x), max(x), length.out = input$bins + 1)})
    output$finalGrade <- renderPlot({
        hist(x, 
             main="Final grade histogram",
             xlab="Final grade",
             breaks = bins()
        )
    })
    
    output$finalGradeBox <- renderPlot({
        boxplot(mydata$G3)
    })
    
    cor <- hetcor(mydata)
    correlations <- cor[["correlations"]]
    
    output$correlation <- renderPlot({
        corrplot(correlations, type = "upper", tl.srt = 45, tl.col = "black")
    })
    
    mydata.school.sex <- mydata %>%
        select(c("school", "sex")) %>%
        count(school, sex)
    
    output$schoolSex <- renderPlot({
        ggplot(mydata.school.sex, aes(x = school, y = n, fill = sex, label = n)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Number of students by school and sex")
    })
    
    mydata.school.schoolsup <- mydata %>%
        select(c("school", "schoolsup")) %>%
        count(school, schoolsup)
    
    output$schoolSup <- renderPlot({
        ggplot(mydata.school.schoolsup, aes(x = school, y = n, fill = schoolsup, label = n)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Extra educational support")
    })
    
    mydata.school.address <- mydata %>%
        select(c("school", "address")) %>%
        count(school, address)
    
    output$schoolAddress <- renderPlot({
        ggplot(mydata.school.address, aes(x = school, y = n, fill = address, label = n)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Student Address")
    })
    
    mydata.school.grade <- mydata %>%
        group_by(school) %>%
        summarise(grade = round(mean(G3), 2))
    
    output$schoolGrade <- renderPlot({
        ggplot(mydata.school.grade, aes(x = school, y = grade, fill = school, label = grade)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Average final grade")
    })
    
    mydata.grade.failures <- mydata %>%
        group_by(failures) %>%
        summarise(grade = round(mean(G3), 2))
    
    mydata.grade.failures$failures <- as.factor(0:3)
    
    output$finalGradeFailures <- renderPlot({
        ggplot(mydata.grade.failures, aes(x = failures, y = grade, fill = failures, label = grade)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Final grade by number of failures")
    })
    
    mydata.grade.higher <- mydata %>%
        group_by(higher) %>%
        summarise(grade = round(mean(G3), 2))
    
    output$finalGradeHigher <- renderPlot({
        ggplot(mydata.grade.higher, aes(x = higher, y = grade, fill = higher, label = grade)) +
            geom_bar(stat = "identity") +
            geom_text(size = 3, position = position_stack(vjust = 0.5)) +
            ggtitle("Final grade by wants to take higher education ")
    })
    
    
})
