The script to execute geneset analyses (pathway analysis and cell signature analysis) is located at this directory.

### Script file
- pathway_cellsignature.r

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R
- gene-set list of hallmark pathways 
  - ./h.all.v6.2.symbols.gmt
- Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
  - ../../data/homologene/homologene.data_geneV2.tsv

### Outputs
- ../../suppl_tables/TableS2.1_GSVAscore_hg.tsv
- ../../suppl_tables/TableS2.2_GSVAscore_mm.tsv
- ./Fig3a_Pathway.jpg
- ./Fig3b_CellType.jpg


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
 [1] edgeR_3.30.3       limma_3.44.1       cowplot_1.1.1      GSVA_1.36.0
 [5] RColorBrewer_1.1-2 forcats_0.5.1      stringr_1.4.0      dplyr_1.0.4
 [9] purrr_0.3.4        readr_1.4.0        tidyr_1.1.2        tibble_3.1.0
[13] ggplot2_3.3.3      tidyverse_1.3.0

loaded via a namespace (and not attached):
 [1] matrixStats_0.58.0          bitops_1.0-6
 [3] fs_1.5.0                    lubridate_1.7.10
 [5] bit64_4.0.5                 httr_1.4.2
 [7] GenomeInfoDb_1.24.0         tools_4.0.0
 [9] backports_1.2.1             utf8_1.1.4
[11] R6_2.5.0                    DBI_1.1.1
[13] BiocGenerics_0.34.0         colorspace_2.0-0
[15] withr_2.4.1                 tidyselect_1.1.0
[17] bit_4.0.4                   compiler_4.0.0
[19] graph_1.66.0                cli_2.3.1
[21] rvest_0.3.6                 Biobase_2.48.0
[23] xml2_1.3.2                  DelayedArray_0.14.0
[25] labeling_0.4.2              scales_1.1.1
[27] digest_0.6.27               XVector_0.28.0
[29] pkgconfig_2.0.3             htmltools_0.5.1.1
[31] dbplyr_2.1.0                fastmap_1.1.0
[33] rlang_0.4.10                readxl_1.3.1
[35] rstudioapi_0.13             RSQLite_2.2.3
[37] shiny_1.6.0                 farver_2.1.0
[39] generics_0.1.0              jsonlite_1.7.2
[41] BiocParallel_1.22.0         RCurl_1.98-1.2
[43] magrittr_2.0.1              GenomeInfoDbData_1.2.4
[45] Matrix_1.3-2                Rcpp_1.0.6
[47] munsell_0.5.0               S4Vectors_0.26.1
[49] fansi_0.4.2                 lifecycle_1.0.0
[51] stringi_1.5.3               SummarizedExperiment_1.18.1
[53] zlibbioc_1.34.0             grid_4.0.0
[55] blob_1.2.1                  parallel_4.0.0
[57] promises_1.2.0.1            crayon_1.4.1
[59] lattice_0.20-41             haven_2.3.1
[61] annotate_1.66.0             hms_1.0.0
[63] locfit_1.5-9.4              ps_1.6.0
[65] pillar_1.5.0                GenomicRanges_1.40.0
[67] stats4_4.0.0                fastmatch_1.1-0
[69] reprex_1.0.0                XML_3.99-0.3
[71] glue_1.4.2                  modelr_0.1.8
[73] vctrs_0.3.6                 httpuv_1.5.5
[75] cellranger_1.1.0            gtable_0.3.0
[77] assertthat_0.2.1            cachem_1.0.4
[79] mime_0.10                   xtable_1.8-4
[81] broom_0.7.5                 later_1.1.0.1
[83] shinythemes_1.2.0           AnnotationDbi_1.50.0
[85] memoise_2.0.0               IRanges_2.22.2
[87] statmod_1.4.34              ellipsis_0.3.1
[89] GSEABase_1.50.0