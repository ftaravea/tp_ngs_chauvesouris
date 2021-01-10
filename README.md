# TP NGS Chauve-souris

readme du projet ngs

Notice : Ce document présente de manière chronologique les avancées du groupe bats 1 au cours des deux semaines de TP NGS.
Les scripts seront décrits brièvements, se réferer aux annotations directement dans le corps des script pour plus de détail.
> Des encarts sur les différentes fonctions de bash seront réalisés.


# Journal de bord

# Jour1:

Présentation des différents groupes de TP.

Généralités concernant bash (cf recapitulatif papier jour1), prise en main.
>Quelques fonctions bash utiles :
#!/bin/bash : permière ligne nécessaire lors de l'écriture d'un script
mkdir : créer un dossier
rm : supprimer un fichier
mv : déplacer un fichier
cat : affichier le contenu d'un fichier
pwd : afficher le chemin actuel
cd chemin : choisir le dossier actif
chmod u+x nom_du_script : permet de donner les droits d'exécution du script à l'utilisateur.
Dans le terminal, ./nom_du_script permet de lancer un script
$variable : appeler une variable définie précedemment
git reset --soft --hard ou --mixed : revenir à un commit précédent (vérifier la documentation avant usage)




PROJET CHAUVE-SOURIS

**Etude de la réponse interferon chez les chauves-souris.**
Pour cela, nous allons analyser des données de transcriptomique (RNAseq) obtenues depuis des cultures de cellules de *Myotis Velifer* après 6 heures d’exposition à des interférons de type 1 (IFN-1). Nous nous concentrerons sur les interferons stimutaled genes (ISG), en particulier le gène *EIF2AK2* qui code pour la Protein kinase RNA-activated (PKR). PKR est une protéine qui inhibe la traduction virale et beaucoup de virus disposent de systèmes de protection qui antagonisent PKR. Il s'agit donc d'un bon modèle pour étudier des problématiques de co-évolution hôte-virus.

Le but de notre groupe est d'étudier l'impact évolutif de la relation hôte-virus chez les chauves-souris, via la recherche d'évenements évolutifs récents ou anciens (notamment des duplications) sur les gènes de la réponse interferon.



DEBUT DU POJET

téléchargement des données via la commande: wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

Afin de protéger les données, le password de la commande précédente a été masqué. Les données ont été produites par l'équipe "Host-pathogen interaction during Lentiviral infection" du CIRI. (Contact: Lucie Etienne)


# Jour 2

Réflexion sur le séquençage (single end vs paired end, contrôle des séquences avec fastqc, trinity)

DEBUT DE L'ETAPE D'ASSEMBLAGE

Utilisation de fastqc via le script boucle_fastqc.sh. fastqc permet de faire un contrôle qualité des données brutes afin de repérer les anomalies à corriger avant l'assemblage. Les données obtenues seront stockées en dehors du git dans /data_download/output_fastqc

Sur les sorties fastqc, on oberve la présence de plusieurs anomalies:
- Les paires de base de fin de read présentent des scores de qualité assez bas
- Les paires de base de début de read possèdent un contenu en ACGT anormal
- Sur de nombreux reads, la fin de read correspond à la séquence de l'adapter Illumina (ceci est lié à la méthode de séquençage utilisée)



Utilisation de trimmomatic pour corriger les séquences selon les défauts observés via fastqc. Pour cela on utilise le script boucle_trimmomatic.sh. Les données obtenues seront stockées en dehors du git dans /data_download/output_trimmomatic
Les principaux paramètres utilisés sont les suivants : 
- ILLUMINACLIP:data:2:30:10 avec en entrée la séquence de l'adapter, pour retirer les morceaux de read qui correspondent à l'adapter (avec une marge de 2 mismatch). Illuminaclip utilise deux méthodes pour trouver les séquences correspondant à l'adapter : Par alignement simple (seuil 10 ici, ce qui permet de détecter des fragments de taille supérieure à 15pb environ) et par une approche en palyndrome qui utilise le fait que nous travaillons sur des données en paired end et qui utilise donc les deux read pairés pour trouver les séquences d'adapter (seuil 30 ici, cette méthode est très sensible et permet même de détecter des fragments de 1pb ou 2pb)
- HEADCROP:9 qui coupe les 9 permières paires de base (contenu en ATGC anormal)
- TRAILING:28 qui ne garde les bases de fin de séquence que si elles ont un score de qualité supérieur à 28 (critère minimum de bonne qualité d'après fastqc)
- MINLEN:100 (qui permet de ne garder que les reads de taille supérieure à 100pb après correction)


# Jour 3

Utilisation de fastqc (boucle_fastqc_post_trimmomatic.sh) sur les fichiers de sortie de trimmomatic pour vérifier l'efficacité du nettoyage des séquences.

Bilan: c'est de la qualité ++ ! Les problèmes soulevés précedemment ont été corrigés.


Trinity est une combinaison de trois programmes permettant de réaliser un assemblage robuste tout en distinguant les transcrits issus de gènes paralogues.
Réalisation d'un script pour simuler le lancement de Trinity. Nom du script : boucle_trinity.sh. Les données obtenues seront stockées en dehors du git dans /data_download/output_trinity_test pour le test et /data_download/output_trinity pour les vraies données. Trinity sera interrompu avant la fin dans notre cas (et les données d'assemblage ajoutées manuellement dans notre VM) car cette étape prendrait trop de temps et de mémoire.
Les paramètre suivants sont utilisés pour Trinity et sont expliqués dans les commentaires du script boucle_trinity.sh.
--seqType fq --left /R1 --right /R2 --max_memory 14G --CPU 4 --SS_lib_type RF



