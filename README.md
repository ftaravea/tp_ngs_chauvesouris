# TP NGS Chauve-souris

readme du projet ngs


# Journal de bord

# Jour1:

#téléchargement des données via la commande: wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

#pour proteger les données, le password de la commande précédente a été masqué


# Jour 2

#Réflexion sur le séquençage (single end vs paired end, contrôle des séquences avec fastqc, trinity)

#utilisation de fastqc via le script boucle_fastqc.sh. Les données obtenues seront stockées en dehors du git dans /data_download/output_fastqc

#Uitlisation de trimmomatic pour corriger les séquences selon les defauts observes via fastqc. pour cela on utilise le script boucle_trimmomatic. Les données obtenues seront stockées en dehors du git dans /data_download/output_trimmomatic