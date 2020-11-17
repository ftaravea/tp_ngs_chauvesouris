#!/bin/bash

# un script qui affiche les dernières lignes des fichiers de données de séquençage

for fichier in /home/rstudio/data/mydatalocal/data_download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
do
  tail $fichier
done