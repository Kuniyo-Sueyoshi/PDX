# CCLE (Cancer Cell Line Encyclopedia) data

# Features
This is a directory to keep and handle CCLE expression data

# Files need to be downloaded in this directory
- ccle_gene_quantification.zip (an expression data file)
- cgHub_CCLE_RNA-seq_metadata_summary.txt (a sample annotation file)

Available at [the Cancer Target Discovery and Development (CTD2) data portal site of National Cancer Institute, NIH](https://ctd2-data.nci.nih.gov/Public/TGen/CCLE_RNA-seq_Analysis/ "CCLE portal")
> Reference; Barretina J et al. The Cancer Cell Line Encyclopedia enables predictive modelling of anticancer drug sensitivity. Nature. 2012 Mar 28;483(7391):603-7. doi: 10.1038/nature11003. PMID: 22460905.

# Procedure
 Extract cancer types of interest ("BRCA", "COAD", "KIRC", "LGG", "PAAD", "SARC", "STAD") and change Ensembl gene ID to Gene Symbol (GENCODE v27) 
```sh
$ python ./extrCol_chxGeneID.py
```
This internally imports
```python
./dct_gencodeV27.py
```

# Expected Output data 
- matTPM_CCLE.tsv