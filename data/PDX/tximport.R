# Salmon-quantified transcript-level expression data -> gene-level TPM expression data
# R version 4.0.0 (2020-04-24)
# Reference
# Soneson, C., Love, M.I., and Robinson, M.D. (2016). Differential analyses for RNA-seq: transcript-level estimates improve gene-level inferences. F1000Research 4, 1521.

if(!require("tximport")){
  install.packages("tximport")
}
library(tximport)

# Each transcript-level counts/abundance data "ExpID-[01-70].sf" computed by Salmon is available at GEO repository with accession number "GSE159702"
# Place those files at sub-directory "./sf/"
files <- list.files("./sf", "ExpID-[0-9]*.sf", full.names=T)
tx.exp <- tximport(files, type = "salmon", txOut = TRUE) # import data

# Label Sample name to Column
sm <- read.table("../../suppl_tables/TableS1_samplelist.tsv", sep = "\t", header=T) # ExpIDs in samplelist "sm" correspond to data-file names "ExpID-[01-70].sf" 
matcher <- sapply(sm$ExpID, function(x) grep(x, files))
label <- sm$sampleName[matcher]
colnames(tx.exp$abundance) <- label
colnames(tx.exp$length) <- label
colnames(tx.exp$counts) <- label

# Sprit allo-species data into tumor (hg) and stroma (mm) data 
# tx.exp[1]; abundance, tx.exp[2]; counts, tx.exp[3]; length
tx.exp.hg <- tx.exp
tx.exp.hg[1:3] <- lapply(tx.exp[1:3], function(x){return(x[grepl("ENST", rownames(x)), ])}) # human reads
tx.exp.mm <- tx.exp
tx.exp.mm[1:3] <- lapply(tx.exp[1:3], function(x){return(x[grepl("ENSMUS", rownames(x)), ])}) # mouse reads

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
	# Estimate gene-level counts/abundance only using transcripts coding protein (=~exon) (optional)
	logi <- grepl("protein_coding", tx2gene$Biotype)
	tx2gene <- tx2gene[logi, ]
	# Transcript to Gene 
	gene.exp <- summarizeToGene(tx.exp, tx2gene, countsFromAbundance = "lengthScaledTPM")
	return(gene.exp)
}

# Execution of Tx to Gene conversion
gene.exp.hg <- fn.tx2gene(tx.exp.hg)
gene.exp.mm <- fn.tx2gene(tx.exp.mm)


# retrieve result tables
# gene.exp$counts; counts estimated from lengthScaledTPM, that no longer correlate transcripts-length 
gene.exp.cnt.hg <- gene.exp.hg$counts
gene.exp.cnt.mm <- gene.exp.mm$counts
# gene.exp$abundance; TPM-like abundance (But library size is not 1e6 because of process of splitting hg/mm transcripts that were originally combined to one data. Note that each TPM-sum in "./sf/ExpID-[01-70].sf" files that includes hg & mm transcripts is 1e6.)
fn_libscale <-  function(x)sweep(x, 2, 1e6 / colSums(x), "*") # scale library-size to 1e6 
gene.exp.tpm.hg <- fn_libscale(gene.exp.hg$abundance)
gene.exp.tpm.mm <- fn_libscale(gene.exp.mm$abundance)


# output
d.out <- data.frame(GeneSymbol=rownames(gene.exp.cnt.hg), round(gene.exp.cnt.hg, digit=3))
write.table(d.out, "./Expression_matrix_CountEstimates_human.tsv", sep = "\t", col.names=TRUE, row.names = FALSE, quote = F)
d.out <- data.frame(GeneSymbol=rownames(gene.exp.cnt.mm), round(gene.exp.cnt.mm, digit=3))
write.table(d.out, "./Expression_matrix_CountEstimates_mouse.tsv", sep = "\t", col.names=TRUE, row.names = FALSE, quote = F)
d.out <- data.frame(GeneSymbol=rownames(gene.exp.tpm.hg), round(gene.exp.tpm.hg, digit=3))
write.table(d.out, "./Expression_matrix_TPM_human.tsv", sep = "\t", col.names=TRUE, row.names = FALSE, quote = F)
d.out <- data.frame(GeneSymbol=rownames(gene.exp.tpm.mm), round(gene.exp.tpm.mm, digit=3))
write.table(d.out, "./Expression_matrix_TPM_mouse.tsv", sep = "\t", col.names=TRUE, row.names = FALSE, quote = F)
