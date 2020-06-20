
library(ggmap)

crimes.houston <- crime %>% filter(!crime$offense %in% c("auto theft", "theft", "burglary"))
#esto es mas correcto, ya que offense hace referencia directamente a crime.
#crimes.houston <- crime %>% filter(!offense %in% c("auto theft", "theft", "burglary"))

#houston<-geocode('houston')
houston<-c(lon=-95.3698,lat= 29.76043)
HoustonMap <- ggmap(get_map(houston, zoom = 14, color = "bw"))
HoustonMap +
  geom_point(aes(x = lon, y = lat, colour = offense), data = crimes.houston, size = 1)
#para conseguir descomponer el gráfico anterior e
HoustonMap +
  geom_point(aes(x = lon, y = lat, colour = offense), data = crimes.houston, size = 1)+
  facet_wrap(~offense)

#Ver rOpenSpain/caRtocuidad en github

#EJERCICIO CON BASE DE DATOS DE CARBURANTES (hacer)
#__________________________________________________
carburante<-read_csv2("_book/data/carburantes.csv")
#con read_csv2 el delimitador son punto y coma
#puede haber problemas con el nombre de las columnas, con los rangos de los precios en las zona donde estamos... etc


#__________________________________________________

HoustonMap +
  stat_density2d(aes(x = lon, y = lat, alpha = ..level..),fill="red4",
                 size = 2, data = subset(crimes.houston,offense=="robbery"),
                 geom = "polygon")
#Para que el color cambie el con el tipo de crimen hay 
HoustonMap +
  stat_density2d(aes(x = lon, y = lat, alpha = ..level..,fill=offense),
                 size = 2, data = crimes.houston,
                 geom = "polygon")+facet_wrap(~offense)

#Cuando los datos se presentan como datos acumulados (que no son tan precisos) puedo representarlos a través de áreas o polígonos.
install.packages("raster")
library(raster)
shape <- getData("GADM", country= "Spain", level = 2) #mapa administrativo a nivel provincial
#puedo jugar con los levels (level 2 son las provincias, level 1 son las CCAA, level 3 son municipios)
plot(shape)
summary(shape)
head(shape)
unique(shape$NAME_1)
#Mapa sin las islas canarias:
peninsula<-subset(shape,!NAME_1=="Islas Canarias")
plot(peninsula)

#podemos convertir el objeto complejo "shape" en uno mas amigable como son los DF.
peninsula.df=fortify(peninsula)
dim(peninsula.df)
head(peninsula.df)
unique(peninsula.df$id)

#Ahora tenemos que ver los datos de paro. La idea es preservar la integridad de los datos del mapa para luego poder fusionarlos con los del paro
paro<-read_csv("_book/data/paro.csv")
#Para juntar las bases de datos usaremos funciones como el merge o el inner join
peninsula.paro=inner_join(paro,peninsula.df,by=c("Prov.id"="id"))
dim(peninsula.paro)
head(peninsula.paro)
#representamos
ggplot(subset(peninsula.paro,Año==2011))+geom_polygon(data=peninsula.paro,aes(long,lat,fill=Tasa.paro,group=group))+
  facet_grid(Sexo~Trimestre)+ scale_fill_gradient(low="aliceblue",high="steelblue4")+coord_quickmap()

#Extension dinámica de gráficos
#install.packages("plotly")
library(plotly)
p<-ggplot(paro, aes(x = Año, y = Tasa.paro, color=Sexo,label=Provincia)) +
  geom_jitter(alpha=.1) + geom_smooth(se=FALSE,method="lm") 
ggplotly(p,tooltip = c("label", "color"))

#otra opcion es usando el paquete tmap
#da error al instalarlo.
#consultar ariadna.cne.iscii.es/MapaM/

#Para solucionar los problemas con gpclibPermit()
#library(maptools)
#library(gpclib)
#gpclibPermit()
