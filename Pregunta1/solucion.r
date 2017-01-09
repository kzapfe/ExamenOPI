### script de R para solucionar la pregunta 1.

## cargamos la lista solo de los datos de A. Obregon resumen por AGEB
tabladatos<-read.csv("TablaObregonAGEB.csv")
## extraemos las columnas de interes
agebs<-tabladatos["ageb"]
habtot<-tabladatos["pobtot"]
## hacemos un nuevo marco de datos con ellas
datos<-data.frame(agebs,habtot)
##revisamos que todo este bien
sapply(datos, mode)
## cambiar asteriscos por "No es un Valor"
datos[datos=="*"]<-NA
##taza de crecimiento en base natural
x<-log(749982/727034)/5  #poblacion 2015/ poblacion 2010)
##factor de crecimiento en 6 años
fcrec<-exp(6*x)
##taza de natalidad estimada por cada 1000 habitantes por MEDIO año
fnat<-7.1
##estimado de bebes de medio año de edad
habestimados<-habtot*fcrec
bebes<-round(habestimados*fnat/1000)
##ordenar todo en un solo marco de datos
datos$pobest2016<-round(habestimados)
datos$bebesest2016<-bebes
##guardar los datos
write.csv(datos, file="EstimadoBebesAObregon.cvs", row.names=FALSE)

