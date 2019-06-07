library(leaflet)
library(plotly)

ui <- 
  shinyUI(
    #navbarPage criará um app com abas. Nos argumentos, temos o nome e o tema.
    navbarPage(
      "Teste",
      
      # Aba 1: Mapa reunioes
      tabPanel(
        "Reunioes",
        
        fluidPage(
          leafletOutput('mapa_reuniao')
          )
        
      ),
      
      # Aba 2: Grafico emails
      tabPanel(
        "E-mails",
        
        fluidPage(
          plotlyOutput('grafico_emails')
          )
        
        )
      
    )
  )
        
         


