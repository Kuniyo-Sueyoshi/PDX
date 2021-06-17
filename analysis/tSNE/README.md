# tSNE

# Description
The script to execute tSNE analysis of cancer/stoma transcriptome is located at this directory.

# Usage
```R
source("./tSNE.r")
```

# Files required to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

# Outputs
- ./FigS1_Boxplot.jpg
- ./Fig2c_tSNE.jpg

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
 [4] cowplot_1.1.1       Rtsne_0.15          RColorBrewer_1.1-2
 [7] forcats_0.5.1       stringr_1.4.0       dplyr_1.0.6
[10] purrr_0.3.4         readr_1.4.0         tidyr_1.1.3
[13] tibble_3.1.2        ggplot2_3.3.4       tidyverse_1.3.1