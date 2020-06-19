#Vamos a crear un ejemplo para estimar el valor del nº PI.

#Muestras
N=100000;

#muestras aleatorias entre -1 y 1
x=runif(N,-1,1)
y=runif(N,-1,1)

plot(x,y)

#definición de la ecuación del círculo
c=(x*x+y*y<=1)

#Plotting
plot(x,y,cex=1,col=c)

head(c)

#esta media por 100 es el % de puntos que caen dentro del círculo:
mean(c)
#la media*2*2 que es el área del cuadrado que contiene al circulo es una aproximacion bastante buena al nº pi:
mean(c)*4

#Si repite este proceso saldrña un nº ligeramente distinta. Conforme vayamos modificando el nº de muestras N
#podremos ajuntar aun más el valor de PI, ahora variará menos. La precision de la estimación depende del tamaño
#muestral. Al aumentar N, la ganancia sobre la precicion no es lineal, se pasa de 10000 a 1e6 y solamente se gana
#precision en un decimal. Se puede adelantar que la ganancia aumenta en un factor sqrt(N)

#La vocación del muestreo es básicamente reducir costes.
#El muestreo como usa un nº menor de muestras de la población podemos controlar mejor la calidad de la recogida de información.
#Lo ideal es muestrear de manera inteligente para que la muestra coja todas las características de la población original.

#Concepto de sesgo: lo peor que le puede pasasr a un muestreo es que esté sesgado, es decir, que la muestra no refleje la realidad.
#Básicamente, algo sesgado es que no refleja la realidad. Es el mayor peligro del muestreo.

#El muestreo permite maximizar la representatividad, es decir que muestre todas las caracteristicas de la poblacion.

#El objetivo fundamental del muestreo es evitar el sesgo y controlar el error muestral (en el ejemplo anterior, sería
#controlar la distancia a la cual el experimento baila alrededor de pi, es decir, controlar la precision en la estimación).

#El error muestral es la variacion del resultado de una muestra a otra.
#El error muestral aparece en el momento que no uso la población total y empiezo a elegir muestras.
#Si escojo muestras aleatorias, el error variará de la misma forma. 
#Al aumentar el tamaño de la muestra, como es lógico, este error disminuye.

# Error Sistemático (es el sesgo), que es distinto al error muestral), viene dado de manera sistemática cuando 
# excluimos una parte de la población. Dos tipos de sesgo según si ocurre a nivel del muestreo o nivel de la medicion.
# - Sesgo de seleccion: cuando la seleccion estña condicionada por la caracteristica a medir.
# - Sesgo de informacion: ocurre en la medicion de la característica de interes (sesgo de memoria, efecto del entrevistador o del cuestionario,...)

#Para evitar el problema del sesgo de seleccion es seleccionar las muestras aleatoriamente, de esta forma no estará condicionada a nada.

#Ejemplo de los aviones y las balas. Los aviones que volvieron son los que no recibieron impactos de bala en sus partes vitales,
#Es por ello que el estadístico ingles reforzó las partes que no estaban tocadas por las balas.

#TECNICAS DE SELECCIÓN

#Seleccion aleatoria dentro del conjunto de la poblacion para evitar el sesgo.

#Población diana: es sobre la que queremos sacar conclusiones. En princpio no podemos muestrear sobre ella, se expluyen elementos, no es idónea
#Población base: es sobre las que es posible obtener informacion. La información extraida sobre esta puede extrapolarse
#sobre la poblacion diana si y solo si se cumplen los criterios de inclusion/exclusion.
#Muestra: subconjunto de la poblacion base (n) con un tamaño mucho menor que el de la pobacion base. (n<<N)

#El muestreo deba ser probabilistico (nos centraremos en este). La probabilidad de que un elemento pueda ser seleccionado para la muestra debe ser no nula.
#Existen muestreos no probabilisticos (problemas con el error muestral).

#MUESTREO ALEATORIO SIMPLE.
# Constituye la base de todos los muestreos. Numeramos los individuos y sacamos una muestra de "n" unidades usando un procedimiento aleatorio
# Es equiprobabilistico, es decir que todos los individuos/muestras tienen la misma prob de ser seleccionados (n/N)
# No todos los muestreos permiten esto último. 
# Otra consecuencia sería que si saco la media de los sueldos de unos individuos por este método, esta puede ser usada para calcular el sueldo del resto de población.
# Tiene algunas limitaciones: es poco eficiente (muestras poco representativas).