>Les fonctions suivantes ont été étudiées et représentent un intérêt certain:
- nohup ./"nom_du_script" >& /home/rstudio/data/mydatalocal/data_download/nohup/nohup18_11 &
Permet de lancer un script en arrière plan. Les données sensées s'afficher sur le terminal s'écriront sur le fichier indiqué après le > ; les & permettent de revenir immédiatement au terminal
- tail -f
Permet de regarder la fin d'un fichier, (-f) permet de mettre à jour ce qui est affiché si le fichier est en train d'être écrit. Particulièrement utile pour le fichier nohup
- ps
Affiche les script en train de tourner sur la machine. kill "identifiant" (ex: kill $293) permet de mettre fin à un script qui tourne en arrière plan. (q ou ctrl+C peuvent marcher pour un script enpremier plan)
- htop
Permet de voir les CPU attribués à nos programmes et d'autres infos utiles



FIN DE L'ETAPE D'ASSEMBLAGE


Discussion avec un membre de l'équipe du CIRI (Lucie Etienne).


Discussion sur les fichiers de sortie de Trinity
Le premier fichier est un fichier .fasta, il contient les séquences sous la forme

Chevrons Nom_de_la_sequence
Séquence GAGAGCTTT etc...

Les éléments 2,3 et 4 du Nom_de_la_sequence correspondent au nom du gène
L'élément 5 correspond au numéro de l'isoforme (transcrit différent des autres pour un même gène)
Ex : >TRINITY_DN18_c1_g1_i3

Quelques fonctionalités utiles :
- Grep ">" Trinity_RF.fasta   pour ne récupérer que les lignes avec un chevron
- Grep ">" Trinity_RF.fasta |less   pour les afficher
- Grep ">" Trinity_RF.fasta |wc -l  pour les compter (nombre d'isoformes total)
- Grep ">" Trinity_RF.fasta |cut -f1,2,3,4 -d "_"   pour couper au niveau des "_" et ne garder que les éléments 1,2,3,4 (donc le nom du gène)
- Grep ">" Trinity_RF.fasta |cut -f1,2,3,4 -d "_" |sort |uniq   pour les trier par ordre alphabétique puis supprimer les doublons (wc -l permet alors de compter le nombre de gènes)

Ici le fichier nous donne plus de 300 000 gènes différents (contre 30 000 environ chez l'homme en vérité). Cela peut être lié à des erreurs d'assemblage.



Premières recherches sur Transcoder, les fichiers cds d'intérêt et la manière de construire une banque blast, en prévision de la session de décembre !



# Jour4:


Présentation des différents projets

Utilisation de TransDecoder sur le fichier de sortie de Trinity via le script use_transdecoder.sh
Transdecoder va identifier les régions codantes codantes probables dans les transcrits.
Les données obtenues seront stockées en dehors du git dans /data_download/annotation/output_transcoder



Suite à cela, nous allons construire une blast data bank à partir de nos séquences et blaster les cds humains contre cette banque.

Nous choisissons d'utiliser les cds humains car ceux-ci sont mieux annotés que ceux de Myotys lucifugus (une espèce proche de l'espèce cible que nous aurions pu utiliser)

Pour le blast, nous utilisons le script use_makeblastdb_blastn qui permet de construire la database via makeblastdb et de blaster nos séquences d'intêtet contre cette data base via blastn.




# Jour5:


Maintenant que nous avons un programme qui permet de blaster nos séquences, on obtient un certain nombre d'alignement corrects avec des tailles de séquences très diverses.

On va écrire un script pour ne garder que les séquences pour lesquelles on a alignement que correspond au moins à la moitié de la taille de la séquence, parse_blastn_output



Création d'un petit script pour installer Phyml, PRANK et Trimal. Voir instal_programs.sh




# Jour6:

Utilisation de trimal et de phyml



