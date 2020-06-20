##########################################################################
# Jose Cajide - @jrcajide
# Master Data Science: Data wrangling with dplyr
##########################################################################

list.of.packages <- c("R.utils", "tidyverse", "doParallel", "foreach", "sqldf", "broom", "DBI", "ggplot2", "tidyr", "lubridate")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


flights <- readr::read_csv('data/2008.csv')

#exploracion inical dataframe
names(flights)
#cuantos datos hemos cargado?
dim(flights)
#inspecccionamos las dos primeras o las dos ultimas filas
head(flights,2)
tail(flights,2)

#es equivalente a describe() de python
summary(flights)

# DPLYR -------------------------------------------------------------------

# Identify the most important data manipulation tools needed for data analysis and make them easy to use in R.
# Provide blazing fast performance for in-memory data by writing key pieces of code in C++.
# Use the same code interface to work with data no matter where it’s stored, whether in a data frame, a data table or database.

# The 5 verbs of dplyr
# select – removes columns from a dataset
# filter – removes rows from a dataset
# arrange – reorders rows in a dataset
# mutate – uses the data to build new columns and values
# summarize – calculates summary statistics

library(dplyr)

# SELECT() ----------------------------------------------------------------------------

flights[c('ActualElapsedTime','ArrDelay','DepDelay')] # base R
#esta funcion es del paquete dplyr. Lo podemos hacer así o con R base que es el caso anterior:
select(flights, ActualElapsedTime, ArrDelay, DepDelay)
#Select para seleccionar las columnas. Como loc e iloc

# Funciones de ayuda para hacer selección dentro del select.

# starts_with(“X”): every name that starts with “X”
# ends_with(“X”): every name that ends with “X”
# contains(“X”): every name that contains “X”
# matches(“X”): every name that matches “X”, where “X” can be a regular expression
# num_range(“x”, 1:5): the variables named x01, x02, x03, x04 and x05
# one_of(x): every name that appears in x, which should be a character vector

select(flights, Origin:Cancelled)
select(flights, -(DepTime:AirTime))
select(flights, UniqueCarrier, FlightNum, contains("Tail"), ends_with("Delay"))

# MUTATE() ----------------------------------------------------------------------------

#Creamos nuevas columnas
foo <- mutate(flights, ActualGroundTime = ActualElapsedTime - AirTime)
#Creamos un dataframe nuevo. Copia del dataframe original en memoria
foo <- mutate(foo, GroundTime = TaxiIn + TaxiOut)
select(foo, ActualGroundTime, GroundTime)
names(foo)

# Con mutate podemos combinar varias operaciones a la vez. Separando las variables por comas, puedo usar una que haya definido 
# antes para el cálculo de la siguiente.

foo <- mutate(flights, 
              loss = ArrDelay - DepDelay, 
              loss_percent = (loss/DepDelay) * 100 )

##########################################################################
# Exercise: 
# Mutate the data frame so that it includes a new variable that contains the average speed, 
#  avg_speed traveled by the plane for each flight (in mph). 
# Hint: Average speed can be calculated as distance divided by number of hours of travel, and note that AirTime is given in minutes
#crear una nueva columna(con mutate) en un dataframe temporal (en foo) que sea la velocidad media de cada avion.

foo <- mutate(flights, 
              avg_speed_mpm = Distance/AirTime,
              avg_speed = avg_speed_mpm*60 )

#para ver el resultado de unas columnas, hay que seleccionarla para verla pq todas las columnas no pueden verse, no caben en la pantalla
select(foo,Distance,AirTime,avg_speed)

##########################################################################

#Filtrando observaciones


# FILTER() --------------------------------------------------------------------------

# x < y, TRUE if x is less than y
# x <= y, TRUE if x is less than or equal to y
# x == y, TRUE if x equals y
# x != y, TRUE if x does not equal y
# x >= y, TRUE if x is greater than or equal to y
# x > y, TRUE if x is greater than y
# x %in% c(a, b, c), TRUE if x is in the vector c(a, b, c)

# Print out all flights in hflights that traveled 3000 or more miles
filter(flights, Distance > 3000)

