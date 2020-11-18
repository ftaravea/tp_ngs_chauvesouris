#!/bin/bash

# un script qui passe les donnees de sortie de trimmomatic dans le traitement fastqc pour analyse de leur qualite


# dossier par defaut pour les donnees
#data_download="/home/rstudio/data/mydatalocal/data_download"
#mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
#cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
#output_fastqc="output_fastqc_post_trimmomatic"
#mkdir -p $output_fastqc
#cd $output_fastqc


# Recuperer les donnees
#home_fastq="/home/rstudio/data/mydatalocal/data_download/output_trimmomatic"
#fastq=${home_fastq}/"*.gz"



#for fichier in $fastq
#do
#  fastqc $fichier -o  "/home/rstudio/data/mydatalocal/data_download/output_fastqc_post_trimmomatic" --format fastq --threads 12  # le -o n'est meme pas necessaire ici
#done




# FIN

# V1 utilisee sur les donnees
for fichier in /home/rstudio/data/mydatalocal/data_download/output_trimmomatic/*.gz
do
  fastqc $fichier -o /home/rstudio/data/mydatalocal/data_download/output_fastqc_post_trimmomatic --format fastq --threads 8
done


