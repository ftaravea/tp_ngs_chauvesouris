#!/bin/bash

# un script qui permet de netoyer les sequences grace a Trimmomatic


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_trimmomatic="output_trimmomatic"
mkdir -p $output_trimmomatic
cd $output_trimmomatic


# Recuperer les donnees
home_fastq="/home/rstudio/data/mydatalocal/data_download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ"
# fastq=${home_fastq}/".*gz" cette ligne n'est pas necessaire ici

# Nous allons creer notre liste a la main
nom_des_fastq="Lib1_31_20_S1
Lib2_31_20_S2
Lib3_31_20_S3
Lib4_31_20_S4
Lib5_31_20_S5
Lib6_31_20_S6"

# pour eviter cette etape fastidieuse, on aurait pu utiliser la ligne suivante
# libs=`ls $fastq| cut -f1,2,3,4 -d "_" | sed 's/ /_/g'|uniq`    
# liste des noms de fichiers. cut permet de couper les tirets (-d "_") puis de ne garder que les 4 premiers elements obtenus (-f1,2,3,4). sed permet de recompleter les blancs par des tirets. uniq permet de ne garder qu'un doublon de chaque nom de fichier



for sample in $nom_des_fastq
do
  fastq_R1=${home_fastq}/${sample}_R1_001.fastq.gz
  fastq_R2=${home_fastq}/${sample}_R2_001.fastq.gz
  echo $fichier   #on affiche le nom du fastq pour lequel l'analyse est en cours
  java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE $fastq_R1 $fastq_R2 ${sample}_R1_001_paired.fq.gz ${sample}_R1_001_unpaired.fq.gz ${sample}_R2_001_paired.fq.gz ${sample}_R2_001_unpaired.fq.gz ILLUMINACLIP:${data_download}/adapt.fasta:2:30:10 HEADCROP:9 TRAILING:28 MINLEN:100
done

# Voici le détail des parametres trimmomatic:
# PE: paired end
# 2 entrees, les sequences forward (R1) et reverse (R2) ; 4 sorties R1 et R2 a chaque fois avec les sequences paired et unpaired
# ILLUMINACLIP fichier contenant les adapter et parametres concernant la comparaison aux adapteurs
# HEADCROP:9 couper les 9 premieres bases ; TRAILING:28 verifier que les bases de la fin soient d'une qualité superieure a 28 
# MINLEN:100 ne pas concerver les read plus petits que 100pb



#Fin


# brouillon de boucle a tester dans le terminal
# for fichier in $nom_des_fastq
# do
#   fastq_R1=${fichier}_R1_001.fastq.gz
#   echo $fichier   #on affiche le nom du fastq pour lequel l'analyse est en cours
#   echo $fastq_R1
# done


