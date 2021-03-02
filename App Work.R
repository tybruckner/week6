
library(shiny)
library(tidyverse)
library(babynames)
library(lubridate)
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
  selectInput("state", 
              "States", 
              choices = list("state" = state.abb),
              multiple = TRUE),
  submitButton(text = "Submit"),
  plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
  output$timeplot <- renderPlot({
    covid19 %>% 
      mutate(state.abb = state)%>%
      group_by(state.abb)%>%
      filter(cases >= 20)%>%
      ggplot() +
      geom_line(aes(x = ymd(date), y = cases)) +
      scale_y_continuous() +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)
