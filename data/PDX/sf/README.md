This is a directory to keep 70 transcript-level count-estimates/abundance data "ExpID-[01-70].sf"
- They are available at GEO repository with accession number "GSE159702"; https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE159702
- They are count-estimates/abundance data computed by Salmon software.
- Reference
Rob Patro, Geet Duggal, Michael I. Love, Rafael A. Irizarry, Carl Kingsford (2017).
Salmon provides fast and bias-aware quantification of transcript expression.
Nature Methods. Advanced Online Publication. doi: 10.1038/nmeth.4197

Unfortunately, we cannot provide raw sequencing data (in fastq or BAM formats) due to the restriction of our Institutional Review Board and Ethic Committee because of patient privacy concerns.
Instead, codes to obtain the transcript abundance data "ExpID-[01-70].sf" from fastq files are shown in the current repository.
$ sh salmon_idx.sh
$ sh salmon_quant.sh 


### version
---------------------------------------
$ cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core)

$ zsh --version
zsh 5.0.2 (x86_64-redhat-linux-gnu)

$ salmon -v
version : 0.8.1



