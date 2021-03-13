# Package requirement
mypkgs <- c("tidyverse", "edgeR", "RColorBrewer", "Rtsne", "GSVA", "cowplot", "ggsignif", "ggrepel")
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

# Re-order and annotate samples
type9 <- c('KIRC','PAAD','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, types = type9)
d.hg <- ls$d.hg # length-scaled Count-estimates of Cancer
d.mm <- ls$d.mm # length-scaled Count-estimates of Cancer
primary <- ls$primary # Primary tumor types of PDX samples
ann_colors <- ls$ann_colors # color annotation of PDX tumor types 
NXIDs <- ls$NXIDs # Unique tumor specimen IDs (=~ Patient IDs)

# Load External data of KIRC PDXs (EGAD00001004799)
load("../../data/EGAD00001004799/gene.exp.hg.EGAD00001004799.rda")
d.hg.ex <- gene.exp.hg.EGAD00001004799$counts # length-scaled Count-estimates of Cancer component
load("../../data/EGAD00001004799/gene.exp.mm.EGAD00001004799.rda")
d.mm.ex <- gene.exp.mm.EGAD00001004799$counts  # ength-scaled Count-estimates of Stroma component

# annotation
# hg
sm.ex <- data.frame(str_split(colnames(d.hg.ex), pattern = "_"))
pass.ex <- gsub("[a-c]$", "", gsub("TG", "", sm.ex[3,]))
NXIDs.ex <- gsub("^c[1-8]", "", gsub("TG", "", sm.ex[3,]))
colnames(d.hg.ex) <- paste("KIRC.Ex", NXIDs.ex, pass.ex, sep = "_")
# mm
colnames(d.mm.ex) <- paste("KIRC.Ex", NXIDs.ex, pass.ex, sep = "_")

# Merge Original PDX data and External PDX data (Cancer component)
data.frame(d.hg.ex) %>% rownames_to_column("Gene") -> d1
data.frame(d.hg) %>% rownames_to_column("Gene") -> d2
merge(d2, d1, by = "Gene") %>% column_to_rownames("Gene") -> d.hg.cmb

# Merge Original PDX data and External PDX data (Stroma component)
data.frame(d.mm.ex) %>% rownames_to_column("Gene") -> d1
data.frame(d.mm) %>% rownames_to_column("Gene") -> d2
merge(d2, d1, by = "Gene") %>% column_to_rownames("Gene") -> d.mm.cmb

# Sort and annotate combined data 
type10 <- c('KIRC','KIRC.Ex','PAAD','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg.cmb, d.mm.cmb, types = type10)
d.hg.cmb <- ls$d.hg
d.mm.cmb <- ls$d.mm
primary10 <- ls$primary
primary.cmb <- factor(gsub("KIRC.Ex", "KIRC", primary10), levels = type9)
NXIDs.cmb <- ls$NXIDs
ann_colors.cmb <- ls$ann_colors

# Lineaer modeling design of Original samples
design <- model.matrix(~ 0 + primary); colnames(design) <- levels(primary)
# contrast matrix for comparison
cont.mat <- makeContrasts(
    KIRC = KIRC - 1/8*(COAD+NSCLC+PAAD+STAD+BRCA+EWS+GBM+GIST),
    levels=design)
# Lineaer modeling design of Combined samples
design.cmb <- model.matrix(~ 0 + primary.cmb); colnames(design.cmb) <- levels(primary.cmb)

# Common theme for ggplot
theme_common <- 
        theme(plot.title=element_text(size=11),
              axis.title.x=element_text(size=9), axis.title.y=element_text(size=9),
              axis.text.x=element_text(size=8), axis.text.y=element_text(size=8),
              legend.title=element_text(size=7), legend.text=element_text(size=7), legend.key.size = unit(0.6, "line")) +
        theme(plot.margin = unit(c(3, 2, 3, 2), units = "mm"),
              legend.margin=margin(t=0, r=1, b=0, l=-3, unit="mm"))

#########################
#### tSNE of combined data ####
#########################
y.hg.cmb <- DGEList(d.hg.cmb)
# Filtering low expressed genes
y.hg.cmb <- calcNormFactors(y.hg.cmb)
drop <- which(apply(cpm(y.hg.cmb), 1, max) < 1)
y.hgl.cmb <- cpm(y.hg.cmb[-drop, ], log = TRUE) # log-CPM value
tsne <- Rtsne(t(as.matrix(y.hgl.cmb)), perplexity = 5) # Execution 
res.tsne <- data.frame(tSNE_1 = tsne$Y[,1], tSNE_2 = tsne$Y[,2], Type = primary10)
# Plot
g.sne.hg <- ggplot(res.tsne, aes(x=tSNE_1, y=tSNE_2, color = Type))+
    geom_point(size=.6) +
    scale_color_manual(values = ann_colors.cmb, name = "Type") + 
    ggtitle("tSNE, Cancer") + 
    theme_classic() +  
    theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) +
    theme_common
g.sne.hg

# Funtion to scale distribution of enrichment scores (70 sample-wise sd / total sd) 
my.scale <- function(df){
    df.sd <- sd(as.vector(df))
    return(t(apply(df, 1, function(row){
        row.sd <- sd(row)
        return((row)/row.sd * df.sd)
    })))
}
   
# Function for PDX-type wise average 
type.ave <- function(df, primary=primary){
  t(apply(df, 1, function(x){tapply(x, primary, mean)
                            }))  
} 

# Function to fit data to linear model and return statistics and q-values given a linear model and contrast-matrix
fn.qvec <- function(df, primary=primary, NXIDs=NXIDs, design = design){
    corfit <- duplicateCorrelation(df, design, block = NXIDs)
    fit <- lmFit(df, design, block=NXIDs, correlation=corfit$consensus)   ### model fitting
    fit2 <- contrasts.fit(fit, cont.mat)     # model fitting
    fit2 <- eBayes(fit2)    # empirical Bayes
    qvec <- p.adjust(fit2$p.value, method = "fdr")
    names(qvec) <- rownames(fit2)
    return(qvec)
}

###################
### Pathway analysis ###
###################

# gene-set list of hallmark pathways 
read_tsv("../GeneSetAnalysis/h.all.v6.2.symbols.gmt", col_names = F) %>% tibble::column_to_rownames("X1") -> t
t <- t[,-1] # remove URL column
rownames(t) <- gsub("HALLMARK_", "", rownames(t))

# remove pathways that seems irrelavant to tumor-microenvironment stroma
rm.words <- c('CHOLESTEROL_HOMEOSTASIS',
             'MYOGENESIS', 
             'UV_RESPONSE_UP', 'UV_RESPONSE_DN',
             'HEME_METABOLISM', 
             'BILE_ACID_METABOLISM', 
             'SPERMATOGENESIS',
             'PANCREAS_BETA_CELLS',
             'KRAS_SIGNALING_UP', 'KRAS_SIGNALING_DN')
t.rm <- t[!(rownames(t) %in% rm.words),]

pathways <- apply(t.rm, 1, function(x){ # data.frame to list
    names(x) <- NULL
    x <- sort(na.omit(x))
    return(list(x)[[1]])
})

# homolog genes table 
read_tsv("../../data/homologene/homologene.data_geneV2.tsv") -> geneV2
# Convert human gene symbol to mouse gene symbol 
pathways.mm <- lapply(pathways, function(x){ 
    y <- geneV2$Symbol.mm[(geneV2$Symbol.hg %in% x)]
    return(sort(y))
})

# Re-order pathways and To_small_letters
# "name_sm" should correspond to "names(q.ano.mm[logi.top10])", but the order is arbitrary.
paths <- c('IL6_JAK_STAT3_Signaling',
             'Allograft_Rejection',
             'Inflammatory_Response',
             'Interferon_gamma_Response',
             'Interferon_alpha_Response',
             'Complement',
             'E2F_Targets',
             'Epithelial_Mesenchymal_Transition',
             'Hypoxia',
             'Glycolysis')
# Function to sort selected pathways and change upper case letters
fn.sort.tolower <- function(df){
    PATHs <- toupper(paths) 
    df.s <- df[PATHs, ] # Pick up ANOVA-significant pathways and Re-order according to "PATHs"
    rownames(df.s) <- paths
    return(df.s)
}

###########################
### Pathway, Original KIRC PDXs ###
##########################
# GSVA scores, Cancer
d.f.GSVA.hg <- read_tsv("../../suppl_tables/TableS2.1_GSVAscore_hg.tsv") %>% 
                        column_to_rownames("Hallmark_pathways") %>% 
                        as.matrix()
# GSVA scores, Stroma
d.f.GSVA.mm <- read_tsv("../../suppl_tables/TableS2.2_GSVAscore_mm.tsv") %>% 
                        column_to_rownames("Hallmark_pathways") %>% 
                        as.matrix()
# Re-order and annotate samples
type9 <- c('KIRC','PAAD','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.f.GSVA.hg, d.f.GSVA.mm, types = type9)
d.f.GSVA.hg <- ls$d.hg
d.f.GSVA.mm <- ls$d.mm
primary <- ls$primary
NXIDs <- ls$NXIDs

# Re-shape GSVA scores of Cancer transcriptome 
es.hg.s <- fn.sort.tolower(d.f.GSVA.hg)
es.c <- type.ave(my.scale(es.hg.s), primary = primary) # mean ES
qvec <- fn.qvec(es.hg.s, primary, NXIDs, design) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("Pathway") -> es.hg.pdx 
es.hg.pdx$Pathway <- factor(es.hg.pdx$Pathway, levels = es.hg.pdx$Pathway) # Factorize 

# Re-shape GSVA scores of Stroma transcriptome 
es.mm.s <- fn.sort.tolower(d.f.GSVA.mm)
es.c <- type.ave(my.scale(es.mm.s), primary = primary) # mean ES
qvec <- fn.qvec(es.mm.s, primary, NXIDs, design) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("Pathway") -> es.mm.pdx 
es.mm.pdx$Pathway <- factor(es.mm.pdx$Pathway, levels = es.mm.pdx$Pathway) # Factorize 


#############################
### Pathway, Combined KIRC PDXs ###
############################
# GSVA scores, Cancer
y.hg.cmb <- DGEList(d.hg.cmb)
y.hgl.cmb <- cpm(y.hg.cmb, log = TRUE) # log-CPM
d.f.GSVA.hg <- gsva(y.hgl.cmb,  pathways)
# Re-shape GSVA scores 
es.hg.s <- fn.sort.tolower(d.f.GSVA.hg)
es.c <- type.ave(my.scale(es.hg.s), primary = primary.cmb) # mean ES
qvec <- fn.qvec(es.hg.s, primary.cmb, NXIDs.cmb, design.cmb) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("Pathway") -> es.hg.cmb
es.hg.cmb$Pathway <- factor(es.hg.cmb$Pathway, levels = es.hg.cmb$Pathway) # Factorize , keep order

# GSVA scores, Stroma
y.mm.cmb <- DGEList(d.mm.cmb)
y.mml.cmb <- cpm(y.mm.cmb, log = TRUE) # log-CPM
d.f.GSVA.mm <- gsva(y.mml.cmb,  pathways.mm)
# Re-shape GSVA scores
es.mm.s <- fn.sort.tolower(d.f.GSVA.mm)
es.c <- type.ave(my.scale(es.mm.s), primary = primary.cmb) # mean ES
qvec <- fn.qvec(es.mm.s, primary.cmb, NXIDs.cmb, design.cmb) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("Pathway") -> es.mm.cmb
es.mm.cmb$Pathway <- factor(es.mm.cmb$Pathway, levels = es.mm.cmb$Pathway) # Factorize , keep order

# Compare "Original" vs "Original + External" KIRC PDX 
# Cancer 
es.path.hg <- merge(x = es.hg.pdx, y = es.hg.cmb, by = "Pathway", sort = F) 
bool <- es.path.hg$qval.x<0.05 & es.path.hg$qval.y<0.05 # statistics
es.path.hg$Signif.Both <- factor(ifelse(bool, "q<0.05", "n.s"), levels=c("q<0.05", "n.s"))
# Stroma
es.path.mm <- merge(x = es.mm.pdx, y = es.mm.cmb, by = "Pathway", sort = F) 
bool <- es.path.mm$qval.x<0.05 & es.path.mm$qval.y<0.05
es.path.mm$Signif.Both <- factor(ifelse(bool, "q<0.05", "n.s"), levels=c("q<0.05", "n.s"))


# Plot, Cancer
g.path.hg <- ggplot(es.path.hg, aes(x = meanES.x, y = meanES.y, label = Pathway, color = Signif.Both)) + 
    geom_hline(yintercept = 0, color = "grey") + geom_vline(xintercept = 0, color = "grey") + 
    geom_rect(xmin=0, ymin=0, xmax=Inf, ymax=Inf, fill = "tomato", alpha = 0.01, color = NA) + 
    geom_rect(xmin=0, ymin=0, xmax=-Inf, ymax=-Inf, fill = "skyblue", alpha = 0.01, color = NA) + 
    geom_point(size=.8) + 
    geom_text_repel(size = 2) + 
    scale_color_manual(values = c("red", "grey2")) + 
    xlab("meanES, Original data") + ylab("meanES, Original+External data") +
    ggtitle("Pathway, KIRC Cancer") + 
    theme_minimal() +
    theme_common

# Plot, Stroma
g.path.mm <- ggplot(es.path.mm, aes(x = meanES.x, y = meanES.y, label = Pathway, color = Signif.Both)) + 
    geom_hline(yintercept = 0, color = "grey") + geom_vline(xintercept = 0, color = "grey") + 
    geom_rect(xmin=0, ymin=0, xmax=Inf, ymax=Inf, fill = "tomato", alpha = 0.01, color = NA) + 
    geom_rect(xmin=0, ymin=0, xmax=-Inf, ymax=-Inf, fill = "skyblue", alpha = 0.01, color = NA) + 
    geom_point(size=.8) + 
    geom_text_repel(size = 2) + 
    scale_color_manual(values = c("red", "grey2")) + 
    xlab("meanES, Original data") + ylab("meanES, Original+External data") +
    ggtitle("Pathway, KIRC Stroma") + 
    theme_minimal() +
    theme_common


###########################
### Cell-type signature Analysis ###
##########################
# Load cell types and cell signature genes 
readr::read_tsv("../../suppl_tables/TableS3_cell_marker.tsv") -> d.marker
# Convert mouse gene symbol to human gene symbol
d.marker <- merge(d.marker, geneV2, by.x = "Symbol", by.y = "Symbol.hg", all.x = TRUE) 
d.marker <- na.omit(d.marker)
# dataframe to list
Sets.CellType <- list()
CellType <- unique(d.marker$CellType)
for(i in 1:length(CellType)){
        Sets.CellType[[i]] <- d.marker$Symbol.mm[grep(CellType[i], d.marker$CellType)]
}
names(Sets.CellType) <- CellType

###############################
### Cell signature, Original KIRC PDXs ###
##############################
# Execute GSVA
y.mm <- DGEList(d.mm)
y.mml <- cpm(y.mm, log = TRUE) # log-CPM value of stroma 
d.f.GSVA.mm <- gsva(y.mml,  Sets.CellType)
es.c <- type.ave(my.scale(d.f.GSVA.mm), primary = primary) # mean ES
qvec <- fn.qvec(d.f.GSVA.mm, primary, NXIDs, design) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("CellType") -> es.mm.pdx 

################################
### Cell signature, Combined KIRC PDXs ###
################################
# GSVA scores, Cancer
y.mm.cmb <- DGEList(d.mm.cmb)
y.mml.cmb <- cpm(y.mm.cmb, log = TRUE) # log-CPM
d.f.GSVA.mm <- gsva(y.mml.cmb, Sets.CellType) # Executiton
# Re-shape  GSVA scores 
es.c <- type.ave(my.scale(d.f.GSVA.mm), primary = primary.cmb) # mean ES
qvec <- fn.qvec(d.f.GSVA.mm, primary.cmb, NXIDs.cmb, design.cmb) # Statistics
data.frame(meanES = es.c[ ,"KIRC"], qval = qvec) %>% rownames_to_column("CellType") -> es.mm.cmb 

# Compare "Original" vs "Original + External" KIRC PDX 
es.cell.m <- merge(x = es.mm.pdx, y = es.mm.cmb, by = "CellType", sort = F) 
bool <- es.cell.m$qval.x<0.05 & es.cell.m$qval.y<0.05 # statistics
es.cell.m$Signif.Both <- factor(ifelse(bool, "q<0.05", "n.s"), levels=c("q<0.05", "n.s"))
# Plot
g.cell.mm <- ggplot(es.cell.m, aes(x = meanES.x, y = meanES.y, label = CellType, color = Signif.Both)) + 
    geom_hline(yintercept = 0, color = "grey") + geom_vline(xintercept = 0, color = "grey") + 
    geom_rect(xmin=0, ymin=0, xmax=Inf, ymax=Inf, fill = "tomato", alpha = 0.01, color = NA) + 
    geom_rect(xmin=0, ymin=0, xmax=-Inf, ymax=-Inf, fill = "skyblue", alpha = 0.01, color = NA) + 
    geom_point(size=.8) + 
    geom_text_repel(size = 2) + 
    scale_color_manual(values = c("red", "grey2")) + 
    xlab("meanES, Original data") + ylab("meanES, Original+External data") +
    ggtitle("Cell signature, KIRC Stroma") + 
    theme_minimal() +
    theme_common

########################
### DEG, Original KIRC PDXs ###
#######################
read_tsv("../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv") -> deg.hg
read_tsv("../../suppl_tables/TableS4_DEG_KIRCvsOthers_Stroma.tsv") -> deg.mm

##########################
### DEG, Combined KIRC PDXs ###
#########################
### DEG analysis of Cancer component 
bool <- rownames(d.hg.cmb) %in% deg.hg$Gene # Genes on DEG-analysis in original PDX data
y.hg.cmb <- DGEList(d.hg.cmb[bool, ])
print("Original counts"); dim(d.hg.cmb)
print("Filtered counts"); dim(y.hg.cmb)
# mean-variance stabilization
v <- voom(y.hg.cmb, design.cmb, plot = T) # voom takes counts 
# passages => techinical duplicates
# intra-specimen (of the same NXID) correlation is incorporated into the covariance matrix
corfit <- duplicateCorrelation(v, design.cmb, block = NXIDs.cmb)
fit.hg <- lmFit(v, design.cmb, block=NXIDs.cmb, correlation=corfit$consensus)   ### model fitting
# Cancer
fit2.hg.cmb <- contrasts.fit(fit.hg, cont.mat)     # model fitting
fit2.hg.cmb <- eBayes(fit2.hg.cmb)    # empirical Bayes
topTable(fit2.hg.cmb, adjust="fdr", number=Inf) %>% rownames_to_column("Gene") -> deg.hg.cmb

### DEG analysis of Stroma component 
bool <- rownames(d.mm.cmb) %in% deg.mm$Gene # Genes on DEG-analysis in original PDX data
y.mm.cmb <- DGEList(d.mm.cmb[bool, ])
print("Original counts"); dim(d.mm.cmb)
print("Filtered counts"); dim(y.mm.cmb)
# mean-variance stabilization
v <- voom(y.mm.cmb, design.cmb, plot = T) # voom takes TPM-counts 
# passages => techinical duplicates
# intra-specimen (of the same NXID) correlation is incorporated into the covariance matrix
corfit <- duplicateCorrelation(v, design.cmb, block = NXIDs.cmb)
fit.mm <- lmFit(v, design.cmb, block=NXIDs.cmb, correlation=corfit$consensus)   ### model fitting
# Stroma
fit2.mm.cmb <- contrasts.fit(fit.mm, cont.mat)     # model fitting
fit2.mm.cmb <- eBayes(fit2.mm.cmb)    # empirical Bayes
topTable(fit2.mm.cmb, adjust="fdr", number=Inf) %>% rownames_to_column("Gene") -> deg.mm.cmb

### Compare "Original" vs "Original + External" KIRC PDX 
# Plot, Cancer
deg.m <- merge(x = deg.hg, y = deg.hg.cmb, by = "Gene")
sig.m <- deg.m[deg.m$adj.P.Val.x<0.05, ]
cor.eff <- cor(sig.m$logFC.x, sig.m$logFC.y, method = "pearson")
g.deg.hg <- ggplot(sig.m, aes(x = logFC.x, y = logFC.y)) + 
    geom_hline(yintercept = 0, color = "grey") + geom_vline(xintercept = 0, color = "grey") + 
    geom_point(size = 0.5, alpha = 0.5) + 
    geom_smooth(method=lm, color = "red", fill = "red", size = .3) +
    annotate("text", x = -2.5, y = 10, fontface="italic", size=2.5,
            label = paste("Pearson's coeff:", round(cor.eff, digit = 3))) + 
    xlab("logFC, Original data") + ylab("logFC, Original+External data") +
    ggtitle("DEGs, KIRC Cancer") + 
    theme_minimal() +
    theme_common + 
    theme(plot.margin = unit(c(t=3, r=6, b=3, l=2), units = "mm"))

# Plot, Stroma
deg.m <- merge(x = deg.mm, y = deg.mm.cmb, by = "Gene")
sig.m <- deg.m[deg.m$adj.P.Val.x<0.05, ]
cor.eff <- cor(sig.m$logFC.x, sig.m$logFC.y, method = "pearson")
g.deg.mm <- ggplot(sig.m, aes(x = logFC.x, y = logFC.y)) + 
    geom_hline(yintercept = 0, color = "grey") + geom_vline(xintercept = 0, color = "grey") + 
    geom_point(size = 0.5, alpha = 0.5) + 
    geom_smooth(method=lm, color = "red", fill = "red", size = .3) +
    annotate("text", x = -1.3, y = 4, fontface="italic", size=2.5,
            label = paste("Pearson's coeff:", round(cor.eff, digit = 3))) + 
    xlab("logFC, Original data") + ylab("logFC, Original+External data") +
    ggtitle("DEGs, KIRC Stroma") + 
    theme_minimal() + 
    theme_common + 
    theme(plot.margin = unit(c(t=3, r=6, b=3, l=2), units = "mm"))

#####################
### Paracrine effectors ###
####################

### PDX
# Load expression data in TPM values of Original PDXs 
d.hg <- read_tsv("../../data/PDX/Expression_matrix_TPM_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.hg <- d.hg[ ,grep("KIRC", colnames(d.hg))] # Slice columns of KIRC samples
colnames(d.hg) <- gsub(pattern = "KIRC", replacement = "PDX_OriginalPDX_KIRC", colnames(d.hg))

# Load expression data in TPM values of External KIRC PDXs (EGAD00001004799)
load("../../data/EGAD00001004799/gene.exp.hg.EGAD00001004799.rda")
d.hg.ex <- gene.exp.hg.EGAD00001004799$abundance # TPM values
# annotation
sm.ex <- data.frame(str_split(colnames(d.hg.ex), pattern = "_"))
pass.ex <- gsub("[a-c]$", "", gsub("TG", "", sm.ex[3,]))
NXIDs.ex <- gsub("^c[1-8]", "", gsub("TG", "", sm.ex[3,]))
colnames(d.hg.ex) <- paste("PDX_ExternalPDX_KIRC", NXIDs.ex, pass.ex, sep = "_")

# Merge Original PDX & External PDX -> Combined PDX data
data.frame(d.hg.ex) %>% rownames_to_column("Gene") -> d1
data.frame(d.hg) %>% rownames_to_column("Gene") -> d2
merge(d2, d1, by = "Gene") -> d.hg.cmb

### CCLE
read_tsv("../../data/CCLE/matTPM_CCLE.tsv") %>% tibble::column_to_rownames("Gene") -> d.ccle
colnames(d.ccle) <- paste("CCLE_CCLE_", colnames(d.ccle), sep = "")
d.ccle[ ,grep("KIRC", colnames(ccle))] %>% tibble::rownames_to_column("Gene") -> d.ccle

### GTEx
read_tsv("../../data/GTEx/matTPM_GTEx_Kidney.tsv") -> d.gtex
colnames(d.gtex) <- gsub("GTEX-", "GTEx_GTEx_", colnames(d.gtex))

# Combined PDX + CCLE
merge(d.hg.cmb, d.ccle, by.x ="Gene", by.y="Gene") -> d.pdx.ccle

# (Combined PDX + CCLE) + GTEx
dm <- merge(d.pdx.ccle, d.gtex, by.x = "Gene", by.y = "Description") %>% tibble::column_to_rownames("Gene")
# re-scale library size of PDX, CCLE and GTEx
fn_libscale <-  function(x)sweep(x, 2, 1e6 / colSums(x), "*") # scale library size 
dm <- fn_libscale(dm) 
dml <- log(dm+1) # log-TPM

# sample annotation
study <- sapply(str_split(colnames(dm), pattern = "_"), function(x)
    x[[1]]
)
study <- factor(study, levels = c("PDX", "CCLE", "GTEx"))

# Tell Original PDXs from External PDXs
pointstyle <- sapply(str_split(colnames(dm), pattern = "_"), function(x)
    x[[2]]
)
pointstyle <- factor(pointstyle, levels = unique(pointstyle))

# Additional common theme for ggplot 
theme_box <- theme(axis.title.x=element_blank(),
              axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) 

# Paracrine (Cancer-Stroma) effectors in KIRC
d.vegfa <- data.frame("data" = study, "logTPM" = as.numeric(dml["VEGFA",]), "point" = pointstyle)
d.apln <- data.frame("data" = study, "logTPM" = as.numeric(dml["APLN",]), "point" = pointstyle)
d.agt <- data.frame("data" = study, "logTPM" = as.numeric(dml["AGT",]), "point" = pointstyle)
# y-axix
ymax <- ceiling(max(d.vegfa$logTPM, d.apln$logTPM, d.agt$logTPM)) + 1

# Plot
p1 <- ggplot(d.vegfa, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(aes(shape = point, size = point), alpha = 0.5) + 
    scale_shape_manual(values = c(1,2,20,20)) + 
    scale_size_manual(values = c(.5,.5,.1,.1)) + 
    ylim(c(0, ymax)) + 
    ylab("logTPM")  + ggtitle("VEGFA, Cancer") +
    theme_classic() + 
    theme_common + 
    theme_box
#    theme(legend.position = 'none')

p2 <- ggplot(d.apln, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(aes(shape = point, size = point), alpha = 0.5) + 
    scale_shape_manual(values = c(1,2,20,20)) + 
    scale_size_manual(values = c(.5,.5,.1,.1)) + 
    ylim(c(0, ymax)) + 
    ylab("logTPM")  + ggtitle("APLN, Cancer") +
    theme_classic() + 
    theme_common + 
    theme_box
#  theme(axis.title.y = element_blank()) + 
   # theme(legend.position = 'none')

p3 <- ggplot(d.agt, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(aes(shape = point, size = point), alpha = 0.5) + 
    scale_shape_manual(values = c(1,2,20,20)) + 
    scale_size_manual(values = c(.5,.5,.1,.1)) + 
    ylim(c(0, ymax)) + 
    ylab("logTPM")  + ggtitle("AGT, Cancer") +
    theme_classic() + 
    theme_common + 
    theme_box
#    theme(axis.title.y = element_blank())

# statiscal test 
sig_size = 0.25
sig_textsize = 2
sig_vjust = - 0.1

ylim <- max(d.vegfa$logTPM)
p1.sig <-  p1 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEx", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )

ylim <- max(d.apln$logTPM)
p2.sig <- p2 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEx", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )

ylim <- max(d.agt$logTPM)
p3.sig <- p3 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEx", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )

######################
### Integrate all the plots ###
######################
p <- cowplot::plot_grid(
    g.sne.hg, g.deg.hg, g.deg.mm, #(1, )
    g.path.hg, g.path.mm, g.cell.mm, #(2, )
    p1.sig, p2.sig, p3.sig, #(3, )
        nrow = 3,
    labels = c("A", "C1", "C2", "B1","B2","B3","D1","D2","D3"), 
    label_size = 12
)
p
ggsave("./FigS3_Ori-Ex_PDX.jpg", dpi = 500, width = 200, height = 200, units = "mm")



