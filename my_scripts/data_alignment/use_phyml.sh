#!/bin/bash

# un script pour lancer Phyml et creer nos arbres phylogenetiques !

echo "Utilisation: ./use_phyml.sh gene_name"
# On donne nos instructions a l utilisateur. Ce script prend une variable d entree (gene_name)


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_prank="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_prank"
mkdir -p $output_prank
#cd $output_prank

# creer un dossier specifique pour les fichiers de sortie du script
output_trimal="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_trimal"
mkdir -p $output_trimal
#cd $output_trimal

# creer un dossier specifique pour les fichiers de sortie du script
output_phyml="/home/rstudio/data/mydatalocal/data_download/alignment_phylogeny/output_phyml"
mkdir -p $output_phyml
cd $output_phyml


gene=$1
#fasta=$2
#fasta_dir=$data_download/"annotation/output_blastn_parsed/final_output/"$fasta
fasta_dir=`ls $data_download/"annotation/output_blastn_parsed/final_output/"$gene"_+"*"fasta"`

echo $gene
echo $fasta_dir

output_prank_file=$output_prank/$gene"_aligned.fasta"
output_prank_f_file=$output_prank/$gene"_aligned_option_f.fasta"

output_trimal_file=$output_trimal/$gene"_aligned.fasta.phyx"
output_trimal_f_file=$output_trimal/$gene"_aligned_option_f.fasta.phyx"

output_phyml_file=$output_phyml/$gene"_aligned.fasta.phyx.phyml"
output_phyml_f_file=$output_phyml/$gene"_aligned_option_f.fasta.phyx.phyml"

  
if [ -e $fasta_dir ] ; then
  echo "Le fichier de sequences "$gene" existe"
  #on vérifie que notre fichier de séquence existe bien
  
  
  #Dans ce programme, les lignes de code correspondant a trimal et prank ont ete commentees de façon a ce que seul phyml soit lance. Ces lignes ont ete conservees par choix, de facon a pouvoir rapidement produire un script qui utilise prank, trimal et phyml en une seule fois.
  
  #prank -gapext=0.5 -gaprate=0.005 -d=$fasta_dir -o=$output_prank_file
  #prank -gapext=0.5 -gaprate=0.005 -d=$fasta_dir +F -o=$output_prank_f_file


  
  #Trimal
  #trimal -in $output_prank_file".best.fas" -out $output_trimal_file -phylip
  #trimal -in $output_prank_f_file".best.fas" -out $output_trimal_f_file -phylip
  
  
  #phyml
  phyml -i $output_trimal_file -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat
  phyml -i $output_trimal_f_file -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat
  #-i : Sequences au format phylip, -d : Nucleotides, -m : Choix du modèle de substitution
  #-a : Estimation du maximum de vraisemblance, -s : Modèle pour la construction de l’arbre : nearest-neighbor interchange (NNI).
  #-b :  Test statistique utilisé pour les branches : approximate likelihood-ratio test (aLRT), --leave_duplicat : Conserver les séquences dupliquées
  
  
  mv $output_trimal_file"_phyml_stats.txt" $output_phyml
  mv $output_trimal_f_file"_phyml_stats.txt" $output_phyml
  mv $output_trimal_file"_phyml_tree.txt" $output_phyml
  mv $output_trimal_f_file"_phyml_tree.txt" $output_phyml
  #deplacer les fichiers de sortie PhyML dans le bon dossier
  
fi ;


# FIN


#  phyml -i $alignement -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat

