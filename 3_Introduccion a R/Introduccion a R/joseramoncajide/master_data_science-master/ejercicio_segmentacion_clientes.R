library(dplyr)

#Cargamos el Dataset
customers=read_csv('http://archive.ics.uci.edu/ml/machine-learning-databases/00292/Wholesale%20customers%20data.csv')
customers %>% head(5)

#Son datos de clientes. Tenemos las cantidades, en dinero, que ha gastado cada cliente en un periodo determinado
#en ese tipo de productos en una tienda.

#canal y region están cargados como número y son veriables discretas(texto), hay que transformarlas.
customers <- mutate(customers, Channel = as.factor(Channel))
customers <- mutate(customers, Region = as.factor(Region))
#Si hacemos un class de esa variable, vemos que está en el formato que nos interesa.
class(customers$Channel)
class(customers$Region)

#si cada fila es un cliente, cuantos clientesn en cada canal han comprado?
table(customers$Channel)

#porcentaje de clientes en cada canal respecto del total
(table(customers$Channel)/nrow(customers))*100

#install.packages('GGally')
library(GGally)
ggpairs(customers)

#Segmentacion de clientes.
#El proceso normal sería explorar los datos, buscar variables correlacionadas (en este caso detergente con grocery entre otras)
#por tanto aportan la misma informacion y podría eleminar una de ellas.

#otra forma de ver la correlacion sin tener que hacer lo anterior
customers %>% 
  #seleccionamos los productos comprados por el usuario
  select(Fresh:Delicassen) %>% cor()

#install.packages('corrplot')
library(corrplot)

customers %>% 
  select(Fresh:Delicassen) %>% cor() %>% corrplot(method = 'number')


#Proceso de segmentacion:
#1. creamos un DF (ya lo hemos creado antes)
customers %>% 
  select(Fresh:Delicassen)
#2. Escalado de los datos. Hay muchas formas, las que ams se usa es la Standarization: (x-mean(x))/st(x)
#   todas las variables se situarán junto con la media.
#   Esto sirve cuando haya variables que tenhgan distinta naturaleza, euros y millas por ejemplo. Aqui no sería del todo necesario
customers_scaled<-customers %>% 
  select(Fresh:Delicassen) %>% 
  scale()
#3. Seleccion del modelo, en este caso KMeans
fit<-kmeans(customers_scaled,5)#va a hacer 5 clusters(centroides)
#fit me devuelve una lista con todos los datos, a cada observacion, la etiqueta al clusters que se le ha asignado.
fit
#añadimos al ds original la columna cluster con lo que nos devuelve el modelo.
customers<-customers %>% 
  mutate(cluster=as.factor(fit$cluster))

#COMPLETAR CON EL CODIGO DEL PROFESOR....
#instalar
#library(ggfortify,cluster)
#autoplot(fit,data=customers,...)

#EJERCICIO: tenemos customers, pues bien tenemos que inspeccionar las caracteristicas de cada segmentto. Para ello
#agrupo por clusters y calculo la media de todas las columnas. Veremos que el CL1 destaca por algo el 2 por otra cosa
# y así.

customers %>% 
  group_by(cluster) %>% 
  summarise_all(mean)

#Si no nos convence la segmenteacion, variamos los parámetros del modelo (clusters)
