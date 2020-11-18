# TP NGS Chauve-souris

readme du projet ngs


# Journal de bord

# Jour1:

Généralités concernant bash (cf recap papier jour1), prise en main.

téléchargement des données via la commande: wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

pour protéger les données, le password de la commande précédente a été masqué.


# Jour 2

Réflexion sur le séquençage (single end vs paired end, contrôle des séquences avec fastqc, trinity)

DEBUT DE L'ETAPE D'ASSEMBLAGE

utilisation de fastqc via le script boucle_fastqc.sh. Les données obtenues seront stockées en dehors du git dans /data_download/output_fastqc

Sur les sorties fastqc, on oberve la présence de plusieurs anomalies
- Les paires de base de fin de read présentent des scores de qualité assez bas
- Les paires de base de début de read possèdent un contenu en ACGT anormal
- Sur de nombreux reads, la fin de read correspond à la séquence de l'adapter Illumina


Uitlisation de trimmomatic pour corriger les séquences selon les defauts observes via fastqc. Pour cela on utilise le script boucle_trimmomatic. Les données obtenues seront stockées en dehors du git dans /data_download/output_trimmomatic
Les principaux paramètres utilisés sont les suivants : 
- ILLUMINACLIP:data:2:30:10 avec en entrée la séquence de l'adapter, pour retirer les morceaux de read qui correspondent à l'adapter (avec une marge de 2 mismatch)
- HEADCROP:9 qui coupe les 9 permières paires de base (contenu en ATGC anormal)
- TRAILING:28 qui ne garde les bases de fin de séquence que si elles ont un score de qualité supérieur à 28 (critère minimum de bonne qualité d'après fastqc)
- MINLEN:100 (qui permet de ne garder que les reads de taille supérieure à 100pb après correction)


# Jour 3

Utilisation de fastqc sur les fichiers de sortie de trimmomatic pour vérifier l'efficacité du netoyage des séquences.

Bilan: c'est de la qualité ++ ! Les problèmes soulevés ont été corrigés.



Réalisation d'un script pour simuler le lancement de Trinity. Nom du script : boucle_trinity. Les données obtenues seront stockées en dehors du git dans /data_download/output_trinity_test pour le test et /data_download/output_trinity pour les vraies données.
Les paramètre suivants sont utilisés pour Trinity et sont expliqués dans les commentaires du script boucle_trinity.
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


Discussion avec un membre de l'équipe du CIRI.


Discussion sur les fichiers de sortie de Trinity
Le premier fichier est un fichier .fasta, il contient les séquences sous la forme /n
>Nom_de_la_séquence /n
Séquence GAGAGCTTT etc...

Les éléments 2,3 et 4 du nom de séquence correspondent au nom du gène
L'élément 5 correspond au numéro de l'isoforme (transcrit différents des autres pour un même gène)
Ex : >TRINITY_DN18_c1_g1_i3

Quelques fonctionalités utiles :
- Grep ">" Trinity_RF.fasta   pour ne récupérer que les lignes avec un chevron
- Grep ">" Trinity_RF.fasta |less   pour les afficher
- Grep ">" Trinity_RF.fasta |wc -l  pour les compter (nombre d'isoformes total)
- Grep ">" Trinity_RF.fasta |cut -f1,2,3,4 -d "_"   pour couper au niveau des "_" et ne garder que les éléments 1,2,3,4 (donc le nom du gène)
- Grep ">" Trinity_RF.fasta |cut -f1,2,3,4 -d "_" |sort |uniq   pour les trier par ordre alphabétique puis supprimer les doublons (wc -l permet alors de compter le nombre de gènes)

Ici le fichier nous donne plus de 300 000 gènes différents (contre 30 000 environ chez l'homme en vérité). Cela peut être lié à des erreurs d'assemblage.



Premières recherches sur Transcoder, les fichiers cds d'intérêt et la manière de construire une banque blast, en prévision de la session de décembre !

