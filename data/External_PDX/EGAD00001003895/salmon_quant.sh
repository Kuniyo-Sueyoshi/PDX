#!/bin/zsh
# Environment; zsh 5.0.2 (x86_64-redhat-linux-gnu)
# Reference:
# Patro, R., Duggal, G., Love, M.I., Irizarry, R.A., and Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nat. Methods 14, 417–419.
# idx.allo.salmon: the output of the preceding script "salmon_idx.sh"

### quant
dirs=`find ./fastq/ -type d | grep "EGAF"` 

for dir in $dirs
do
    outdir=${dir/fastq/sf} 
    echo $outdir
#    mkdir $outdir
    files_R1=`find ${dir} -type f -name "*1.fastq"`
    files_R2=`find ${dir} -type f -name "*2.fastq"`
    ### Execution of expression quantification 
    salmon quant -i ../../PDX/sf/idx.allo.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}
done
