----------- AULA 06/06 -----------------


Bibliotecas:
markdown -> relatorios
shiny -> dashboard


Apostila:
Estat�stica B�sica 1 e Visualiza��o de Dados no R


#Salvando o gr�fico
trellis.device(device = "png", filename="Barra.png")
print(barra)
dev.off()

#Gr�fico din�mico
biblioteca: ggplot2
fun��o: ggplotly(p)
p � o gr�fico

786799 

