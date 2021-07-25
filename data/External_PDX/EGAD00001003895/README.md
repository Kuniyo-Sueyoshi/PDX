# External data of KIRC (EGAD00001003895)

# Feature
This is a directory to keep and process the external data (EGAD00001003895) of KIRC (Kideny clear cell renal carcinoma) xenografts. 
> Reference; Wang T, Lu R, Kapur P, Jaiswal BS, Hannan R, Zhang Z, Pedrosa I, Luke JJ, Zhang H, Goldstein LD, Yousuf Q, Gu YF, McKenzie T, Joyce A, Kim MS, Wang X, Luo D, Onabolu O, Stevens C, Xie Z, Chen M, Filatenkov A, Torrealba J, Luo X, Guo W, He J, Stawiski E, Modrusan Z, Durinck S, Seshagiri S, Brugarolas J. An Empirical Approach Leveraging Tumorgrafts to Dissect the Tumor Microenvironment in Renal Cell Carcinoma Identifies Missing Link to Prognostic Inflammatory Factors. Cancer Discov. 2018 Sep;8(9):1142-1155. doi: 10.1158/2159-8290.CD-17-1246. Epub 2018 Jun 8. PMID: 29884728; PMCID: PMC6125163.

# Data expected to be prepared in this repository
1. gene.exp.hg.EGAD00001003895.rda
   - R data of human reads that contain a list of
     - abundance matrix
     - counts matrix
2. gene.exp.mm.EGAD00001003895.rda
- R data of mouse reads that contain a list of
  - abundance matrix
  - counts matrix

# Procedures to obtain the data (1),(2)
1. Download bam files "EGAF..."  using pyega3 according to the EGA instruction. They are publicly available (but controlled) at [European Genome-Phenome Archive (EGA) with accession number "EGAD00001003895"](https://ega-archive.org/datasets/EGAD00001003895 "EGAD00001003895"). EGA files listed below contain all the data of clear cell renal cell carcinoma PDX data that were available at EGAD00001003895 and convertable from bam to fastq later.   
- EGAD00001003895
  - bam/EGAF00001808513
  - bam/EGAF00001808516
  - bam/EGAF00001808522
  - bam/EGAF00001808525
  - bam/EGAF00001808528
  - bam/EGAF00001808531
  - bam/EGAF00001808534
  - bam/EGAF00001808537
  - bam/EGAF00001808546
  - bam/EGAF00001808549
  - bam/EGAF00001808552
  - bam/EGAF00001808561
  - bam/EGAF00001808564
  - bam/EGAF00001808570

2. Convert bam to fastq
```sh
# Example
perl bam2fastq.pl ./bam/EGAF00001808513/SAM19944478_36813.filtered.bam ./fastq/EGAF00001808513 20
```
Dr. Tao Wang kindly offered to share the script "bam2fastq.pl" with us.

3. Quantify counts by salmon
```sh
sh ./salmon_quant.sh
# Internally import allo-species index ../../PDX/sf/idx.allo.salmon
```

4. Transcript-level to Gene-level
```R
source("./tximport.R")
```

## Additinal environments tested
> sambamba 0.6.8 by Artem Tarasov and Pjotr Prins (C) 2012-2018  
LDC 1.11.0 / DMD v2.081.2 / LLVM6.0.1 / bootstrap LDC - the LLVM D compiler (0.17.6git-0156298)

> samtools (Tools for alignments in the SAM format)  
Version: 1.9 (using htslib 1.9)