### Description
The script to execute Stromal Score analysis using ESTIMATE is located at this directory.

### Usage
```R
source("StromalScore.r")
```

### R-packages requirement
```sh
conda install -c conda-forge r-r.utils
```
```R
R>
library(utils)
rforge <- "http://r-forge.r-project.org"
install.packages("estimate", repos=rforge, dependencies=TRUE)
mypkgs <- c("tidyverse", "RColorBrewer", "estimate", "cowplot")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
```

### Reuqired files to run the script
- Gene-level exprssion data in Transcript Per Million (TPM) values of Cancer/Stroma components of PDXs 
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
  - ../../data/PDX/Expression_matrix_TPM_mouse.tsv
- Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
  - ../../data/homologene/homologene.data_geneV2.tsv
- Pre-processed Cancer Cell Line Encyclopedia (CCLE) data
  - ../../data/CCLE/matTPM_CCLE.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

### Outputs
- Fig2A_StromalScore.jpg