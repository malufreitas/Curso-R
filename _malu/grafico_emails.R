require(plotly)
require(data.table)
require(tidyverse)
require(magrittr)
require(htmlwidgets)

#Gráficos simples
base_emails <- 
  fread('emails.csv')

tratamento_dados <- base_emails %>%
  group_by(Categorias) %>% 
  summarise(CONT = length(Categorias))


#Alguns gráficos

######
#Barra
######

#Criando o gráfico de barras
p <- plot_ly(data = tratamento_dados , y = ~CONT, x = ~Categorias , type = 'bar') %>% 
  layout(title = "E-mails Grandes Clientes",
         xaxis = list(title = "Categorias"),
         yaxis = list(title = "Qtd e-mails")
         )


p

plot_ly(data = base_emails, y=~Categorias, x=~Categorias, type='bar',
       transforms = list( type = 'aggregate',
                          groups = base_emails$Categorias,
                          aggregattions = list(target = 'y', func = 'length', enabled = T)) )







#Para uso em Shiny:

# - Na ui, inserir 'plotlyOutput()'.
# - No server, inserir 'renderPlotly({})'

#Para mais exemplos:
#https://plot.ly/r/
