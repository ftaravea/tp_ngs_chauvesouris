# TP NGS Chauve-souris

readme du projet ngs

Notice : Ce document présente de manière chronologique les avancées du groupe bats 1 au cours des deux semaines de TP NGS.
Les scripts seront décrits brièvements, se réferer aux annotations directement dans le corps des scripts pour plus de détail.
> Des encarts sur les différentes fonctions de bash seront réalisés.


# Journal de bord

# Jour 1

Présentation des différents groupes de TP.

Généralités concernant bash (cf recapitulatif papier jour1), prise en main.

>Quelques fonctions bash utiles :

- #!/bin/bash : permière ligne nécessaire lors de l'écriture d'un script
- mkdir : créer un dossier
- rm : supprimer un fichier
- mv : déplacer un fichier
- cat : affichier le contenu d'un fichier
- pwd : afficher le chemin actuel
- cd chemin : choisir le dossier actif
- chmod u+x nom_du_script : permet de donner les droits d'exécution du script à l'utilisateur.
- Dans le terminal, ./nom_du_script permet de lancer un script
- $variable : appeler une variable définie précedemment
- git reset --soft --hard ou --mixed : revenir à un commit précédent (vérifier la documentation avant usage)




PROJET CHAUVE-SOURIS

**Etude de la réponse interferon chez les chauves-souris.**

Pour cela, nous allons analyser des données de transcriptomique (RNAseq) obtenues depuis des cultures de cellules de *Myotis Velifer* après 6 heures d’exposition à des interférons de type 1 (IFN-1). Nous nous concentrerons sur les interferons stimutaled genes (ISG), en particulier le gène *EIF2AK2* qui code pour la Protein kinase RNA-activated (PKR). PKR est une protéine qui inhibe la traduction virale et beaucoup de virus disposent de systèmes de protection qui antagonisent PKR. Il s'agit donc d'un bon modèle pour étudier des problématiques de co-évolution hôte-virus.

Le but de notre groupe est d'étudier l'impact évolutif de la relation hôte-virus chez les chauves-souris, via la recherche d'évenements évolutifs récents ou anciens (notamment des duplications) sur les gènes de la réponse interferon.



DEBUT DU POJET

Téléchargement des données via la commande: wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=XXX ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

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

Ici l'assemblage nous donne plus de 300 000 gènes différents (contre 30 000 environ chez l'homme en vérité). Cela peut être lié à des erreurs d'assemblage.



Premières recherches sur Transcoder, les fichiers cds d'intérêt et la manière de construire une banque blast, en prévision de la session de décembre !



# Jour 4


Présentation de l'avancée des différents projets.



ANNOTATION DU TRANSCRIPTOME

Utilisation de TransDecoder sur le fichier de sortie de Trinity via le script use_transdecoder.sh

Transdecoder va identifier les régions codantes probables dans les transcrits. Pour cela, le programme prend en considération la taille du cadre de lecture (ORF) susceptible d'être traduit (entre un codon start et un codon stop), puis il calcule un score de probabilité pour les longs ORF (de taille supérieure à 100pb), tout en prenant en considération le sens de lecture reverse/forward. A la fin, TransDecoder va nous donner un fichier avec les régions codantes (cds) probables du transcriptome.

Les données obtenues seront stockées en dehors du git dans /data_download/annotation/output_transcoder

Les paramètres utilisés pour Transdecoder sont présentés en annotation du script use_transdecoder.sh




Suite à cela, nous allons construire une blast data bank à partir de nos séquences et blaster les cds d'ISG humains contre cette banque. Nous choisissons d'utiliser les cds humains car nous disposons de données très complètes et bien annotées. Il aurait également été possible de blaster les cds d'une espèce de chauve-souris proche de *Myotis velifer* (par exemple *Myotis lucifugus*). Celà nous permettra de récupérer les homologues chez *Myotis velifer*.

Pour le blast, nous utilisons le script use_makeblastdb_blastn qui permet de construire la database via makeblastdb et de blaster nos séquences d'intêtet contre cette data base via blastn.

Les données obtenues sont stockées en dehors du git, dans "/home/rstudio/data/mydatalocal/data_download/annotation/output_blastn"



# Jour 5



Création d'un petit script pour installer Phyml, PRANK et Trimal. Voir instal_programs.sh


