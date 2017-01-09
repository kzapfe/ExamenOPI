#!/bin/bash

## Script al aventón para limpiar datos del CVP2010 y solo quedarme con lo que me interesa.

#los encabezados
head -1 resultados_ageb_urbana_09_cpv2010.csv > encabezados.csv
#los totales por AGEB
cat resultados_ageb_urbana_09_cpv2010.csv | grep "Obreg" | grep "Total AGEB" > tabla_AGEBAObre.cvs

#Listo
cat tabla_AGEBAObre.cvs encabezados.csv > TablaObregonAGEB.csv
