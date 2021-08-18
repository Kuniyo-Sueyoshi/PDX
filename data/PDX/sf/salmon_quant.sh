#!/bin/zsh
# Environment; zsh 5.0.2 (x86_64-redhat-linux-gnu)
# Reference:
# Patro, R., Duggal, G., Love, M.I., Irizarry, R.A., and Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nat. Methods 14, 417–419.
# idx.xeno.salmon: the output of the preceding script "salmon_idx.sh"

### quant
dirs=`find /DIRECTORY_TO_PDX_SEQDATA/ -type d`
for dir in $dirs
do
    outdir="./SET_DIRECTORY_NAME_FOR_OUTPUT"
    files_R1=`find ${dir} -type f -name "*R1*fastq.gz"
    files_R2=`find ${dir} -type f -name "*R2*fastq.gz" 
    ### Execution of expression quantification 
    salmon quant -i idx.xeno.salmon -l A -1 $files_R1 -2 $files_R2 -o ${outdir}
    cp ${outdir}/quant.sf ./
done
