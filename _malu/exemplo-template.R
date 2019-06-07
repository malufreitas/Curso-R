library(dplyr)
library(magrittr)
library(shiny)
library(shinythemes)
library(plotly)
library(dygraphs)
library(leaflet)
library(DT)
library(datasets)
library(zoo)
library(xts)
library(datasets)
library(data.table)


#########Criando UI#########
options(shiny.reactlog = TRUE)


####### UI
ui <-
  shinyUI(
    #navbarPage criará um app com abas. Nos argumentos, temos o nome e o tema.
    navbarPage(
      "Nome"
      ,theme = shinytheme('cosmo')
      #tabPanel criará uma nova aba
      
      # 1
      ,tabPanel(
        "Aba 1"
        #sidebarPanel cria uma barra lateral para seus filtros.
        ,sidebarPanel(
          #Vamos criar um filtro simples de data nesta aba
          
          # DADOS
          dateRangeInput(
            'filtro_data'  # nome id servidor
            ,label = 'Selecione a data'
            #Os argumentos 'start' e 'end' dão a seleção de gráfico
            #quando o aplicativo abrir. 'min' e 'max' é todo o horizonte
            #temporal de sua série
            ,start = '1949-01-01'  # ano-mês-dia
            ,end = '1951-01-01'
            ,min = '1949-01-01'
            ,max = '1960-12-01'
            #visão mensal:
            ,startview = 'month'
            #calendário começa no domingo:
            ,weekstart = 0
            #quero que a data apareça no formato "jan/2019"
            ,format = 'M-yy'
            ,language = 'pt-BR'
            )
          )
        
        # PAINEL (GRÁFICOS)
        ,mainPanel(
          #Aqui aparecerá o gráfico. Ficará ao lado do 'sidebarPanel'
           plotlyOutput("grafico1")  #nome id servidor
           )
        )
      
      # 2
      ,tabPanel(
        "Aba 2"
        #Aqui utilizaremos 'fluidPage', um layout livre, em que os objetos
        #inseridos são colocados de forma "empilhada", mas que podem ter
        #seus tamanhos definidos pela função "column"
        ,fluidPage(
          #O selectInput dá opções de filtro para um gráfico ou tabela,
          #mas contendo uma opção por vezhttp://127.0.0.1:6383/#tab-5804-2
          selectInput(
            inputId = 'escolher'  # id servidor
            ,label = "Escolha a Espécie"
            ,choices = unique(iris$Species)
            ,selected = "setosa"
            )
          #Observe abaixo a função 'column'. Definimos o tamanho 12, para as
          #nossas saídas ocuparem toda a página.
          ,column(
            12
            ,plotlyOutput('irisgrafico')
            ,DTOutput("iristabela")
            )
          )
        )
      
      # 3
      ,tabPanel(
        "Aba 3",
        fluidPage(
          #'selectizeInput' permite e seleção de diversas variáveis
          selectizeInput(
            'selecionavarios'  # id servidor
            ,choices = c('Temp', 'Wind')
            ,selected = 'Temp'
            ,label = 'Escolha a variável'
            ,multiple = TRUE
            )
          )
        ,dygraphOutput('grafico3')
        )
      
      # 4
      ,tabPanel(
        "Aba 4",
        fluidPage(
          #'selectizeInput' permite e seleção de diversas variáveis
          selectInput(
            'GRUPO'  # id servidor
            ,choices = LETTERS
            ,selected = 'A'
            ,label = 'Escolha o Grupo'
          )
        )
        ,leafletOutput('mapa4')
      )
      
      # 5
      ,tabPanel(
        "Aba 5"
        #sidebarPanel cria uma barra lateral para seus filtros.
        ,sidebarPanel(
          #Vamos criar um filtro simples de data nesta aba

          # DADOS

        )

        # PAINEL (GRÁFICOS)
        ,mainPanel(
          #Aqui aparecerá o gráfico. Ficará ao lado do 'sidebarPanel'
           #nome id servidor
        )
      )
      
      
      )
    )






#########Criando Server##########

base_es <- fread('INSTALACOES_ES.txt',sep = ";")

#Como a base é muito grande, vamos selecionar 500 observações aleatórias

base_es <- base_es[sample(nrow(base_es), 5000),]

#Vou selecionar as variáveis de interesse e criar uma coluna com valores hipotéticos.

base_es %<>%
  dplyr::select(NUMERO, C_LAT, C_LONG) %>%
  mutate(
    VALOR = sample(10000:1000000, nrow(base_es))
    ,C_LAT = as.numeric(as.character(C_LAT))
    ,C_LONG = as.numeric(as.character(C_LONG))
    ,NUMERO = as.character(NUMERO)
    ,GRUPO = as.character(sample(LETTERS, nrow(base_es), replace = TRUE)
    )
  ) %>%
  dplyr::filter(!is.na(C_LONG))




########## SERVE
server <- shinyServer(function(input, output, session) {
  #1) Primeira Aba:
  #Usaremos os dados "AirPassengers",uma série temporal da base 
  #do R. Vamos, antes, criar um data frame

  data("AirPassengers")
  #Criando o vetor de data

  vet_data <- as.data.frame(as.yearmon(time(AirPassengers)))

  #Criando vetor de valores
  valor <- as.data.frame(AirPassengers)

  #Unindo ambos os vetores
  serie <- bind_cols(vet_data, valor)


  #Renomeando colunas e definindo a primeira como objeto 'Date'

  colnames(serie) <- c('Data', 'Passageiros')

  serie$Data <- as.Date(serie$Data)

  #Criando filtro para a data, dentro da função 'reactive':

  funcao <- reactive({

    objeto <- serie %>%
    dplyr::filter(Data >= input$filtro_data[1] & Data <= input$filtro_data[2])

  plotly::plot_ly(objeto, x= ~Data, y= ~Passageiros,
                  name = 'Passageiros',
                  type = 'bar') %>%
      layout(xaxis = list(title = ""),
             yaxis = list(title = "Número de Passageiros"),
             legend = list(orientation = 'h'))})

  #Gerando o gráfico com Plotly. Função "renderPlotly":
  output$grafico1 <- renderPlotly({funcao()})

  
  #2) Segunda aba:
  #Usaremos o famosos dados 'iris' da base do R.

  data("iris")

  #Criando gráfico

  output$irisgrafico <- renderPlotly({
    b <- iris %>%
      dplyr::filter(Species == input$escolher)

    plotly::plot_ly(b, x = ~Sepal.Length, y = ~Petal.Length,
                    marker = list(
                      size = 10,
                      color = 'rgba(255, 0 , 0, .8)',
                      width = 2
                    )) %>%
      layout(title = 'Iris Flower')
  })

  #Vamos agora criar o objeto reativo para a nossa tabela

  tabela <- reactive({as.data.table(iris) %>%
    dplyr::filter(Species == input$escolher)
    datatable(iris,
              extensions = 'Buttons', options = list(
                dom = 'Bfrtip',
                buttons = c('csv')
              )
              )
    })

  output$iristabela <- renderDT({tabela()})

  #3) Terceira Aba:
  # Para a terceira aba, usaremos os dado 'airquality', também da base do R.
  data('airquality')

  #Vou criar um vetor de datas mais condizente para se trabalhar com gráficos e selecionar algumas variáveis de interesse - no caso, 'Temp' e 'Wind'.
  #Trabalhar com o Dygraphs no Shiny tem uma especificidade.
  # Você precisa converter seu data frame em um 'xts.data.table', do pacote 'xts', e usar a função reactive, para tornar seu objeto reativo


  grafico_aba3 <- reactive({
    airquality <- mutate(airquality,
                         Date = paste0('1973-','0',
                                       airquality$Month,
                                       '-',
                                       airquality$Day)) %>%
      select(Date, Temp, Wind)

    airquality$Date <- as.Date(airquality$Date)
    airquality <- airquality %>%
      dplyr::select(Date, input$selecionavarios) %>%
      setDT(.) %>%
      as.xts.data.table()
  })

  #Criando o gráfico. Repare que 'grafico_aba3', quando recebe 'reactive', torna-se uma função.

  output$grafico3 <- renderDygraph({
    dygraph(grafico_aba3(), main = "Gráfico Aba 3") %>%
      dyAxis("y", label = "Temp (ºF)") %>%
      dyAxis("y2", label = "Wind (mph)",
             independentTicks = TRUE) %>%
      dySeries("Temp", axis = 'y2') %>%
      dyOptions(drawPoints = TRUE,
                pointSize = 2,
                drawGrid = input$selecionavarios) %>%
      dyRangeSelector(dateWindow = airquality$Date)
  })

  #Mapa
  mapa_aba4 <-
    reactive({
      aa <-
        base_es %>%
        dplyr::filter(GRUPO == input$GRUPO)

      leaflet(options = leafletOptions(minZoom = 0, maxZoom = 30)) %>%
        addTiles() %>%  # adicionar mapa padrão
        #addProviderTiles(providers$Stamen.Toner) %>% #adicionar mapa com outro tema
        addMarkers(aa$C_LONG, #Longitude
                   aa$C_LAT,  #Latitude
                   popup =  paste("Instalação: ", aa$NUMERO, "<br>",
                                  "CONSUMO:", base_es$VALOR))
    })

  output$mapa4 <- renderLeaflet({
    mapa_aba4()
    })

})

# Rodando App

shinyApp(ui, server)




# Conectando com o servidor shinyapps.io