# All flights flown by one of AA or UA. La pasamos un vector de compañias para que se quede o filtre los que están en ese vector.
filter(flights, UniqueCarrier %in% c('AA', 'UA'))
#para ver solo 6 registros, con un head
head(filter(flights, UniqueCarrier %in% c('AA', 'UA')),6)
#para verlo en el workspace:
View(head(filter(flights, UniqueCarrier %in% c('AA', 'UA')),6))

# All flights where taxiing took longer than flying
# Taxi-Out Time: The time elapsed between departure from the origin airport gate and wheels off.
# Taxi-In Time: The time elapsed between wheels-on and gate arrival at the destination airport.
filter(flights, TaxiIn + TaxiOut > AirTime)
#vemos como podemos poner directamente las condiciones en los filtros

# Combining tests using boolean operators

# All flights that departed late but arrived ahead of schedule (& = and, | = or)
filter(flights, DepDelay > 0 & ArrDelay < 0)

# All flights that were cancelled after being delayed. Podemos ir concatenando opciones.
filter(flights, Cancelled == 1, DepDelay > 0)
#Como en este caso es sobre la misma consuta el resultado es el mismo que el que daría Cancelled == 1 & DepDelay > 0

##########################################################################
# Exercise: 
# How many weekend flights to JFK airport flew a distance of more than 1000 miles 
# but had a total taxiing time below 15 minutes?

# 1) Select the flights that had JFK as their destination and assign the result to jfk.
#Creo un df que contenga únicamente los vuelos con destino a JFK filtrados.
JFK<-filter(flights,Dest == 'JFK')

# 2) Combine the Year, Month and DayofMonth variables to create a Date column (No tiene nada que ver 
# con el ejercicio, es para practicar).

#JFK <- mutate(JFK, DateFlight = as.Date(paste(Year,Month,DayOfWeek,sep='-'),format = "%m/%d/%Y"))
JFK <- mutate(JFK, DateFlight = as.Date(paste(Year,Month,DayOfWeek,sep='-')))
#Si hacemos un class de esa variable, vemos que está en el formato que nos interesa.
class(JFK$DateFlight)
#NOTA PERSONAL: ISOdate es mejor no usarlo porque devuelve un dataframe. Luego habría que coger un vector dentro del Dataframe.
# flights['Year'] devuelve un dataframe, por lo que usar ISOdate con esto es muy pesado para trabajar.
# si quiero obtener solo un vector sería: flights['Year']$Year, o esta que es mejor flights$Year.
# por lo que usariamos: ISOdate(flights$Year,flights$Month,flights$DateofWeek).
#Con paste podemos poner directamente el nombre de las columnas del DF pq estamos en dplyr. 

# 3) Result:
nrow(filter(JFK, DayOfWeek == 6 | DayOfWeek == 7, Distance > 1000, TaxiIn + TaxiOut < 15))
#Otra solucion: nrow(filter(JFK, DayOfWeek %in% c(6,7), Distance > 1000, TaxiIn + TaxiOut < 15))
#Solucion 572 vuelos.

# 4) Delete jfk object to free resources 
rm(JFK)


# ARRANGE() --------------------------------------------------------------------------
# es para ordenar, es como un orderby de SQL.

# Cancelled
( cancelled <- select(flights, UniqueCarrier, Dest, Cancelled, CancellationCode, DepDelay, ArrDelay) )

( cancelled <- filter(cancelled, Cancelled == 1, !is.na(DepDelay)) )

# Arrange cancelled by departure delays
arrange(cancelled, DepDelay)

# Arrange cancelled so that cancellation reasons are grouped
arrange(cancelled, CancellationCode)

# Arrange cancelled according to carrier and departure delays
arrange(cancelled, UniqueCarrier, DepDelay)

# Arrange cancelled according to carrier and decreasing departure delays
arrange(cancelled, UniqueCarrier, desc(DepDelay))

rm(cancelled)

# Arrange flights by total delay (normal order).
arrange(flights, DepDelay + ArrDelay)

# Keep flights leaving to DFW and arrange according to decreasing AirTime 
arrange(filter(flights, Dest == 'JFK'), desc(AirTime))

#arrange siempre ordena de forma ascendente, para que sea descendente hay que pasarle el argumento desc()

# SUMMARISE() -----------------------------------------------------------------------

#Cuando hacemos esto sin agrupar por nada nos devuelve una sola fila. Lo normal es usarlo con funciones (típicas o no de R)

