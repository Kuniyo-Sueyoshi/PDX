# Repository of transcript-level expression data

# Feature
This is a directory to keep transcript-level count-estimates/abundance data computed by Salmon software.
> (Reference) Rob Patro, Geet Duggal, Michael I. Love, Rafael A. Irizarry, Carl Kingsford (2017).
Salmon provides fast and bias-aware quantification of transcript expression.
Nature Methods. Advanced Online Publication. doi: 10.1038/nmeth.4197

# Files expected to be prepared in this directory
- ExpID-01.sf
- ExpID-02.sf
- ...
- ExpID-70.sf
They are available at [GEO repository with accession number "GSE159702"](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702 "GSE159702")

# Dependency
The 70 files need to be prepared in case users intend to yeild gene-level expresison data (e.g. ../Expression_matrix_CountEstimates_human.tsv) by runnig
```R
../tximport.r
```

# Comment
Unfortunately, we cannot provide raw sequencing data (in fastq or BAM formats) due to the restriction of our Institutional Review Board and Ethic Committee because of patient privacy concerns.
Instead, codes to obtain the transcript abundance data "ExpID-[01-70].sf" from fastq files are shown in the current repository.
```sh
sh salmon_idx.sh
sh salmon_quant.sh 
```



