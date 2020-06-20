library(rvest)
amanece <- read_html("http://www.imdb.com/title/tt0094641/")

#Extraemos título
amanece %>% html_nodes('title')

#Para extraer el texto: html_text
amanece %>% html_nodes('title') %>% html_text()

#Vemos los párrafos que hay
amanece %>% html_nodes('p')
#Si me interesa el párrafo 19, se accede como una lista
amanece %>% html_nodes('p') %>% .[19]
amanece %>% html_nodes('p') %>% .[19] %>% html_text()
#Mirando la ayuda de HTML_text vemos la opcion trim, que me elimina lo que hay antes y despues del texto 
#Así tengo el texto limpio, sin \n.
amanece %>% html_nodes('p') %>% .[19] %>% html_text(trim=TRUE)

#EJERCICIO, DESCARGAR EL ULTIMO DISCURSO DEL REY DE ESPAÑA
discurso<-read_html("http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5738")
discurso %>% html_nodes('title') %>% html_text()
discurso %>% html_nodes('p') %>% .[4] %>% html_text(trim=TRUE)

#EXTRACCION DE TABLAS.
p<-read_html("https://resultados.elpais.com/elecciones/2016/generales/congreso/")
#Tabla:Votos por partidos en Total España que es la segunda
tabla<-p %>% html_nodes("table") %>% .[2]
tabla %>% html_table()
  
#Vemos las tablas que hay en amanece y seleccionamos la primera para transdormarla en tipo DF
amanece %>% html_nodes("table") %>% .[1] %>% html_table(header = TRUE)
amanece %>% html_nodes("table") %>% .[[1]] %>% html_table(header = TRUE) %>% .[[2]]

#Extraccion de lo votos de la tabla del el Pais
tabla<-p %>% html_nodes("table") %>% .[[2]]
#Es la tercera columna de la segunda tabla la de los votos
votos<-tabla %>% html_table(header = TRUE) %>% .[[3]]
#Despues veremos como limpiar todos estos datos.

#Extraccion de vínculos, util para ir de una web a otra.
#Le estoy diciendo, extrae todos los enlaces de esta tabla
amanece %>% html_nodes("table a") 
#nos quedamos con el atributo correspondiente
raiz<-"http://www.imdb.com"
jose=amanece %>% html_nodes("table a") %>% html_attr("href") %>% .[[1]]
#Ahora concateno la raiz de la pagina con el resto de ruta
browseURL(paste(raiz,jose,sep="/"))

#Extraer la lista de provincias de la Wikipedia
#https://es.wikipedia.org/wiki/Provincia_de_Espa%C3%B1a
provincias<-read_html("https://es.wikipedia.org/wiki/Provincia_de_Espa%C3%B1a")
tablaprovincias<-provincias %>% html_nodes("table")
tablaprovincias %>% .[[2]]
#Vemos que es la segunda tabla
tablaprovincias<-provincias %>% html_nodes("table") %>% .[[2]] %>% html_table(fill=TRUE)
#Y me quedo con la lista de provincias.
listaprovincias<-tablaprovincias %>% .[[1]]
listaprovincias

#OTRO DISCURSO DEL REY PERO EN ESPAÑOL
discurso_ESP<-read_html("http://www.casareal.es/ES/Actividades/Paginas/actividades_discursos_detalle.aspx?data=5000")
#Extraido todos los párrafos y los concateno en un solo texto (esto último lo hago con paste(a,collapse=" "))
discurso_ESP %>% html_nodes('p') %>% html_text(trim=TRUE) %>% paste(collapse=" ")

#EXTRAER LAS COTIZACIONES EN BOLSA DEL IBEX
#“http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000” 
cotizaciones<-read_html("http://www.bolsamadrid.es/esp/aspx/Mercados/Precios.aspx?indice=ESI100000000")
cotizaciones %>% html_nodes('table')
#hay 5 tablas, vamos a checkear cual es
cotizaciones %>% html_nodes('table') %>% html_table(fill=TRUE) %>% lapply(names)
cotizaciones %>% html_nodes('table') %>% html_table(fill=TRUE) %>% lapply(dim)
#Vemos que als tablas interesantes con la 4 y la 5.
#El ibex 35 tiene 35 empresas, luego será la última (35+1 filas)
datos_cotiz_ibex<-cotizaciones %>% html_nodes('table') %>% html_table(fill=TRUE,header=TRUE) %>% .[[5]]
datos_cotiz_ibex