# min(x) – minimum value of vector x.
# max(x) – maximum value of vector x.
# mean(x) – mean value of vector x.
# median(x) – median value of vector x.
# quantile(x, p) – pth quantile of vector x.
# sd(x) – standard deviation of vector x.
# var(x) – variance of vector x.
# IQR(x) – Inter Quartile Range (IQR) of vector x.

# Print out a summary with variables min_dist and max_dist
# Es aplicar una funcion o funciones a una o unas variables y luego resumir nuestro dataset a través de ellas.
summarize(flights, min_dist = min(Distance), max_dist = max(Distance))

# Remove rows that have NA ArrDelay: temp1
#Filtramos de vuelos todas aquellas observaciones donde no es un NA en ArrDelay, y esto lo metemos en un df nuevo.
na_array_delay <- filter(flights, !is.na(ArrDelay))

# Generate summary about ArrDelay column of temp1
summarise(na_array_delay, 
          earliest = min(ArrDelay), 
          average = mean(ArrDelay), 
          latest = max(ArrDelay), 
          sd = sd(ArrDelay))
# sd es la standar desviation
# si a todas las opciones (min(),max()...) les ponemos narm=TRUE eliminará las filas con NA y no habrá que hacer el filtro
hist(na_array_delay$ArrDelay)

rm(na_array_delay)

# Keep rows that have no NA TaxiIn and no NA TaxiOut: temp2
taxi <- filter(flights, !is.na(TaxiIn), !is.na(TaxiOut))

##########################################################################
# Exercise: 
# Print the maximum taxiing difference of taxi with summarise()
summarise(taxi, 
          max_taxing_difference = max(abs(TaxiIn-TaxiOut)))

# dplyr provides several helpful aggregate functions of its own, in addition to the ones that are already defined in R. These include:
# first(x) - The first element of vector x.
# last(x) - The last element of vector x.
# nth(x, n) - The nth element of vector x.
# n() - The number of rows in the data.frame or group of observations that summarise() describes.
# n_distinct(x) - The number of unique values in vector x.


# Filter flights to keep all American Airline flights: aa
aa <- filter(flights, UniqueCarrier == "AA")
names(aa)
##########################################################################
# Exercise: 
# Print out a summary of aa with the following variables:
# n_flights: the total number of flights,
# n_canc: the total number of cancelled flights,
# p_canc: the percentage of cancelled flights,
# avg_delay: the average arrival delay of flights whose delay is not NA.
summarise(aa, 
          n_flights = n(), 
          n_canc = sum(Cancelled), 
          p_canc = (sum(Cancelled)/n())*100, 
          avg_delay = mean(ArrDelay,na.rm = TRUE))

#Nota: Cancelled es una columna de booleanos, para saber los vuelos que han sido cancelados hay que sumar, los que estén a 1 contarán y los que no no.
# Podemos volver a usar n_flights y n_canc para calcular p_canc, así es mas eficiente.

#Next to these dplyr-specific functions, you can also turn a logical test into an aggregating function with sum() or mean(). 
# A logical test returns a vector of TRUE’s and FALSE’s. When you apply sum() or mean() to such a vector, R coerces each TRUE to a 1 and each FALSE to a 0. 
# This allows you to find the total number or proportion of observations that passed the test, respectively

set.seed(1973)
(foo <- sample(1:10, 5, replace=T))
foo > 5
sum(foo > 5) # num. elementos > 5
mean(foo)
mean(foo > 5)

##########################################################################
# Exercise: 
# Print out a summary of aa with the following variables:
# n_security: the total number of cancelled flights by security reasons,
# CancellationCode: reason for cancellation (A = carrier, B = weather, C = NAS, D = security)
summarise(aa, 
          n_security = sum(CancellationCode=='D',na.rm = T))


# %>% OPERATOR ----------------------------------------------------------------------
#hasta ahora hemos visto las principales funciones de dplyr aisladas. Podemos concatenarlas 
# a traves de tuberias: %>%.

# Piping

mean(c(1, 2, 3, NA), na.rm = TRUE)

# Vs con tuberias. Ahora en la funcion mean no le tengo que especificar los datos de entrada por así decirlo
# atajo de teclado: ctrl+shift+m=%>%

