The script to execute tSNE analysis is located at this directory.

### Script file
- tSNE.r

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

### Outputs
- ./FigS1_Boxplot.jpg
- ./Fig2c_tSNE.jpg


--------------------------------------------------
### R> sessionInfo()
R version 4.0.0 (2020-04-24)
Platform: x86_64-conda_cos6-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)
Matrix products: default
BLAS/LAPACK: /***/miniconda3/lib/libopenblasp-r0.3.8.so
locale:
 [1] LC_CTYPE=en_US.utf-8       LC_NUMERIC=C
 [3] LC_TIME=en_US.utf-8        LC_COLLATE=en_US.utf-8
 [5] LC_MONETARY=en_US.utf-8    LC_MESSAGES=en_US.utf-8
 [7] LC_PAPER=en_US.utf-8       LC_NAME=C
 [9] LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=en_US.utf-8 LC_IDENTIFICATION=C
attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base
other attached packages:
 [1] edgeR_3.30.3       limma_3.44.1       cowplot_1.1.1      Rtsne_0.15
 [5] RColorBrewer_1.1-2 forcats_0.5.1      stringr_1.4.0      dplyr_1.0.4
 [9] purrr_0.3.4        readr_1.4.0        tidyr_1.1.2        tibble_3.1.0
[13] ggplot2_3.3.3      tidyverse_1.3.0
loaded via a namespace (and not attached):
 [1] tidyselect_1.1.0 locfit_1.5-9.4   haven_2.3.1      lattice_0.20-41
 [5] colorspace_2.0-0 vctrs_0.3.6      generics_0.1.0   utf8_1.1.4
 [9] rlang_0.4.10     pillar_1.5.0     glue_1.4.2       withr_2.4.1
[13] DBI_1.1.1        dbplyr_2.1.0     modelr_0.1.8     readxl_1.3.1
[17] lifecycle_1.0.0  munsell_0.5.0    gtable_0.3.0     cellranger_1.1.0
[21] rvest_0.3.6      labeling_0.4.2   ps_1.6.0         fansi_0.4.2
[25] broom_0.7.5      Rcpp_1.0.6       scales_1.1.1     backports_1.2.1
[29] jsonlite_1.7.2   farver_2.1.0     fs_1.5.0         digest_0.6.27
[33] hms_1.0.0        stringi_1.5.3    grid_4.0.0       cli_2.3.1
[37] tools_4.0.0      magrittr_2.0.1   crayon_1.4.1     pkgconfig_2.0.3
[41] ellipsis_0.3.1   xml2_1.3.2       reprex_1.0.0     lubridate_1.7.10
[45] assertthat_0.2.1 httr_1.4.2       rstudioapi_0.13  R6_2.5.0
[49] compiler_4.0.0