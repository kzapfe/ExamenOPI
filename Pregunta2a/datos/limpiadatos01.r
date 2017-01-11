##Octubre  y Diciembre vienen con un formato, Noviembre con otro
## Ordenando las fechas pa que a R le gusten.

#datosmes<-read.csv("2016-10.csv")
datosmes<-read.csv("2016-12.csv")
nomcols<-colnames(datosmes)

datosmes$Fecha_Retiro<-as.Date(datosmes$Fecha_Retiro,   format = "%d/%m/%Y")
fechahoraretiro<-as.POSIXlt(paste(datosmes$Fecha_Retiro, datosmes$Hora_Retiro),format='%Y-%m-%d %I:%M:%S %p')

datosmes$Fecha_Arribo<-as.Date(datosmes$Fecha_Arribo,   format = "%d/%m/%Y")
fechahorarribo<-as.POSIXlt(paste(datosmes$Fecha_Arribo, datosmes$Hora_Arribo),format='%Y-%m-%d %I:%M:%S %p')

datosmes$fhretiro<-fechahoraretiro
datosmes$fharribo<-fechahorarribo

##estas estaciones no existen, al parecer son datos auxiliares
datosmes<-datosmes[ ! datosmes$Ciclo_Estacion_Arribo %in% c(1001,1002,1006,4000), ]
datosmes<-datosmes[ ! datosmes$Ciclo_Estacion_Retiro %in% c(1001,1002,1006,4000), ]

datosmes<-subset(datosmes, select=-c(Fecha_Retiro,Fecha_Arribo, Hora_Retiro, Hora_Arribo, Genero_Usuario, Bici, Edad_Usuario))

unos<-rep(1, nrow(datosmes))
datosmes$uso<-unos

#write.csv(datosmes, "octubre2016.csv")
write.csv(datosmes, "diciembre2016.csv")
 
###Para noviembre es ligeramente diferente
noviembre<-read.csv("2016-11.csv", header=FALSE)
##las columnas vienen sin nombre, ponles los otros
colnames(noviembre)<-nomcols

noviembre$Fecha_Retiro<-as.Date(noviembre$Fecha_Retiro,   format = "%Y-%m-%d")
noviembre$Fecha_Arribo<-as.Date(noviembre$Fecha_Arribo,   format = "%Y-%m-%d")

fechahoraretiro<-as.POSIXlt(paste(noviembre$Fecha_Retiro, noviembre$Hora_Retiro),format='%Y-%m-%d %H:%M:%OS')
fechahorarribo<-as.POSIXlt(paste(noviembre$Fecha_Arribo, noviembre$Hora_Arribo),format='%Y-%m-%d %H:%M:%OS')

### ya de aqui en adelante es escencialmente igual

noviembre$fhretiro<-fechahoraretiro
noviembre$fharribo<-fechahorarribo

noviembre<-noviembre[ ! noviembre$Ciclo_Estacion_Arribo %in% c(1001,1002,1006,4000), ]
noviembre<-noviembre[ ! noviembre$Ciclo_Estacion_Retiro %in% c(1001,1002,1006,4000), ]

noviembre<-subset(noviembre, select=-c(Fecha_Retiro,Fecha_Arribo, Hora_Retiro, Hora_Arribo, Genero_Usuario, Bici, Edad_Usuario))

unos<-rep(1, nrow(noviembre))
noviembre$uso<-unos

write.csv(noviembre, "noviembre2016.csv")