c(1, 2, 3, NA) %>% mean(na.rm = TRUE)


summarize(filter(mutate(flights, diff = TaxiOut - TaxiIn),!is.na(diff)), avg = mean(diff))

# Vs con tuberias
#va de izquierda a derecha.

flights %>%
  mutate(diff=(TaxiOut-TaxiIn)) %>%
  filter(!is.na(diff)) %>%
  summarise(avg=mean(diff))

#Explicacion: cogemos df, filtramos, nos quedamos con las columnas, ordenamos y nos quedamos con la nueva columna creada.
flights %>%
  filter(Month == 5, DayofMonth == 17, UniqueCarrier %in% c('UA', 'WN', 'AA', 'DL')) %>%
  select(UniqueCarrier, DepDelay, AirTime, Distance) %>%
  arrange(UniqueCarrier) %>%
  mutate(air_time_hours = AirTime / 60)

##########################################################################
# Exercise: 
# Use summarise() to create a summary of flights with a single variable, n, 
# that counts the number of overnight flights. These flights have an arrival 
# time that is earlier than their departure time. Only include flights that have 
# no NA values for both DepTime and ArrTime in your count.
#NOTA:para ver vuelos que son overnight creo una columna para verlo y poder comparar usando un vector de booleanos
flights %>% 
  filter(!is.na(ArrTime) & !is.na(DepTime)) %>% 
  mutate(overnight=ArrTime<DepTime) %>% 
  filter(overnight==TRUE) %>% 
  summarise(n=n())
#lectura: mequito los datos con NA de ambas columnas, depues creo un vector de booleanos y lo guardo
#filtro por los true de este vector y los cuento.

#otra forma,aplicando la condicion sobre el filtro directamente:
flights %>% 
  filter(!is.na(ArrTime) & !is.na(DepTime)) %>% 
  filter(ArrTime<DepTime) %>% 
  summarise(n=n())


# GROUP_BY() -------------------------------------------------------------------------

flights %>% 
  group_by(UniqueCarrier) %>% 
  summarise(n_flights = n(), 
            n_canc = sum(Cancelled), 
            p_canc = 100*n_canc/n_flights, 
            avg_delay = mean(ArrDelay, na.rm = TRUE)) %>% 
  arrange(avg_delay)
#ahora tengo agrupados por compañia todos estos datos.

flights %>% 
  group_by(DayOfWeek) %>% 
  summarize(avg_taxi = mean(TaxiIn + TaxiOut, na.rm = TRUE)) %>% 
  arrange(desc(avg_taxi))
#aquí lo mismo, tendré una fila por dia de la senama

# Combine group_by with mutate
# a rank le pasas un vector y te saca un ranking. Podemos combinarla usando dplyr
rank(c(21, 22, 24, 23))

flights %>% 
  filter(!is.na(ArrDelay)) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(p_delay = sum(ArrDelay >0)/n()) %>% #el total de vuelos es por compañia pq hemos agrupado
  mutate(rank = rank(p_delay)) %>% 
  arrange(rank) 

#depues de un group by se hace un summarise con las funciones típicas.

##########################################################################
# Exercises: 
# 1) In a similar fashion, keep flights that are delayed (ArrDelay > 0 and not NA). 
# Next, create a by-carrier summary with a single variable: avg, the average delay 
# of the delayed flights. Again add a new variable rank to the summary according to 
# avg. Finally, arrange by this rank variable.
flights %>% 
  filter(!is.na(ArrDelay), ArrDelay>0) %>% 
  group_by(UniqueCarrier) %>% 
  summarise(avg=mean(ArrDelay)) %>% 
  mutate(rank = rank(avg)) %>% 
  arrange(rank)


# 2) How many airplanes only flew to one destination from JFK? 
# The result contains only a single column named nplanes and a single row.
flights %>% 
  filter(Origin=='JFK') %>% 
  group_by(TailNum) %>% 
  summarise(ndest=n_distinct(Dest)) %>% 
  #ahora filtramos por destinos únicos
  filter(ndest==1) %>% 
  summarise(n_planes=n())
  
# 3) Find the most visited destination for each carrier
# Your solution should contain four columns:
# UniqueCarrier and Dest, n, how often a carrier visited a particular destination,
# rank, how each destination ranks per carrier. rank should be 1 for every row, 
# as you want to find the most visited destination for each carrier.

