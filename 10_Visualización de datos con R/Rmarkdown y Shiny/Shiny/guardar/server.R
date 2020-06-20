# Definición de la parte server
shinyServer(function(input, output) {
  
    #Datos para cálculo tendencia por provincia
  #Cuando el usuario selecciona el trimestre hacemos que la BBDD reaccione.
	datos<-reactive({ 
		trimestres=input$trimestre
		#Si el input es todos los trismestres hay que coger todos
		if(trimestres=="Todos") trimestres=c("I","II","III","IV")
		subset(paro,Sexo==input$sexo & Trimestre %in% trimestres)	
	})	
  
	output$tendencia <- renderPlot({ evolucion(datos(),input$alpha/100) })
	
	output$datos <-  renderDataTable(datos(),options = list(pageLength = 10))	
	
	#cuando damos al boton de guardar vemos que se guarda con el nombre de tendencia...
	output$guardarTendencia <- downloadHandler(
		filename = function() { paste0("tendencia",Sys.Date(), '.pdf') },
		content = function(file) {
			p<-evolucion(datos(),input$alpha/100)
			ggsave(file,p,width=12,height=8)
		})		
		
	output$guardarTabla <- downloadHandler(
    filename = function() { paste0("datos_paro", '.csv') },
    content = function(file) {
			write_excel_csv(datos(),file)
		})	
  			
})
