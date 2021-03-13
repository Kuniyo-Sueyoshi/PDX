# Package requirement
mypkgs <- c("tidyverse", "RColorBrewer", "GSVA", "cowplot","edgeR")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))

# Load expression data in length-scaled Count estimate values of Cancer (hg) / Stroma (mm) component of PDXs 
d.hg <-read_tsv("../../data/PDX/Expression_matrix_CountEstimates_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.mm <- read_tsv("../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv") %>% column_to_rownames("GeneSymbol")

# Annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R")
type9 <- c('PAAD','KIRC','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, types = type9)
d.hg <- ls$d.hg # length-scaled Count-estimates of Cancer
d.mm <- ls$d.mm # length-scaled Count-estimates of Cancer
primary <- ls$primary # Primary tumor types of PDX samples
ann_colors <- ls$ann_colors # color annotation of PDX tumor types 
NXIDs <- ls$NXIDs # Unique tumor specimen IDs (=~ Patient IDs)

# gene-set list of hallmark pathways 
 t <- read_tsv("./h.all.v6.2.symbols.gmt", col_names = F) %>% tibble::column_to_rownames("X1")
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

###################
### Pathway analysis ###
###################
# hg 
y.hg <- cpm(DGEList(d.hg), log=T) # log-CPM value
d.f.GSVA.hg <- gsva(y.hg,  pathways) # Execution of GSVA
# mm
y.mm <- cpm(DGEList(d.mm), log = T) # log-CPM value
d.f.GSVA.mm <- gsva(y.mm,  pathways.mm) # Execution of GSVA

# ANOVA; select top 10 significant pathways across PDX types in stromal data 
p.ano.mm <- apply(d.f.GSVA.mm, 1, function(x){
    res <- oneway.test(x ~ primary)
    #res <- kruskal.test(x ~ primary)
    return(res$p.value)
})
q.ano.mm <- p.adjust(p.ano.mm, method = "BH")
q.10th <- sort(q.ano.mm)[10] 
print(q.10th, format = "%.f3")
logi.top10 <-  q.ano.mm <= q.10th
names(q.ano.mm[logi.top10])

# Function, 70 sample-wise sd / total sd 
my.scale <- function(df){
    df.sd <- sd(as.vector(df))
    return(t(apply(df, 1, function(row){
        row.sd <- sd(row)
        return((row)/row.sd * df.sd)
    })))
}
   
# Function, PDX-type wise average 
type.ave <- function(df){
  t(apply(df, 1, function(x){tapply(x, primary, mean)
  }))  
}

# Lineaer model matrix ( = Full model))
design <- model.matrix(~ 0 + primary); colnames(design) <- levels(primary)

# contrast matrix for comparison
cont.mat <- makeContrasts(
    COAD = COAD - 1/8*(NSCLC+PAAD+STAD+KIRC+BRCA+EWS+GBM+GIST), 
    PAAD = PAAD - 1/8*(COAD+NSCLC+STAD+KIRC+BRCA+EWS+GBM+GIST),
    STAD = STAD - 1/8*(COAD+NSCLC+PAAD+KIRC+BRCA+EWS+GBM+GIST),
    NSCLC = NSCLC - 1/8*(COAD+PAAD+STAD+KIRC+BRCA+EWS+GBM+GIST),
    KIRC = KIRC - 1/8*(COAD+NSCLC+PAAD+STAD+BRCA+EWS+GBM+GIST),
    BRCA = BRCA - 1/8*(COAD+NSCLC+PAAD+STAD+KIRC+EWS+GBM+GIST),
    EWS = EWS - 1/8*(COAD+NSCLC+PAAD+STAD+KIRC+BRCA+GBM+GIST),
    GIST = GIST - 1/8*(COAD+NSCLC+PAAD+STAD+KIRC+BRCA+EWS+GBM),
    GBM = GBM - 1/8*(COAD+NSCLC+PAAD+STAD+KIRC+BRCA+EWS+GIST),
              levels=design)

fn.qmat <- function(df){
    corfit <- duplicateCorrelation(df, design, block = NXIDs)
    fit <- lmFit(df, design, block=NXIDs, correlation=corfit$consensus)   ### model fitting
    fit2 <- contrasts.fit(fit, cont.mat)     # model fitting
    fit2 <- eBayes(fit2)    # empirical Bayes
    qmat <- apply(fit2$p.value, 2, function(x){p.adjust(x, method = "fdr")})
    qmat <- qmat[ ,levels(primary)] # reorder columns
    return(qmat)
}

# Re-order pathways and To_small_letters
# "name_sm" should correspond to "names(q.ano.mm[logi.top10])", but the order is arbitrary.
name_sm <- c('IL6_JAK_STAT3_Signaling',
             'Allograft_Rejection',
             'Inflammatory_Response',
             'Interferon_gamma_Response',
             'Interferon_alpha_Response',
             'Complement',
             'E2F_Targets',
             'Epithelial_Mesenchymal_Transition',
             'Hypoxia',
             'Glycolysis')
fn.sort.tolower <- function(df){ # function to sort selected pathways and change upper case letters
    order.path <- toupper(name_sm)
    df.s <- df[order.path, ]
    rownames(df.s) <- name_sm
    return(df.s)
}

###  Prepare for plot, Cancer
# data 
es.hg <- d.f.GSVA.hg[logi.top10, ]
es.hg.s <- fn.sort.tolower(es.hg)
es.hg.c <- type.ave(my.scale(es.hg.s)) # average enrichment scores
as.data.frame(es.hg.c) %>% rownames_to_column("Pathway") %>%
    tidyr::pivot_longer(cols =  -Pathway, names_to = "Type", values_to = "meanES") -> es.hg.l
# Statistics
qmat.hg <- fn.qmat(es.hg.s)
qtxt.hg <- ifelse(qmat.hg < 0.05, yes = ifelse(qmat.hg < 0.005, "‡", "†"), NA)
data.frame(qtxt.hg) %>% rownames_to_column("Pathway") %>% 
    tidyr::pivot_longer(cols = -Pathway, names_to = "Type", values_to = "SigText") -> txt.gsva.l
es.hg.l$SigText <- txt.gsva.l$SigText
# Reorder Pathways
es.hg.l$Pathway <- factor(es.hg.l$Pathway, levels = unique(es.hg.l$Pathway))
es.hg.l$Type <- factor(es.hg.l$Type, levels =levels(primary))

### Prepare for plot
# data
es.mm <- d.f.GSVA.mm[logi.top10, ]
es.mm.s <- fn.sort.tolower(es.mm)
es.mm.c <- type.ave(my.scale(es.mm.s)) # average enrichment scores
as.data.frame(es.mm.c) %>% rownames_to_column("Pathway") %>%
    tidyr::pivot_longer(cols =  -Pathway, names_to = "Type", values_to = "meanES") -> es.mm.l
# Statistics
qmat.mm <- fn.qmat(es.mm.s)
qtxt.mm <- ifelse(qmat.mm < 0.05, yes = ifelse(qmat.mm < 0.005, "‡", "†"), NA)
data.frame(qtxt.mm) %>% rownames_to_column("Pathway") %>% 
    tidyr::pivot_longer(cols = -Pathway, names_to = "Type", values_to = "SigText") -> txt.gsva.l
es.mm.l$SigText <- txt.gsva.l$SigText
# Reorder Pathways
es.mm.l$Pathway <- factor(es.mm.l$Pathway, levels = unique(es.mm.l$Pathway))
es.mm.l$Type <- factor(es.mm.l$Type, levels = levels(primary))

### Plot 
# Common theme for ggplot
mytheme <- 
    theme_bw() + 
    theme(plot.background = element_blank(),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_blank(),
          panel.background = element_blank(),
          axis.line = element_blank(),
          axis.ticks = element_blank(),
          strip.background = element_rect(fill = "white", colour = "white", size = 0.3),
          legend.title=element_text(size=7), legend.text=element_text(size=7), legend.key.size = unit(.6, "line"),
          legend.margin=margin(t=0, r=-0.6, b=0, l=-1, unit="mm"), 
          plot.margin = margin(t=6, r=2, b=2, l =1, unit = "mm"),
          axis.title.x=element_blank(), axis.title.y=element_blank(),
          axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1, size = 7),
          axis.text.y = element_text(size=7))

# Common scale range
ES.max <- max(es.hg.l$meanES, es.mm.l$meanES)
scale.max <- ceiling(ES.max * 10) / 10
ES.min <- min(es.hg.l$meanES, es.mm.l$meanES)
scale.min <- floor(ES.min * 10) / 10

# Plot
gh <- ggplot(es.hg.l, aes(x = Type, y = Pathway, fill = meanES)) + 
    geom_tile() + 
    geom_text(aes(label=SigText), size = 1.5, vjust = 0.7) + 
    scale_fill_gradientn("meanES", colours = c("#4787ff", "white", "#ff6347"), limits=c(scale.min, scale.max)) + 
    mytheme +
    theme(legend.position = "none")

gm <- ggplot(es.mm.l, aes(x = Type, y = Pathway, fill = meanES)) + 
    geom_tile() + 
    geom_text(aes(label=SigText), size = 1.5, vjust = 0.7) + 
    scale_fill_gradientn("meanES", colours = c("#4787ff", "white", "#ff6347"), limits=c(scale.min, scale.max)) + 
    mytheme + 
    theme(axis.text.y = element_blank()) 
cowplot::plot_grid(gh, gm, rel_widths = c(0.618, 0.382))
ggsave("Fig3a_Pathway.jpg", dpi = 500, width = 114, height = 64, units = "mm")

# output 
d.rm <- data.frame(matrix(rep(NA, length(rm.words)*ncol(d.f.GSVA.hg)), nrow = length(rm.words)))
rownames(d.rm) <- rm.words
# hg
colnames(d.rm) <- colnames(d.f.GSVA.hg)
rbind(d.f.GSVA.hg, d.rm) %>% round(digits = 5) %>% tibble::rownames_to_column("Hallmark_pathways") -> d.out
write.table(d.out, "../../suppl_tables/TableS2.1_GSVAscore_hg.tsv", quote = F, row.names = F, sep = "\t")
# mm
colnames(d.rm) <- colnames(d.f.GSVA.mm)
rbind(d.f.GSVA.mm, d.rm) %>% round(digits = 5) %>% tibble::rownames_to_column("Hallmark_pathways") -> d.out
write.table(d.out, "../../suppl_tables/TableS2.2_GSVAscore_mm.tsv", quote = F, row.names = F, sep = "\t")


##########################
### Stroma signature Analysis ###
#########################
# Cell types and cell signature genes 
readr::read_delim("../../suppl_tables/TableS3_cell_marker.tsv", delim = "\t") -> d.marker
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
y.mm <- cpm(DGEList(d.mm), log = T) # log-CPM value of stroma 
d.f.GSVA.mm <- gsva(y.mm, Sets.CellType) # Execution of GSVA
### plot
# data
es.mm.c <- type.ave(my.scale(d.f.GSVA.mm)) # mean Enrichment score
as.data.frame(es.mm.c) %>% rownames_to_column("CellType") %>%
    tidyr::pivot_longer(cols =  -CellType, names_to = "Type", values_to = "meanES") -> es.mm.l
# Statistics
qmat.mm <- fn.qmat(d.f.GSVA.mm)
qtxt.mm <- ifelse(qmat.mm < 0.05, yes = ifelse(qmat.mm < 0.005, "‡", "†"), NA)
data.frame(qtxt.mm) %>% rownames_to_column("CellType") %>% 
    tidyr::pivot_longer(cols = -CellType, names_to = "Type", values_to = "SigText") -> txt.gsva.l
es.mm.l$SigText <- txt.gsva.l$SigText
# Reorder Celltype by clustering  
clr <- heatmap(es.mm.c, scale = "none", Colv = NA)
cell.clust.idx  <- rownames(es.mm.c)[clr$rowInd]
es.mm.l$CellType <- factor(es.mm.l$CellType, levels = cell.clust.idx)
# Reorder PDX type
es.mm.l$Type <- factor(es.mm.l$Type, levels = levels(primary))
# plot 
gm <- ggplot(es.mm.l, aes(x = Type, y = CellType, fill = meanES)) + 
    geom_tile() + 
    geom_text(aes(label=SigText), size = 1.5, vjust = 0.7) + 
    scale_fill_gradientn("meanES", colours = c("#4787ff", "white", "#ff6347"))  +
    mytheme
gm
ggsave("Fig3b_CellType.jpg", dpi = 500, width = 62, height = 50, units = "mm")