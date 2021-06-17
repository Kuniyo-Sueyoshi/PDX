# Packages
mypkgs <- c("tidyverse", "RColorBrewer", "cowplot")
invisible(lapply(mypkgs, function(x){
    if(suppressWarnings(!do.call("require", list(x)))){
        BiocManager::install(x)
        do.call("require", list(x))
    }
}))

if(suppressWarnings(!require(estimate))){
    #library(utils)
    rforge <- "http://r-forge.r-project.org"
    install.packages("estimate", repos=rforge, dependencies=TRUE)
    require(estimate)
}


### Pre-process of expresison data of Stromal component of PDXs 
# homolog genes table 
geneV2 <- read_tsv("../../data/homologene/homologene.data_geneV2.tsv")
# Convert mouse gene symbol to human gene symbol 
d <- read_tsv("../../data/PDX/Expression_matrix_TPM_mouse.tsv") # TPM-value yielded by tximport
dm <- merge(x = geneV2, y = d, by.x = "Symbol.mm", by.y = "GeneSymbol")
dm <- dm[ ,!(colnames(dm) %in% c("Symbol.mm","NumGene"))] # remove two columns
colnames(dm) <- gsub(pattern = "Symbol.hg", replacement = "GeneSymbol", colnames(dm))
write_tsv(dm, file = "./Expression_matrix_TPM_mouse_hgSymbol.tsv") # Row orders have changed

### ESTIMSTE analysis of PDXs
# Cancer component of PDXs
hg.expr <- "../../data/PDX/Expression_matrix_TPM_human.tsv" # TPM-value yielded by tximport
filterCommonGenes(input.f=hg.expr, output.f="./hg_est.gmt", id="GeneSymbol")
estimateScore("./hg_est.gmt", "./hg_est_score.gmt", platform="illumina")

# Stromal component of PDXs 
mm.expr <- "./Expression_matrix_TPM_mouse_hgSymbol.tsv" # TPM-value yielded by tximport
filterCommonGenes(input.f=mm.expr, output.f="./mm_est.gmt", id="GeneSymbol")
estimateScore("./mm_est.gmt", "./mm_est_score.gmt", platform="illumina")

# Read ESTIMATE Stromalscores of PDXs
read_tsv("./hg_est_score.gmt", skip = 2) -> est.t
read_tsv("./mm_est_score.gmt", skip = 2) -> est.s
est.t[ ,-1] %>% column_to_rownames("Description") -> df.est.t
est.s[ ,-1] %>% column_to_rownames("Description") -> df.est.s

# Annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R")
type.levels = c("COAD","PAAD","BRCA","STAD","KIRC","GBM","GIST","EWS","NSCLC") # fix levels of tumor types
ls <- fn_anno_sort(d.hg = df.est.t, d.mm = df.est.s,  types= type.levels)
df.est.t <- ls$d.hg
df.est.s  <- ls$d.mm
primary <- ls$primary
NXIDs <- ls$NXIDs
ann_colors <- ls$ann_colors

# Dataframe of Stromal scores of PDXs
est <- data.frame(Type = primary, 
                  Tumor = as.numeric(df.est.t[1, ]),
                  Stroma = as.numeric(df.est.s[1,]))
est %>% gather(key=Reads, value=ESTIMATEscore, Tumor, Stroma) -> est.m


### ESTIMSTE analysis of CCLE (Cancer cell lines) expression data 
# Please refrer to "~/PDX/github/data/CCLE/README.md" about how to obtain and prepare CCLE expression matrix data
ccle.expr <-  "../../data/CCLE/matTPM_CCLE.tsv" 
filterCommonGenes(input.f=ccle.expr, output.f="./ccle_est.gmt", id="Gene")
estimateScore("./ccle_est.gmt", "./ccle_est_score.gmt", platform="illumina")

# Read ESTIMATE Stromalscores of CCLE
read_tsv("./ccle_est_score.gmt", skip = 2) -> est.ccle
head(est.ccle)

# sample annotation
primary.ccle <- sapply(str_split(colnames(est.ccle), pattern = "\\."), function(x) return(x[[1]]))[c(-1,-2)]
type8.ccle <- c("COAD", "PAAD", "BRCA", "STAD", "KIRC", "LGG", "SARC")
primary.ccle <- factor(primary.ccle, levels = type8.ccle)
est.ccle.m <- data.frame(Type = primary.ccle, 
                  StromalScore = as.numeric(est.ccle[1, c(-1, -2)]))
col.ccle <- c(ann_colors[c("COAD", "PAAD", "BRCA", "STAD", "KIRC", "GBM")], SARC = "black")
names(col.ccle) <- type8.ccle

### Plot
# Common theme
theme_common <- theme_classic() +  
        theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) + 
        theme(axis.text.x = element_text(angle = 45, vjust = .5)) + 
        theme(plot.title=element_text(size=8),
              axis.title.x=element_text(size=6), axis.title.y=element_text(size=6),
              axis.text.x=element_text(size=6), axis.text.y=element_text(size=6), 
              legend.title=element_text(size=6), legend.text=element_text(size=6), legend.key.size = unit(0.5, "line"))

# PDX
g.pdx <- ggplot(est.m, aes(x=Reads, y=ESTIMATEscore)) + geom_boxplot(outlier.shape=NA, size=.5) +
        geom_jitter(aes(color=Type), 
                    position=position_jitter(width=.1, height=0), size=.6) +
        scale_color_manual(name = "Type", values = ann_colors) + 
        ylim(-3500, 2500) + 
        ggtitle("PDX") + ylab("Stromal score") +  xlab("") + 
        theme_common

# CCLE
g.ccle <- ggplot(est.ccle.m, aes(x=Type, y=StromalScore)) + 
    geom_violin(aes(fill = Type), size=0.3, alpha = 0.3) + 
    geom_jitter(aes(color = Type), width = .2, alpha=0.3, size=.03) +
    scale_fill_manual(values = col.ccle) +
    scale_color_manual(values = col.ccle) + 
    ylim(-3500, 2500) + 
    ggtitle("CCLE") + ylab("") +  xlab("Tumor cell lines") + 
    theme_common+ 
    theme(axis.title.y=element_blank()) + 
    theme(legend.position = "none") 

cowplot::plot_grid(g.pdx, g.ccle,  
                   nrow = 1, align = "h", rel_widths = c(.5, .5)) 
ggsave("./Fig2a_StromalScore.jpg", dpi = 500, width = 90, height = 57, units = "mm")