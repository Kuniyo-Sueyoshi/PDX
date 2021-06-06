# Main analyses and scripts

# Features
This repository includes scripts to reproduce Figures and Supplementary Figures relating to bioinformatics anayses in the study.

# Usage example
Please see sub-repository/README.md for the details.
```sh
cd ./DEG
```
```R
source("./DEG.r")
```

# General requirement
Please see sub-repository/README.md or each script(.r) regarding the R-package instalation.
```R
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
 [1] ggrepel_0.8.2      ggsignif_0.6.0     cowplot_1.1.1      GSVA_1.36.0
 [5] Rtsne_0.15         RColorBrewer_1.1-2 edgeR_3.30.3       limma_3.44.1
 [9] forcats_0.5.1      stringr_1.4.0      dplyr_1.0.4        purrr_0.3.4
[13] readr_1.4.0        tidyr_1.1.2        tibble_3.1.0       ggplot2_3.3.3
[17] tidyverse_1.3.0
```