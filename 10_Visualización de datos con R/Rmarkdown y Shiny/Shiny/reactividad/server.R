# Definición de la parte server
shinyServer(function(input, output) {
  
  #Tenemos que hacer el filtrado antes de pasarle la BBDD ya que en ambos gráficos se usa.
  #La app tiene que ser rápida, para ello no se filtra como normalmente, se usa la funcion reactive (que reacciona)
  datos <- reactive({ 
						subset(gapminder,continent==input$continent)						
					}) 
  
  output$evolucion <- renderPlot({ 
    #color=input$color
    #Aislamos el cambio de color en este gŕafico
    isolate({color=input$color})
	ggplot(datos(),aes(x=year,y=lifeExp,group=country)) + 
		geom_line(stat="smooth",method="loess",alpha=.2,color=color)
	})
	
  output$bigotes <- renderPlot({ 
	fill=input$color
	ggplot(datos(),aes(x=factor(year),y=lifeExp)) + 
		geom_boxplot(fill=fill)
	}) 	
})


