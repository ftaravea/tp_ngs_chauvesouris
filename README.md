# TP NGS Chauve-souris

readme du projet ngs


# Journal de bord

# Jour1:

Généralités concernant bash (cf recap papier jour1)

téléchargement des données via la commande: wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

pour proteger les données, le password de la commande précédente a été masqué


# Jour 2

Réflexion sur le séquençage (single end vs paired end, contrôle des séquences avec fastqc, trinity)

DEBUT DE L'ETAPE D'ASSEMBLAGE

utilisation de fastqc via le script boucle_fastqc.sh. Les données obtenues seront stockées en dehors du git dans /data_download/output_fastqc

Uitlisation de trimmomatic pour corriger les séquences selon les defauts observes via fastqc. pour cela on utilise le script boucle_trimmomatic. Les données obtenues seront stockées en dehors du git dans /data_download/output_trimmomatic
Les principaux paramètres utilisés sont les suivants : 
ILLUMINACLIP:data:2:30:10 HEADCROP:9 TRAILING:28 MINLEN:100


# Jour 3

Utilisation de fastqc sur les fichiers de sortie de trimmomatic pour vérifier l'efficacité du netoyage des séquences.

Réalisation d'un script pour simuler le lancement de Trinity. Nom du script : boucle_trinity.Les données obtenues seront stockées en dehors du git dans /data_download/output_trinity_test pour le test et /data_download/output_trinity pour les vraies données.
Les paramètre suivants sont utilisés pour Trinity
--seqType fq --left /R1 --right /R2 --max_memory 14G --CPU 4 --SS_lib_type RF


Les fonctions suivantes ont été étudiées et représentent un intérêt certain:
- nohup ./"nom_du_script" >& /home/rstudio/data/mydatalocal/data_download/nohup/nohup18_11 &
Permet de lancer un script en arrière plan. Les données sensées s'afficher sur le terminal s'écriront sur le fichier indiqué après le > ; les & permettent de revenir immédiatement au terminal
- tail -f
Permet de regarder la fin d'un fichier, (-f) permet de mettre à jour ce qui est affiché si le fichier est en train d'être écrit. Particulièrement utile pour le fichier nohup
- ps
Affiche les script en train de tourner sur la machine. kill "identifiant" (ex: kill $293) permet de mettre fin à un script qui tourne en arrière plan. (q ou ctrl+C peuvent marcher pour un script enpremier plan)
- htop
Permet de voir les CPU attribués à nos programmes et d'autres infos utiles



FIN DE L'ETAPE D'ASSEMBLAGE

