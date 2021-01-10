#!/bin/bash


#un script pour installer les programmes dont on a besoin

my_program="/home/rstudio/data/mydatalocal/my_program"

cd $my_program

###trimal

git clone https://github.com/scapella/trimal.git

cd trimal/source

make

export PATH=$PATH:/home/rstudio/data/mydatalocal/my_program/trimal/source/



###Prank

cd $my_program

wget http://wasabiapp.org/download/prank/prank.linux64.170427.tgz
tar xzf prank.linux64.170427.tgz

export PATH=$PATH:/home/rstudio/data/mydatalocal/my_program/prank/bin/



###phyML

git clone https://github.com/stephaneguindon/phyml.git

mv phyml $my_program

cd $data/phyml

./autogen.sh
./configure --enable-phyml
make

export PATH=$PATH:/home/rstudio/data/mydatalocal/my_program/phyml/src/



# FIN