#MUESTREO ALEATORIO CON REPOSICION.

#Las muestras son seleccionadas una tras otra, devolviendo cada muestra antes de que se seleccione la siguiente.
#De esta forma, una unidad puede aparecer más de una vez en el muestra.

# Constituye un muestreo equiprobabilistico.
# Las muestras pueden generar un mayor error probabilistico. Si la poblacion es muy grande es lo mismo que el muestreo sin reposicion.

#MUESTREO ESTRATIFICADO Y POR CONGLOMERADOS
#Se trata de muestreo con informacion sobre la estructura de la poblacion.
#La poblacion se puede dividir en subgrupos homogéneos (llamados estratos). Se espera que la variable de interés varíe entre los estratos.
#La población puede ser dividida en  unidades primarias que muestran características similares y que son más faciles (ecomonicamente hablando tambien).
  
  #A) MUESTREO ESTRATIFICADO.
  # Merece la pena usarlo cuando la variable de interés difiere mucho de un grupo a otro. Ej: todos los hombres ganan lo mismo y todas las mujeres tambien
  # pero la diferencia entre sueldo de hombres y mujeres es muy grande.
  # Idea: que entre estratos haya mucha heterogeniedad y dentro de cada estrato mucha homogeneidad
  # Idea: que el nº de estratos sea reducido.
  # Asignacion de los estratos uniforme: poco deseada, no muestra la realidad.
  # Asignacion proporcional: la distribucion se acercará mas a la realidad. Se intenta buscar la proporcion en los estratos.
  # Se distribuye de acuerdo al peso del estrato en la población. Pero tampoco es lo más optimo. 
  # La idea es hacer más esfuerzo (mas observaciones) donde hay mas variabilidad, es donde hay que rascar algo. Ahí es donde está la información potencial
  # Asignación óptima: tiene en cuenta la variablidad en el seno de cada estrato. Tiene la dificultad que es dificil encontrar la variabilidad dentro de cada estrato.
  # Cuando los estudios se hacen cada periodos largos de tiempo, somos capaces de observar o detectar esta variabilidad.
  
  #Aplicando asignacion proporcional tendríamos un estimador natural para estimar la media de la poblacion (ya que es equiprobable).
  
  #Ejemplo de implementacion con R-> ver en archivo muestreo.R

  #B) MUESTREO POR CONGLOMERADOS.
  # Suponemos que las unidades de la población están agrupadas por conglomerados (barrio, empresa,...).
  # Idealmente cada conglomerado es una imagen a pequeña escala de la poblacion.
  # El primer objetivo de este muestreo es reducir los costes. EN vez de muestrear directamente los individuos, muestremos grupos de ellos.
  # Ver ejemplo muestreo.R

###### INFERENCIA

N=1e6
alturas=rnorm(N,100,7) #Altura de 1m con una cierta desv.tip
n=500
#extraigo muestra de la población
muestra=sample(alturas,n)
mean(muestra)

#usando la teoría estadistica, puedo obtener a partir de una sola muestra, resultados de este tipo:
t.test(muestra)
#Solo una muestra, nos proporciona un intervalo de confianza para el tamaño medio "95 percent confidence interval:98.03288 100.56506"
#Esto significa que el 95% de las muestras el verdadero valor estará dentro del intervalo.

#la estadistica descriptiva solo describe lo que hay en la muestra. No se evalua el error cometido al inferir sobre la poblacion.

#Podemos hacer 2 tipos de inferencia: por estimacion(estimamos una media), o tomamos una decision (vemos si las niñas tiene un tamaño mayor que hace 10 años)

#El razonamiento inferencial es opuesto al razonamiento deductivo.

#Concepto de variable aleatoria: ¿cuantos envases (en Kg) recicla un hogar al año?
# Este volumen de envases es una variable ( X ) porque varía de un hogar al otro.
# Es aleatoria porque no controlamos (del todo) sus variaciones; no podemos prever sus valores de manera deterministica
#¿Cómo describir una variable aleatoria?-->histograma, media, std, pdf...
# la desviacion típica es usada y se define como sqrt(varianza) para tenerla en las mismas unidades.
# distribucion normal,centrada en la media. Suele representar una variable numérica y contínua. Es muy practica pq conociendo la media y la std conocemos todo.

#Inferencia sobre la media: una forma natural de estimar un parametro poblacional consiste en utilizar su equivalente muestral.
#La media muestral "y" es la media de los valores de la muestra. 

