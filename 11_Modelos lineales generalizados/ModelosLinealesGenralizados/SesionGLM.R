cars
View(cars)

#FUNDAMENTOS MODELO LINEAL NORMAL

#Los modelos son agnosticos de la realidad, no saben que quieres hacer, encontes
#si se usa mal puede dar valores erróneos.

#Vamos a intentar dada una distancia, calcular una velocidad.
#En R la funcion que permite crear un modelo linal es "lm". Ver ayuda
#lm(variables a predecir~variables predictoras,datos,) 
lmcars<-lm(speed~dist,data=cars)
#un modelo lineal tiene muchos atributos ocultos: lmcars$+tab (coeficientes, residuos y fit.values son los que vamos a ver)
require(ggplot2)
#plotear ambas variables
#

#Importancia de la estimación por descenso por gradiente en el mundo big data.
#En este caso se usa modelos ML ya que hay pocos datos en el dataset.

lmcars$residuals
#hay 50 residuos pq hay 50 observaciones, un error por observación.
#Si hacemos su media vemos que es 0. Pero no debemos mirar el error sin mas, hay que ver los max, min y std
summary(lmcars$residuals)
#los valores del modelo son: lmcars$fitted.values
#variable a predecir es la distancia.

#El valor real menos los residuos veberían darte los valore del modelo
cars$speed-lmcars$residuals
lmcars$fitted.values
#y vemos que son iguales

#lmcars intercept es donde intercepta con el eje de abcisas.
#lmcars dist es por lo que se multiplica
# speed=8.2839+0.1656*dist

#Probamos con otro dataset
mtcars
#calcularemos el tiempo que tarda en recorrer 1/4 de milla.
#en este caso usaremos más de una variable predictora
lmtcars<-lm(qsec~cyl+hp+wt,data=mtcars)
#aqui el modelo es: y=ax_1+bx_2+cx_3 el modelo correspondería un hiperplano
mean(mtcars$qsec)
#Por cada unidad de cilindro, y disminuye 0.58, y así con todas las variables.
#un coeficiente es mas importante cuanto mas grande es su valor (mas peso), se pueden comparar coeficientes atendiendo a sus coeficiente.
summary(lmtcars)

#Cuantos mas datos mejor se estima el modelo.
#p_valores, al ser mas bajo mejor (mas asperiscos), el coef será mas significativo, es decir, importante.
#el coeficiente que más importancia tiene es hp en este caso
summary(mtcars$hp)
#hp va desde 52 hasta 335.
#La unidad que se ha estimado depende de los valores que toma la variable de origen.
#varía mucho.
#Hay que fijarse en la significancia del parámetro. En este caso el p-valor.

#vamos a ver si todo esto es verdad. Si se añade un nº al azar,¿ayudará a predecir mejor? 
#NO, NO CONTIENE INFORMACION RELECVANTE ASÍ QUE NO DEBERÍA
nrow(mtcars)
mtcars$azar<-rnorm(32)
#creo otro modelo con esta variable
lmtcars2<-lm(qsec~cyl+hp+wt+azar,data=mtcars)
summary(lmtcars2)
#vamos la significancia, y como preveiamos no lo es, no es significante.

# ejemplo con VARIABLES COLINEALES (VARIABLES AUNQUE NO SEAN LA MISMA SE PARECEN MUCHO)
#en un mismo modelo competirían entre sí robandose varianza. Va parecer que no son tan buenas pero ambas lo son
mtcars$wt2<-mtcars$wt*10+5+rnorm(32)
#realmente son la misma variable solo que alterada, su comportamiento debería ser lo mismo
#vamos a ver que pasa ahora
lmtcars3<-lm(qsec~cyl+hp+wt+wt2+azar,data=mtcars)
summary(lmtcars3)
#vemos el problema de la colinealidad que ahora ni wt sale significativa. Esto es un problema muy frecuente.
#pasa otra cosa, que la estimacion de wt es 1.08 pero su error es de 1.8, luego estámuy mal estimado.
#¿que variable decido quitar o dejar en el modelo? Hay mucha bibliografia pero genetalmente dos métodos
# 1. Lo que aplicaremos nosotros. NOTA: Modelos anidados son aquellos cuyos parámetros están en el mismo espacio paramétrico.
#   Si están anidados se pueden comparar entre si.Si añades variables insignificantes, el modelo no mejora y hay que quedarse con el anteior.
#   Esto es el concepto de STEPWISE (seleccion por pasos), compara (guiandose por el error), seleccionando variables y así nos quedamos conn la mejor
#   Stepwise se puede hacer hacia delante o hacia detras o en las dos direcciones, es indisinto. LO que cambia es que cojas una variable u otra.
# 2. PCA. Pierdes interpretabilidad de las variables pero es muy potente.

