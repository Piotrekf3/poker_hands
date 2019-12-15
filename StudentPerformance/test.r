mydata <- read.table(
  "student.csv", sep = ";",
  header = TRUE
)

res <- cor(mydata)

head(mydata)

library(polycor)
library(dplyr)
cor <- hetcor(mydata)
correlation <- cor[["correlations"]]

test <- mydata %>%
  select(c("school", "sex"))



mydata.school <- mydata %>%
  select(c("school", "sex")) %>%
  count(school, sex)
mydata.school

mydata_long <- reshape2::melt(mydata.school, id = "school")

mydata.school.grade <- mydata %>%
  group_by(school) %>%
  summarise(grade = mean(G3))

mydata.grade.failures <- mydata %>%
  group_by(failures) %>%
  summarise(grade = round(mean(G3), 2))
mydata.grade.failures$failures <- as.factor(0:3)
