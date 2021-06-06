### Description
The script to execute Tumor purity analysis is located at this directory.

### Usage
```R
source("./tumorpurity.r")
```

### R-packages requirement
```R
R>
mypkgs <- c("tidyverse", "RColorBrewer", "cowplot")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))
```

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R
- Tumor purity of TCGA samples computed by ABSOLUTE algorithm 
  - ../../data/TCGA/TCGA_mastercalls.abs_tables_JSedit.fixed.tx
- Sample list of TCGA involved in ABSOLUTE tumorpurity anaylysis
  - ../data/TCGA/samplelist_CNVrun_BRCA.txt
  - ../data/TCGA/samplelist_CNVrun_KIRC.txt
  - ../data/TCGA/samplelist_CNVrun_PAAD.txt
  - ../data/TCGA/samplelist_CNVrun_COAD.txt
  - ../data/TCGA/samplelist_CNVrun_LUAD.txt
  - ../data/TCGA/samplelist_CNVrun_SARC.txt
  - ../data/TCGA/samplelist_CNVrun_GBM.txt
  - ../data/TCGA/samplelist_CNVrun_LUSC.txt
  - ../data/TCGA/samplelist_CNVrun_STAD.txt
  
### Outputs
- ./Fig2b_Tumorpurity.jpg