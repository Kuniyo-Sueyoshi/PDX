# Package requirement
mypkgs <- c("tidyverse", "RColorBrewer", "cowplot", "ggsignif")
invisible(lapply(mypkgs, function(x){
    if(!do.call("require", list(x))){
        install.packages(x)
    }
}))

# Load expression data in TPM valuse of Cancer (hg) / Stroma (mm) component of PDXs 
d.hg <-read_tsv("../../data/PDX/Expression_matrix_TPM_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.mm <- read_tsv("../../data/PDX/Expression_matrix_TPM_mouse.tsv") %>% column_to_rownames("GeneSymbol")

# Annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R")
type9 <- c('PAAD','KIRC','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, type9)
d.hg <- ls$d.hg # length-scaled Count estimates, Cancer
d.mm <- ls$d.mm # length-scaled Count estimates, Stroma
primary <- ls$primary # Primary tumor types of PDX samples
ann_colors <- ls$ann_colors # color annotation of PDX tumor types 
NXIDs <- ls$NXIDs # Unique tumor specimen IDs (=~ Patient IDs)

# Load and merge data
# PDX 
d.pdx <- d.hg[ ,grep("KIRC", colnames(d.hg))] %>% tibble::rownames_to_column("Gene")
colnames(d.pdx) <- paste("PDX-", colnames(d.pdx), sep = "")
# CCLE 
read_tsv("../../data/CCLE/matTPM_CCLE.tsv") %>% tibble::column_to_rownames("Gene") -> ccle
d.ccle <- ccle[ ,grep("KIRC", colnames(ccle))] %>% tibble::rownames_to_column("Gene")
colnames(d.ccle) <- paste("CCLE-", colnames(d.ccle), sep = "")
# GTEx
d.gtex <- read_tsv("../../data/GTEx/matTPM_GTEx_Kidney.tsv") 
# PDX + CCLE
d.pdx.ccle <- merge(d.pdx, d.ccle, by.x ="PDX-Gene", by.y="CCLE-Gene")
# GTEx + (PDX + CCLE)
dm <- merge(d.pdx.ccle, d.gtex, by.x = "PDX-Gene", by.y = "Description") %>% tibble::column_to_rownames("PDX-Gene") 
# re-scale library size of PDX, CCLE and GTEx
fn_libscale <-  function(x)sweep(x, 2, 1e6 / colSums(x), "*") # scale library size 
dm <- fn_libscale(dm) 
dml <- log(dm+1) # log-TPM

head(dm)
# sample annotation
study <- sapply(str_split(colnames(dm), pattern = "-"), function(x)
    x[[1]]
)
study <- factor(study, levels = c("PDX", "CCLE", "GTEX"))


### Plot
# Upstream regulators that located at Paracrine effectors zone in Fig4A
d.vegfa <- data.frame("data" = study, "logTPM" = as.numeric(dml["VEGFA",]))
d.apln <- data.frame("data" = study, "logTPM" = as.numeric(dml["APLN",]))
d.agt <- data.frame("data" = study, "logTPM" = as.numeric(dml["AGT",]))

# Upstream regulators that DID NOT locate at Paracrine effectors zone in Fig4A
d.tgfb1 <- data.frame("data" = study, "logTPM" = as.numeric(dml["TGFB1",]))
d.app <- data.frame("data" = study, "logTPM" = as.numeric(dml["APP",]))
d.dll4 <- data.frame("data" = study, "logTPM" = as.numeric(dml["DLL4",]))

# y-axis
ymax <- ceiling(max(d.vegfa$logTPM, d.apln$logTPM, d.agt$logTPM, d.tgfb1$logTPM, d.app$logTPM, d.dll4$logTPM)) + 1

# common theme for ggplot 
mytheme <- theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank()) +  
        theme(axis.line=element_line(colour = "black", size = .35),
              axis.ticks=element_line(colour = "black", size = .35)) + 
        theme(axis.title.x=element_blank(), axis.title.y=element_text(size=6),
              axis.text.x = element_text(size=7, angle = 45, vjust = 1, hjust = 1), 
              axis.text.y = element_text(size=6)) + 
        theme(plot.title = element_text(size = 7))

# Upstream regulators that located at Paracrine effectors zone in Fig4A
p1 <- ggplot(d.vegfa, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM")  + ggtitle("VEGFA") +
    mytheme
p2 <- ggplot(d.apln, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM") + ggtitle("APLN") + 
    mytheme + 
    theme(axis.title.y = element_blank())
p3 <- ggplot(d.agt, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM") + ggtitle("AGT") +  
    mytheme +
    theme(axis.title.y = element_blank())

# Upstream regulators that DID NOT locate at Paracrine effectors zone in Fig4A
p4 <- ggplot(d.tgfb1, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM") + ggtitle("TGFB1") + 
    mytheme 
p5 <- ggplot(d.app, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM") + ggtitle("APP") + 
    mytheme + 
    theme(axis.title.y = element_blank())
p6 <- ggplot(d.dll4, aes(x = data, y = logTPM)) + 
    geom_boxplot(outlier.size = 0, notchwidth=1.5, lwd=0.35, fill="grey") +
    geom_point(size=.1, alpha = 0.5) + ylim(c(0, ymax)) + 
    ylab("logTPM") + ggtitle("DLL4") + 
    mytheme + 
    theme(axis.title.y = element_blank())

### statiscal test 
sig_size = 0.25
sig_textsize = 2
sig_vjust = - 0.1

# Upstream regulators that located at Paracrine effectors zone in Fig4A
ylim <- max(d.vegfa$logTPM)
p1.sig <-  p1 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )
ylim <- max(d.apln$logTPM)
p2.sig <- p2 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )
ylim <- max(d.agt$logTPM)
p3.sig <- p3 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )

# Upstream regulators that DID NOT locate at Paracrine effectors zone in Fig4A
ylim <- max(d.tgfb1$logTPM)
p4.sig <- p4 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )
ylim <- max(d.app$logTPM)
p5.sig <- p5 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )
ylim <- max(d.dll4$logTPM)
p6.sig <- p6 + 
    geom_signif(comparisons = list(c("CCLE", "PDX"), c("GTEX", "PDX")),
                test = "wilcox.test", col = "red", size = sig_size, textsize = sig_textsize, vjust = sig_vjust,
                map_signif_level =  c("‡"=0.005,"†"=0.05, "n.s."=1), 
                y_position = c(ylim+0.3, ylim+1.2)
               )

# plot
p <- cowplot::plot_grid(p1.sig, p2.sig, p3.sig, p4.sig, p5.sig, p6.sig, nrow = 2,  rel_widths = c(.36, .32, .32))
p
ggsave("./Fig4b_PDX_CCLE_GTEx.jpg", dpi = 500, width = 64, height = 70, units = "mm")