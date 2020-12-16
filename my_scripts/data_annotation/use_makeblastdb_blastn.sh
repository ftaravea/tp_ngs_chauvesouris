#!/bin/bash

# un script pour creer notre banque blast avec makeblastdb a partir des sorties de Trinity puis pour blaster des sequences contre cette banque avec blastn
# on va utiliser les séquences du dossier all_aln

echo "utilisation: ./use_makeblastdb_blastn.sh gene_name"
# On donne nos instructions a l utilisateur. Ce script prend une variable d entree (gene_name)

# dossier par defaut pour les donnees
data_download="/home/rstudio/data/mydatalocal/data_download/annotation"
mkdir -p $data_download     #-p permet de ne pas creer le dossier si il existe deja
cd $data_download

# creer un dossier specifique pour les fichiers de sortie du script
output_blast="/home/rstudio/data/mydatalocal/data_download/annotation/output_blastn"
mkdir -p $output_blast
cd $output_blast

gene=$1
# On stocke la chaine de caracteres entree par l utilisateur dans la variable gene

querydir=$data_download/"all_aln"
query=$querydir/$gene".fas"

if [ -e $query ] ; then
  echo "$query exists"    #confirmer que le fichier contenant les sequences pour le gene existe bien
  
  #creer notre blast data base
  assemblage=$data_download/"output_transcoder/Trinity_RF.fasta.transdecoder.cds"  #sortie trinity qui sert a creer notre data base
  blast_db_dir=$data_download/"output_blast_database"
  blast_db=$blast_db_dir/"Myotis_velifer_cds.db"
  db=$blast_db.nhr    # Une ligne pour pouvoir verifier plus tard si la banque existe bien
  
  mkdir -p $blast_db_dir
  
  if [[ -s $db ]] ; then    #si la banque existe deja, pas la peine de la recreer
  echo "$db exists"
  else
  echo "$db is empty."
  /softwares/ncbi-blast-2.10.1+/bin/makeblastdb -in $assemblage -dbtype nucl -parse_seqids -out $blast_db
  # on cree la banque.
  fi ;
  
  
  # et maintenant, on blast nos sequences
  mkdir -p $output_blast
  
  blast=$output_blast/$gene".blast"
  echo $blast
  if [[ -s $blast ]] ; then #Si le fichier existe deja, on ne le recree pas a nouveau.
  echo "$blast exists"
  else
  echo "$blast is empty"
  /softwares/ncbi-blast-2.10.1+/bin/blastn -db $blast_db -query $query -evalue 1e-20 -outfmt 6 -out $blast
  # db = notre data bank, query = le fichier de notre gene a blaster, expect value threshold pour garder un  , outfmt 6 sortie au format tabulaire
  fi ;
  
fi ;  
  




