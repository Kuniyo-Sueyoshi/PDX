### Description
The script to execute tSNE analysis is located at this directory.

### Usage
```R
source("./tSNE.r")
```
### R-packages requirement
```R
R>
mypkgs <- c("tidyverse", "RColorBrewer", "Rtsne", "cowplot","edgeR")
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
- ./FigS1_Boxplot.jpg
- ./Fig2c_tSNE.jpg
