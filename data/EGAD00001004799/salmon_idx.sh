#!/bin/zsh
# Environment; zsh 5.0.2 (x86_64-redhat-linux-gnu)
# Reference:
# Patro, R., Duggal, G., Love, M.I., Irizarry, R.A., and Kingsford, C. (2017). Salmon provides fast and bias-aware quantification of transcript expression. Nat. Methods 14, 417–419.
# gencode.v27.transcripts.fa.gz: the human whole transcriptome (GENCODE, release 27, GRCh38.p10)
# gencode.vM15.transcripts.fa.gz: the mouse whole transcriptome (GENCODE, release M15, GRCm38.p5) 

### ref-index
zcat ../ref/gencode.v27.transcripts.fa.gz\
     ../ref/gencode.vM15.transcripts.fa.gz >\
     allo.fa
salmon index -t allo.fa -i idx.allo.salmon --type quasi -k 31

