## -------------------------------------------------------------------------
## SCRIPT: Introducción a la Modelización Estadística.R
## CURSO: Master en Data Science
## SESIÓN: Introducción a la Modelización Estadística
## PROFESOR: Antonio Pita Lozano
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 1. Bloque de inicializacion de librerias #####

if(!require("ggplot2")){
  install.packages("ggplot2")
  library("ggplot2")
}

if (!require("gap")){
  install.packages("gap")
  library(gap)
}

#setwd("D:/Documentos, Trabajos y Demás/Formación/Kschool/201807 Clase VIII Master Data Science/2 Introducción a la Modelización Estadística")
setwd("/media/sf_Ubuntu_Data_Science/DATA SCIENCE MASTER VM/ Introducción a la modelización estadística. RegresionLineal")
## -------------------------------------------------------------------------
##       PARTE 1: INTRODUCCIÓN A LA REGRESION LINEAL
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 2. Bloque de carga de datos #####

creditos=read.csv("data/creditos.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 3. Bloque de revisión basica del dataset #####
#cada registro es una persona con sus ingresos/hora en dólares. Balance es el saldo en cuenta.
str(creditos)
head(creditos)
summary(creditos)

#exite un salario máximo muy distante de la media. En la estadistica clasica todo gira en torno a la media. Se puede eliminar
#pero ya es decision nuestra. La regresion lineal se ve afectada por los outlayers. Pero que consideramos como outlayer? depende de la media y la mediana.
#La estadistica robusta tiene en cuenta los outlayers y no hay que obviarlos, de hecho se tiene en cuenta.

## -------------------------------------------------------------------------

##### 4. Bloque de tratamiento de variables #####

creditos$Gender=as.factor(creditos$Gender)
creditos$Mortgage=as.factor(creditos$Mortgage)
creditos$Married=as.factor(creditos$Married)
creditos$Ethnicity=as.factor(creditos$Ethnicity)

summary(creditos)

## -------------------------------------------------------------------------

##### 5. Bloque de test de diferencia de medias mediante regresion lineal #####
#estudiamos las hipótesis nula y la contrastamos, por ver un poco la naturaleza del dataset.
t.test(Income ~ Gender, data = creditos)

# mediante un modelo lineal
modeloT=lm(Income ~ Gender, data = creditos)
summary(modeloT)
#R cuadrado ajutado penaliza un poco cada vez que metes más variables. Ya que R cuadrado al introducir más variables aumenta y no tiene pq ser bueno.
#Interpretacion del modelo: 
#me indica que la formula es: y=44.802-1.335*GenderFemale
#si yo hago una estimacion para los homnres, sería 44.8 y para las mujeres 44.8-1.3=43.5
#-1.3 tiene un error de casi 4, y su p-valor es 0.7 luego no es significativamente 0 y lo que se refleja es que la mujer y el hombre no cobran muy disinto.
# EL intervalo de confianza para -1.3, puedo calcularlo al 68 al 95 y al 99%. Sabemos que el error Std Error es casi 4, podemos clacular estos intervalos
# 68% [-5,3 2,8]
# 95% [-9,3 6,7]
# 99% [-12,3 10.7] 

## -------------------------------------------------------------------------

##### 6. Bloque de regresion lineal individual #####

modeloInd1=lm(Income ~ Rating, data = creditos)
summary(modeloInd1)
#Interpretacion: y=-16,2+0,17*rating
#Si me fijo entre la raelacion del Rating y el income no tengo que fijarme en R², solo me fijeré en el para hacer predicciones. Tenemos que fijarnos en los coeficientes.
#El rating influye en los ingresos ya que el p-valor no lo está indicando ya que es muy pequeño 2e-16 ***.
#Si el rating sube 1, el income sobe 0,17
#68% [0,17-0.08,0.17+0.008]
#95% [0,17-2*0.08,0.17+2*0.008]
#99% [0,17-3*0.08,0.17+3*0.008]~[0.1686,0.1724]

## -------------------------------------------------------------------------

##### 7. Bloque de representación gráfica #####

ggplot(creditos, aes(x = Rating, y = Income)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)
#no vamos a poder encontrar una formula que me ajuste para un rating de 250 6 o 7 valores de income, infeririamos en overfiting y no queremos eso, queremos que generalice.
## -------------------------------------------------------------------------

##### 8. Bloque de regresion lineal otras variables #####
#estudiamos distintas variables como influyen en los ingresos.
#la correlacion es simetrica, me da igual income-rating que rating-income. Rompiendo con la causa efecto.

#cuando se habla de ML no se da probabilidad, es un tema de puntaje o score porque no hay una distribucion estadistica detras.
#Si estuviera basado en distr. estadisticas se podría dar una probabilidad (por ejemplo en la regresion logaritmica)
modeloInd2=lm(Income ~ Products, data = creditos)
summary(modeloInd2)
#EL p valor 0.618   no es estadisticamente disinto de 0 por lo que no se puede rechazar la hipótesis nula.
# Conclusion: con los datos no podemos concluir que haya una relacion significativa entre productos e ingresos. Quizá si hay mas datos si pero no es representativo.
#no se puede concluir, o los datos no pueden contrastar la hipotesis que nos planteamos, que a mas products mas income o al reves.

modeloInd3=lm(Income ~ Age, data = creditos)
summary(modeloInd3)
#mis datos contrastan que a mas edad mas ingresos pero por los pelos: p_valor 0.0329* (0.05) confianza al 95%.
#Coresponde a que 1 de cada 20 falla

modeloInd4=lm(Income ~ Education, data = creditos)
summary(modeloInd4)
#deberian ser los mas mayores los que mas cobran. Los mas mayores son los que mas cobran y menos educacion tienen. Si la edada fuera constante los que mas cobran serían los que mas educacion tienen

modeloInd5=lm(Income ~ Gender, data = creditos)
summary(modeloInd5)

modeloInd6=lm(Income ~ Mortgage, data = creditos)
summary(modeloInd6)

modeloInd7=lm(Income ~ Married, data = creditos)
summary(modeloInd7)

modeloInd8=lm(Income ~ Ethnicity, data = creditos)
summary(modeloInd8)

modeloInd9=lm(Income ~ Balance, data = creditos)
summary(modeloInd9)

## -------------------------------------------------------------------------

##### 9. Bloque de regresion lineal multiple #####

modeloGlobal=lm(Income ~ ., data = creditos)
summary(modeloGlobal)
#vemos que hay coeficientes no significativos, deberiamos ir quitando uno a uno por que haya multicolinealidad.
#llama la atencion mortageYes es muy grande, 39 es muy grande pq el valor medio del salario es 44. Podemos estar ante un caso de multicolinealidad

## -------------------------------------------------------------------------

##### 10. Bloque de comparacion de modelos #####

anova(modeloInd1,modeloGlobal)
#nos indica que hay diferencias significativas, con el modelo 2 aporta muchas cosas mas que con el 1.
## -------------------------------------------------------------------------

##### 11. Bloque de Ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloMultiple=lm(Income ~            , data = creditos)
summary(modeloMultiple)

anova(modeloInd1,modeloMultiple)
anova(modeloMultiple,modeloGlobal)

## -------------------------------------------------------------------------

##### 12. Bloque de analisis del modelo #####
#nos quedamos solo con algunas variables
modeloFinal=lm(Income ~ Rating+Mortgage+Balance, data = creditos)
summary(modeloFinal)
plot(modeloFinal$residuals)
hist(modeloFinal$residuals)
#intentamos ver la normalidad de los puntos, si saliesen los puntos justo encima de la linea roja correspponderia juntamente con una normal
qqnorm(modeloFinal$residuals); qqline(modeloFinal$residuals,col=2)
#calculo de Intervalos de confianza, en este caso al 95%. Si sale una estrella o un punto en el p-valor no nos fiemos, si salen *** podemos estar mas tranquilos.
confint(modeloFinal,level=0.95)

cor(modeloFinal$residuals,creditos$Rating)
cor(modeloFinal$residuals,creditos$Balance)
#Tenemos una variable que es categórica, podemos observarla así:
boxplot(modeloFinal$residuals~creditos$Mortgage)
#cogemos la variable, la agrupamos por creditos$Mortgage haciendola funcion mean.
aggregate(modeloFinal$residuals~creditos$Mortgage,FUN=mean)

shapiro.test(modeloFinal$residual)

anova(modeloFinal,modeloGlobal)
#meter 7 coeficientes(grados de libertad) para pasar de 1 a 2 no merece la pena. No hay diferencias significativas entre ambos modelos, me qudaria con el mas sencillo, el 1.
## -------------------------------------------------------------------------

##### 13. Bloque de analisis de variable Balance #####

modeloBalance=lm(Balance ~ ., data = creditos)
summary(modeloBalance)
#vamos a explicar el saldo en cuenta respecto a otras variables.
#tnemos que buscar que cosas nos pueden llamar la atencion, el income es negativo, a menos ingresos menos balance es raro -->ceteris_parius
#aqui el problema es que el rating es un puntaje, a igualdad de rating el que tiene mas income tiene mas balance:
modeloBalance=lm(Balance ~ Income, data = creditos)
summary(modeloBalance)
## -------------------------------------------------------------------------

##### 14. Bloque de ejercicio #####

## ¿Cuales serian las variables que incluiriamos en el modelo?

modeloBalanceFin=lm(Balance ~                    , data = creditos)
summary(modeloBalanceFin)

anova(modeloBalance,modeloBalanceFin)

## -------------------------------------------------------------------------

##### 15. Bloque de modelado (stepwise) backward #####

ModelAutoBackward=step(modeloBalance,direction="backward",trace=1)
summary(ModelAutoBackward)
ModelAutoStepwise=step(modeloBalance,direction="both",trace=1)
summary(ModelAutoStepwise)
anova(ModelAutoBackward,modeloBalance)
anova(ModelAutoStepwise,modeloBalance)

## -------------------------------------------------------------------------
##       PARTE 2: REGRESIÓN MULTIPLE:
##                  APLICACIONES AL ESTUDIO DE LA OFERTA y LA DEMANDA
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 16. Bloque de carga de datos #####

Ventas=read.csv2("data/ventas.csv",stringsAsFactors = FALSE)

## -------------------------------------------------------------------------

##### 17. Bloque de revisión basica del dataset #####

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 18. Bloque de formateo de variables #####

Ventas$Fecha=as.Date(Ventas$Fecha)
Ventas$Producto=as.factor(Ventas$Producto)

str(Ventas)
head(Ventas)
summary(Ventas)

## -------------------------------------------------------------------------

##### 19. Bloque de Estimación de ventas en función al precio #####

modelo1=lm(Cantidad~Precio,data=Ventas)
summary(modelo1)
#y=3304.87-251.793*precio. Al amentar el precio en 1, las ventas han sido inferiores en -251.793.
#Con el precio explicamos el 82% de la variabilidad pero solo me vale para predicciones.
#Vemos que el p valor es estadisticamente sginificativo, disinto de 0 pero no me dicen que el valor sea representativo como valor, esto tengo que hacerlo atendido el Std Error. El error estandar es 2.5 aproximando por 3: 95% [-257,-245] son intervalos razonables con una horquilla razonalble.

plot(modelo1$residuals)
smoothScatter(modelo1$residuals)
#se mueven en torno al 0
hist(modelo1$residuals)
#vemos mucho mejor que se asemeja a una normal
qqnorm(modelo1$residuals); qqline(modelo1$residuals,col=2)
#se ajusta bien a la recta normal
confint(modelo1,level=0.95)

## -------------------------------------------------------------------------

##### 20. Bloque de Estimación de semielasticidad de las ventas con respecto al precio #####
#por definificon en las transparencias:
modelo2=lm(log(Cantidad)~Precio,data=Ventas)
summary(modelo2)
#interpretacion: como el log está en la parte izquierda, una subida de precio en 1 euro es que las ventas se van a recudir en un 14%
plot(modelo2$residuals)
smoothScatter(modelo2$residuals)
hist(modelo2$residuals)
qqnorm(modelo2$residuals); qqline(modelo2$residuals,col=2)
confint(modelo2,level=0.95)

## -------------------------------------------------------------------------

##### 21. Bloque de Estimación de elasticidad de las ventas con respecto al precio #####
#aplicando logaritmo en ambos lados. Este modelo es el que mejor va, economicamente hablando.
modelo3=lm(log(Cantidad)~log(Precio),data=Ventas)
summary(modelo3)
#interpretacion: como el log está en la parte izquierda, una subida de precio en 1% es que las ventas se van a recudir en un 0.87%. Dependerá del precio real que tendrá en ese momento.
plot(modelo3$residuals)
hist(modelo3$residuals)
qqnorm(modelo3$residuals); qqline(modelo3$residuals,col=2)
confint(modelo3,level=0.95)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN LINEAL MULTIPLE: 
##                  ESTUDIO DE CAMBIOS ESTRUCTURALES
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 22. Bloque de análisis gráfico por tipo producto #####

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col=2)
#pasa esto por que he querido juntar dos productos disintos en el mismo análisis
plot(modelo1$residuals,col=Ventas$Producto)
#vemos como existe un sesgo.
plot(modelo2$residuals,col=Ventas$Producto)
plot(modelo3$residuals,col=Ventas$Producto)

