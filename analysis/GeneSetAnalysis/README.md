# Geneset analysis 

# Description
The script to execute geneset analyses (pathway analysis and cell signature analysis) is located at this directory.

# Usage
```R
source("./pathway_cellsignature.r")
```

# Files required to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R
- gene-set list of hallmark pathways 
  - ./h.all.v6.2.symbols.gmt
- Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
  - ../../data/homologene/homologene.data_geneV2.tsv

# Outputs
- ../../suppl_tables/TableS2.1_GSVAscore_hg.tsv
- ../../suppl_tables/TableS2.2_GSVAscore_mm.tsv
- ./Fig3a_Pathway.jpg
- ./Fig3b_CellType.jpg

# R environment and packages
> R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] BiocManager_1.30.16 edgeR_3.34.0        limma_3.48.0
 [4] cowplot_1.1.1       GSVA_1.40.1         RColorBrewer_1.1-2
 [7] forcats_0.5.1       stringr_1.4.0       dplyr_1.0.6
[10] purrr_0.3.4         readr_1.4.0         tidyr_1.1.3
[13] tibble_3.1.2        ggplot2_3.3.4       tidyverse_1.3.1