#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



library(shiny)
library(plotly)

ui <- fluidPage(
  titlePanel("Gráfico do Sensor 1"),
  mainPanel(
    plotlyOutput("grafico")
  )
)