## -------------------------------------------------------------------------

##### 23. Bloque de análisis de estructuras por producto #####

modelo1_A0143=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0143",])
modelo1_A0351=lm(Cantidad~Precio,data=Ventas[Ventas$Producto=="A0351",])

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(modelo1_A0143,col="blue")
abline(modelo1_A0351,col="green")

summary(modelo1)
#y=3304.878-251.793*precio. R²=0.82
summary(modelo1_A0143)
#y=7264.56-1139.53*precio. R²=0.36. El verde aproxima mucho peor que el modelo que considera los dos, como es normal
summary(modelo1_A0351)
#y=4020.22-343.50 *precio. R²=0.1233.  

#Solo podemos compara con R² si provienen del mismo modelo de datos, en cuento lo cambiemos nos nos sirve.
## -------------------------------------------------------------------------

##### 24. Bloque de contraste de Chow de diferencias estructurales #####

chow.test(Ventas$Cantidad[Ventas$Producto=="A0143"],Ventas$Precio[Ventas$Producto=="A0143"],Ventas$Cantidad[Ventas$Producto=="A0351"],Ventas$Precio[Ventas$Producto=="A0351"])
#los modelos no son iguales y hay diferencias significativas

#hacemos los tres analisis enteiores de forma conjunta, obtendremos con una regresion los 3 modelos de golpe.
modelo1_Chow=lm(Cantidad~Precio*Producto,data=Ventas)