flights %>% 
  #Como quiero obtener para cada compañia su destino tengo que agrupar por las dos variables para que las pase al siguiente lado de la tuberia
  group_by(UniqueCarrier,Dest) %>% 
  #cada fila es un vuelo, cuento simplemente los registros que hay.
  summarise(n=n()) %>% 
  mutate(rank=rank(desc(n))) %>% 
  #como solo quiero el primero de cada compañia pues pongo el rank=1, si quisiese el segundo pues pondria rank=2.
  filter(rank==1)


# Other dplyr functions ---------------------------------------------------

# top_n()

flights %>% 
  group_by(UniqueCarrier) %>% 
  top_n(2, ArrDelay) %>% #Es una forma de iterar sobre los grupos.
  select(UniqueCarrier,Dest, ArrDelay) %>% 
  arrange(desc(UniqueCarrier))


# mutate_if(is.character, str_to_lower)
# mutate_at :es mutacion en determinadas variables
# 

foo <- flights %>% 
  head %>% 
  select(contains("Delay")) %>% 
  #coge todas las variables que acaben en delay y me las divides entre dos
  mutate_at(vars(ends_with("Delay")), funs(./2)) 
foo

foo %>% 
  mutate_at(vars(ends_with("Delay")), funs(round)) 

rm(foo)


# Dealing with outliers ---------------------------------------------------
#vamos a ver como detectar outlayers sobre una variable.

# ActualElapsedTime: Elapsed Time of Flight, in Minutes
summary(flights$ActualElapsedTime)
#viendo el resumen podemos ver si en una variable hay outlayers. Podemos usar histogramas
hist(flights$ActualElapsedTime)
#esta variable está sesgada ya que a partir de 500 prácticamente no tenemos valores.
#Tenemos presencia de outlayers que nos están ocultando el verdadero comportamiento de los datos.
library(ggplot2)
ggplot(flights) + 
  geom_histogram(aes(x = ActualElapsedTime))

boxplot(flights$ActualElapsedTime,horizontal = TRUE)
#vemos los puntos negros como los valores extremos. Esto es una proyeccion del histograma
#podemos usar la siguiente funcion para sacar los outlayers
outliers <- boxplot.stats(flights$ActualElapsedTime)$out
length(outliers)
outliers
#una vez que tenemos los outlayers podemos filtrar nuestro dataset y limpiarlo por así decirlo. Habrá una comparacion y dará un vector de booleanos, esto nos servirá para filtrar
no_outliers <- flights %>% 
  filter(!ActualElapsedTime %in% outliers) 

boxplot(no_outliers$ActualElapsedTime,horizontal = TRUE)

mean(no_outliers$ActualElapsedTime, na.rm = T)
#se observa como se corrige la media de 127 a 117.
hist(no_outliers$ActualElapsedTime)
#y vemos como mejora el comportamiento del histograma.

rm(outliers)
rm(no_outliers)


barplot(table(flights$UniqueCarrier))



# Missing values ----------------------------------------------------------

NA
#vemos la dimension de flights
flights %>% dim

# Removing all NA's from the whole dataset
#na.omit funciona bien si tenemos buenos datos. Podemos aplicarla a la columna directamente donde están los NA
flights %>% na.omit %>% dim
#complete.cases Comprueba si todos hay NA
flights %>% filter(complete.cases(.)) %>% dim
library(tidyr) # for drop_na()
flights %>% drop_na() %>% dim

# Removing all NA's from a varible

flights %>% 
  drop_na(ends_with("Delay")) %>% #de todas las variables que acaben en delay
  summary()

# Better aproaches
flights %>% 
  filter(is.na(DepTime)) %>% 
  mutate(DepTime = coalesce(DepTime, 0L))#0L fuerza a que el 0 sea un valor entero
#Given a set of vectors, coalesce() finds the first non-missing value at each position

flights %>% 
  filter(is.na(DepTime)) %>% 
  mutate(DepTime = coalesce(DepTime, CRSDepTime))

unique(flights$CancellationCode)
#si quiero poner NA se puede poner con esta funcion
foo <- flights %>% 
  mutate(CancellationCode = na_if(CancellationCode, "A"))
unique(foo$CancellationCode)

