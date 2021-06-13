# -*- coding: utf-8 -*-

import pandas as pd

# read CCLE sample annotation
d_smInfo = pd.read_csv("cgHub_CCLE_RNA-seq_metadata_summary.txt", delimiter = "\t")
cells = ["BRCA", "COAD", "KIRC", "LGG", "PAAD", "SARC", "STAD"]
for i in range(len(cells)):
    logi = d_smInfo['disease'].str.contains(cells[i])
    if i==0:
        d_smInfoMin = d_smInfo.ix[logi,:]
    else:
        d_smInfoMin = d_smInfoMin.append(d_smInfo.ix[logi,:])

analid = d_smInfoMin['analysis_id'].tolist()
# list -> character -> replace -> list
myfiles = (",".join(analid).replace(",", ".gene.quantification.txt,")+".gene.quantification.txt").split(",")
diseases = d_smInfoMin["disease"].tolist()
barcodes = d_smInfoMin["barcode"].tolist()

# unzip 
import zipfile
zip_f = zipfile.ZipFile("./ccle_gene_quantification.zip")

for i,myfile in enumerate(myfiles):
    print("loading file is... Cancer type: " + diseases[i] + ", CCLE barcodes: " + barcodes[i] + ", FileName: "+ myfile)
    d = pd.read_csv(zip_f.open(myfile), skiprows = 12, sep = "\t")
    d.index = d["# Name"]
    d_one = d[["TPM"]]
    d_one = d_one.rename(columns={'TPM': barcodes[i]})
    if i == 0:
        d_all = d_one
    else:
        d_all = pd.concat([d_all, d_one], axis = 1)

# ENSG_ID -> GeneSymbol
print("Loading Dictionary function to convert 'ENSG_ID -> GeneSymbol' from dct_gencodeV27.py ") 
import dct_gencodeV27 # my function
ls_ensg = d_all.index
ls_symbol = []
for j in range(len(ls_ensg)):
    GeneSymbol = dct_gencodeV27.ensg_symbol(ls_ensg[j])
    ls_symbol.append(GeneSymbol)
d_all.index = ls_symbol

d_all = d_all.drop("None") # drop rows of index = "None" (No corresponding GeneName for ENSG_ID)
d_all = d_all[~d_all.index.duplicated(keep="first")]

d_all.columns = diseases
d_all = d_all.rename_axis('Gene').reset_index() # index (= GeneSymbol) -> 1st column

d_all.to_csv("matTPM_CCLE.tsv", sep="\t", index=False)
