#crear un vector con todas las fechas de este año
# Creating date sequences
v_dias<-seq(as.Date("2018-1-1"), as.Date("2018-12-31"), by = "days")

#sacar la fecha de hoy
today<-Sys.Date()
today

#cuantos días han pasado desde principio de año? y cuantos días quedan para que acabe?
dias_pasados<-as.numeric(today-v_dias[1])
dias_pasados
dias_restantes<-as.numeric(v_dias[length(v_dias)]-today)
dias_restantes

#¿Cuantos meses faltan para que acabe el año?
month(v_dias[length(v_dias)])-month(today)

#-------------------------------------------------------
#todo esto se puede hacer buscando la posicion en el vector del día de hoy y contando desde el inicio y hasta el final
#which(today==v_dias)
#length(v_dias)-which((today==v_dias))
#floor((length(v_dias)-which(today==v_dias))/30)

c(1,2,'tres')
#vemos que transforma los numeros en texto y así con el resto
c(1,TRUE,3)
c('uno',FALSE)

#con las listas combinamos elementos de distintos tipos

