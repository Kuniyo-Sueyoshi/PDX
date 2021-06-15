# GTEx expression data

# Feature
This is a directory to prepare the GTEx (Genotype-Tissue Expression) Kidney data. 
> Reference; GTEx Analysis V8 (dbGaP Accession phs000424.v8.p2)

# Files expected to be placed in this repository
1. matTPM_GTEx_Kidney.tsv
   - Gene-level expression data in TPM value of cancer-free kidney tissue 

# Procedures to obtain the file (1)
1. Download a *Gene TPMs* expression data and a *sample annotation* file of *GTEx Analysis V8* from [GTEx data portal](https://www.gtexportal.org/home/datasets "GTEx expression data")
   - [GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct.gz](https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct.gz)
   - [GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt](https://storage.googleapis.com/gtex_analysis_v8/annotations/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt)

2. Extract tissue types of interest ("Kideny")
```sh
python ./extrTiss.py
```



