This is a directory to keep and process the external data of KIRC (Kideny clear cell renal carcinoma) xenografts. 

###########################################################################
### Procedures to obtain gene-level expression data of external KIRC PDXs
##########################################################################
(1) Download a data file in zip and a sample annotation file 
- https://ctd2-data.nci.nih.gov/Public/TGen/CCLE_RNA-seq_Analysis/
  |- ccle_gene_quantification.zip
  |- cgHub_CCLE_RNA-seq_metadata_summary.txt
- They are publicly available at the Cancer Target Discovery and Development (CTD2) data portal site of National Cancer Institute, NIH; https://ctd2-data.nci.nih.gov/Public/TGen/CCLE_RNA-seq_Analysis/
- Reference;
Barretina J, Caponigro G, Stransky N, Venkatesan K, Margolin AA, Kim S, Wilson CJ, Lehár J, Kryukov GV, Sonkin D, Reddy A, Liu M, Murray L, Berger MF, Monahan JE, Morais P, Meltzer J, Korejwa A, Jané-Valbuena J, Mapa FA, Thibault J, Bric-Furlong E, Raman P, Shipway A, Engels IH, Cheng J, Yu GK, Yu J, Aspesi P Jr, de Silva M, Jagtap K, Jones MD, Wang L, Hatton C, Palescandolo E, Gupta S, Mahan S, Sougnez C, Onofrio RC, Liefeld T, MacConaill L, Winckler W, Reich M, Li N, Mesirov JP, Gabriel SB, Getz G, Ardlie K, Chan V, Myer VE, Weber BL, Porter J, Warmuth M, Finan P, Harris JL, Meyerson M, Golub TR, Morrissey MP, Sellers WR, Schlegel R, Garraway LA. The Cancer Cell Line Encyclopedia enables predictive modelling of anticancer drug sensitivity. Nature. 2012 Mar 28;483(7391):603-7. doi: 10.1038/nature11003. Erratum in: Nature. 2012 Dec 13;492(7428):290. Erratum in: Nature. 2019 Jan;565(7738):E5-E6. PMID: 22460905; PMCID: PMC3320027.

(2) Extract cancer types of interest ("BRCA", "COAD", "KIRC", "LGG", "PAAD", "SARC", "STAD") and change Ensembl gene ID to Gene Symbol (GENCODE v27) 
$ python ./extrCol_chxGeneID.py
  - it will internally import "./dct_gencodeV27.py"

#################
### Output data 
#################
(1) matTPM_CCLE.tsv
