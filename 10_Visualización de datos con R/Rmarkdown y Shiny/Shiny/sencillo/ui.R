# Definción del UI
shinyUI(fluidPage(
  
	# Titulo
	titlePanel("Una regresión y un histograma"),
  
	sidebarLayout(
	# Barra lateral
		sidebarPanel(
		  sliderInput("grosor","Tamaño de los puntos:",min = 0,max = 20,value = 10,step=2),
		  selectInput("colorines","Color de los puntos:",choices = c("Rojo"="red3","Azul"="blue3","Naranja"="orange3"),selected="orange3"),
		  sliderInput("transparencia","Transparencia:",min = 0.1,max = 1,value = 0.5,step=0.1)
		),
    
	# Muestra el grafico en el panel principal
		mainPanel(
			plotOutput("grafico"),
			#Quiero crear otro gráfico que sea un histograma
			plotOutput("histograma")
		)
  )
))
