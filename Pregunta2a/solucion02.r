library(lubridate)
library(lme4) ##ajustes lineales por grupo
library(ggplot2) ## graficas menos feas


### Empezamos con los datos de la pregunta anterior.
datoslimpios<-read.csv("DatosEcoBiciTresMeses.csv")

diasarribo<-day(datoslimpios$fharribo)
diasretiro<-day(datoslimpios$fhretiro)

mesarribo<-month(datoslimpios$fharribo)
mesretiro<-month(datoslimpios$fhretiro)

datoslimpios$diasarribo<-as.factor(diasarribo)
datoslimpios$diasretiro<-as.factor(diasretiro)
datoslimpios$mesarribo<-as.factor(mesarribo)
datoslimpios$mesretiro<-as.factor(mesretiro)

usoarribo<-aggregate(uso~diasarribo+mesarribo+Ciclo_Estacion_Arribo, datoslimpios, sum)
usoretiro<-aggregate(uso~diasretiro+mesretiro+Ciclo_Estacion_Retiro, datoslimpios, sum)

#numeritos de dia en orden para tendencias
usoretiro$diasretiro<-as.numeric(usoretiro$diasretiro)
usoretiro$diasretiro[usoretiro$mesretiro==11]<-usoretiro$diasretiro[ usoretiro$mesretiro==11]+31
usoretiro$diasretiro[usoretiro$mesretiro==12]<-usoretiro$diasretiro[ usoretiro$mesretiro==12]+61
#usoretiro$diasretiro <- as.factor(usoretiro$diasretiro)

##probablemente esto seria más facil hacerlo en una funcion que hacer copy and paste and replace
usoarribo$diasarribo<-as.numeric(usoarribo$diasarribo)
usoarribo$diasarribo[usoarribo$mesarribo==11]<-usoarribo$diasarribo[ usoarribo$mesarribo==11]+31
usoarribo$diasarribo[usoarribo$mesarribo==12]<-usoarribo$diasarribo[ usoarribo$mesarribo==12]+61
#usoarribo$diasarribo <- as.factor(usoarribo$diasarribo)

##ajustes lineales
ajustearribo<-lmList(uso ~ diasarribo | Ciclo_Estacion_Arribo, data=usoarribo)
coefarribo<-coef(ajustearribo)

ajusteretiro<-lmList(uso ~ diasretiro | Ciclo_Estacion_Retiro, data=usoretiro)
coefretiro<-coef(ajusteretiro)
#los que muestran tendencia al alsa
alsaarribo<-coefarribo[ coefarribo$diasarriob>0,]
alsaretiro<-coefretiro[ coefretiro$diasretiro>0,]
alsaarribo<-alsaarribo[order(alsaarribo$diasarribo),]

masarribo<-rownames(tail(alsaarribo))
masretiro<-rownames(tail(alsaretiro))

lasmasaca<-intersect(masarribo,masretiro)

usoretiroalsa<-usoretiro[ usoretiro$Ciclo_Estacion_Retiro %in% lasmasaca, ]
usoarriboalsa<-usoarribo[ usoarribo$Ciclo_Estacion_Arribo %in% lasmasaca, ]

##Dibujitos
graforetiro<- ggplot(usoretiroalsa, aes(x=diasretiro, y=uso, color=factor(Ciclo_Estacion_Retiro)))+geom_point()+geom_smooth(method=lm)
 ggsave(filename="grafoalsaretiro.svg", plot=graforetiro)
grafoarribo<- ggplot(usoarriboalsa, aes(x=diasarribo, y=uso, color=factor(Ciclo_Estacion_Arribo)))+geom_point()+geom_smooth(method=lm)
ggsave("grafoalsaarrribo.svg", grafoarribo)

