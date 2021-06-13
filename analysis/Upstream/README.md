### Description
The script to predict paracrine effectors examine posssible paracrine regulators are located at this directory.

### Usage
```R
source("./Upstream.r")
source("./PDX_CCLE_GTEx.r")
```
### R-packages requirement
```R
R>
mypkgs <- c("tidyverse", "ggrepel", "RColorBrewer", "cowplot", "ggsignif")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))
```

### Reuqired files to run the scripts
- A list of possible upstream regulators over PDX stromal transcriptome (IPA® analysis) 
  - ../../suppl_tables/TableS5_IPA_Regulators_KIRC_Stroma.txt
- A list of differentially expressed genes in PDX cancer component.
  - ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
- Original PDX expression data in TPM values  
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
  - ../../data/PDX/Expression_matrix_TPM_mouse.tsv
- CCLE expression data in TPM values
  - ../../data/CCLE/matTPM_CCLE.tsv
- GTEx expression data in TPM value
  - ../../data/GTEx/matTPM_GTEx_Kidney.tsv

### Outputs
- ./FigS2_IPA_KIRC.jpg
- ./Fig4a_Upstrm_KIRC.jpg