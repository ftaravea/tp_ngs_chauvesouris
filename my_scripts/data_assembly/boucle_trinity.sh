#!/bin/bash

# un script pour utiliser Trinity


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script trinity
output_trinity="/home/rstudio/data/mydatalocal/data_download/output_trinity_test"
mkdir -p $output_trinity
cd $output_trinity


# Recuperer les donnees trimmomatic
home_trimmomatic="/home/rstudio/data/mydatalocal/data_download/output_trimmomatic"
left_trimmomatic=$(ls ${home_trimmomatic}/*R1_001_paired.fq.gz |paste -d "," -s)
right_trimmomatic=$(ls ${home_trimmomatic}/*R2_001_paired.fq.gz |paste -d "," -s)
#on veut faire une liste des localisations de nos fichiers, séparés par des virgules pour Trinity
#$() permet de mettre tout ça dans une variable
#ls permet de lister nos fichiers, paste applique a cette liste permet de les mettre les uns a la suite des autres (-s) separes par des virgules (-d ",")



# Lancer trinity
Trinity --seqType fq --left $left_trimmomatic --right $right_trimmomatic --max_memory 14G --CPU 4 --SS_lib_type RF --output $output_trinity

#explication des parametres trinity:
# seqType fastq (ou fasta)
# left ensemble des sequences forward et right, ensemble des sequences reverse
# max_memory et CPU memoire et coeur aloues au programme (notre machine virtuelle est une 16G 4CPU)
# SS_lib_type type de paired end read method   ici FR (ce qui se traduit en RF pour trinity)     information disponible ici https://www.lexogen.com/sense-mrna-sequencing/ FAQ1.9 dans notre cas


# FIN
