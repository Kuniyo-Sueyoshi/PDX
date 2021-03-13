#!/bin/zsh
# Environment; zsh 5.0.2 (x86_64-redhat-linux-gnu)
# Reference:
# Patro, R., Duggal, G., Love, M.I., Irizarry, R.A., and Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nat. Methods 14, 417–419.
# idx.allo.salmon: the output of the preceding script "salmon_idx.sh"

### quant
#files=`find . -type f -name "*fastq.gz$"`

outdir="./RNA_XP165M_TGc7a"
files_R1="./EGAF00002399466/1620R-17-01_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399467/1620R-17-01_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc4a"
files_R1="./EGAF00002399468/1620R-17-02_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399469/1620R-17-02_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc4b"
files_R1="./EGAF00002399470/1620R-17-03_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399471/1620R-17-03_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc4c"
files_R1="./EGAF00002399472/1620R-17-04_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399473/1620R-17-04_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc7b"
files_R1="./EGAF00002399474/1620R-17-05_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399475/1620R-17-05_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc8a"
files_R1="./EGAF00002399476/1620R-17-07_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399477/1620R-17-07_S1_L006_R2_001.fastq.gz"
salmon quant -i ../../data/PDX/sf/idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}

outdir="./RNA_XP165M_TGc8b"
files_R1="./EGAF00002399478/1620R-17-08_S1_L006_R1_001.fastq.gz"
files_R2="./EGAF00002399479/1620R-17-08_S1_L006_R2_001.fastq.gz"
salmon quant -i ./idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}