#Incertidumbre en la estimacion: el error estandar de la media muestral es proporcional a la desviacion típica de los datos: error_estandar=sigma/sqrt(n)
#Vemos que es proporcional a la raiz de n y no directamente a n.
#Teorema central del limite
#Cuando n(tamaño muestral) y (N-n)(tamaño muestral pequeño en relación a la poblacion) son grandes la media muestral se puede aproximar por una distribucion normal con media mu y desviación típica sigma.

#ejemplo:
require(tidyverse)
set.seed(1234)
NN=1e6
poblacion=rnorm(NN,108,5)#poblacion
n=250#tamaño muestral
#en vez de hacer un bucle podemos usar replicate para generar 1000 veces el proceso
K=1000
medias=replicate(K,mean(sample(poblacion,nn)))#obtendremos 1000 medias muestrales

#es un muestreo equiprobabilistico, la media deberia ser igual a la otra media, es decir 108.
#según la teoria el error=sigma/sqrt(n)=5/sqrt(10)~1/3cm
mean(medias)
sd(medias)
1/sqrt(10)
#Histograma
qplot(medias,ylab="frecuencia",xlab="Media Muestral",bins=10)
#y vemos como se aproxima a una distribucion normal.

#Si aumento el tamño muestral mu y sd serán mucho mas parecidas. Resultado asintotico n->N mu y sd serán mas parecidos a la teoria.

#El intervalo de confianza permite reflejar la incertidumbre en la estimacion. Típicamente un interv. (del 95%) de la media poblacional tiene la forma media_muestral(y)+-1.96+se(media_muestral)
# 1.96 corresponde al cuantil 97.5%: qnorm(0.975)=1.959964, de ahi viene este valor.

#Con R:
K=1000

resumen<-function() {
  muestra=sample(poblacion,nn);
  c(media=mean(muestra),ds=sd(muestra))
}

res=replicate(K,resumen())
#traspongo y lo pongo en formato DF para que no sea horrible. 
res=data.frame(t(res))
head(res)

#Calculo un intervalo de confianza para cada muestra
res$limite_inferior=res$media-1.96*(res$ds/sqrt(nn))
res$limite_superior=res$media+1.96*(res$ds/sqrt(nn))
head(res)
#Segun la teoria, en el 95% de los casos contendrán el verdadero valor (mu=108)
#Calculamos el acierto.
res$acierto=(res$limite_inferior<108 & 108<res$limite_superior)
head(res)
mean(res$acierto)
# es un 95.4% de acierto. Pero hemos hecho trampa, no conocemos sigma a la hora de calcular el error, no la conocemos. 
# Hemos sustituido la verdadera desviacion poblacional por la desviacion de la muestra. Podemos hacerlo pero no podemos hacer oidos sordos y ser consecuente.
# Varia el centro del intervalo y tambien su tamaño (debido a este motivo). Se puede construir un estimador pero no deja de ser lo que es, un estimador. Tendremos mas variabilidad de la esperada.

#la distribucion t-student es como una normal pero más pesada, sus colas se alargan mas y es por que hay mas incertibumbre:
#y+-t*s/sqrt(n)
qt(.975,nn-1)#donde nn son los grados de libertad
#1.969537 es un dato más grande que va a generar mas incertidumbre.
#Si nn grande, se aproxima a más a la normal

#Calculamos los intervalos de confiana de acuerdo al cuantil de la student:
#Calculo un intervalo de confianza para cada muestra
res$limite_inferior=res$media-qt(.975,nn-1)*(res$ds/sqrt(nn))
res$limite_superior=res$media+qt(.975,nn-1)**(res$ds/sqrt(nn))
head(res)
#Segun la teoria, en el 95% de los casos contendrán el verdadero valor (mu=108)
#Calculamos el acierto.
res$acierto=(res$limite_inferior<108 & 108<res$limite_superior)
head(res)
mean(res$acierto)
#vemos como ahora obtenemos un 97.9% de acierto. 

#Por otro lado, podemos calcular el tamaño muestral necesario para alcanzar un determinado error:
#El margen de error lo conozco, es: 1.96*(res$ds/sqrt(nn)), y vemos como es proporcional a nn.
#Pero vemos como seguimos sin conocer Sigma. Podemos usarlo de un proyecto piloto anterior o coger el de la muestra.


#REVISAR CONTRASTE DE HIPÓTESIS EN APUNTES
#Oobteniendo el p_valor en R: 
pnorm(327,330,5/sqrt(10))








