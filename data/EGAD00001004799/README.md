This is a directory to keep and process the external data of KIRC (Kideny clear cell renal carcinoma) xenografts. 

### Procedures to obtain gene-level expression data of external KIRC PDXs
(1) Download fastq files "EGAF..."  using pyega3 according to the EGA instruction
- EGAD00001004799
  - EGAF00002399466
  - EGAF00002399467
  - EGAF00002399468
  - EGAF00002399469
  - EGAF00002399470
  - EGAF00002399471
  - EGAF00002399472
  - EGAF00002399473
  - EGAF00002399474
  - EGAF00002399475
  - EGAF00002399476
  - EGAF00002399477
  - EGAF00002399478
  - EGAF00002399479
- They are publicly available (but controlled) at European Genome-Phenome Archive (EGA) with accession number "EGAD00001004799"; https://ega-archive.org/datasets/EGAD00001004799
- Please refer to "filelist_TG_EGAD00001004799.tsv" for the file annotation 
- Reference; HIF-2 Complex Dissociation, Target Inhibition, and Acquired Resistance with PT2385, a First-in-Class HIF-2 Inhibitor, in Patients with Clear Cell Renal Cell Carcinoma. Courtney KD, Ma Y, Diaz de Leon A, Christie A, Xie Z, Woolford L, Singla N, Joyce A, Hill H, Madhuranthakam AJ, Yuan Q, Xi Y, Zhang Y, Chang J, Fatunde O, Arriaga Y, Frankel AE, Kalva S, Zhang S, McKenzie T, Reig Torras O, Figlin RA, Rini BI, McKay RM, Kapur P, Wang T, Pedrosa I, Brugarolas J. Clin Cancer Res 26:2020 793-803

(2) Make reference Salmon-index of allo-species
- $ sh ./salmon_idx.sh

(3) Quantify counts
- $ sh ./salmon_quant.sh 

(4) Transcript-level to Gene-level
- R> source("./tximport.R")

### Output data 
(1) gene.exp.hg.EGAD00001004799.rda (human reads)
- R data that contain a list of
  - abundance matrix
  - counts matrix

(2) gene.exp.mm.EGAD00001004799.rda (mouse reads)
- R data that contain a list of
  - abundance matrix
  - counts matrix

---------------------------------------
### version 
---------------------------------------
### $ salmon -v
version : 0.8.1

### $ pyega3
pyEGA3 - EGA python client version 3.4.1 (https://github.com/EGA-archive/ega-download-client)
Parts of this software are derived from pyEGA (https://github.com/blachlylab/pyega) by James Blachly
Python version : 3.6.10
OS version : Linux #1 SMP Fri Oct 20 20:32:50 UTC 2017
Server URL: https://ega.ebi.ac.uk:8052/elixir/data
Session-Id: 85898709

### R> sessionInfo()
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
[1] tximport_1.16.1
loaded via a namespace (and not attached):
[1] compiler_4.0.0
---------------------------------------
