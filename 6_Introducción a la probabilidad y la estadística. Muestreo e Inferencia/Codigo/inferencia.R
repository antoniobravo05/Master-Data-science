require(tidyverse)
set.seed(1234)

##################################################
######## Estimación de la media poblacional ######
##################################################

NN=1e6
poblacion=rnorm(NN,108,5)  #distribución de la altura de niñas de 5 años en la población

nn=250 #tamaño muestral

########### Estimación puntual

muestra=sample(poblacion,nn) #muestreo simple
mean(muestra) #media muestral de la altura
mean(muestra<100) #proporcioón muestral de niñas con un altura inferior a 1 metro

########### Distribución de la media muestral
K=1000 #Número de muestras 
medias=replicate(K,mean(sample(poblacion,nn))) 
qplot(medias,ylab="frecuencia",xlab="Media muestral") 

########### Estimación por intervalos
t.test(muestra) #intervalo de confianza
t.test((muestra<100)) #intervalo de confianza para la proporción

##################################################
######## Determinación del tamaño muestral ######
##################################################

e=.5 #margen de error
alfa=.05 # (1-alfa) es el nivel de confianza
sigma=6 # acotamos la desviación tipica
z=qnorm(1-alfa/2) #cuantil de la normal

nn=ceiling(z^2/e^2*sigma^2) #tamaño muestral requerido
muestra1=sample(poblacion,nn) #muestreo simple
intervalo=t.test(muestra1)$conf.int
intervalo
diff(intervalo)/2 #semi-longitud del interval: margen de error 

##################################################
######## Contrastes de Hipotesis #################
##################################################
NN=1e6
poblacion=rnorm(NN,325,10) #distribución del contenido de las botellas de coca-cola

nn=50 #tamaño muestral
muestra2=sample(poblacion,nn) #muestreo simple

########### Contraste unilateral
t.test(muestra2,alternative="less",mu=330)

########### Contraste bilateral
t.test(muestra2,mu=330)

########### Comparación de medias
poblacionA=rnorm(NN,15,10);poblacionB=rnorm(NN,20,10) 
nA=nB=nn #tamaños muestrales
muestraA=sample(poblacionA,nA) 
muestraB=sample(poblacionB,nB) 
t.test(muestraA,muestraB,var.equal = TRUE)


