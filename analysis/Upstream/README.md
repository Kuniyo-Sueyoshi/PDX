# Upstream regulator estimation

# Description
The script to estimate tumor-to-stroma paracrine effectors in KIRC PDXs are located at this directory.

# Usage
```R
source("./Upstream.r")
source("./PDX_CCLE_GTEx.r")
```

# Reuqired files to run the scripts
- A list of possible upstream regulators over PDX stromal transcriptome (IPA® analysis) 
  - ../../suppl_tables/TableS5_IPA_Regulators_KIRC_Stroma.txt
- A list of differentially expressed genes in PDX cancer component.
  - ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- Original PDX expression data in TPM values  
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
  - ../../data/PDX/Expression_matrix_TPM_mouse.tsv
- CCLE expression data in TPM values
  - ../../data/CCLE/matTPM_CCLE.tsv
- GTEx expression data in TPM value
  - ../../data/GTEx/matTPM_GTEx_Kidney.tsv

# Outputs
- ./FigS2_IPA_KIRC.jpg
- ./Fig4a_Upstrm_KIRC.jpg
- ./Fig4b_PDX_CCLE_GTEx.jpg

# R environment and packages
R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] ggsignif_0.6.2      cowplot_1.1.1       RColorBrewer_1.1-2
 [4] BiocManager_1.30.16 ggrepel_0.9.1       forcats_0.5.1
 [7] stringr_1.4.0       dplyr_1.0.6         purrr_0.3.4
[10] readr_1.4.0         tidyr_1.1.3         tibble_3.1.2
[13] ggplot2_3.3.4       tidyverse_1.3.1