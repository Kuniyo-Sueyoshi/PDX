# Package requirement
mypkgs <- c("tidyverse", "RColorBrewer", "Rtsne", "cowplot","edgeR")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))

# Load expression data of Cancer (hg) / Stroma (mm) component of PDXs 
d.hg <-read_tsv("../../data/PDX/Expression_matrix_CountEstimates_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.mm <- read_tsv("../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv") %>% column_to_rownames("GeneSymbol")

# Annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R") # load function
type9 <- c('PAAD','KIRC','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, type9)
d.hg <- ls$d.hg # Count-estimates of Cancer
d.mm <- ls$d.mm # Count-estimates of Cancer
primary <- ls$primary # Primary tumor types of PDX samples
ann_colors <- ls$ann_colors # color annotation of PDX tumor types 
NXIDs <- ls$NXIDs # Unique tumor specimen IDs (=~ Patient IDs)

# Common theme for ggplot
theme_common <- theme_classic() +  
        theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) + 
        theme(plot.title=element_text(size=8),
              axis.title.x=element_text(size=5), axis.title.y=element_text(size=5),
              axis.text.x=element_text(size=5), axis.text.y=element_text(size=5), 
              legend.title=element_text(size=5), legend.text=element_text(size=5), legend.key.size = unit(0.5, "line")) + 
        theme(legend.margin=margin(t=-1, r=-0.6, b=0, l=0, unit="mm"))

### tSNE analysis of Cancer component 
y.hg <- DGEList(d.hg)
# Filtering low expressed genes
y.hg0 <- calcNormFactors(y.hg0)
drop <- which(apply(cpm(y.hg), 1, max) < 1) # Genes with TMM-normalized CPM < 1
y.hgl <- cpm(y.hg0[-drop, ], log = T) # log-CPM  value
tsne <- Rtsne(t(as.matrix(y.hgl)), perplexity = 5) # tSNE execution
res.tsne <- data.frame(tSNE_1 = tsne$Y[,1], tSNE_2 = tsne$Y[,2], Type = primary)
g.sne.hg <- ggplot(res.tsne, aes(x=tSNE_1, y=tSNE_2, color = Type))+
    geom_point(size=.6) +
    scale_color_manual(values = ann_colors, name = "Type") + 
    ggtitle("Cancer, PDX") +  
    theme_common

### tSNE analysis of Stroma component 
y.mm <- DGEList(d.mm)
# Filtering low expressed genes
y.mm0 <- calcNormFactors(y.mm)
drop <- which(apply(cpm(y.mm0), 1, max) < 1) # Genes with TMM-normalized CPM < 1
y.mml <- cpm(y.mm0[-drop, ], log = T) # log-CPM  value
tsne <- Rtsne(t(as.matrix(y.mml)), perplexity = 5) # tSNE execution
res.tsne <- data.frame(tSNE_1 = tsne$Y[,1], tSNE_2 = tsne$Y[,2], Type = primary)
g.sne.mm <- ggplot(res.tsne, aes(x=tSNE_1, y=tSNE_2, color = Type))+
    geom_point(size=.6) +
    scale_color_manual(values = ann_colors, name = "Type") + 
    ggtitle("Stroma, PDX") +
    theme_common

# plot 
cowplot::plot_grid(g.sne.hg, g.sne.mm, ncol = 1) # plot
ggsave("./Fig2c_tSNE.jpg", dpi = 800, width = 60, height = 80, units = "mm")

