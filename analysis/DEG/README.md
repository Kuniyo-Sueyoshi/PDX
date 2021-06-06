### Description
The script to execute differential expression analysis of genes is located at this directory.

### Usage
```R
source("./DEG.r")
```

### R-Package requirement
```R
R>
mypkgs <- c("tidyverse", "edgeR", "RColorBrewer", "limma")
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

### Outputs
- ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv