## -------------------------------------------------------------------------
## SCRIPT: Aprendizaje no Supervisado.R
## CURSO: Master en Data Science
## SESIÓN: Aprendizaje no Supervisado
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("dummies")){
  install.packages("dummies")#transforma variables categóricas en variables dummy (numéricas)
  library("dummies")
}
#Recomendacion, cuanto mas generalista sea nuestro código, mejor. Menos problemas nos dará.
#setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201807 Clase VIII Master Data Science/5 Aprendizaje no Supervisado")

# indicar el directorio de trabajo (session>set working directory>To source file location)
setwd("~/Documents/DATA SCIENCE MASTER VM/Apredizaje no supervisado")

## -------------------------------------------------------------------------
##       PARTE 1: CLUSTERING JERARQUICO: NETFLIX MOVIELENS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####
#dataset de peliculas (1664 obs de 20 variables)
movies = read.table("data/movies.txt",header=TRUE, sep="|",quote="\"")

## -------------------------------------------------------------------------

##### 3. Bloque de analisis preliminar del dataset #####

str(movies)
head(movies)
tail(movies)

#cuantas hay de comedia, de western y romance 
table(movies$Comedy)
table(movies$Western)
table(movies$Romance, movies$Drama)
#tenemos muchos romances que son dramas y al reves.

## -------------------------------------------------------------------------

##### 4. Bloque de calculo de distancias #####
#calculamos las distancias de todas las categorias
distances = dist(movies[2:20], method = "euclidean")

## -------------------------------------------------------------------------

##### 5. Bloque de clustering jerarquico #####

clusterMovies = hclust(distances, method = "ward.D")
#con 1000 o 2000 va muy bien pero con 1e6 no, tiene problemas de escalado.

dev.off()
plot(clusterMovies)

#Hay que tener cuidado con los output de las librerias. Deben permitirnos analizar los registros.

rect.hclust(clusterMovies, k=2, border="yellow")
rect.hclust(clusterMovies, k=3, border="blue")
rect.hclust(clusterMovies, k=4, border="green")
rect.hclust(clusterMovies, k=6, border="orange")

#Ya se cuantos grupos tendré, ahora que nombre les doy, como los interpreto?
#Definimos el nº de clusters:
NumCluster=6

rect.hclust(clusterMovies, k=NumCluster, border="red")

movies$clusterGroups = cutree(clusterMovies, k = NumCluster)

## -------------------------------------------------------------------------

##### 6. Bloque de analisis de clusters #####

table(movies$clusterGroups)
#vemos de cada grupo que tipo de peliculas hay. Si queremos ver una peli de accion, tengo que ir al grupo 1, pero no todas son de aacion.
tapply(movies$Action, movies$clusterGroups, mean)
tapply(movies$Adventure, movies$clusterGroups, mean)
tapply(movies$Animation, movies$clusterGroups, mean)
tapply(movies$Childrens, movies$clusterGroups, mean)
tapply(movies$Comedy, movies$clusterGroups, mean)
tapply(movies$Crime, movies$clusterGroups, mean)
tapply(movies$Documentary, movies$clusterGroups, mean)
tapply(movies$Drama, movies$clusterGroups, mean)
#¿Como es el grupo 1 y el grupo 2?
#Con Ncluster=2, el segundo grupo es interesante, son todo drama. En el algoritmo jerarquico no es necesario poner/fijar semilla.
#con Ncluster=4, el grupo 2 seria drama, el grupo 3 serían comedias con un punto dramático (no son comedias romanticas), el grupo 4 serían romance con comedia y dramas.
#No hay un clustering que sea mejor, con cada N cambiará, debemos elegir nosotros.
aggregate(.~clusterGroups,FUN=mean, data=movies)

## -------------------------------------------------------------------------

##### 7. Bloque de ejemplo #####

subset(movies, Title=="Men in Black (1997)")
#asignamos a cada pelicula su cluster asignados.
#con el cluster 2
cluster2 = subset(movies, movies$clusterGroups==2)

cluster2$Title[1:10]
#con el cluster 7
cluster7 = subset(movies, movies$clusterGroups==7)

cluster2$Title[1:10]

# ****** si me llega ahora una peli nueva, ¿a qué cluster lo asigno y como? Este es el gran
#problema del clustering jerarquico, no hay ninguna funconi que haga esto de manera analítica.

## -------------------------------------------------------------------------
##       PARTE 2: CLUSTERING kMEANS
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 8. Bloque de carga de Datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 9. Bloque de revisión basica del dataset #####

str(creditos)
head(creditos)
summary(creditos)

## -------------------------------------------------------------------------

##### 10. Bloque de tratamiento de variables #####
#cambiamos las variables caracter a dummys
creditosNumericos=dummy.data.frame(creditos, dummy.class="character" )

