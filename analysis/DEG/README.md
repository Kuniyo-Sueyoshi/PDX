# Differential expression analysis

# Description
The script to execute differential expression analysis (cancer-components and stroma-components of PDX) is located at this directory.

# Usage
```R
source("./DEG.r")
```

# Files required to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

# Outputs of the script
- ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv

# R environment and packages
> R version 4.1.0 (2021-05-18)  
Platform: x86_64-apple-darwin17.0 (64-bit)  
Running under: macOS Catalina 10.15.7  
attached base packages:  
[1] stats     graphics  grDevices utils     datasets  methods   base  
other attached packages:  
 [1] BiocManager_1.30.16 statmod_1.4.36      RColorBrewer_1.1-2
 [4] edgeR_3.34.0        limma_3.48.0        forcats_0.5.1
 [7] stringr_1.4.0       dplyr_1.0.6         purrr_0.3.4
[10] readr_1.4.0         tidyr_1.1.3         tibble_3.1.2
[13] ggplot2_3.3.4       tidyverse_1.3.1