#1.
#Esto no se va a hacer así, se hace automáticamente
#Anova compara dos modelos y usando esto se puede seguir la metrica del stepwise
anova(lmtcars2,lmtcars)
lmtcars0<-lm(qsec~cyl,data=mtcars)
anova(lmtcars,lmtcars0)
#estos dos modelos son distintos F=18,9 y nos quedariamos con el segundo.
#Forma automática:
help("step")
#AIC es para comparar modelos tanto anidados como no anidados(no se debría pero se usa)
step(lmtcars3,direction = "both")
#SI el AIC baja es mejor.
#podemos usar este método de tanto en modelos lineales como en modelos lineales generalizados.
step(lmtcars0,direction = "both")
step(lmtcars2,direction = "both")

names(lmcars)
#para comparar usamos el AIC o el logLik
AIC(lmcars)#cuanto mayor mejor
logLik(lmcars)
#FORMAS DE HACER UN DIAGNOSTICO PARA VER SI SE HA HECHO BIEN EL MODELO
plot(lmtcars3)
#Que los coches indpendentemente de si son lentos o rapidos tengan un error mas o menos es el mismo es bueno, no hay error sintemático
#Es bueno que no haya correlacion entre el error y el valor predecido, esto indicaría error sistemático.
#NORMAL Q-Q. Si sigue la manera punteada, es que los residuos siguen una distribucion normal.
#Leverage es un nº que me indica si un dato es influyente en el modelo. Un punto con mucho leverage indica un modelo inestrable, que si quitas ese punto el modelo variará muhco. Y no va a ser un modelo que generalice bien
#hay que buscar que el leverage esté dentro de un intervalo razonable.
#en principio todo parece que se estima correctamtne en el modelo 3 que es el malo, el que tiene la redundancia y el ruido

library(ROCR)
library(caret)
#dummy variables: me creo una variable España y te pongo un 1 si eres español o un 0 si no, y así con el resto de paises.
#Estas variables dummy son lineales ya que entre dos puntos (o un 1 o un 0) sólo hay lineas.
#En R y en mtcars, am es una variable cualitativa (ya es una dummy por si sola) y tal y como está ya podríamos meterla en el modelo
lmtcars4<-lm(qsec~hp+cyl+wt+am,data=mtcars)
#interpretacion AM, cuando incremento una unidad, se hace manual (1=manual)
#concepto de referencia de una estmacion de una variable dummy.

summary(mtcars$mpg)
#agrupamos según su valor definiendo intervalos, si están por debajo de 15, 2, si están por encima de 15 y debajo de 22 1, y si está por encima de 22 0.
mtcars$mpg_cualitativa<-as.factor((mtcars$mpg<15) +(mtcars$mpg<22))
lmtcars_cualitativa<-lm(qsec~mpg_cualitativa+hp,data=mtcars)
summary(lmtcars_cualitativa)
#debería haber 3 variables dummy, la del 0, la del 1 y la del 2.Pero hay solo 2, la variable de referencia es la que desaparece, en este caso la del 0
#mpg_cualitativa1  0.107371  significa que si perteneces al grupo 1 tu valor se incrementa en ese valor comparado ocn el valor de referencia.

#Usar variables cualitativas en las variables a predecir--> para eso hay que usar GLMs
summary(lmtcars)
#una variable categórica (la dependiente, la de los residuos) de 2 niveles nunca puede ser una normal, el supuesto de normalidad se incumple desde le principio. Ya no nos vale el modelo gaussiano y ya hay que pasarse a otros modelos--> MODELO BINOMIAL y regresión LOGÍSTICA.
#Siempre a resolver un problema categórico no se puede resolver con un lm, tiene que ser con un GLM

