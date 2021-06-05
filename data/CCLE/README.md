This is a directory to keep and process the external data of KIRC (Kideny clear cell renal carcinoma) xenografts. 

### Procedures to obtain gene-level expression data of external KIRC PDXs
(1) Required file (a data file and a sample annotation file) and comments
- https://ctd2-data.nci.nih.gov/Public/TGen/CCLE_RNA-seq_Analysis/ (the Cancer Target Discovery and Development (CTD2) data portal site of National Cancer Institute, NIH)
  - ccle_gene_quantification.zip
  - cgHub_CCLE_RNA-seq_metadata_summary.txt
- Reference; Barretina J et al. The Cancer Cell Line Encyclopedia enables predictive modelling of anticancer drug sensitivity. Nature. 2012 Mar 28;483(7391):603-7. doi: 10.1038/nature11003. PMID: 22460905.

(2) Extract cancer types of interest ("BRCA", "COAD", "KIRC", "LGG", "PAAD", "SARC", "STAD") and change Ensembl gene ID to Gene Symbol (GENCODE v27) 
- $ python ./extrCol_chxGeneID.py
  - Internally import "./dct_gencodeV27.py"

### Output data 
- matTPM_CCLE.tsv
