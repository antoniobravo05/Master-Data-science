require(dplyr)
require(tidyverse)
#Fijando la semilla, obtenemos los mismos números. Esta semilla depende del reloj interno del procesador de PC y no habría manera de controlarla.
#set.seed(1234)

require(rvest)
url="https://es.wikipedia.org/wiki/Provincia_de_España"
provincias<-read_html(url) %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE,fill=TRUE) %>% .[[1]]

#####################################
######## Muestreo simple ############
#####################################

sample(provincias,5)

########
NN=1e6
#Niñas de 5 años y queremos generar su altura
y=rnorm(NN,100,10)
hist(y)
summary(y)
sd(y)

y=rnorm(NN,100,5)
summary(y)

nn=100
muestra=sample(y,nn)
mean(muestra)
########


########
NN=10000
poblacion=rnorm(NN,108,5)
nn=250 #tamaño muestral
muestra=sample(poblacion,nn)
mean(muestra)
#t.test(muestra)

#####################################
### Muestreo simple con reposición ##
#####################################

#Ejemplo muestreo simple con reposicion.
sample(letters,20,replace=T)
# Vemos que las letras pueden a parecer 2 veces en la muestra.
#Si ponemos repalce=False, no podremos coger más elementos en el muestreo de los que conste la población.
#sample(letters,30,replace=T), esto funcion. sample(letters,30) esto no.


muestra=sample(provincias,nn,replace=TRUE)
table(muestra)

muestra=sample(poblacion,nn,replace=TRUE)
mean(muestra)
#t.test(muestra)


#####################################
######## Muestreo estratificado #####
#####################################

NN=nrow(diamonds) #tamaño de la poblacion
nn= 250 #tamaño muestral

######## Preambulo
#sample_n: coge la poblacion y el tamaño muestral. Hace un muestreo de la BBDD entera, no como sample que muestreaba un vector.
diamonds %>% sample_n(nn) #muestreo simple de la base de datos "diamonds"
mean(diamonds$price)
muestra<-diamonds %>% sample_n(nn)
mean(muestra$price)
#Si repetimos estas 2 ultimas lineas, vemos que varía mucho.
diamonds %>%  group_by(cut) %>% summarise(media=mean(price), n = n()) #peso y media de los estratos: calidad del diamante (cut)
#Vemos que existe mucha variacion en el precio de los diamantes según la calidad del diamante(cut), podemos usar esta variable para hacer muestreo estratificado

######## Muestreo estratificado con afijación fija
k<-5#son los estratos, es decir los grupos que hay si agrupamos por cut.
muestra <- diamonds %>% group_by(cut) %>% sample_n(nn/k)#nn/k=250/5=50. Vamos a coger 50 muestras de cada estrato
#puedo calcular la media para ver como varía el precio medio de un estrato a otro.
mean(muestra$price)
#Pero aqui no puedo usar esto pq no es un muestreo equiprobabilistico.

muestra %>% summarise(media=mean(price), n = n())


######## Muestreo estratificado con afijación proporcional
#aqui hacemos lo mismo que en el caso anterior cambiando que ahora usamos sample_frac. Ahora no le pasamos el tamaño de la muestra,
#le pasamos nn/NN, es decir, la relacion entre tamaño de muestra y poblacion.
#Seleccionare una muestra proporcional a cada estrato. n_k=n*N_k/N
muestra <- diamonds %>% group_by(cut) %>% sample_frac(nn/NN) 
muestra %>% summarise(media=mean(price),n = n())
#ahora vemos como cada estrato tiene un nº de muestras distinto, no es uniforme, es proporcional al tamaño de cada estrato.
#podríamos en este caso usar le media muestral (asigna el mismo peso a cada elemento de la muestra):
mean(muestra$price)
#Si ejecutamos varias veces vemos que varía mucho menos que antes.

#El peso del diamante influye mucho en el peso, estudiar un poco que ocurre con el:
qplot(carat,price,data=diamonds)
#Mientras tanto, para el cut
qplot(cut,price,data=diamonds,geom="boxplot") #vamos com esta variables discrimina menos y mejora menos el muestreo
#por color:
qplot(color,price,data=diamonds,geom="boxplot") 

####### Muestreo estratificado por calidad y color del diamante
# Vamos a intentar estratificar según el color y el cut.
muestra <- diamonds %>% group_by(cut,color) %>% sample_frac(nn/NN) 
muestra %>% summarise(media=mean(price),n = n())
#El problema de coger 250 es que en muchos estratos solo tengo una muestra. Podemos mejorar lo anterior, sabiendo
# que el color condiciona mas el precio que cut
muestra <- diamonds %>% group_by(color) %>% sample_frac(nn/NN) 
muestra %>% summarise(media=mean(price),n = n())
mean(muestra$price)
#vemos que sigue cambiando si ejecutamos varias veces.

#Para usar el peso para estratificar tenemos que usar cat ya que peso es una variable categórica.


#####################################
#####Muestreo por conglomerado ######
#####################################

diamonds$origen=sample(provincias,NN,replace=TRUE) #se asigna de manera artificial un estado (americano) a cada diamante
head(diamonds)
diamonds %>%  group_by(origen) %>% summarise(media=mean(price), n = n())


mm=10 
muestraI <- diamonds %>%  group_by(origen) %>% summarise(N = n()) %>% sample_n(mm,weight=N) #Primero se muestrea 10 estados.
#1º.Seleccionaremos las provincias con el tamaño proporcional en cuestion a los diamantes que tiene esta provincia
muestraI
#Una vez que tenemos las provincias nos limitaos a analizar la sub-base original que solo contiene diamantes en estas provincias.
#definimos el nuevo frame, nos filtramos por las provincias seleccionadas en la etapa anterior.

#Para conseguir muesreo equiprobabilistico tenemos que obtener una muestra aleatoria de tamaño n/m 250/10 dentro de cada conglomerado seleccionado.
frameI <- diamonds %>% filter(origen %in% muestraI$origen)  # nos quedamos con los 10 estados seleccionados

muestraII <- frameI %>%	group_by(origen) %>% sample_n(nn/mm) #Muestreo dentro de cada conglometrado. Tenemos que usar sample_n y no sample_frac
muestraII %>% summarise(media=mean(price),n = n())
#Están las 10 comunidades y que hay 10 conglomerados con 25 muestras. Es equiprobabilistico, podemos usar la media probabilistica para calcular sobre la población.