#GLM

# 1.DIstribucion de una variables=distribucion de los errores
# 2.Funcion de enlace(g(y)) -->ver apuntes
# 3.Combinacion lineal.

#ejemplo titanic regresión (estimación) logística.
#install.packages("titanic")
library(titanic)
#se usa regresion logaritmica pq hay una gran conexion entre las variables categóricas.

#lo que quiero usar es titanic_train en verdad, para entrenar el modelo.
head(titanic_train)
#primer modelo:
titanic0<-glm(Survived~Age,data=titanic_train)
summary(titanic0)
#ha usado el lm normal, para ello
titanic0$family
#vemos que como no le hemos especificado nada ha usado un modelo normal (gaussiano) y funcion enlace la identidad
#Pero es un error, pq está mal. La variable no sigue una funcion de distribucion gaussiana, esto no te lo dice nadie, hay que saberlo, a través de ver el histograma o la funcion QQ. Muchas variables aunque son cuantitativas no son normales (ojo con esto).

#Hay que tener fundamentos en estadistica, (ver referencias de coursera y libros dados por Alejandro)
#vemos el parámetro family de glm. Se le especifica la distribucion y la funcion de enlace
titanic0<-glm(Survived~Age,data=titanic_train,family = gaussian(link="identity"))
titanic0$family

titanic1<-glm(Survived~Age,data=titanic_train,family = binomial(link="identity"))
titanic1$family
summary(titanic1)
# En cualquier modelo lineal el 0 es la referencia, para cualquier variable.
#vemos que a mayor edad, menos tasa de supervivencia. Pero probablemente es muy raro que la relacion sea lineal.
#age muy parecido a 0 indica que ahora el intercepto es la probabilidad (0.48) e indica que mas o menos la mitad de las personas murió.
#mas pendiente (age) mas se distinguen los que mueren de los que sobreviven y cuando es menor es que hay  mas confusion.

#la logistica solo puede hacer barreras lineales (solo puede expresarlas mediante una combinacion lineal estas, no curvas).
#vamos a usar una logit, en vez de identity
titanic2<-glm(Survived~Age,data=titanic_train,family = binomial(link="logit"))
summary(titanic1)
#el AIC cuanto mas alto peor, y aqui vale 964.32
summary(titanic2)
#ahora las estimaciones de los coef cambian: Positivos: aumenta la probabilidad de 1, negativo:disminuye la prob. de uno
#ver concepdo de "Odds", es una forma de expresar probabilidades: prob%/(1-%prob) te dá la Odds: Ejemplo: 0.9/0.1=9 Odds. 0.5/0.5=1 Odds.
#Odds ratio es, si cogemos el ejemplo anterior (tos y no tos para grupo de fumadores y grupo de no fumadores), es la division de las divisiones, en este caso 9/1=9, quiere decir que en grupo de arriba, hay 9 veces mas tos que en el de abajo.
#Para hacer esto es necesario dos grupos. 
#En la funciones binomiales son odds ratios, no probabilidades.

#volviendo a los modelos, redefinimos con mas variables:
titanic2<-glm(Survived~Age+Pclass+Sex,data=titanic_train,family = binomial(link="logit"))
summary(titanic2)
#vemos como ha descendido el AIC. Vemos relaciones mucho mas potentees, la mortalidad depende mucho de la edad, no linealmente, pero tambien de la clase y del sexo.
#que Pclass sea -1.28 significa que a mayor nº de clase menor probabilidad de superv.
#sexmale indicaria 0 hombres, 1 mujeres. Un incremento en Sexmale es un deremento de la mortalidad. Tienes un 2.52 menos de probailidad de morir que el otro grupo.
#sale sexmale como es 0 o 1 y es dummy pero no Pclass, hay que transformarla en dummy.
#Cuando ya tienes mas de una variable, el efecto de los coeficientes depende de los demás.
#Ojo con confiar en que estos modelos pueden resolver cualquier cosa-->supuesto de aditividad: se van suponiendo cosas que hacen que algo coja mucho peso, pero en el mundo real no todo es aditivo, cuidado con esto.
#En estos casos el error no se mide con las distancias (como se hacia en los modelos anteiores)
#se usan matrices de confusion--> basicamente son porcentajes de error:
titanic2<-glm(Survived~Age+as.factor(Pclass)+Sex,data=titanic_train,family = binomial(link="logit"))
summary(titanic2)
#ahora sí me lo trata como una variable categórica. La variable de referencia es (Pclass)1. Es peor para la mortalidad ser de tercera clase.
#Los grados de libertad: nos indican cuanas cosas puedo modificar antes de quedarme sin mas opciones.
#Cuantos cambios puedo hacer en mis param antes que el modelo quede cerrado. 