On va commencer par écrire un script pour ne garder que les séquences pour lesquelles on a un homologue dont la taille correspond au moins à la moitié de la taille de la séquence de référence. Le but est d'éliminer les artefacts de petite taille. Pour cela, nous utilisons le script parse_blastn_output.sh. On utilise la fonction blastdbcmd afin d'extraire les homologues d'intéret de notre data base


Voici le nombre d'homologues obtenus pour *Myotis velifer* pour différents ISG après traitement :
- PKR : 2
- SAMHD1 : 2
- BST2 : 11
- SAMD9-SAMD9L : 3




ALIGNEMENTS DES DONNEES

Maintenant que nous avons récupéré nos différents homologues, nous allons réaliser l'alignement des séquences en utilisant PRANK.

Les scripts use_prank.sh, use_trimal.sh et use_phyml.sh on été séparés en trois scripts différents mais ils pourraient sans problème être utilisés les uns à la suite des autres dans le même script.

Pour réaliser l'alignement, nous utilisons le script use_prank.sh, les différents paramètres sont détaillés en commentaire du script.

prank -gapext=0.5 -gaprate=0.005 -d=fasta_dir +F -o=output_prank_f_file

Nous avons décidé de tester deux conditions différentes (avec ou sans l'option F qui permet de passer les insertions). Aucune différence significative n'a été observée sur les résultats finaux.

Les données obtenues seront stockées en dehors du git dans /data_download/alignment_phylogeny/output_prank

Les alignements ont été visualisés avec SeaView pour vérifier l'absence d'anomalies majeures.



# Jour 6

Utilisation de trimAl et de PhyML et analyse des résultats.



Les sorties de Prank sont converties au format phylip en utilisant trimAl (use_trimal.sh) grace à l'option -phylip.

Les données obtenues seront stockées en dehors du git dans /data_download/alignment_phylogeny/output_trimal



PHYLOGENIE

Enfin, les arbres phylogénétiques sont obtenus en utilisant PhyML (use_phyml.sh). PhyML est un programme qui permet de réaliser des phylogénies en utilisant la méthode de maximum de vraisemblance.

phyml -i $output_trimal_file -d nt -m HKY85 -a e -c 4 -s NNI -b -1 --leave_duplicat

Voici le détail des options utilisées avec PhyML dans notre cas :
- -i : Entrée du programme, les séquences alignées au format phylip (trimAl)
- -d : Nucléotides (autre choix : acides aminés)
- -m : Choix du modèle de substitution des acides nucléiques, ici, le modèle HKY85. C'est un modèle qui fait la distinction entre les transitions et les transversions et qui donne une probabilité différentes aux bases ACGT.
- -a : Estimation du maximum de vraisemblance
- -s : Modèle pour la construction de l’arbre : nearest-neighbor interchange (NNI). Méthode lente mais optimale.
- -b : Test statistique utilisé pour les branches : approximate likelihood-ratio test (aLRT). Plus rapide que le bootstrap, vérifie qu'une branche apporte bien un gain de likelihood comparé à un arbre sans cette branche.
- --leave_duplicat : Conserver les séquences dupliquées

Les données obtenues sont stockées en dehors du git dans /data_download/alignment_phylogeny/output_phyml



QUELQUES RESULTATS

Nous ne présenterons pas ici tous les résultats de manière détaillée pour des raisons de protection des données, ceux-ci ont déjà été présentés aux personnes interessées lors des différentes présentations réalisées en cours et en fin de TP.

Les gènes suivant ont été testés avec la méthode décrite precedemment :
- BST2
- PKR
- SAMD9-SAMD9L
- SAMD9 et SAMD9L indépendemment l'un de l'autre
- SAMHD1

Les arbres phylogénétiques sont observés et analysés avec SeaView

Biais notés :
- Dans certains cas, l'assemblage par trinity va être responsable de la séparation de plusieurs copies d'un même gène. Dans ce cas, nous obtenons de très nombreux homologues pour un gène ce qui est un artefact d'assemblage. C'est par exemple le cas avec BST2 pour lequl nous obtenons 11 homologues différents. Une méthode pour contrer ce genre d'artefact serait l'utilisation d'un génome de référence pour repérer ces homologues artefactuels. (nous ne disposons pas de génome de référence dans le cas de Myotis velifer)



Plusieurs phénomène interessants ont été observés et peuvent être mentionnés :
- 


