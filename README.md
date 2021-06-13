# Expression analysis of PDXs 
The current repository includes codes used in the study entitled "Systematic analysis of the cancer-stroma interactome of a diverse collection of patient-derived xenografts unveils the unique homeostasis of renal cell carcinoma".

# Contents
1. analysis/ (Main analyses and scripts)
   - DEG/
   - EGAD00001004799/
   - ESTIMATE/
   - GeneSetAnalysis/
   - tSNE/
   - TumorPurity/
   - Upstream/
2. data/ (Expression data, external data, etc. to execute analyses)
   - PDX/
   - ref/
   - CCLE/  
   - EGAD00001004799/
   - GTEx/
   - homologene/
   - TCGA/
4. suppl_tables/ (Supplementary tables provided in the study, Input/Output tables in the analyses)
   - TableS1_samplelist.tsv
   - TableS2.1_GSVAscore_hg.tsv
   - TableS2.2_GSVAscore_mm.tsv
   - TableS3_cell_marker.tsv
   - TableS4_DEG_KIRCvsOthers_Stroma.tsv
   - TableS6_DEG_KIRCvsOthers_Cancer.tsv
   - TableS5_IPA_Regulators_KIRC_Stroma.txt

# Tested environment
```sh
$ cat /etc/redhat-release
$ CentOS Linux release 7.4.1708 (Core)

$ zsh --version
$ zsh 5.0.2 (x86_64-redhat-linux-gnu)

$ python -VV
$ Python 3.6.10 | packaged by conda-forge | (default, Mar  5 2020, 10:05:08) [GCC 7.3.0]
```
```R
R> sessionInfo()
R version 4.0.0 (2020-04-24)
Platform: x86_64-conda_cos6-linux-gnu (64-bit)
Running under: CentOS Linux 7 (Core)
```

# Usage example
```sh
git clone https://github.com/Kuniyo-Sueyoshi/PDX.git
cd ./analysis/DEG
```
```R
source("./DEG.r")
```
Please see sub-repository/README.md for the details.

# Author
* Kuniyo Sueyoshi
* Department of Preventive Medicine, Graduate School of Medicine, The University of Tokyo, Tokyo 113-8654, Japan
* 103011ms@gmail.com

# License
Please site the artile; (Hopefully coming soon...).