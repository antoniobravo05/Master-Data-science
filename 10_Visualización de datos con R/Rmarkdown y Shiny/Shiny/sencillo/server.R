# Definición de la parte server
shinyServer(function(input, output) {
  
  output$grafico <- renderPlot({
    ggplot(cars,aes(x=dist,y=speed))+
		#geom_point(size=input$grosor,color="orange3",alpha=.3) +
      geom_point(size=input$grosor,color=input$colorines,alpha=input$transparencia) +
		geom_smooth(method='lm')
  })
  #Quiero crear otro gráfico que sea un histograma
  output$histograma <- renderPlot({
    #Histograma de la distancia de frenado
    ggplot(cars,aes(x=dist))+
      geom_histogram(color="white",fill=input$colorines)
  })
})
