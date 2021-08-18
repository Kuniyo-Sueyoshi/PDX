# Package requirement
mypkgs <- c("tidyverse", "RColorBrewer", "cowplot", "ggrepel")
invisible(lapply(mypkgs, function(x){
    if(suppressWarnings(!do.call("require", list(x)))){
        BiocManager::install(x)
        do.call("require", list(x))
    }
}))

# Load expression data of Cancer (hg) / Stroma (mm) component of PDXs 
d.hg <-read_tsv("../../data/PDX/Expression_matrix_CountEstimates_human.tsv") %>% column_to_rownames("GeneSymbol") 
d.mm <- read_tsv("../../data/PDX/Expression_matrix_CountEstimates_mouse.tsv") %>% column_to_rownames("GeneSymbol")

# Annotate samples and sort data
source("../../data/PDX/fn_anno_sort.R")
type9 <- c('PAAD','KIRC','NSCLC','COAD','STAD', 'BRCA', 'GBM', 'EWS', 'GIST')
ls <- fn_anno_sort(d.hg, d.mm, type9)
d.hg <- ls$d.hg # length-scaled Count estimates, Cancer
d.mm <- ls$d.mm # length-scaled Count estimates, Stroma
primary <- ls$primary
NXIDs <- ls$NXIDs
ann_colors <- ls$ann_colors

### Tumor purity of PDXs; Gene-level Counts ratio 
data.frame(Tumor=apply(d.hg, 2, sum), Stroma=apply(d.mm, 2, sum)) %>%
  tibble::rownames_to_column('sm') -> d # Total read-counts
d$Tumor_prop <- d$Tumor/(d$Tumor+d$Stroma) # Ratio (Tumor/Stroma) of each sample
d$sm <- factor(d$sm, levels = unique(d$sm))

### Tumor purity of TCGA samples via ABSOLUTE 
tp.all <- read.csv("../../data/TCGA/TCGA_mastercalls.abs_tables_JSedit.fixed.txt", sep = "\t")
tp.all <- tp.all[order(tp.all$sample), ]
files <- list.files(path = "../../data/TCGA", pattern = "samplelist_CNVrun_", full.names = T)
tp.ls <- list()
tp.ls.type <- character()
tp.ab <- data.frame(sample = character(),
                    Tumor_Purity = numeric(), 
                   Type = character())
for(i in 1:length(files)){
    tp <- read.csv(files[i], header = F, sep = "\t")
    tp.type <- str_split(files[i], pattern = "_|\\.")[[1]][7] # SARC, BRCA, GBM...
    tp.ls.type <- c(tp.ls.type, tp.type)
    t.m <- merge(tp.all, tp, by.x = "sample", by.y = "V1")
    # List
    tp.ls <- append(tp.ls, list(t.m))
    # Long-type Data frame
    df.add <- cbind(t.m[ ,c("sample", "purity")], Type=rep(tp.type, nrow(t.m)))
    tp.ab <- rbind(tp.ab, df.add)
}
names(tp.ls) <- tp.ls.type
tp.ab$Type <- gsub("LUAD", "NSCLC", tp.ab$Type)
tp.ab$Type <- gsub("LUSC", "NSCLC", tp.ab$Type)
tp.ab$Type <- factor(tp.ab$Type, levels = c("SARC", "BRCA", "GBM", "STAD", "NSCLC", "COAD", "KIRC", "PAAD"))
tp.ab <- na.omit(tp.ab)

### plot 
theme_nolegend <- theme_classic() +  
        theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) + 
        theme(axis.text.x = element_text(angle = 60, vjust = .5)) + 
        theme(plot.title=element_text(size=8),
              axis.title.x=element_blank(),
              axis.title.y=element_text(size=6),
              axis.text.x=element_text(size=6), 
              axis.text.y=element_text(size=5), 
              legend.title=element_text(size=5)) + 
        theme(legend.position = 'none') 

