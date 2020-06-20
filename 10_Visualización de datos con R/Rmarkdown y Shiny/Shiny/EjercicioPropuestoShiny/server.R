# Definición de la parte server
shinyServer(function(input, output) {
  #Aqui no hace falta hace run reactive, lo podría hacer dentro del gráfico pero lo haremos porque es mas limpio
  datos<-reactive({
    subset(gapminder,year==input$years)
  })
  
  output$grafico <- renderPlot({
    #Este sería al gráfico simple. 
    #ggplot(gapminder)+aes(x=gdpPercap,y=lifeExp,size=pop,color=continent)+
    #  geom_point()+xlim(0,50000)+ylim(20,90)+scale_size(guide="none")
    #Ahora tengo que filtrar por los años
    ggplot(datos())+
      aes(x=gdpPercap,y=lifeExp,size=pop,color=continent)+
      geom_point()+
      #Voy a usar el año para imprimirlo como fondo del gráfico, usamos geom_text.
      #Si no ponemos nada dentro coge los valores del datos ya definido. Yo quiero un único texto, no un texto por etiqueta
      #Quiero que esté en el centro x=25000 e y =55
      geom_text(x=40000,y=30,label=as.character(input$years),size=30,color="grey80",alpha=.3)+
      xlim(0,50000)+
      ylim(25,85)+
      scale_size(guide="none")+
      theme_bw()
  })
})