## -------------------------------------------------------------------------

##### 11. Bloque de Segmentación mediante Modelo RFM 12M  #####
#el problema al trabajar con distancias es que con variables dummy la distancia siempre será cmo máximo 1
#el problema será que va a ponderar con aquellas magnitudes donde los valores sean los máximos (por ejemplo el balance)
#esto se puede corregir normalizando los datos. La tecnica mas estanda es hacer el z_score: se le resta la mediay se divide por la desv.típica
#antes, en el ejemplo anterior no hace falta normalizar pq todo eran 0s y 1s.

#con tecnicas basadas en distancias, normalizar es muy buena idea, se evitan que variables grandes sean dominantes
#con otras tecnicas no basadas en distancias (RL,arboles, DL,...) utilizar variables normalizadas no mejora nada la capacidad predictiva del modelo. Si mejora la eficiencia computacinoal pero no la cap. predictiva.

#esta funcion hace el zscore (normaliza)
creditosScaled=scale(creditosNumericos)

#no sabemos los clusters a hacer, tenemos que probar, k=1, k=2...
NUM_CLUSTERS=5
set.seed(1234)
Modelo=kmeans(creditosScaled,NUM_CLUSTERS)

creditos$Segmentos=Modelo$cluster
creditosNumericos$Segmentos=Modelo$cluster

table(creditosNumericos$Segmentos)

aggregate(creditosNumericos, by = list(creditosNumericos$Segmentos), mean)
#con k=3, el grupo 1 son mujeres casadas con ingresos mayores y el grupo 2 son solteros y el grupo 3 hombres casados.
#con k=2, el grupo 1 son mujeres casadas y el grupo 2 son hombres solteros
#unas variables pueden ayudarnos a identificar los grupos y otras a describirlos. para k=4 el grupo 3 son los que tienen hipoteca con unos ingresos mayores y un saldo en uenta mayor.
#pondremos/sacaremos las variables interesantes (cuya separacion nos ayude a entender los grupos)
#nosotros debemos tener el criterio.
#tenemos que hacer un analisis y exponer al stajkeholder algunas alternativas y el que elija.

## -------------------------------------------------------------------------

##### 12. Bloque de Ejericio  #####

## Elegir el numero de clusters
# que k es el mejor? depende, analiticamente se puede buscar pero depende de lo que queramos
## -------------------------------------------------------------------------

##### 13. Bloque de Metodo de seleccion de numero de clusters (Elbow Method) #####
#esta es la regla del codo. Se suman los errores (distancia respecto al centroide de todos los puntos)
Intra <- (nrow(creditosNumericos)-1)*sum(apply(creditosNumericos,2,var))
for (i in 2:15) Intra[i] <- sum(kmeans(creditosNumericos, centers=i)$withinss)
plot(1:15, Intra, type="b", xlab="Numero de Clusters", ylab="Suma de Errores intragrupo")

#hay que buscar a partir de qué punto la reduccion no es suficiente para justificar un centroide más.
# entonces en este caso hay que usar el k=3 o k=4 porque más introduce más complejidad pero sin bajar mucho el error.
# Pero todo depende y hay que ver si es adecuado para nuestro negocio. Esto es una ciencia y no ingeniería.

## -------------------------------------------------------------------------
##       PARTE 3: PCA: REDUCCIÓN DE DIMENSIONALIDAD.
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 14. Bloque de carga de datos #####

coches=mtcars # Base de datos ejemplo en R

## -------------------------------------------------------------------------

##### 15. Bloque de revisión basica del dataset #####

str(coches)
head(coches)
summary(coches)

## -------------------------------------------------------------------------

##### 16. Bloque de modelo lineal #####

modelo_bruto=lm(mpg~.,data=coches)
summary(modelo_bruto)

cor(coches)

## -------------------------------------------------------------------------

##### 17. Bloque de modelos univariables #####

modelo1=lm(mpg~cyl,data=coches)
summary(modelo1)
modelo2=lm(mpg~disp,data=coches)
summary(modelo2)
modelo3=lm(mpg~hp,data=coches)
summary(modelo3)
modelo4=lm(mpg~drat,data=coches)
summary(modelo4)
modelo5=lm(mpg~wt,data=coches)
summary(modelo5)
modelo6=lm(mpg~qsec,data=coches)
summary(modelo6)
modelo7=lm(mpg~vs,data=coches)
summary(modelo7)
modelo8=lm(mpg~am,data=coches)
summary(modelo8)
modelo9=lm(mpg~gear,data=coches)
summary(modelo9)
modelo10=lm(mpg~carb,data=coches)
summary(modelo10)

cor(coches)

## -------------------------------------------------------------------------

##### 18. Bloque de Ejercicio #####

## ¿Qué modelo de regresión lineal realizarías?

