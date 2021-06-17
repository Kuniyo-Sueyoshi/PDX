# Validation of KIRC PDX transcriptome

# Description
The script to execute validation analyses is placed in this directory.  
In the script, Original KIRC PDXs and External KIRC PDXs (EGAD00001004799) are to be integrated; then the results of (1) tSNE of cancer components, (2) Geneset analyses, (3) Differential exprssion analyses, and (4) Expression patterns of estimated paracrine effectors are to be compared with original results.


# Usage
```R
source("./Orignal_vs_External.r")
```

# Files required to run the script
- Gene-level exprssion data in Count-estimate values of Original PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Expression data of External KIRC PDX data (EGAD00001004799)
  - ../../data/EGAD00001004799/gene.exp.hg.EGAD00001004799.rda
  - ../../data/EGAD00001004799/gene.exp.mm.EGAD00001004799.rda
- gene-set list of hallmark pathways
  - ../GeneSetAnalysis/h.all.v6.2.symbols.gmt
- homolog genes table
  - ../../data/homologene/homologene.data_geneV2.tsv
- GSVA enrichement scores of pathway analyses of Original PDXs
  - ../../suppl_tables/TableS2.1_GSVAscore_hg.tsv
  - ../../suppl_tables/TableS2.2_GSVAscore_mm.tsv
- Cell types and cell signature genes 
  - ../../suppl_tables/TableS3_cell_marker.tsv
- Result tables of differential expression analyses of Original PDXs
  - ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
  - ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv
- Gene-level exprssion data in Transcript Per Million (TPM) values of Original PDXs 
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
- CCLE expression data in TPM values
  - ../../data/CCLE/matTPM_CCLE.tsv
- GTEx expression data in TPM values
  - ../../data/GTEx/matTPM_GTEx_Kidney.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

# Outputs
- ./FigS3_Ori-Ex_PDX.jpg

# R environment and packages
> R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] BiocManager_1.30.16 statmod_1.4.36      ggrepel_0.9.1
 [4] ggsignif_0.6.2      cowplot_1.1.1       GSVA_1.40.1
 [7] Rtsne_0.15          RColorBrewer_1.1-2  edgeR_3.34.0
[10] limma_3.48.0        forcats_0.5.1       stringr_1.4.0
[13] dplyr_1.0.6         purrr_0.3.4         readr_1.4.0
[16] tidyr_1.1.3         tibble_3.1.2        ggplot2_3.3.4
[19] tidyverse_1.3.1