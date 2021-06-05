This is a directory to keep the tumor purity data of TCGA samples. 

### Procedures to obtain data
(1) Download a ABSOLUTE purity/ploidy file that is publicly available at
- https://gdc.cancer.gov/about-data/publications/pancanatlas
  - TCGA_mastercalls.abs_tables_JSedit.fixed.txt
    - $ wget http://api.gdc.cancer.gov/data/4f277128-f793-4354-a13d-30cc7fe9f6b5
   
(2) Download lists of TCGA-Barcodes for running analysis: annotation file
- http://gdac.broadinstitute.org/runs/stddata__latest/samples_report/
  - samplelist_CNVrun_BRCA.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/BRCA/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_GBM.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/GBM/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_LUAD.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/LUAD/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_LUSC.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/LUSC/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_PAAD.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/PAAD/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_STAD.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/STAD/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_COAD.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/COAD/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_KIRC.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/KIRC/CopyNumber_Gistic2/arraylistfile.txt
  - samplelist_CNVrun_SARC.txt
    - http://gdac.broadinstitute.org/runs/analyses__latest/reports/cancer/SARC/CopyNumber_Gistic2/arraylistfile.txt
     
Reference; Aran, D., Sirota, M., and Butte, A.J. (2015). Systematic pan-cancer analysis of tumour purity. Nat. Commun. 6, 1–12.