modelo11=lm(mpg~cyl+wt,data=coches)
summary(modelo11)
summary(modelo_bruto)

modelo=step(modelo_bruto,direction="both",trace=1)
#teóricamente el mejor modelo es Step:  AIC=61.31
#mpg ~ wt + qsec + am
summary(modelo)

## -------------------------------------------------------------------------

##### 19. Bloque de Analisis de Componentes Principales #####
#cambiamos los sitemas de referencia, ahora las nuevas variables serán incorreladas
PCA<-prcomp(coches[,-c(1)],scale. = TRUE)

summary(PCA)
#me indica los valores propios. Con PC2 tendríamos el 84% de la informacion.
#Con PC5 te quedas con la mitad de variables y tenemos el 95% de informacion de la varianza
#pero hay que ver el tradeoff, no hay nada que sea mejor o peor, todo dependerá de lo que queramos asumir.
#al final es un criterio, pero no hay un criterio.
plot(PCA)
# me voy a quedar con las nuevas 10 variables y ahora no tendré problemas pq serán incorreladas y podré discriminar mejor entre ellas
## -------------------------------------------------------------------------

##### 20. Bloque de ortogonalidad de componentes principales #####

cor(coches)
cor(PCA$x)

## -------------------------------------------------------------------------

##### 21. Bloque de representacion grafica mediante componentes principales #####

biplot(PCA)

PCA$rotation

## -------------------------------------------------------------------------

##### 22. Bloque de creacion de variables componentes principales #####
#¿Cuál era la vairable que mas aportaba al modelo? el peso wt: R^2=0.75
# y el modelo bruto R^2=0.86.
# ¿Cuanto aportará la variable PCA1?

coches$PCA1=PCA$x[,1]
coches$PCA2=PCA$x[,2]
coches$PCA3=PCA$x[,3]

## -------------------------------------------------------------------------

##### 23. Bloque de regresion lineal con componentes principales #####

modelo_PCA=lm(mpg~PCA1,data=coches)
summary(modelo_PCA)

modelo_PCA=lm(mpg~PCA$x,data=coches)
summary(modelo_PCA)
#ahora no tengo multicolinealidad, puedo cargarme las que no sean significativas.

#modelo con la 1 y con la 3
modelo_PCA=lm(mpg~PCA1+PCA3,data=coches)
summary(modelo_PCA)
#cuando las variables son incorreladas, no tiene efecto en los coeficientes estimados el cambiar las variables.
#con esta tecnica se ha transfromado el modelo con las mismas caracteristicas usando solo 2 variables.
#ahora, es dificil interpretar estas variables transformadas. SI no hay que interpretarlas, me podria valer.
#Se podría sacar la relacion establecida en la transformacion con la rotacion:
PCA$rotation
#PCA1 será la combinacion lineal: mpg=20.09-2.25PCA1+... con PCA1=0.4cyl+0.39disp...

#podemos guardar el modelo:
save(modelo10,file="modelo10")
#una vez tengamos el modelo, puedo cargarlo directamtnet en la base de datos.( EN EL MOTOR DE LA BBDD, usando el lenguaje de la BBDD que se utilice) Ya que la mayor parte del tiempo se pierden en mover los datos. 
#ANTES DE PONERNOS CON EL CODIGO, TENEMOS QUE TENER CLARO CUAL VA A SER LA LINEA DE PRODUCCION.
#MODELOS EN R QUE VAYAN A SISTEMA DE PRODUCCION NO HAY.
biplot(PCA,choices=c(1,3))




## -------------------------------------------------------------------------
##       PARTE 4: CLUSTERING K-MEANS Y PCA. SAMSUNG MOBILITY DATA
## -------------------------------------------------------------------------

#Para poner en produccion/explotacion un k means, cuando lleguen datos nuevos, cojo el registro y tengo que hacer lo mismo que en el entrenamiento
#tengo que escalar y calcular la distancia a los centroides con el espacio escalado. El problema es como normalizo?
#deberia guardar los centroides del espacio escalado y luego la media y la varianza de todas las variables originales para poder normalizar y luego porder calcualr la distancia del nuevo punto a los centroides y elegir el minimo.

#Si ss van a imputar nulos, hay que guardar la media y la varianza tambien, no hay que calcular la media y la varizanda otra vez. HAY QUE HACER LO MISMO EN EXPLOTACION QUE EN ENTRENAMIENTO.

#Hay que dividir y separar muy bien la parte de entrenamiento y luego la parte de produccion da igual el lenguaje (R,python...) lo importante es saber como mandarlo a produccion. Esto en Orace va como un tiro, hacer sumas y restas... Va muy bien. Así que se puede hacer bien en el motor de la BBDD 
## -------------------------------------------------------------------------

##### 24 Bloque de inicializacion de librerias y establecimiento de directorio #####

