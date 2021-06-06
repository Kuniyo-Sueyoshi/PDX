### Description
The script to execute differential expression analysis of genes is located at this directory.

### Usage
```R
source("./Orignal_vs_External.r")
```

### R-Package requirement
```R
R>
mypkgs <- c("tidyverse", "edgeR", "RColorBrewer", "Rtsne", "GSVA", "cowplot", "ggsignif", "ggrepel")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))
```

### Reuqired files to run the script
- Gene-level exprssion data in Count-estimate values of Original PDXs 
  - ../../data/PDX/Expression_matrix_CountEstimates_human.tsv
  - ../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv
- Expression data of External KIRC PDX data (EGAD00001004799)
  - ../../data/EGAD00001004799/gene.exp.hg.EGAD00001004799.rda
  - ../../data/EGAD00001004799/gene.exp.mm.EGAD00001004799.rda
- gene-set list of hallmark pathways
  - ../GeneSetAnalysis/h.all.v6.2.symbols.gmt
- homolog genes table
  - ../../data/homologene/homologene.data_geneV2.tsv
- GSVA enrichement scores of pathway analyses of Original PDXs
  - ../../suppl_tables/TableS2.1_GSVAscore_hg.tsv
  - ../../suppl_tables/TableS2.2_GSVAscore_mm.tsv
- Cell types and cell signature genes 
  - ../../suppl_tables/TableS3_cell_marker.tsv
- Result tables of differential expression analyses of Original PDXs
  - ../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv
  - ../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv
- Gene-level exprssion data in Transcript Per Million (TPM) values of Original PDXs 
  - ../../data/PDX/Expression_matrix_TPM_human.tsv
- CCLE expression data in TPM values
  - ../../data/CCLE/matTPM_CCLE.tsv
- GTEx expression data in TPM values
  - ../../data/GTEx/matTPM_GTEx_Kidney.tsv
- Function to annotate and sort PDX samples
  - ../../data/PDX/fn_anno_sort.R

### Outputs
- ./FigS3_Ori-Ex_PDX.jpg