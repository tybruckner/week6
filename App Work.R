
library(shiny)
library(tidyverse)
library(babynames)
library(lubridate)
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

ui <- fluidPage(
  selectInput("state", 
              "States", 
              choices = list("state" = state.name),
              multiple = TRUE),
  submitButton(text = "Submit"),
  plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
  output$timeplot <- renderPlot({
    covid19 %>% 
      filter(cases > 20)%>%
      filter(state %in% input$state)%>%
      ggplot() +
      geom_line(aes(x = ymd(date), y = cases, color = state)) +
      theme_minimal()+
      scale_y_continuous(labels = scales::comma)+
      labs(title = "COVID 19 Cases", x = "", y = "Cases",color = "State(s)" )
  })
}

shinyApp(ui = ui, server = server)
