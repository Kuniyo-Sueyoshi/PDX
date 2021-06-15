# Homologue (human & mouse)

# Feature
This is a directory to keep homologue data.
> Reference; NCBI Resource Coordinators, N.R. (2016). Database resources of the National Center for Biotechnology Information. Nucleic Acids Res. 44, D7-19.

# Files expected to be placed in this repository
1. homologene.data_geneV2.tsv

# Procedures to yield the expected files
Data download details
1. Download Homologue data from [HomoloGene site](https://ftp.ncbi.nih.gov/pub/HomoloGene/build68/ "homologene")
  - [homologene.data](https://ftp.ncbi.nih.gov/pub/HomoloGene/build68/homologene.data)

2. Creat a correspondence table of human gene symbols and mouse gene symbols 
```sh
python  Homolog_geneV2.py homologene.data
```