summary(modelo1)
summary(modelo1_Chow)
#agrupando, vemos que los coedificntes c y d son estadisticamente diferenctes de 0, por lo que son efectos distintos para los dos productos.
plot(modelo1$residuals,col=Ventas$Producto)
plot(modelo1_Chow$residuals,col=Ventas$Producto)

plot(Ventas$Precio,Ventas$Cantidad)
abline(modelo1,col="red",lty = "dashed")
abline(a=7264.56,b=-1139.53,col="blue")
abline(a=7264.56-3244.34,b=-1139.53+796.03,col="green")

anova(modelo1,modelo1_Chow)

## -------------------------------------------------------------------------
##       PARTE 3: REGRESIÓN MULTIPLE:
##                  OUTLIERS Y LA FALTA DE ROBUSTEZ
## -------------------------------------------------------------------------

## -------------------------------------------------------------------------

##### 25. Bloque de creación de datos simulados #####
#creamos un dataset.
x=c(1,2,3,4,5,6,7,8,9,10)
y=3*x+2+rnorm(length(x),0,1)
Datos=data.frame(x,y)
modelolm=lm(y~x, data=Datos)
summary(modelolm)


xOut=c(x,15)
yOut=c(y,300)
DatosOut=data.frame(xOut,yOut)
modelolmOut=lm(yOut~xOut,data=DatosOut)
summary(modelolmOut)

## -------------------------------------------------------------------------

##### 26. Bloque de representación gráfica #####

#la estadistica robusta identifica automaticamente los outlayers y los trata, no tenemos que quitarlos
#library(MASS)
#modelolm=rlm(y~x,data=Datos)
#modelolmOut=lm(yOut~xOut,data=DatosOut)


plot(xOut,yOut)
abline(modelolm,col="blue")
abline(modelolmOut,col="red")
#Vemos como la regresion ajuta mal con los outlayers. Un unico outlayer me fastidia bastante.
abline(a=modelolm$coefficients[1],b=modelolm$coefficients[2],col="blue")
abline(a=modelolmOut$coefficients[1],b=modelolmOut$coefficients[2],col="red")

ggplot(Datos, aes(x = x, y = y)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

ggplot(DatosOut, aes(x = xOut, y = yOut)) + geom_point() + 
  geom_smooth(method = "lm", se=TRUE, color="red", formula = y ~ x)

## -------------------------------------------------------------------------