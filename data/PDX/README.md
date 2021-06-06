This is a directory to keep expression data of PDX human/mouse reads and homologue data.

### PDX expression data 
Gene-level expression data of 70 PDX samples are deposited in this directory. Main analyses in the directory "../../analysis/" are executable with files (1)-(4). 
- Expression_matrix_CountEstimates_human.tsv - (1)
- Expression_matrix_CountEstimates_mouse.tsv - (2)
- Expression_matrix_TPM_human.tsv - (3)
- Expression_matrix_TPM_mouse.tsv - (4)

Files (1) and (2) are also available at a GEO repository; https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702 as 
- GSE159702_Expression_matrix_CountEstimates_human.tsv.gz - (1')
- GSE159702_Expression_matrix_CountEstimates_mouse.tsv.gz  (2')

Nomenclature keys of file names
- Expression_matrix; Gene-level expression data summarized from transcript-level by tximport.R (See below) 
- CountEstimates; Transcript length-scaled count-estimates computed by Salmon (See "./sf/README.md" for the details)
- TPM; Transcript Per Million (TPM) values computed by Salmon (See "./sf/README.md" for the details) 
- human; GENCODE, release 27, GRCh38.p10
- mouse; GENCODE, release M15, GRCm38.p5

Optionally, users can retrive gene-level, human/mouse-allotted expression data (1)-(4) from transcript-level data of xenografts.
- Download 70 transcript-level count-estimates/abundance data "ExpID-[01-70].sf" to the sub-direcotory "./sf/".
 - Available at GEO repository with accession number "GSE159702"; https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702
 - Count-estimates/abundance data computed by Salmon software. Please see "./sf/README.md" for the details.   
- Start R in the current directory, then press a command 'source("./tximport.R")' 

### Homologue
(1) Homologue data is available at HomoloGene site
- https://ftp.ncbi.nih.gov/pub/HomoloGene/build68/
  - homologene.data
  - Reference; NCBI Resource Coordinators, N.R. (2016). Database resources of the National Center for Biotechnology Information. Nucleic Acids Res. 44, D7-19.

(2) Creat a correspondence table of human gene symbols and mouse gene symbols
```sh
python Homolog_geneV2.py homologene.data
```

(3) output data;
- homologene.data_geneV2.tsv

### R requirement
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