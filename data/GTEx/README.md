This is a directory to prepare the GTEx Kidney data. 

###########################################################################
### Procedures to obtain gene-TPM data of disease-free tissue GTEx V8
##########################################################################
(1) Download a expression data file and a sample annotation file that are publicly available at Genotype-Tissue Expression (GTEx) data portal;
- https://www.gtexportal.org/home/datasets
  |- GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct.gz
     - wget https://storage.googleapis.com/gtex_analysis_v8/rna_seq_data/GTEx_Analysis_2017-06-05_v8_RNASeQCv1.1.9_gene_tpm.gct.gz
  |- GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt
     - wget https://storage.googleapis.com/gtex_analysis_v8/annotations/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt
# Reference; GTEx Analysis V8 (dbGaP Accession phs000424.v8.p2)

(2) Extract tissue types of interest ("Kideny")
$ python ./extrTiss.py

#################
### Output data 
#################
(1) matTPM_GTEx_Kidney.tsv

