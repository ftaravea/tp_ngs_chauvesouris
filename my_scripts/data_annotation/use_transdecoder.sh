#!/bin/bash

# un script pour utiliser Transcoder


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_transcoder="/home/rstudio/data/mydatalocal/data_download/annotation/output_transcoder"
mkdir -p $output_transcoder
cd $output_transcoder

# recuperer les donnees de sortie de trinity qui servent d'entree pour transcoder
read=$data_download/"output_trinity"

TransDecoder.LongOrfs -t $read/"Trinity_RF.fasta" --gene_trans_map $read/"Trinity_RF.fasta.gene_trans_map" -m 100 -S -O $output_transcoder
TransDecoder.Predict -t $read/"Trinity_RF.fasta" -single_best_only --cpu 16 -O $output_transcoder

