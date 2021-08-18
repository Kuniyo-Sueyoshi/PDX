# Salmon-quantified transcript-level expression data -> gene-level TPM expression data
# R version 4.0.0 (2020-04-24)
# Reference
# Soneson, C., Love, M.I., and Robinson, M.D. (2016). Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences. F1000Research 4, 1521.

if(!require("tximport")){
  install.packages("tximport")
}
library(tximport)
library(tidyverse)

files <- list.files(".", recursive=T, pattern="quant.sf")
# Sample name = directory name
sm <-str_split(files, pattern="/")
sm <- sapply(sm, function(x) x[[1]])
names(files) <- sm

# read files
tx.exp <- tximport(files, type = "salmon", txOut = TRUE)

# Sprit xeno-species data into tumor (hg) and stroma (mm) data 
# tx.exp[1]; abundance, tx.exp[2]; counts, tx.exp[3]; length
tx.exp.hg <- tx.exp
tx.exp.hg[1:3] <- lapply(tx.exp.hg[1:3], function(x){return(x[grepl("ENST", rownames(x)), ])})
tx.exp.mm <- tx.exp
tx.exp.mm[1:3] <- lapply(tx.exp.mm[1:3], function(x){return(x[grepl("ENSMUST", rownames(x)), ])})

# Tx2gene #
# Retrieve Transcript annotations (TxAnno), GeneID, and Biotype from GENCODE whole transcriptome
# The rownames(tx.exp$counts) corresponds the annotation of the whole transcriptome of human (GENCODE, release 27, GRCh38.p10) or mouse (GENCODE, release M15, GRCm38.p5) 
# function to summarize transcript-level counts/abandance to gene-level counts/abundance
fn.tx2gene <- function(tx.exp){
	   # Annotation; Transcript - gene
	   TxAnno <- rownames(tx.exp$counts)
	   tx2gene <- data.frame(TXNAME=TxAnno, 
				GENEID=sapply(strsplit(TxAnno,"\\|"),'[',6), 
                  		Biotype=sapply(strsplit(TxAnno,"\\|"),'[',8))
	# Estimate gene-level counts/abundance only using transcripts coding protein (=~exon)
	logi <- grepl("protein_coding", tx2gene$Biotype)
	tx2gene <- tx2gene[logi, ]
	# Transcript to Gene 
	gene.exp <- summarizeToGene(tx.exp, tx2gene, countsFromAbundance = "lengthScaledTPM")
	return(gene.exp)
}

# Execution of Tx to Gene conversion
gene.exp.hg.EGAD00001004799 <- fn.tx2gene(tx.exp.hg)
gene.exp.mm.EGAD00001004799 <- fn.tx2gene(tx.exp.mm)

# Save the fields "list$abundance" and "list$counts" but discard the fields "list$length" and "list$countfromabundance" to reduce data size
gene.exp.hg.EGAD00001004799 <- gene.exp.hg.EGAD00001004799[1:2]
gene.exp.mm.EGAD00001004799 <- gene.exp.mm.EGAD00001004799[1:2]

# gene.exp$abundance # TPM-like abundance (But library size is not 1e6 because of process of splitting hg/mm transcripts that were originally one. Note that each TPM-sum in "./sf/ExpID-[01-70].sf" files that includes hg & mm transcripts is 1e6.)
fn_libscale <-  function(x)sweep(x, 2, 1e6 / colSums(x), "*") # scale library-size to 1e6 
gene.exp.hg.EGAD00001004799$abundance <- fn_libscale(gene.exp.hg.EGAD00001004799$abundance)
gene.exp.mm.EGAD00001004799$abundance <- fn_libscale(gene.exp.mm.EGAD00001004799$abundance)

save(gene.exp.hg.EGAD00001004799, file = "gene.exp.hg.EGAD00001004799.rda")
save(gene.exp.mm.EGAD00001004799, file = "gene.exp.mm.EGAD00001004799.rda")


