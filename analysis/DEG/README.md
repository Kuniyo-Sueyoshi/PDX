The script to execute differential expression analysis of genes is located at this directory.

### Script file
- DEG.r

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

### Outputs
- ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv

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
attached base packages: [1] stats     graphics  grDevices utils     datasets  methods   base
other attached packages:
 [1] RColorBrewer_1.1-2 edgeR_3.30.3       limma_3.44.1       forcats_0.5.1
 [5] stringr_1.4.0      dplyr_1.0.4        purrr_0.3.4        readr_1.4.0
 [9] tidyr_1.1.2        tibble_3.1.0       ggplot2_3.3.3      tidyverse_1.3.0
loaded via a namespace (and not attached):
 [1] Rcpp_1.0.6       cellranger_1.1.0 pillar_1.5.0     compiler_4.0.0
 [5] dbplyr_2.1.0     tools_4.0.0      statmod_1.4.34   lattice_0.20-41
 [9] jsonlite_1.7.2   lubridate_1.7.10 lifecycle_1.0.0  gtable_0.3.0
[13] pkgconfig_2.0.3  rlang_0.4.10     reprex_1.0.0     cli_2.3.1
[17] rstudioapi_0.13  DBI_1.1.1        haven_2.3.1      withr_2.4.1
[21] xml2_1.3.2       httr_1.4.2       fs_1.5.0         generics_0.1.0
[25] vctrs_0.3.6      hms_1.0.0        locfit_1.5-9.4   grid_4.0.0
[29] tidyselect_1.1.0 glue_1.4.2       R6_2.5.0         fansi_0.4.2
[33] readxl_1.3.1     modelr_0.1.8     magrittr_2.0.1   ps_1.6.0
[37] backports_1.2.1  scales_1.1.1     ellipsis_0.3.1   rvest_0.3.6
[41] assertthat_0.2.1 colorspace_2.0-0 utf8_1.1.4       stringi_1.5.3
[45] munsell_0.5.0    broom_0.7.5      crayon_1.4.1