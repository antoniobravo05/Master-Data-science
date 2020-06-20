# Definición del UI
shinyUI(fluidPage(
  
# Titulo
titlePanel("Una regresión"),


# Diseño de la interfaz
sidebarPanel(width=3,	
  #Contiene solamente un botón
	selectInput("regresor",h4("Elegir variable de regresión:"),choices=names(mtcars)[2:5],selected="hp") 	   	  
	),
	
mainPanel(width=9, 
  #Creamos pestañas/paneles para meter en ellas cosas distintas. Hay 3 tipos de salida en este caso
	tabsetPanel(
		tabPanel("Regresión",
			plotOutput("regresion")
			),				
		tabPanel("Dotplot",
			plotOutput("dotplot")
			),
		tabPanel("Datos",
			dataTableOutput("datos")
			)	
		)
	)	
) )


