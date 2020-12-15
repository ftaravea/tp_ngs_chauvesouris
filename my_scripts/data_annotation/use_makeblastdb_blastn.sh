#!/bin/bash

# un script pour creer notre banque blast avec makeblast puis blaster
# on va utiliser les séquences du fichier all_aln

echo "uilisation: ./use_makeblastdb_blastn.sh gene_name"

# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download/annotation"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_blast="/home/rstudio/data/mydatalocal/data_download/annotation/output_blastn"
mkdir -p $output_blast
cd $output_blast

gene=$1

querydir=$data_download/"all_aln"
query=$querydir/$gene".fas"

if [ -e $query ] ; then
  echo "$query exists"    #confirmer que le gene existe
  
  #creer notre blast data base
  assemblage=$data_download/"output_transcoder/Trinity_RF.fasta.transdecoder.cds"
  blast_db_dir=$data_download/"output_blast_database"
  blast_db=$blast_db_dir/"Myotis_velifer_cds.db"
  db=$blast_db.nhr
  
  mkdir -p $blast_db_dir
  
  if [[ -s $db ]] ; then
  echo "$db exists"
  else
  echo "$db is empty."
  /softwares/ncbi-blast-2.10.1+/bin/makeblastdb -in $assemblage -dbtype nucl -parse_seqids -out $blast_db
  fi ;
  
  
  blast_out_dir=$output_blast
  
  mkdir -p $blast_out_dir
  
  blast=$blast_out_dir/$gene".blast"
  echo $blast
  if [[ -s $blast ]] ; then
  echo "$blast exists"
  else
  echo "$blast is empty"
  /softwares/ncbi-blast-2.10.1+/bin/blastn -db $blast_db -query $query -evalue 1e-20 -outfmt 6 -out $blast
  fi ;
  
fi ;  
  




