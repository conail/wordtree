#!/bin/bash

INPUT=../data/CORPUS_UTF-8
OUTPUT=../data/text

mkdir $OUTPUT

# Strip metadata from input files, and output lowercase
# sentences without punctuation.
for doc in $INPUT/*
do
    xmlstarlet sel -t -v /TEI.2/text/body/div1/p/s $doc |
	tr [:upper:] [:lower:] |
	tr -cd [a-z0-9\ ] > $OUTPUT/$(basename $doc)
done
