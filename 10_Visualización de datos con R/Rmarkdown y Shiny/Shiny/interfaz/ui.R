# Definición del UI
shinyUI(fluidPage(
  
	# Titulo
	titlePanel("Una regresión"),

  #Anchura maxima del fluidrow=12 unidades
	
	# Diseño de la interfaz
	fluidRow(
	  #4 es la anchura, luego va el tipo de boton. h4 es la funcion de HTML que define el tamaño/formato de los caracteres
		column(4,		
			selectInput("regresor",h4("Elegir variable de regresión:"),choices=names(mtcars)[2:5],selected="hp") 	  
			),
		column(4,		
			textInput("titulo",h4("Titulo del gráfico:"),value = "Regresión") 	  
			),
		column(4,		
			sliderInput("grossor",h4("Tamaño de los puntos:"), min = 1,max = 20,value = 2,step=1) 	  
			)
		),
	fluidRow( 	
		hr(), #linea horizontal (se pinta)
		br(), #salto de linea
		#8 es el tamaño del gráfico, para que quede centrado seleccionamos un offset = 2 para cada lado
		column(8,offset = 2,align="center",plotOutput("grafico"))
		),
	fluidRow( 	
		br(),
		br(),
		column(12,offset = 10,img(src="kschool.png",width=100))
		)	
		#En la carpeta www se ponen las imágenes.
) )


########### Ejercicio
# organizar verticalmente los widgets con la función sidebarPanel
# Añadir en la interfaz un histograma de la distribución del consumo de los coches