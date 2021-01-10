#!/bin/bash

# un script qui passe les donnees brutes de sequencage dans le traitement fastqc pour analyse de leur qualite
# Version 2. Pour la Version1 aller voir le git du 17/11/2020 14h ou aller voir en fin de script


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_fastqc="output_fastqc"
mkdir -p $data_download/$output_fastqc
cd $output_fastqc            # On se place dans le dossier cree


# Recuperer les donnees
home_fastq="/home/rstudio/data/mydatalocal/data_download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ"     #dossier des donnees brutes
fastq=${home_fastq}/"*.gz"         #Variable contenant les fichiers de donnees



for fichier in $fastq
do
  fastqc $fichier -o $output_fastqc --format fastq --threads 8         # le -o n'est meme pas necessaire ici     --threads precise le nombre de fichiers qui peuvent etre traites simultanement (dependant de la memoire de la VM)
done




# FIN

# V1 utilisee sur les donnees
# for fichier in /home/rstudio/data/mydatalocal/data_download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
# do
#   fastqc $fichier -o /home/rstudio/data/mydatalocal/data_download/output_fastqc --format fastq --threads 8
# done


