#!/bin/bash
# Academically licensed software
if [ ! -e "bin/tmhmm/2.0/bin/decodeanhmm.Linux_x86_64" ];
then
    echo "TMHMM not found"
    sed -i 's/binary.tmhmm.path=.*/binary.tmhmm.path=/g' interproscan.properties
fi

if [ ! -e "bin/phobius/1.01/phobius.pl" ];
then
    echo "PHOBIUS not found"
    sed -i 's/binary.phobius.pl.path.1.01=.*/binary.phobius.pl.path.1.01=/g' interproscan.properties
fi

if [ ! -e "bin/signalp/4.0/signalp" ];
then
    echo "SIGNALP not found"
    sed -i 's/binary.signalp.4.0.path=.*/binary.signalp.4.0.path=/g' interproscan.properties
    sed -i 's/signalp.4.0.perl.library.dir=.*/signalp.4.0.perl.library.dir=/g' interproscan.properties
fi

if [ ! -d "data/pirsf/" ];
then
    echo "DATA not found"
fi

USER_DIR=$PWD
cd $(dirname "$0")

# set environment variables for getorf
export EMBOSS_ACDROOT=bin/nucleotide
export EMBOSS_DATA=bin/nucleotide

java $DOCKER_JAVA_ARGS -jar  interproscan-5.jar $@ -u $USER_DIR
