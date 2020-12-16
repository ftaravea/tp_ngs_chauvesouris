#!/bin/bash

# un script pour lancer PRANK et aligner nos sequences !

# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_prank="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_prank"
mkdir -p $output_prank
cd $output_prank