library(ggplot2)
library(effects)
library(plyr)

## -------------------------------------------------------------------------

##### 25. Bloque de carga de Datos #####

load("data/samsungData.rda")

## -------------------------------------------------------------------------
# Vamos a intentar usar clasificación, que es un algoritmo supervisado. Para ello vamos a clusterizar (algoritmo supervisado)

##### 26. Bloque de analisis preliminar del dataset #####

str(samsungData)
head(samsungData)
tail(samsungData)

table(samsungData$activity)
#mas o menos hay una probabilidad de acertar de 1/6 y si tuviera que elegir, seria laying
str(samsungData[,c(562,563)])#nos las cargamos la actividad en el cluster y el individuo tampoco.
## -------------------------------------------------------------------------
#clasificacion multiclase, según las primeras inspecciones: standing, walking, walkdown, walkup, sitting, lying.
#Tecnicas multiclase para bernuilly: se hace modelo apra standing, modelo para walking...
#puedo convertir el problema multiclase en 6 problemas uniclase, con 6 modelos distintos. Se podría usar regresion logistica para cada uno de los casos.

#Ponemos 70% de los datos para train~serán 5100 registros mas o menos, con 561 tendremos OVERFITTING seguro.
#por ello habrña que reducir variables con la reduccion de la dimensionalidad, implicitamente no tendremos multicolinealidad. Para asegurar no tener overfittin podriamos escoger sqrt(561) como máximo, mas o menos 20 variables.

#Pero no estamos con clustering, vamos a ver como podemos hace un sistema predictivo con clustering.
#con un sistema de clasificacion puedo establecer un sistema de predictivo, será muy mediocre pero se puede. El que mas se repita en cada grupo, esa será la predicción.

##### 27. Bloque de segmentacion kmeans #####

samsungScaled=scale(samsungData[,-c(562,563)])

set.seed(1234)
#hacemos y problemos con 6 clusters, luego con 8.
# con k=6 el grupo 1 separa movimiento de no movimiento, el quinto grupo de pie. COn el grupo 2, al azar, si se le asigna laying aciertas en casi un 90% de los casos.
#El hacer el mismo nº de clsuters a categorias no es idoneo pq pueden no salirnos 6 grupos bien diferenciados
kClust1 <- kmeans(samsungScaled,centers=8)

table(kClust1$cluster,samsungData[,563])
#vemos que al modelo le cuesta entre walk, walkup y woalkdown. SI tuviera que hacer un modelo predictivo lo haria sobre el grupo 8 y el 1.
nombres8<-c("walkup","laying","walkdown","laying","standing","sitting","laying","walkdown")

Error8=(length(samsungData[,563])-sum(nombres8[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error8
#Con esto, hay un 60% de acierto con un cluster. Lo importante es como con una tecnica de clustering se puede hacer prediccion

## CLuster con 10 centros.
set.seed(1234)
kClust1 <- kmeans(samsungScaled,centers=10)

#comparacion de la actividad sabida en el DS y el cluster asignado:
samsungData$cluster=nombres10[kClust1$cluster]
samsungData[,c(563,564)]
#tabla acierto-error
table(samsungData$activity,samsungData$cluster)

table(kClust1$cluster,samsungData[,563])
#se puede mejorar o poner en el foco en el grupo 1, 4, 8 y 9
nombres10<-c("walkup","laying","walkdown","sitting","standing","laying","laying","walkdown","sitting","walkup")

Error10=(length(samsungData[,563])-sum(nombres10[kClust1$cluster]==samsungData[,563]))/length(samsungData[,563])

Error10
#y vamos que son mas o menos igual.
#la idea del DS es innovar y pensar, mezclar tecnicas, no hacerlo pq eso lo hace una maquina.
## -------------------------------------------------------------------------

##### 28. Bloque de PCA #####

PCA<-prcomp(samsungData[,-c(562,563)],scale=TRUE)
#PCA$rotation
#attributes(PCA)
summary(PCA)
plot(PCA)
PCA$x[,1:3]

#para tener un diagrama vistoso cogemos las 2 primeras cmponentes principales. Son compnentes principales, no dan mucha info pero se puede ver como se separan los datos
dev.off()
par(mfrow=c(1,3))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(2,3)],col=as.numeric(as.factor(samsungData[,563])))
plot(PCA$x[,c(1,3)],col=as.numeric(as.factor(samsungData[,563])))

#aqui vemos que esto me puede servir de clasificador dependiendo de donde caiga el punto. Hemos conseguido dibujar un clasificador, en 2 dimensiones de 563 componentes usando PCA.
par(mfrow=c(1,1))
plot(PCA$x[,c(1,2)],col=as.numeric(as.factor(samsungData[,563])))

## -------------------------------------------------------------------------