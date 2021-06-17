### Description
The script to execute differential expression analysis of genes is located at this directory.

### Usage
```R
source("./DEG.r")
```

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

### Outputs
- ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv

# R environment and packages
> R version 4.1.0 (2021-05-18)  
> Platform: x86_64-apple-darwin17.0 (64-bit)  
> Running under: macOS Catalina 10.15.7
locale:  
[1] ja_JP.UTF-8/ja_JP.UTF-8/ja_JP.UTF-8/C/ja_JP.UTF-8/ja_JP.UTF-8
attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base
other attached packages:
 [1] statmod_1.4.36     RColorBrewer_1.1-2 edgeR_3.34.0       limma_3.48.0
 [5] forcats_0.5.1      stringr_1.4.0      dplyr_1.0.6        purrr_0.3.4
 [9] readr_1.4.0        tidyr_1.1.3        tibble_3.1.2       ggplot2_3.3.4
[13] tidyverse_1.3.1
loaded via a namespace (and not attached):
 [1] tidyselect_1.1.1    locfit_1.5-9.4      haven_2.4.1
 [4] lattice_0.20-44     colorspace_2.0-1    vctrs_0.3.8
 [7] generics_0.1.0      utf8_1.2.1          rlang_0.4.11
[10] pillar_1.6.1        glue_1.4.2          withr_2.4.2
[13] DBI_1.1.1           dbplyr_2.1.1        modelr_0.1.8
[16] readxl_1.3.1        lifecycle_1.0.0     munsell_0.5.0
[19] gtable_0.3.0        cellranger_1.1.0    rvest_1.0.0
[22] ps_1.6.0            fansi_0.5.0         broom_0.7.7
[25] Rcpp_1.0.6          scales_1.1.1        backports_1.2.1
[28] BiocManager_1.30.16 jsonlite_1.7.2      fs_1.5.0
[31] hms_1.1.0           stringi_1.6.2       grid_4.1.0
[34] cli_2.5.0           tools_4.1.0         magrittr_2.0.1
[37] crayon_1.4.1        pkgconfig_2.0.3     ellipsis_0.3.2
[40] xml2_1.3.2          reprex_2.0.0        lubridate_1.7.10
[43] assertthat_0.2.1    httr_1.4.2          rstudioapi_0.13
[46] R6_2.5.0            compiler_4.1.0