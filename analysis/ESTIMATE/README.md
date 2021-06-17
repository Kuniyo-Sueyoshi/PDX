# Stromal score

# Description
The script to execute Stromal Score analysis using ESTIMATE is located at this directory.
> reference;  Yoshihara K, Shahmoradgoli M, Martínez E, Vegesna R, Kim H, Torres-Garcia W, Treviño V, Shen H, Laird PW, Levine DA, Carter SL, Getz G, Stemke-Hale K, Mills GB, Verhaak R. (2013). Inferring tumour purity and stromal and immune cell admixture from expression data. Nature Communications 4, 2612

# Usage
```R
source("StromalScore.r")
```

# Files reuqired to run the script
- Gene-level exprssion data in Transcript Per Million (TPM) values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
  - ../../data/PDX/Expression_matrix_TPM_mouse.tsv
- Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
  - ../../data/homologene/homologene.data_geneV2.tsv
- Pre-processed Cancer Cell Line Encyclopedia (CCLE) data
  - ../../data/CCLE/matTPM_CCLE.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

# Outputs of the script
- Fig2A_StromalScore.jpg

# R environment and packages
> R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] BiocManager_1.30.16 estimate_1.0.13     cowplot_1.1.1
 [4] RColorBrewer_1.1-2  forcats_0.5.1       stringr_1.4.0
 [7] dplyr_1.0.6         purrr_0.3.4         readr_1.4.0
[10] tidyr_1.1.3         tibble_3.1.2        ggplot2_3.3.4
[13] tidyverse_1.3.1