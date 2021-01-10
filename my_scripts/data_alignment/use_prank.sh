#!/bin/bash

# un script pour lancer PRANK et aligner nos sequences !

echo "Utilisation: ./use_prank.sh gene_name"
# On donne nos instructions a l utilisateur. Ce script prend une variable d entree (gene_name)


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download 
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_prank="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_prank"
mkdir -p $output_prank
cd $output_prank

#Dans ce programme, les lignes de code correspondant a trimal et phyml ont ete commentees de façon a ce que seul prank soit lance. Ces lignes ont ete conservees par choix, de facon a pouvoir rapidement produire un script qui utilise prank, trimal et phyml en une seule fois.

# creer un dossier specifique pour les fichiers de sortie du script
#output_trimal="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_trimal"
#mkdir -p $output_trimal
#cd $output_trimal

# creer un dossier specifique pour les fichiers de sortie du script
#output_phyml="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_phyml"
#mkdir -p $output_phyml
#cd $output_phyml

gene=$1
#fasta=$2      Il s'agit d une autre maniere de proceder qui n a finalement pas ete utilisee.
#fasta_dir=$data_download/"annotation/output_blastn_parsed/final_output/"$fasta
fasta_dir=`ls $data_download/"annotation/output_blastn_parsed/final_output/"$gene"_+"*"fasta"`

echo $gene
echo $fasta_dir

output_prank_file=$output_prank/$gene"_aligned.fasta"
output_prank_f_file=$output_prank/$gene"_aligned_option_f.fasta"

#output_trimal_file=$output_trimal/$gene"_aligned.fasta.phyx"
#output_trimal_f_file=$output_trimal/$gene"_aligned.fasta.phyx"
  
if [ -e $fasta_dir ] ; then
  echo "Le fichier de sequences "$gene" existe"
  #on vérifie que notre fichier de séquence existe bien
  
  
  prank -gapext=0.5 -gaprate=0.005 -d=$fasta_dir -o=$output_prank_file
  prank -gapext=0.5 -gaprate=0.005 -d=$fasta_dir +F -o=$output_prank_f_file
  # nous testons deux conditions differentes avec ou sans l'option F
  # -gapext et -gaprate sont des penalitees attribuees au gap dans l'alignment (respectivement pour l'extension du gap et l'ouverture du gap) Ces criteres permettent d'ameliorer la qualite de l'alignement.
  # F est une option qui permet de forcer l'alignement a sauter les insertions.


  
  #Trimal
  #trimal -in $output_prank_file".best.fas" -out $output_trimal_file -phylip
  #trimal -in $output_prank_f_file".best.fas" -out $output_trimal_f_file -phylip
  
  
  #phyml
  #phyml -i $output_trimal_file".best.fas" -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat
  #phyml -i $output_trimal_f_file".best.fas" -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat
  
  
fi ;

# FIN

