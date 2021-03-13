The script to execute Stromal Score analysis using ESTIMATE is located at this directory.

### Reuqired files
# Gene-level exprssion data in Transcript Per Million (TPM) values of Cancer/Stroma components of PDXs 
../../data/PDX/Expression_matrix_TPM_human.tsv
../../data/PDX/Expression_matrix_TPM_mouse.tsv
# Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
../../data/homologene/homologene.data_geneV2.tsv
# Pre-processed Cancer Cell Line Encyclopedia (CCLE) data
../../data/CCLE/matTPM_CCLE.tsv
# Function to annotate and sort PDX samples
../../data/PDX/fn_anno_sort.R

### Outputs
"./Fig2A_StromalScore.jpg

--------------------------------------------------
R> sessionInfo()
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
 [1] cowplot_1.1.1      estimate_1.0.13    RColorBrewer_1.1-2 forcats_0.5.1
 [5] stringr_1.4.0      dplyr_1.0.4        purrr_0.3.4        readr_1.4.0
 [9] tidyr_1.1.2        tibble_3.1.0       ggplot2_3.3.3      tidyverse_1.3.0

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.6       cellranger_1.1.0 pillar_1.5.0     compiler_4.0.0
 [5] dbplyr_2.1.0     tools_4.0.0      digest_0.6.27    jsonlite_1.7.2
 [9] lubridate_1.7.10 lifecycle_1.0.0  gtable_0.3.0     pkgconfig_2.0.3
[13] rlang_0.4.10     reprex_1.0.0     cli_2.3.1        rstudioapi_0.13
[17] DBI_1.1.1        haven_2.3.1      withr_2.4.1      xml2_1.3.2
[21] httr_1.4.2       fs_1.5.0         generics_0.1.0   vctrs_0.3.6
[25] hms_1.0.0        grid_4.0.0       tidyselect_1.1.0 glue_1.4.2
[29] R6_2.5.0         fansi_0.4.2      readxl_1.3.1     farver_2.1.0
[33] modelr_0.1.8     magrittr_2.0.1   ps_1.6.0         backports_1.2.1
[37] scales_1.1.1     ellipsis_0.3.1   rvest_0.3.6      assertthat_0.2.1
[41] colorspace_2.0-0 labeling_0.4.2   utf8_1.1.4       stringi_1.5.3
[45] munsell_0.5.0    broom_0.7.5      crayon_1.4.1