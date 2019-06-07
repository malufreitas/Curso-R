#install.packages('rsconnect')
# require(rsconnect)
# 
# 
# rsconnect::setAccountInfo(
#   name='visualizacao'
#   ,token='F2F3B56E0967F478FA96B3F2BCF5BF00'
#   ,secret='BCTJhBONgoZm+ZksbfB61ic1oRx3Spn0A25Dfzsy'
# )


#Tutorial deploy

#http://shiny.rstudio.com/articles/shinyapps.html
#https://docs.rstudio.com/shinyapps.io/

# library(rsconnect)
# rsconnect::deployApp()
#library(rsconnect)
library(datasets)
library(shiny)

setwd('C:/Users/7100644/Desktop/CURSO_R/_malu/')

source('front-end.R')
source('back-end.R')
source('grafico_emails.R')
source('mapa_reunioes.R')

shinyApp(ui, server)

##############################
#terminateApp("TESTE_DEPLOY")

# shiny::runApp('app.R')
# 
# library(rsconnect)
# rsconnect::deployApp()
