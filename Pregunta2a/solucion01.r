### cargamos los datos
datostotales<-read.csv("datos/TresMesesAgain.csv")
## De momento, para sumar mas facil, le ponemos un uno a cada renglon al final
dim(datostotales)
unos<-rep(1, nrow(datostotales))
datostotales$uso<-unos

### Resulta que a R no le gusta como estan las fechas y horas.
### Necesitamos una libreria para darles masaje a los datos.
## Esta nos puede ayudar a poner en orden las fechas y horas.
library(lubridate)

###Recuerda los campos en columnas porfa
colnames(datostotales)

## Pon las fechas bien.
datostotales$Fecha_Retiro<-as.Date(datostotales$Fecha_Retiro,   format = "%d/%m/%Y")
datostotales$Fecha_Arribo<-as.Date(datostotales$Fecha_Arribo,   format = "%d/%m/%Y")
### todo el dato temporal junto pof favor
fechahoraretiro<-as.POSIXlt(paste(datostotales$Fecha_Retiro, datostotales$Hora_Retiro),format='%Y-%m-%d %I:%M:%S %p')
fechahorarribo<-as.POSIXlt(paste(datostotales$Fecha_Arribo, datostotales$Hora_Arribo),format='%Y-%m-%d %I:%M:%S %p')

datostotales$fhretiro<-fechahoraretiro
datostotales$fharribo<-fechahorarribo
##Ya no necesitamos las otras columnas
datoslimpios<-subset(datostotales, select=-c(Fecha_Retiro,Fecha_Arribo, Hora_Retiro, Hora_Arribo))

##Ya no necesitamos el data frame original.
rm(datostotales,unos)
### para agrupar por hora de retiro o arribo conviene tener
### columnas separadas de ese dato
datoslimpios$horaret<-hour(datoslimpios$fhretiro)
datoslimpios$horarrib<-hour(datoslimpios$fharribo)
datoslimpios$horaret<-as.factor(datoslimpios$horaret)
datoslimpios$horarrib<-as.factor(datoslimpios$horarrib)
### las estaciones 1001, 1002, 1006 y 4000 no existen.
### Al parecer son renglones de ayuda.
datoslimpios<-datoslimpios[ ! datoslimpios$Ciclo_Estacion_Arribo %in% c(1001,1002,1006,4000), ]
datoslimpios<-datoslimpios[ ! datoslimpios$Ciclo_Estacion_Retiro %in% c(1001,1002,1006,4000), ]

##los voy a necesitar para las otras preguntas asi.
write.cvs(datoslimpios,  "DatosEcoBiciTresMeses.cvs")

##Ahora si: uso por estacion y por hora
arribohest<-aggregate(uso~horarrib+Ciclo_Estacion_Arribo, datoslimpios,sum)
retirohest<-aggregate(uso~horaret+Ciclo_Estacion_Retiro, datoslimpios,sum)
##y los ordenamos para ver las estaciones mas usadas
attach(arribohest)
arribohest[order(uso),]
attach(retirohest)
retirohest[order(uso),]

