library(shiny)
library(duckdb)
library(plotly)
library(DBI)

# Substitua com suas credenciais de banco de dados
con <- dbConnect(duckdb::duckdb(), "../serial_import_ser_2025/dados/dados_arduino.duckdb")
#query <- "SELECT * FROM dados_sensores2"
#data <- dbGetQuery(con, query)

server <- function(input, output, session) {
  # Função para ler os dados do banco de dados
  read_data <- function() {
    query <- "SELECT * FROM dados_sensores2"
    data <- dbGetQuery(con, query)
    #cat('chegou aqui')
    return(data)
  }
  
  # Função para preparar os dados para o gráfico
  prepare_data <- function(data) {
    data$funcionamento_completo = as.logical(data$funcionamento_completo)
    #data$data_hora <- as.POSIXct(paste(data$data, data$hora), format = "%Y-%m-%d %H:%M:%S")
    return(data)
  }
  
  # Função para criar o gráfico de linha interativo
  create_plot <- function(data) {
    plot_ly(data, x = ~timestamp, y = ~valor_sensor1, type = "scatter", mode = "lines") %>% 
      layout(title = "Valor do Sensor 1 ao Longo do Tempo",
             xaxis = list(title = "Tempo"),
             yaxis = list(title = "Valor"))
    
  }
  
  # ReactivePoll para atualizar o gráfico a cada 30 segundos
  data <- reactivePoll(3000, NULL, read_data, read_data)
  
  # Renderizar o gráfico na interface do usuário
  output$grafico <- renderPlotly({
    create_plot(data())
  })
}