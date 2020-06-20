##########################################################################
# Jose Cajide - @jrcajide
# Master Data Science: Getting data from Google BigQuery
##########################################################################

list.of.packages <- c("dplyr", "tidyverse", "bigrquery", "sqldf", "DBI", "ggplot2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# devtools::install_github("rstats-db/bigrquery")

library(bigrquery)
library(ggplot2)
library(sqldf)
library(dplyr)

# If you don't already have a Google project...
# Login into the Google Developer Console
# Create a project and activate the BigQuery API
# Open public dataset: 
#   https://bigquery.cloud.google.com/table/datascience-open-data:flights.flights
# Execute your first query...
# SELECT * FROM `datascience-open-data.flights.flights` LIMIT 1000

#HEMOS IDO A GOOGLE BIGQUERY, HEMOS CREADO EL PROYECTO EN LA HERRAMIENTA (MasterDataScience), buscamos en Google cloud platform
# nuestro proyecto. Una vez hagamos esto buscamos BIGQUERY, habiliamos la API sobre el proyecto y ejecutamos la quuery del ejemplo

#creamos el proyecto en googleBigquery
project <- "masterdatascience-207408" # Pon aquí tu proyecto, consultamos el ID del proyecto en google cloud console
#project <- "datascience-open-data" 

con <- DBI::dbConnect(bigquery(),
                      project = "datascience-open-data",#nombre del proyecto al que nos estamos conectando
                      dataset = "flights",
                      billing = project #este proyecto de datos es gratuito por lo que no haría falta especificarle el billing
)

DBI::dbListTables(con)
#creamos un objeto tabla con la conexion a flights, se llamará flights_db. Contiene las cadenas de conexion a las tablas bigquery
flights_db <- tbl(con, "flights")

# SQL
#defino la variable SQL con la query
sql <- "SELECT
  COUNT(DISTINCT Year) AS years,
COUNT(DISTINCT UniqueCarrier) AS carriers,
COUNT(DISTINCT Dest) AS airports
FROM (
SELECT
Year,
UniqueCarrier,
Dest
FROM
`datascience-open-data.flights.flights`
GROUP BY
1,
2,
3 )"
#ejecutamos la query, importante que el proyecto sea el nuestro (masterdatascience-207408), no el del profesor.
#Si asignamos esto a algo ya tendremos el dataframe
query_exec(sql, project = project, use_legacy_sql = F)


# Which is the flight cancellation ratio by year?

# Dplyr
library(dplyr)
flights_db %>% head

# Let BQ do the aggregation
cancellations <- flights_db %>% 
  group_by(Year) %>% 
  summarise(n_flights = n(), 
            n_canc = sum(Cancelled)) %>% 
  collect()#es para devolver un resultado de un job que ha sido mandado a la query. Hay que tenner cuidado a ver si la respuesta cabe en el ordenador.
  
# Then apply transformations over your small local data frame for easy EDA
cancellations_by_year <- cancellations %>% 
  mutate(ratio = n_canc / n_flights) %>% 
  arrange(desc(Year)) 


ggplot(cancellations_by_year, aes(x=Year, y=ratio, group=1)) +
  geom_line() + 
  theme_light()


# Segment! Segement! Segment!: Segment by Destination Airport
# Calculate 
#segmentacion por año y por destino
cancellations <- flights_db %>% 
  group_by(Year,Dest) %>% 
  summarise(n_flights = n(), 
            n_canc = sum(Cancelled)) %>% 
  collect() 


cancellations_1 <- cancellations %>% 
  mutate(ratio = n_canc / n_flights) %>% 
  arrange(n_flights)


ggplot(cancellations_1, aes(x=Year, y=ratio, group=Dest, color=Dest)) +
  geom_line(show.legend=F, aes(color = Dest), size=0.6, alpha=.5) + 
  scale_x_continuous()+
  theme_light()

# What's happening?
cancellations_1 %>% summary()

hist(cancellations_1$n_flights, breaks = 100)
hist(cancellations_1$n_canc, breaks = 100)

#para quitar outlayers filtramos y quitamos aquellas que estén 2 puntos por encima o por debajo de la media.
#esta es una de las formas para quitar valores extremos
cancellations_2 <- cancellations %>% 
  filter(abs(n_flights - mean(n_flights)) > 2*sd(n_flights) ) %>% 
  mutate(ratio = n_canc / n_flights, 
         top = if_else(ratio > .04, "Y", "N") )%>% 
  arrange(n_flights)

ggplot(cancellations_2, aes(x=Year, y=ratio, group=Dest, color=top)) +
  geom_line(show.legend=T, aes(color = top), size=.6, alpha=.9) + 
  scale_x_continuous()+
  scale_colour_brewer(palette = "Set1", direction = -1) +
  theme_light()

DBI::dbDisconnect(con)

#Para traducir DPLYR a SQL (show_query()) (nos muestra el equivalente a este código de dplyr en SQL)
flights_db %>% 
  group_by(Year) %>% 
  summarise(n_flights = n(), 
            n_canc = sum(Cancelled)) %>% show_query()
  
