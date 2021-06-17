# Tumor purity analysis

# Description
The script to execute Tumor purity analysis of PDXs is located at this directory. As a reference, TCGA tumor purity scores calculated by ABSOLUTE are to be imported.

# Usage
```R
source("./tumorpurity.r")
```

# Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R
- Tumor purity of TCGA samples computed by ABSOLUTE algorithm 
  - ../../data/TCGA/TCGA_mastercalls.abs_tables_JSedit.fixed.tx
- Sample list of TCGA involved in ABSOLUTE tumorpurity anaylysis
  - ../data/TCGA/samplelist_CNVrun_BRCA.txt
  - ../data/TCGA/samplelist_CNVrun_KIRC.txt
  - ../data/TCGA/samplelist_CNVrun_PAAD.txt
  - ../data/TCGA/samplelist_CNVrun_COAD.txt
  - ../data/TCGA/samplelist_CNVrun_LUAD.txt
  - ../data/TCGA/samplelist_CNVrun_SARC.txt
  - ../data/TCGA/samplelist_CNVrun_GBM.txt
  - ../data/TCGA/samplelist_CNVrun_LUSC.txt
  - ../data/TCGA/samplelist_CNVrun_STAD.txt
  
# Outputs of the script
- ./Fig2b_Tumorpurity.jpg

# R environment and packages
> R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] BiocManager_1.30.16 ggrepel_0.9.1       cowplot_1.1.1
 [4] RColorBrewer_1.1-2  forcats_0.5.1       stringr_1.4.0
 [7] dplyr_1.0.6         purrr_0.3.4         readr_1.4.0
[10] tidyr_1.1.3         tibble_3.1.2        ggplot2_3.3.4
[13] tidyverse_1.3.1