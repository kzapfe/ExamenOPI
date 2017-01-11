library(lubridate)
library(ggplot2)
library(reshape2)

datos<-read.csv("DatosEcoBiciTresMeses.csv")
diasarribo<-day(datos$fharribo)
diasretiro<-day(datos$fhretiro)

mesarribo<-month(datos$fharribo)
mesretiro<-month(datos$fhretiro)

datos$horaret<-hour(datos$fhretiro)
datos$horarribo<-hour(datos$fharribo)

datos$horaret<-as.factor(datos$horaret)
datos$horarrib<-as.factor(datos$horarribo)
datos$diasarribo<-as.factor(diasarribo)
datos$diasretiro<-as.factor(diasretiro)
datos$mesarribo<-as.factor(mesarribo)
datos$mesretiro<-as.factor(mesretiro)


nombres<-c("hora", "dia", "mes","Estacion","uso")


usoarribo<-aggregate(uso~horarribo
                     +diasarribo+mesarribo+Ciclo_Estacion_Arribo, datos, sum)
colnames(usoarribo)<-nombres

#por alguna razon se colo la estacion fantasma
usoarribo<-usoarribo[ usoarribo$Estacion !=1002,]

dataria <- paste(usoarribo$hora, usoarribo$dia, usoarribo$mes)
dataria<-as.POSIXct(dataria, format="%H %d %m")
usoarribo$datu<-dataria
usoarribo<-subset(usoarribo, select=-c(hora, dia, mes))
usoarribo$Estacion<-as.factor(usoarribo$Estacion)


usoretiro<-aggregate(uso~horaret
                     +diasretiro+mesretiro+Ciclo_Estacion_Retiro, datos, sum)
colnames(usoretiro)<-nombres

usoretiro<-usoretiro[ usoretiro$Estacion !=1002,]


dataria <- paste(usoretiro$hora, usoretiro$dia, usoretiro$mes)
dataria<-as.POSIXct(dataria, format="%H %d %m")
usoretiro$datu<-dataria
usoretiro<-subset(usoretiro, select=-c(hora, dia, mes))
usoretiro$Estacion<-as.factor(usoretiro$Estacion)

rm(datos)

hhs<-seq(from=as.POSIXct("2017-10-1 00:00"),to=as.POSIXct("2017-12-31 23:00"),
         by="hour")
tantashoras<-length(hhs)
tantasestac<-452

 #creamos un data frame de ceros para rellenar las horas
ceros<-data.frame(Estacion=rep(seq(1,452),each=tantashoras),
                  uso=rep(0,tantashoras*tantasestac),rep(hhs,tantasestac))


#llenamos las horas que faltan
retiros<-merge(usoretiro,ceros[-2],all.y=TRUE)
arribos<-merge(usoarribo, ceros[-2],all.y=TRUE)


retiros[is.na(retiros)]<-0
arribos[is.na(arribos)]<-0

anchoarribo<-dcast(arribos, datu~Estacion, value.var="uso", fun.aggregate=sum)
anchoretiro<-dcast(retiros, datu~Estacion, value.var="uso", fun.aggregate=sum)
#de pearson, por omision, ya es muy tarde.
correlacion<-cor(anchoarribo[-1],anchoretiro[-1])
otra<-melt(correlacion)
 colnames(otra)<-c("Arribo", "Retiro", "correl")
#dibujito
grafo<-qplot(x=Arribo, y=Retiro, data=otra, fill=correl, geom="tile")
#ggsave(filename="Correlacion01.png", plot=grafo, width=12,height=12,units=c("cm"))
