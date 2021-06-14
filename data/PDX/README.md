# PDX expression data

# Features
This is a directory to keep expression data of PDX human/mouse reads and homologue data.

# Files expected to be prepared in this directory
Four Gene-level, human/mouse-allotted PDX expression data: 
1. Expression_matrix_CountEstimates_human.tsv
2. Expression_matrix_CountEstimates_mouse.tsv
3. Expression_matrix_TPM_human.tsv
4. Expression_matrix_TPM_mouse.tsv

# Dependency
Files (1)-(4) need to be prepared before the analyses as follows:
  - ../../analysis/DEG/
  - ../../analysis/EGAD00001004799/
  - ../../analysis/ESTIMATE/
  - ../../analysis/GeneSetAnalysis/
  - ../../analysis/tSNE/
  - ../../analysis/TumorPurity/
  - ../../analysis/Upstream/

# Procedures to prepare the files (1)-(4)
1. Download Supplementary files available at [a GEO repository with accession number "GSE159702"](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702 "GSE159702") 
   - GSE159702_Expression_matrix_CountEstimates_human.tsv.gz
   - GSE159702_Expression_matrix_CountEstimates_mouse.tsv.gz
   - GSE159702_Expression_matrix_TPM_human.tsv.gz
   - GSE159702_Expression_matrix_TPM_mouse.tsv.gz
2. run a shell command;
```sh
unzip_rename.sh
```

# Optinal procedures to obtain gene-level expression data files (1)-(4)
1. Download 70 transcript-level expressione data "ExpID-[01-70].sf" to the sub-direcotory "./sf/".
   - Available at [the GEO repository](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702 "GSE159702")
   - These are transcript-level count-estimates/abundance data computed by Salmon software. Please see "./sf/README.md" for the details.   
2. Start R in the current directory, then run a command;
```R
source("./tximport.R")
```

# Nomenclature keys of file names
- *Expression_matrix*; Gene-level expression data summarized from transcript-level by tximport.R (See below) 
- *CountEstimates*; Transcript length-scaled count-estimates computed by Salmon (See "./sf/README.md" for the details)
- *TPM*; Transcript Per Million (TPM) values computed by Salmon (See "./sf/README.md" for the details) 
- *human*; GENCODE, release 27, GRCh38.p10
- *mouse*; GENCODE, release M15, GRCm38.p5

# R environment and packages
```R
R>
sessionInfo()
R version 4.0.0 (2020-04-24)
Platform: x86_64-conda_cos6-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)
Matrix products: default
BLAS/LAPACK: ***/miniconda3/lib/libopenblasp-r0.3.8.so
locale:
 [1] LC_CTYPE=en_US.utf-8       LC_NUMERIC=C
 [3] LC_TIME=en_US.utf-8        LC_COLLATE=en_US.utf-8
 [5] LC_MONETARY=en_US.utf-8    LC_MESSAGES=en_US.utf-8
 [7] LC_PAPER=en_US.utf-8       LC_NAME=C
 [9] LC_ADDRESS=C               LC_TELEPHONE=C
[11] LC_MEASUREMENT=en_US.utf-8 LC_IDENTIFICATION=C
attached base packages: [1] stats     graphics  grDevices utils     datasets  methods   base
other attached packages: [1] tximport_1.16.1
loaded via a namespace (and not attached): [1] compiler_4.0.0
```