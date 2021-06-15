# Reference

# Feature
Refenrence sequence and transcript annotation files need to be located in this directory.

# Files expected to be placed in this repository
1. gencode.v27.annotation.gtf.gz
2. gencode.v27.transcripts.fa.gz
3. gencode.vM15.annotation.gtf.gz
4. gencode.vM15.transcripts.fa.gz

# Procedure to obtain the files (1)-(4)
1. Download GENCODE annotation (gtf) and sequence (Fasta;fa) data
- [Human; GENCODE release 27 (GRCh38.p10)](https://www.gencodegenes.org/human/release_27.html)
  - [gencode.v27.annotation.gtf.gz](http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.annotation.gtf.gz)
  - [gencode.v27.transcripts.fa.gz](http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_27/gencode.v27.transcripts.fa.gz)
- [Mouse; GENCODE release M15 (GRCm38.p5)](https://www.gencodegenes.org/mouse/release_M15.html)
  - [gencode.vM15.annotation.gtf.gz](http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M15/gencode.vM15.annotation.gtf.gz)
  - [gencode.vM15.transcripts.fa.gz](http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M15/gencode.vM15.transcripts.fa.gz)

# Dependency
The files (1)-(4) are required to...
- Make salmon index files 
  - ../PDX/sf/salmon_idx.sh
  - ../EGAD00001004799/salmon_idx.sh
- convert ENSEMBL_Gene_ID - GeneSymbol
  - ../ref/dct_gencodeV27.py