# CancellationCode: reason for cancellation (A = carrier, B = weather, C = National Air System, D = security)
foo <- flights %>% 
  mutate(CancellationCode = recode(CancellationCode, "A"="Carrier", "B"="Weather", "C"="National Air System", 
                                   .missing="Not available", 
                                   .default="Others" ))
#recode:replace numeric values based on their position, and character values by their name.
foo %>% select(CancellationCode) %>% sample(,10)
rm(foo)



# Tidy Data ---------------------------------------------------------------
#En cada columna del Dset vamos a tener una variable y en cada fila tendremos un registro de esa variable.

library(tidyr)

# Wide Vs Long 

#tabla normal: formato largo --> pivotando la tabla, formato ancho.
#               formato ancho --> despivotando la tabla, formato largo.
# spread, para poner la tabla en formato ancho
# gather, para poner la tabla en formato estrecho

flights %>% 
  group_by(Origin, Dest) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  spread(Origin, n) %>% 
  gather("Origin", "n", 2:ncol(.)) %>% 
  arrange(-n) 


##########################################################################
# Run the follow statements step by step and trying to understand what they do
# ungroup removes grouping.
flights %>% 
  group_by(UniqueCarrier, Dest) %>% 
  summarise(n = n()) %>%
  ungroup() %>% 
  group_by(Dest) %>% 
  mutate(total= sum(n), pct=n/total, pct= round(pct,4)) %>% 
  ungroup() %>% 
  select(UniqueCarrier, Dest, pct) %>% 
  spread(UniqueCarrier, pct) %>% 
  replace(is.na(.), 0) %>% 
  mutate(total = rowSums(select(., -1))) 


# unite()
# separate()

##########################################################################
# Run the follow statements step by step and trying to understand what they do

flights %>% 
  head(20) %>% 
  unite("code", UniqueCarrier, TailNum, sep = "-") %>% 
  select(code) %>% 
  separate(code, c("code1", "code2")) %>% 
  separate(code2, c("code3", "code4"), -3)#le digo que me separe por los ultimos 3 valores de la cadena

#el paste dentro de una tuberia tiene que ir dentro de un mutate.
#para no hacer el paste, usamos una funcion equivalemten que es unite.



# Dplyr: Joins ------------------------------------------------------------

# inner_join(x, y)  SELECT * FROM x INNER JOIN y USING (z)
# left_join(x, y) SELECT * FROM x LEFT OUTER JOIN y USING (z)
# right_join(x, y, by = "z") SELECT * FROM x RIGHT OUTER JOIN y USING (z)
# full_join(x, y, by = "z") SELECT * FROM x FULL OUTER JOIN y USING (z)

# semi_join(x, y)
# anti_join(x, y)


airlines <- readr::read_csv('data/airlines.csv')
airlines

airports <- readr::read_csv('data/airports.csv')
airports

# Before joing dataframes, check for unique keys
#NOTA IMPORTANTE: Es importante hacer al hacer joins que las tablas maestras no contengan campos duplicados
airports %>% 
  count(iata) %>% 
  filter(n > 1)
#nos devuelve 0 y es lo que queremos, nos aseguramos que no hay datos duplicados. 

#copiamos flight en flight2 con las columnas que queremos.
flights2 <- flights %>% 
  select(Origin, Dest, TailNum, UniqueCarrier, DepDelay)

# Top delayed flight by airline (vuelos con mas retrasos por cada aerolinea)
#puedo hacer el join dentro de la tuberia
flights2 %>% 
  group_by(UniqueCarrier) %>%
  top_n(1, DepDelay) %>% 
  left_join(airlines, by = c("UniqueCarrier" = "Code"))
#joint funciona de forma automática, detecta las columnas que se comparten y lo hace, esto es bueno y malo.

##########################################################################
# Exercises:
# Join flights2 with airports dataset
flights2 %>% 
  left_join(airports, by = c("Dest" = "iata"))

rm(flights2)
#sólo hace falta saber cual es la lógica.

# Dates with lubridate ----------------------------------------------------

# Base R

as.POSIXct("2013-09-06", format="%Y-%m-%d")
as.POSIXct("2013-09-06 12:30", format="%Y-%m-%d %H:%M")


flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3, remove = F)

flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate(Date = as.Date(paste(Year, Month, DayofMonth, sep = "-")),
         HourMinute = (paste(Hour, Minute, sep = ":")),
         Departure = as.POSIXct(paste(Date, HourMinute), format="%Y-%m-%d %H:%M"))

# Easier with lubridate
library(lubridate)
today()
now()


(datetime <- ymd_hms(now(), tz = "UTC"))
(datetime <- ymd_hms(now(), tz = 'Europe/Madrid'))

Sys.getlocale("LC_TIME")
Sys.getlocale(category = "LC_ALL")

# Available locales: Run this in your shell: locale -a
(datetime <- ymd_hms(now(), tz = 'Europe/Madrid', locale = Sys.getlocale("LC_TIME")))
month(datetime, label = TRUE, locale = 'fi_FI.ISO8859-15')
wday(datetime, label = TRUE, abbr = FALSE, locale = 'fi_FI.ISO8859-15')

year(datetime)
month(datetime)
mday(datetime)

ymd_hm("2013-09-06 12:3")
ymd_hm("2013-09-06 12:03")

# Esto genera un error
flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate(dep = make_datetime(Year, Month, DayofMonth, Hour, Minute))

flights %>% 
  head %>%
  select(Year:DayofMonth,DepTime,ArrTime) %>% 
  separate(DepTime, into = c("Hour", "Minute"), sep = -3) %>% 
  mutate_if(is.character, as.integer) %>% 
  mutate(dep_date = make_datetime(Year, Month, DayofMonth) ,
         dep_datetime = make_datetime(Year, Month, DayofMonth, Hour, Minute))

# Let’s do the same thing for each of the four time columns in flights. 
# The times are represented in a slightly odd format, so we use modulus arithmetic to pull out the hour and minute components

# ?Arithmetic
# %/% := integer division
# %% := modulus

departure_times <- flights %>% 
  head(2) %>% 
  select(DepTime) %>% 
  pull()

# Supongamos la hora: 1232
departure_times %/% 100
departure_times %% 100

make_datetime_100 <- function(year, month, day, time) {
  make_datetime(year, month, day, time %/% 100, time %% 100)
}

flights %>% select(TaxiIn, TaxiOut)

flights_dt <- flights %>%  
  filter(!is.na(DepTime), !is.na(ArrTime), !is.na(CRSDepTime), !is.na(CRSArrTime)) %>% 
  mutate(
    dep_time = make_datetime_100(Year, Month, DayofMonth, DepTime),
    arr_time = make_datetime_100(Year, Month, DayofMonth, ArrTime),
    sched_dep_time = make_datetime_100(Year, Month, DayofMonth, CRSDepTime),
    sched_arr_time = make_datetime_100(Year, Month, DayofMonth, CRSArrTime)
  ) %>% 
  select(Origin, Dest, ends_with("_time"))

# distribution of departure times across the year
flights_dt %>% 
  ggplot(aes(dep_time)) + 
  geom_freqpoly(binwidth = 86400)

# wday()
flights_dt %>% 
  mutate(wday = wday(dep_time, label = TRUE)) %>% 
  ggplot(aes(x = wday)) +
  geom_bar()


# Time periods functions
minutes(10)
days(7)
months(1:6)
weeks(3)

datetime
datetime + days(1)

# Datos incoherentes

flights_dt %>% 
  filter(arr_time < dep_time) %>% 
  select(Origin:arr_time)


flights_dt <- flights_dt %>% 
  mutate(
    overnight = arr_time < dep_time,
    arr_time_ok = arr_time + days(overnight * 1),
    sched_arr_time_ok = sched_arr_time + days(overnight * 1)
  )

# Check
flights_dt %>% 
  filter(overnight == T)

# Time Zones
ymd_hms("2007-01-01 12:32:00")
str(flights_dt$dep_time)

pb.txt <- "2007-01-01 12:32:00"
# Greenwich Mean Time (GMT)
(pb.date <- as.POSIXct(pb.txt, tz="Europe/London"))
# Pacific Time (PT)
format(pb.date, tz="America/Los_Angeles",usetz=TRUE)
# Con lubridate
with_tz(pb.date, tz="America/Los_Angeles")
# Coordinated Universal Time (UTC)
with_tz(pb.date, tz="UTC") 