# PDX
d$Type <- factor(gsub(".NX.*", "", d$sm), levels = c("EWS", "GIST", "BRCA", "GBM", "STAD", "COAD", "NSCLC", "KIRC", "PAAD"))
g.pg <- ggplot(d, aes(x=Type, y=Tumor_prop, fill = Type)) + 
        geom_boxplot(aes(x=Type, y=Tumor_prop, middle = mean(Tumor_prop)),
                     outlier.color = NA, size=.25, alpha=0.3) + 
        stat_summary(fun=mean, geom="point", shape=1, size=1, color="black") + 
        geom_jitter(aes(color = Type), width = .1, alpha=1, size=0.1) +
        scale_fill_manual(values = ann_colors, name = "Type") +
        scale_color_manual(values = ann_colors, name = "Type") +
        xlab("") + ylab("Tumor purity") + ylim(c(0,1)) + 
        theme_nolegend

# TCGA
tp.ab$Type <- factor(tp.ab$Type, levels = c("SARC", "BRCA", "GBM", "STAD", "COAD", "NSCLC", "KIRC", "PAAD"))

g.ab <- ggplot(tp.ab, aes(x=Type, y = purity)) +
        geom_violin(aes(fill = Type), size=0.3, alpha = 0.3) + 
        #geom_dotplot(aes(color = Type), binaxis='y', stackdir='center', dotsize=.02, binwidth = 0.02, stackratio = 3)+#) + 
        geom_jitter(aes(color = Type), width = .2, alpha=0.3, size=.03) +
        stat_summary(fun=mean, geom="point", shape=1, size=1, color="black") + 
        scale_fill_manual(name = "Type", values = c("white", ann_colors_sort)) +
        scale_color_manual(name = "Type", values = c("black", ann_colors_sort)) +
        xlab("") + ylab("Tumor purity") + ylim(0, 1) + 
        theme_nolegend

# scaltter plot of PDX & TCGA
d.sarc <- data.frame(Tumor_prop = d$Tumor_prop, 
                    Type = gsub("GIST", "SARC", gsub("EWS", "SARC", d$Type)))
tp.pdx.mean <- tapply(X = d.sarc$Tumor_prop, INDEX = d.sarc$Type, FUN = mean)
tp.pdx.mean <- tp.pdx.mean[order(names(tp.pdx.mean))]
tp.ab.mean <- tapply(X = tp.ab$purity, INDEX = tp.ab$Type, FUN = mean)
tp.ab.mean <- tp.ab.mean[order(names(tp.ab.mean))]
data.frame(PDX = tp.pdx.mean, TCGA = tp.ab.mean) %>% tibble::rownames_to_column("Type") -> tp.scat 
tp.scat$Type <-  factor(tp.scat$Type, levels = c("SARC", "BRCA", "GBM", "STAD", "COAD", "NSCLC", "KIRC", "PAAD"))
mytheme <- theme_classic() +  
        theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) + 
        theme(plot.title=element_text(size=8),
              axis.title=element_text(size=6),
              axis.text=element_text(size=6)) + 
        theme(legend.position = 'none') 

ann_colors.tmp <- c(ann_colors, SARC = "white")
ann_colors_sort <- ann_colors.tmp[match(levels(tp.scat$Type), names(ann_colors.tmp))]

g <- ggplot(tp.scat, aes(PDX, TCGA)) + 
    geom_smooth(method=lm, color = "grey", fill = "lightgrey") +
    geom_point(color = "black", size = 1.5) + 
    geom_point(aes(color = Type), size = 1.2) + 
    scale_color_manual(values = ann_colors_sort) +
    ggrepel::geom_text_repel(aes(label = Type), size = 2, box.padding = 0.3, min.segment.length = 1) +  
    xlab("Mean tumor purity of PDX") + ylab("Mean tumor purity of TCGA") +
    mytheme + 
    #scale_x_continuous(limits = c(0.7,1), breaks = c(0.7,0.8,0.9,1.0)) + 
    theme(plot.margin=margin(b=4, t=4, r=1.5,l=1.5,unit="mm"))

# plot
cowplot::plot_grid(g.pg+ggtitle("PDX"), g.ab+ggtitle("TCGA"), g, nrow = 1, rel_widths = c(.5, .48, 0.52))#, align = "h")
ggsave("./Fig2b_Tumorpurity.jpg", dpi = 800, width = 114, height =57, units = "mm")
