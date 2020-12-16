#!/bin/bash

#Un script pour sélectionner les sorties de blast avec un alignement de taille suffisante (50% de la taille de la séquence)


# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download/annotation"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_blastn_parsed=$data_download/"output_blastn_parsed"
mkdir -p $output_blastn_parsed
cd $output_blastn_parsed

gene=$1

querydir=$data_download/"all_aln"
query=$querydir/$gene".fas"


########################################################
### PARSE BLAST OUTPUT

## Estimation grossiere de la longueur des genes d interet
nombre_char=cat $query | wc -c
nombre_seq=cat $query | grep ">" -c
lenght_seq=echo "($nombre_char/$nombre_seq)" | bc

echo "estimation of query length=" $lenght_seq

echo "selection of lines in BLAST output corresponding to alignement at least 50% of query length"
target=echo $lenght_seq/2 | bc
echo "That it" $target "bp"

output_blast="/home/rstudio/data/mydatalocal/data_download/annotation/output_blastn"
blast=$output_blast/$gene".blast"

#cat $blast | awk '{if($4>$target) {print $2 " " $4}}'

###
homologs= cat $blast | awk '{if($4>'$target') {print $2}}' | sort | uniq
echo "Sequences a recuperer:"
echo $homologs

file_homologs=$output_blastn_parsed/$gene".fasta"
  
if [[ -s $file_homologs ]] ; then #Si le fichier existe deja
rm $file_homologs #on le supprime
fi;


blast_db_dir=$data_download/"output_blast_database"
blast_db=$blast_db_dir/"Myotis_velifer_cds.db"

for seq in $homologs
  do
  /softwares/ncbi-blast-2.10.1+/bin/blastdbcmd -entry $seq -db $blast_db -out tmp.fasta
  cat tmp.fasta >> $file_homologs
done

cat $query $file_homologs > $output_blastn_parsed/$gene"_+Myovelsup${target}.fasta"