#NAVEGACIÓN
sesion<-html_session("http://www.imdb.com")
#Voy a boxoffice si esa página lo contiene
sesion %>% jump_to("boxoffice")
sesion %>% jump_to("boxoffice") %>% html_nodes("table") %>% .[[1]] %>% html_table()
#-podemos ver el historial con session_history()
#-ir al 5 enlace de la pagina con: follow_link(5). SI hay un link que contiene Indian pues iremos a el con: 
#follow_link('Indian')
#Extraccion de formularios
html_form(sesion)
#Seleccionamos el primero, fijo valores y escojo una opcion del select.
busqueda<-html_form(sesion) %>% .[[1]] %>% set_values(q="sobrevivir",s="Titles")
busqueda
#Hago la solicitud a la página con el formulario relleno.
busqueda %>% submit_form(session=sesion) %>% html_nodes("table") %>% html_table()
#Vemos que es la primera table la que nos devuelve el resultado
busqueda %>% submit_form(session=sesion) %>% html_nodes("table") %>% html_table() %>% .[[1]]

#---------------------------------------------------------------------------------
# MINERIA DE TEXTO (Analisis de texto)

#hay varios tipos, aqui veremos y usaremos la frecuencia de palabras.
#token=unidades minimas de analisis (pueden ser palabras, grupos de dos palabras, ... etc)

#Para analizar el texto:
# 1. Creacion del corpus (tiene como idea, crear un marco de referencia)
# 2. Limpieza y filtraje de intormacion relevante
# 3. analisis del texto e interpretacion de los resultados

#Limpieza:
gsub("h","H",c("hola","Búho"))
#que empieze por h
gsub("^h","H",c("hola","Búho")) #usamos expresiones regulares
#El patron siempre se considera como una funcino regular
#Podemos usar tambien str_replace()
library(tidyverse)
str_replace(c("hola","Búho"),"^h","H")

gsub("a","as",c("sandia","pera"))
gsub("a$","as",c("sandia","pera"))

gsub(".","",c("123.345","3.1416"))
gsub("\\.","",c("123.345","3.1416"))
gsub(".","",c("123.345","3.1416"),fixed=TRUE)

#grep me permite detectar patrones
grep("a",c("sandia","pera",'platano'))
grep("a$",c("sandia","pera",'platano'),value=TRUE)

#Extraemos todos los colores que terminan por blue
grep("blue$",colors(),value=TRUE)
#tambien podemos usar str_extract para lo mismo

paste("individuo",1:10,sep="-")
paste("fichero",Sys.Date(),".pdf",sep="_")

#Concatenar
paste(c("Hoy es una buen dia","para salir"),collapse=" ")
#Separar de acuerdo a un criterio
strsplit("Hoy es una buen dia para salir",split=" ")
         
fichero<-c("ventas_12345_pdf","ventas_segundo_23345_pdf")
strsplit(fichero,"_\\d{5}_")
str_extract(fichero,"\\d{5}")

#EJERCICIO MEDALLA FIELD (PREMIO A LOS MEJORES MATEMÁTICOS MENORES DE 40 AÑOS)
require(rvest)
mfield<-read_html("https://es.wikipedia.org/w/index.php?title=Medalla_Fields&oldid=103644843")
mfield %>% html_nodes("table") 

tabla <- mfield %>% html_nodes("table") %>% .[[2]] %>% html_table(header=TRUE) %>% .[[2]]
#knitr:::kable(tabla %>% head(10))

#Hay algunos premiados que tienen doble nacionalidad, extraemos la nacionalidad
paises<-str_extract(tabla,"\\([^()]+\\)")
paises
#Ahora hay que quitar los parentesis
paises2<-gsub("\\(","",paises)
paises2<-gsub("\\)","",paises2)
#ó pasandole una lista de elementos en vez de hacerlo en 2 pasos
#paises2<-gsub("[()]","",paises2)
listapaises<-paises2 %>% strsplit(" y ") %>% unlist() %>% str_replace("^[:blank:]","")
table(listapaises)

#Creacion del corpus (tokenizacion del texto)
texto<-c("Eso es insultar al lector, es llamarle torpe","Es decirle: ¡fíjate, hombre, fíjate, que aquí hay intención!","Y por eso le recomendaba yo a un señor que escribiese sus artículos todo en bastardilla","Para que el público se diese cuenta de que eran intencionadísimos desde la primera palabra a la última.")
texto

# conversion a un DF
require(tidyverse)
texto_df <- data_frame(fila = 1:4, texto = texto)
texto_df

#descomposicion del texto en tokens
require(tidytext)
texto_df %>% unnest_tokens(palabra, texto)
texto_df %>% unnest_tokens(palabra, texto,token="ngrams",n=2)

#Tokenización de la obra de Jane Austen
require(janeaustenr)
libros <- austen_books() %>%
  group_by(book) %>%
  #Para cada libro defino unanueva columna con el nº de fila y la variable capítulo, para ello detecto el formato de los capítulos
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [[:digit:]ivxlc]", ignore_case=TRUE)))) %>%
  ungroup()

#ejemplo como funciona cumsum
cumsum(c(0,0,1,0,1,1,0))

tokens <- libros %>% unnest_tokens(word, text)
tokens

#Caracterizaremos cada novela mediante analisis de frecuencias de palabras.
#una palabra que caracteriza a una novela es la que aparece en la novela frecuentemente y es menos frecuente en el resto
#Se le da un peso a los tokens del corpus según aparece dentro de la novela y según aparece entre las novelas.

#quitamos las palabras que no nos interesan 
tokens<-tokens %>% anti_join(stop_words)
#Contamos las frecuencias
freq <- tokens %>% count(word, sort = TRUE) 
freq

#representamos la distribución de las palabras más frecuentes:
require(ggplot2)
freq %>%
  filter(n > 600) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()
#otra representacion
require(wordcloud)
wordcloud(words = freq$word, freq = freq$n, min.freq = 300,
          max.words=100, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))

#Otro enfoque es observar la frecuencia inversa de documentos (idf) para una palabra dada, 
#que aumenta su peso si se usa en pocos documentos de la colección

#cntamos la frecuencia de cada palabra en el seno de cada novela
book_words <- austen_books() %>% unnest_tokens(word, text) %>%
  count(book, word, sort = TRUE) %>%
  ungroup()
#aplico la funcion para calcular la frecuenci y el identificador idf
freq_rel <- book_words %>% bind_tf_idf(word, book, n)
freq_rel
#un idf de 0 significa que la palabra aparece en todas las obras. Tiene un peso muy pequeño porque es muy comun

#vemos las palabras con mayor peso. Son nombres de personajes, como es lógico aparecen y son propios de cada novela.
freq_rel %>% arrange(desc(tf_idf))

#De esta forma puedo quedarme con la spalabras representativas y obviar las que no me aporten nada. En este caso nos quedamos con el top 15
freq_rel %>% arrange(desc(tf_idf)) %>%
  mutate(word = factor(word, levels = rev(unique(word)))) %>% 
  group_by(book) %>% 
  top_n(15) %>% 
  ungroup() %>%
  ggplot(aes(word, tf_idf, fill = book)) +
  geom_col(show.legend = FALSE) +
  labs(x = NULL, y = "tf-idf") +
  facet_wrap(~book, ncol = 2, scales = "free") +
  coord_flip()

#Son todo nombres propios, podemos eliminarlos a la hora de tokenizar, sin pasar a minuscula, todo lo que empieze
#por mayuscula, lo quitamos. Nos cargaremos todas las palabras que empiezan una frase pero si el corpus es extenso
#no deberia preocuparnos.