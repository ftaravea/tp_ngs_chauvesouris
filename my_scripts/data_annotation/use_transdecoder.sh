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
TransDecoder.Predict -t $read/"Trinity_RF.fasta" --single_best_only --cpu 16 -O $output_transcoder

# TransDecoder.LongOrfs permet d extraire les long open reading frames (ORF)
# TransDecoder.Predict permet d estimer la probabilite que les ORF obtenues soient bien des regions codantes
# -t et --gene_trans_map fichiers de sortie de trinity (entree de transdecoder) -m taille minimale souhaitee pour les ORF (ici 100pb) -S car nos donnees sont Strand-specific  -O chemin de sortie pour trandecoder
# -single_best_only permet de ne garder que le meilleur ORF pour chaque transcrit

#FIN

