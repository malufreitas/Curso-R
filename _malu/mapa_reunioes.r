library(rgdal)
library(ggplot2)
library(ggmap)
library(rgdal)
library(rgeos)
library(maptools)
library(dplyr)
library(tidyr)
library(tmap)
library(plotly)
require(broom)
require(data.table)
require(leaflet)
require(stringr)



shape_reuniao <- 
  rgdal::readOGR(
    dsn = '//enbr09/Public/Gabriel_Motta/VISUALIZACAO/Mapa',
    layer = 'ES_Mun97_region', encoding = "latin1")

base_reuniao <- fread('C:/Users/7100644/Desktop/CURSO_R/_malu/reunioes.csv',sep = ";")

base_reuniao[, Municipio := str_to_upper(Municipio)]
shape_reuniao@data

base_reuniao %<>%
  mutate(MUNICIPIO_CORRIGIDO = 
           stringr::str_replace_all(Municipio, c("Ó|Ô" = "O", "Á|Ã" = "A", "Ç" = "C", "Í" = "I", "É|Ê" = "E", "Ú|Û" = "U"))) %>% 
  group_by(MUNICIPIO_CORRIGIDO) %>% 
  summarize(CONT = length(MUNICIPIO_CORRIGIDO))



aa <- shape_reuniao@data %>%
  left_join(base_reuniao, 
            by = c("SEM_ACENTO"= "MUNICIPIO_CORRIGIDO")) 

aa[is.na(aa$CONT), "CONT"] <- 0
aa


shape_reuniao@data <- aa

#rev(viridis::magma(256)) #Paleta de cor

numpal <- colorNumeric("Blues", #Paleta de cor
                       shape_reuniao$CONT) #Variável numérica


# mapa reuniao
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


