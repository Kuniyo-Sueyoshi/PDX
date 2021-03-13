#! /usr/bin/env python
# -*- coding: utf-8 -*
# ftp://ftp.ncbi.nih.gov/pub/HomoloGene/build68/

### Usage ###
# python  Homolog_geneV2.py homologene.data
#############

import sys

with open(sys.argv[1], "r") as f:
    with open(sys.argv[1]+"_geneV2.tsv", "w") as ff:
        ff.write("NumGene" + "\t" +  "Symbol.hg" + "\t" + "Symbol.mm" + "\n")
        NUMGENE = 0
        Gene_hg = None
        Gene_mm = None
        for line in f:
            items = line.split('\t')
            NumGene = items[0] # gene number
            NumSpecies = items[1] # Species number
            if not NumGene == NUMGENE: # in case of New gene number
                try:
                   ff.write(NUMGENE + "\t" +  Gene_hg + "\t" + Gene_mm + "\n")
                except:
                    pass
                # update/reset variables
                NUMGENE = NumGene
                Gene_mm = None
                Gene_hg = None
            if NumSpecies == "9606":
                Gene_hg = items[3] # Human GeneSymbol
            if NumSpecies == "10090":
                Gene_mm = items[3] # Mouse GeneSymbol
                
        try: # Don't forget to write out the last NumGene
            ff.write(NUMGENE + "\t" +  Gene_hg + "\t" + Gene_mm)
        except:
            pass

