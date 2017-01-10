#!/bin/bash

##Nomas para poner todo en una sola tabla manejable
# Los datos de noviembre no traen encabezado, pero los de diciembre si
#hay que quitarselo
tail -n +2 2016-12.csv > diciembre.csv
cat 2016-10.csv 2016-11.csv diciembre.csv > TresMeses.csv 
#Por alguna razón quedan saltos de linea estilo DOS:
dos2unix TresMeses.csv TresMesesAgain.csv

# A R no le gustan los formatos de fecha y hora con mayuscula
sed -i 's/AM/am/g' TresMesesAgain.csv 
sed -i 's/PM/pm/g' TresMesesAgain.csv

