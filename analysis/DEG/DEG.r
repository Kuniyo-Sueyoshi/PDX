# Package requirement
mypkgs <- c("tidyverse", "edgeR", "RColorBrewer", "limma")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))

# Function to annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R")

# Load expression data of Cancer (hg) / Stroma (mm) component of PDXs 
d.hg <-read_tsv("../../data/PDX/Expression_matrix_CountEstimates_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.mm <- read_tsv("../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv") %>% column_to_rownames("GeneSymbol")

type9 <- c('PAAD','KIRC','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, types = type9)
d.hg <- ls$d.hg # Count-estimates of Cancer
d.mm <- ls$d.mm # Count-estimates of Cancer
primary <- ls$primary # Primary tumor types of PDX samples
ann_colors <- ls$ann_colors # color annotation of PDX tumor types 
NXIDs <- ls$NXIDs # Unique tumor specimen IDs (=~ Patient IDs)

# sample Summary
num.primary <- summary(primary)
num.pass <- tapply(NXIDs, primary, function(x)sum(summary(unique(x))))
labels <- paste(names(num.primary), " ", num.primary, " (", num.pass, ")", sep = "")
pie(num.primary, labels = labels, main = paste("Samples", sum(num.primary)), col = ann_colors)

# lineaer modeling design
design <- model.matrix(~ 0 + primary); colnames(design) <- levels(primary)

# contrast matrix for comparison
cont.mat <- makeContrasts(
    KIRCvsOthers = KIRC - 1/8*(COAD+NSCLC+PAAD+STAD+BRCA+EWS+GBM+GIST),
              levels=design)
print("contrast matrix")
cont.mat

### DEG analysis of Cancer component ###
y.hg0 <- DGEList(d.hg)
# Filtering low expressed genes
y.hg0 <- calcNormFactors(y.hg0)
drop <- which(apply(cpm(y.hg0), 1, max) < 1) # Genes with TMM-normalized CPM < 1
y.hg <- y.hg0[-drop, ] # Values in the data "y.hg" are Count-estimates. NOT TMM-normalized CPM or TPM. 
print("Original counts"); dim(y.hg0)
print("Filtered counts"); dim(y.hg)
# mean-variance stabilization
v <- voom(y.hg, design, plot = T) # voom takes counts 
# passages => techinical duplicates
# intra-specimen (of the same NXID) correlation is incorporated into the covariance matrix
corfit <- duplicateCorrelation(v, design, block = NXIDs)
fit.hg <- lmFit(v, design, block=NXIDs, correlation=corfit$consensus)   ### model fitting
fit2.hg <- contrasts.fit(fit.hg, cont.mat)     # model fitting
fit2.hg <- eBayes(fit2.hg)    # empirical Bayes
test <- colnames(cont.mat) # test: KIRC vs the remaining types
print(test)
deg.hg -> topTable(fit2.hg, adjust="fdr", number=Inf, sort.by = "P") %>% rownames_to_column("Gene") # Result of DEG analysis 
write.table(deg.hg, paste("../../suppl_tables/TableS6_DEG_", test, "_Cancer.tsv", sep=""), row.names = F, quote = F, sep = "\t")

### DEG analysis of Stroma component ###
y.mm0 <- DGEList(d.mm)
# Filtering low expressed genes
y.mm0 <- calcNormFactors(y.mm0)
drop <- which(apply(cpm(y.mm0), 1, max) < 1)  # Genes with TMM-normalized CPM < 1
y.mm <- y.mm0[-drop, ] # Values in this data are Count-estimates. NOT CPM or TPM. 
print("Original counts"); dim(y.mm0)
print("Filtered counts"); dim(y.mm)
# mean-variance stabilization
v <- voom(y.mm, design, plot = T) # voom takes counts 
# passages => techinical duplicates
# intra-specimen (of the same NXID) correlation is incorporated into the covariance matrix
corfit <- duplicateCorrelation(v, design, block = NXIDs)
fit.mm <- lmFit(v, design, block=NXIDs, correlation=corfit$consensus)   ### model fitting
fit2.mm <- contrasts.fit(fit.mm, cont.mat)     # model fitting
fit2.mm <- eBayes(fit2.mm)    # empirical Bayes
test <- colnames(cont.mat) # test: KIRC vs the remaining types
print(test)
deg.mm -> topTable(fit2.mm, adjust="fdr", number=Inf, sort.by = "P") %>% rownames_to_column("Gene") # Result of DEG analysis 
write.table(deg.mm, paste("../../suppl_tables/TableS4_DEG_", test, "_Stroma.tsv", sep=""), row.names = F, quote=F, sep = "\t")