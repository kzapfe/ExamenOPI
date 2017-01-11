### cargamos los datos
octubre<-read.csv("datos/octubre2016.csv")
noviembre<-read.csv("datos/noviembre2016.csv")
diciembre<-read.csv("datos/diciembre2016.csv")

datos<-rbind(octubre,noviembre,diciembre)
write.csv(datos,  "DatosEcoBiciTresMeses.csv")

##funciones que ayudan a agrupar por dia y hora
library(lubridate)

##los voy a necesitar para las otras preguntas asi.
write.csv(datos,  "DatosEcoBiciTresMeses.csv")

datos$horaret<-hour(datos$fhretiro)
datos$horarrib<-hour(datos$fharribo)
datos$horaret<-as.factor(datos$horaret)
datos$horarrib<-as.factor(datos$horarrib)

##Ahora si: uso por estacion y por hora
arribohest<-aggregate(uso~horarrib+Ciclo_Estacion_Arribo, datos,sum)
retirohest<-aggregate(uso~horaret+Ciclo_Estacion_Retiro, datos,sum)
##y los ordenamos para ver las estaciones mas usadas
attach(arribohest)
arribohest[order(uso),]
attach(retirohest)
retirohest[order(uso),]