titanic2$fitted.values#vale entre 0 y 1, y representa g(y) que es la funconi de enlace y en este caso particular es una logi. La funcion de enlace transforma la combinacion lineal en esa probabilidad entre 0 y 1. La combinacion lineal va desde -inf hasta inf
#pasar la combinacion lineal por la funcion de enlace minimiza el error.
#donde corto? fallece no fallece
misPredicciones=titanic2$fitted.values>0.5#serán los que sobreviven los que estén por encima de 0.5

#Supniendo que estamos con el test en vez de con el train.
titanic_train$Survived
(misPredicciones*1)#para transformar true en 1 y false en 0
#comparamos
titanic_train$Survived==(misPredicciones*1)
mean(titanic_train$Survived==(misPredicciones*1))

#SI hago lo mismo estableciendo la frontera en 0.6, 0.8 y 0.9 cambia la media de acierto.
#¿qué punto cojo? Lo decidiré yo en base a lo que quiera arriesgar. Depende de lo conservador que sea cogeré una u otra
#si hago algo muy sensible, detectará falsos positivos, acertará siempre pero a costa de acertar cuando no debe.
#Lo contrario es especificidad. Podemos decidir el punto de corte según la curva ROC.

#respuesta del modelo 0<respuesta<1
p<-titanic2$fitted.values
#Segunda manera:
p<-predict(titanic2,type="response")#sin el response, devuelve el combinador lineal.Pero esto es trampa pq estamos haciendo el training. Tenemos que hacerlo sobre el este, por ello usamos otro dataset de datos.
#p<-predict(titanic2,type="response",newdata=titanic_test)
library(ROCR)
titanic_prediction<-prediction(p,titanic_train$Survived)#como p es del train voy a usar el train
#imputacion de los valores nan pq si no da error
titanic_train$Age[is.na(titanic_train$Age)]<-mean(titanic_train$Age, na.rm=TRUE)
#titanic_train$Age[is.na(titanic_train$Age)] si hacemos esto debe devolcer 0, ya están rellenos con la media.
#Hay que volver a entrenar al modelo:
titanic2<-glm(Survived~Age+as.factor(Pclass)+Sex,data=titanic_train,family = binomial(link="logit"))
#vuelvo a predecir:
p<-titanic2$fitted.values
titanic_prediction<-prediction(p,titanic_train$Survived)
#Curva roc:
plot(performance(titanic_prediction,measure="tpr",x.measure = "fpr"))
#hay muchas formas de medir un estadistico pero todas estan basadas en la tabla de confusion (acierto fallo).
#pero el precio del coste lo determina el usuario, el modelo no lo sabe.
#para ver el punto de corte vemos los alpha values que son los cutoff:
k<-performance(titanic_prediction,measure="tpr",x.measure = "fpr")
#k es un objeto especial que tiene slots. Para acceder a los slots @. [[1]] indica que es una lista
str(k@x.name[[1]])
l<-k@x.name[[1]]
max(which(l>0.2))
k@alpha.values[[1]][1]

#para el auc (área bajo la curva) otro indicador como el ROC
performance(titanic_prediction,measure="auc")
#un auc por debajo de 0.5 indica que se ha invertido.

#para aprender mas R:
#https://www.coursera.org/learn/r-programming

#https://www.coursera.org/learn/statistical-inference

#https://www.coursera.org/learn/regression-models

#https://www.edx.org/es/micromasters/data-science

#una vez sea subido el TFM a github, vamos a https://medium.com y ahí podemos publicar un blocpost.




