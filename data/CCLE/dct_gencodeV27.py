#! /usr/bin/env python
# -*- coding: utf-8 -*
# http://www.ensembl.org/biomart/martview/
import csv
# ENSG/T -> GeneSymbol
mydict1 = {}
mydict2 = {}
mydict3 = {}
with open("/home/sueyoshi/PDX/github/data/ref/gencode.v27.annotation.gtf", "r") as f:
    r = csv.reader(f, delimiter="\t")
    next(r)
    next(r)
    next(r)
    next(r)
    next(r)
    for line in r:
        if line[2] == "transcript":
            ensg = line[8].split('"')[1].split(".")[0]
            enst = line[8].split('"')[3].split(".")[0]
            symbol = line[8].split('"')[7]
            mydict1[ensg] = symbol
#            mydict2[enst] = symbol
#            mydict3[ensg] = enst
def ensg_symbol(x):
    return(mydict1.get(x,"None")) 
#def enst_symbol(x):
#    return(mydict2.get(x,"None")) 
#def ensg_enst(x):
#    return(mydict3.get(x,"None"))
