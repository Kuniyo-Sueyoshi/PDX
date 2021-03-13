Scripts to predict paracrine effectors (Upstream.r) and examine posssible paracrine regulators (PDX_CCLE_GTEx.r) are located in this directory.

### Reuqired files
# A list of possible upstream regulators over PDX stromal transcriptome produced by IPA analysis 
../../suppl_tables/TableS5_IPA_Regulators_KIRC_Stroma.txt
# A list of differentially expressed genes in PDX cancer component.
../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv

### Outputs
./FigS2_IPA_KIRC.jpg
./Fig4a_Upstrm_KIRC.jpg

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
 [1] ggsignif_0.6.0     cowplot_1.1.1      RColorBrewer_1.1-2 forcats_0.5.1
 [5] stringr_1.4.0      dplyr_1.0.4        purrr_0.3.4        readr_1.4.0
 [9] tidyr_1.1.2        tibble_3.1.0       ggplot2_3.3.3      tidyverse_1.3.0

loaded via a namespace (and not attached):
 [1] Rcpp_1.0.6       cellranger_1.1.0 pillar_1.5.0     compiler_4.0.0
 [5] dbplyr_2.1.0     tools_4.0.0      jsonlite_1.7.2   lubridate_1.7.10
 [9] lifecycle_1.0.0  gtable_0.3.0     pkgconfig_2.0.3  rlang_0.4.10
[13] reprex_1.0.0     cli_2.3.1        rstudioapi_0.13  DBI_1.1.1
[17] haven_2.3.1      withr_2.4.1      xml2_1.3.2       httr_1.4.2
[21] fs_1.5.0         generics_0.1.0   vctrs_0.3.6      hms_1.0.0
[25] grid_4.0.0       tidyselect_1.1.0 glue_1.4.2       R6_2.5.0
[29] fansi_0.4.2      readxl_1.3.1     modelr_0.1.8     magrittr_2.0.1
[33] ps_1.6.0         backports_1.2.1  scales_1.1.1     ellipsis_0.3.1
[37] rvest_0.3.6      assertthat_0.2.1 colorspace_2.0-0 utf8_1.1.4
[41] stringi_1.5.3    munsell_0.5.0    broom_0.7.5      crayon_1.4.1