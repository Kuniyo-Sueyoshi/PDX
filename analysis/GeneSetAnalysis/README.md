### Description
The script to execute geneset analyses (pathway analysis and cell signature analysis) is located at this directory.

### Usage
```R
source("./pathway_cellsignature.r")
```
### R-packages requirement
```R
R>
mypkgs <- c("tidyverse", "RColorBrewer", "GSVA", "cowplot","edgeR")
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
- gene-set list of hallmark pathways 
  - ./h.all.v6.2.symbols.gmt
- Pre-processed data of homologue pairs (Human gene symbol - Mouse gene symbol) obtained from Homologue data base (HomoloGene, build68)
  - ../../data/homologene/homologene.data_geneV2.tsv

### Outputs
- ../../suppl_tables/TableS2.1_GSVAscore_hg.tsv
- ../../suppl_tables/TableS2.2_GSVAscore_mm.tsv
- ./Fig3a_Pathway.jpg
- ./Fig3b_CellType.jpg
