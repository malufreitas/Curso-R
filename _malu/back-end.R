server <- shinyServer(function(input, output, session) {

  # mapa reuniao
  mapa_aba1 <-
    reactive({
      mapa_reuniao <- leaflet(shape_reuniao) %>%
        addTiles() %>% 
        addPolygons(color = "#444444", #cor
                    weight = 1, #Grossura 
                    fillOpacity = 1, #Transparência
                    fillColor = ~numpal(CONT), # Preenchimento
                    highlightOptions = highlightOptions(color = "white", 
                                                        weight = 2, 
                                                        bringToFront = TRUE), #Deixar destacado
                    popup = ~SEM_ACENTO #Rótulo quando clica)
        )
      
      })
  
  output$mapa_reuniao <- renderLeaflet({
    mapa_aba1()
    })
  
  
  # grafico emails
  grafico_aba2 <- 
    reactive({
      plot_ly(data = tratamento_dados , y = ~CONT, x = ~Categorias , type = 'bar') %>% 
        layout(title = "E-mails Grandes Clientes",
               xaxis = list(title = "Categorias"),
               yaxis = list(title = "Qtd e-mails")
               )
      })
  
  output$grafico_emails <- renderPlotly({
    grafico_aba2()
    })
  
})