# -*- coding: utf-8 -*-

import time
start = time.time()

tiss = "Kidney"
f = open("GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct", "r")
next(f)
next(f)
line = f.readline().strip()
f.close()
allIDs = line.split("\t")

import pandas as pd
d_sm = pd.read_csv("GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt", delimiter = "\t")
logi = (d_sm["SMTS"] == tiss)
d_smMin = d_sm.ix[logi,:]
smids = d_smMin["SAMPID"].tolist()
smtiss = d_smMin["SMTS"].tolist()

indices = [] # Index that indicates where $tiss sapmles are.
for ID in smids:
    try:
        indices.append(allIDs.index(ID) + 1) # +1 ;head -n1 = "sample GTEX-11PR... GTEX-1SK3..." 
    except:
        pass

import subprocess as sbp 
cmd1 = "tail -n +3 GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct" # skip 2 rows
cutopt = "-f2," + ",".join(map(str, indices)) # cut option -f; -f2=geneName, -f[indices]: samples
cmd2 = "cut %s" %cutopt
p1 = sbp.Popen(cmd1.split(" "), stdout=sbp.PIPE)
p2 = sbp.Popen(cmd2.split(" "), stdin=p1.stdout, stdout=sbp.PIPE)
stdout = p2.stdout.read().decode("UTF-8") # byte -> str
f = open("matTPM_GTEx_Kidney_dup.tsv", "w")
f.write(stdout)
f.close()

d = pd.read_table("./matTPM_GTEx_Kidney_dup.tsv")
dd = d[~d["Description"].duplicated()] # remove duplicated genes
dd.to_csv("./matTPM_GTEx_Kidney.tsv", sep = "\t", index = False, float_format='%.4f')
import os
os.remove("./matTPM_GTEx_Kidney_dup.tsv")

elapsed_time = time.time() - start
print ("elapsed_time:{0}".format(elapsed_time) + "[sec]")
