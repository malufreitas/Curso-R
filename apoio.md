----------- AULA 06/06 -----------------


Bibliotecas:
markdown -> relatorios
shiny -> dashboard


Apostila:
Estatística Básica 1 e Visualização de Dados no R


#Salvando o gráfico
trellis.device(device = "png", filename="Barra.png")
print(barra)
dev.off()

#Gráfico dinâmico
biblioteca: ggplot2
função: ggplotly(p)
p é o gráfico

786799 

