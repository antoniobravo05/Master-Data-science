# Definción del UI
shinyUI(fluidPage(
  
	# Titulo
	titlePanel("Esperanza de vida"),
  
	sidebarLayout(
	# Barra lateral
		sidebarPanel(
		  sliderInput("years","Años:",min=min(unique(gapminder$year)),max=max(unique(gapminder$year)),
		              value =1952,step = 5,sep="",animate = TRUE),
		  animationOptions(interval = 1000, loop = TRUE)
		),
    
	# Muestra el grafico en el panel principal
		mainPanel(
			plotOutput("grafico")
		)
  )
))

#----------------------------
#Slider Input Widget        |
#----------------------------
#sliderInput(inputId, label, min, max, value, step = NULL, round = FALSE,
#            format = NULL, locale = NULL, ticks = TRUE, animate = FALSE,
#            width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL,
#            timezone = NULL, dragRange = TRUE)

#animationOptions(interval = 1000, loop = FALSE, playButton = NULL,
#                 pauseButton = NULL)

