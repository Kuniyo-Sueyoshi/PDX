# Package requirement
mypkgs <- c("tidyverse", "ggrepel")
invisible(lapply(mypkgs, function(x){
    if(suppressWarnings(!do.call("require", list(x)))){
        BiocManager::install(x)
        do.call("require", list(x))
    }
}))

### Estimated Upstream regulators over stroma transcriptome
# load a list of possible upstream regulators over PDX stromal transcriptome produced by IPA analysis
d <- read.csv("../../suppl_tables/TableS5_IPA_Regulators_KIRC_Stroma.txt", header = T, sep="\t")
d$Activation.z.score[is.na(d$Activation.z.score)] <- 0
d$Predicted.Activation.State[is.na(d$Predicted.Activation.State)] <- "Not significant"
# plot
g <- ggplot(d, aes(x=Activation.z.score, y=-log10(q.overlap), color = Predicted.Activation.State)) + 
        geom_point(stat = "identity", position = "identity", size = .5) + 
        scale_colour_manual(values = c("tomato", "blue2", "black")) + 
        geom_text_repel(data = subset(d, p.value.of.overlap < 0.000005),  aes(label = Upstream.Regulator), size = 3, show.legend = FALSE) + 
        theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank()) +  
        theme(axis.line=element_line(colour = "black", size = .25),
              axis.ticks=element_line(colour = "black", size = .25)) + 
        theme(axis.title=element_text(size=10),
              axis.text=element_text(size=8), 
              legend.title=element_text(size=10), legend.text=element_text(size=8), legend.key.size = unit(1, "line")) 
g
ggsave("./FigS2_IPA_KIRC.jpg",  dpi = 500, width = 114, height = 90, units = "mm")



### Estimate possible cancer-stroma paracrine effectors
# Load a list of differentially expressed genes in PDX cancer component.
d_pdx <- read_tsv("../../suppl_tables/TableS6_DEG_KIRCvsOthers_Cancer.tsv")

# Merge possible upstream regulators and DEGs in PDX cancer
dm <- merge(d_pdx, d, by.x = "Gene",  by.y = "Upstream.Regulator")
sortlist <- order(dm$q.overlap, pmax(dm$q.overlap, dm$adj.P.Val))
dm <- dm[sortlist,]
dm$logP.in.tumor.dir <- -log10(dm$adj.P.Val)*dm$t/abs(dm$t)

# Plot
g <- ggplot(dm, aes(x = logP.in.tumor.dir, y = -log10(q.overlap))) +
    geom_vline(xintercept = -log10(1), size=.35, color="grey") +
    geom_point(size = 1.1) +
    geom_point(aes(color = Activation.z.score), size = 1) +
    scale_color_gradient2(low = "blue2", high = "tomato") + 
    geom_text_repel(data = subset(dm, (p.value.of.overlap < 1E-4 & logP.in.tumor.dir > 1.4) | p.value.of.overlap < 1E-6)
                                  ,  aes(label = Gene), size = 3) +
    theme(panel.grid.major = element_blank(),
              panel.grid.minor = element_blank(),
              panel.background = element_blank()) +  
    theme(axis.line=element_line(colour = "black", size = .35),
              axis.ticks=element_line(colour = "black", size = .35)) + 
    theme(axis.title=element_text(size=8), axis.text=element_text(size=8), 
              legend.title = element_text(size=7), legend.text = element_text(size=6), 
              legend.key.size = unit(.2, "inch"), legend.position = c(.75, .95), legend.direction="horizontal") +
    xlab("Expression in KIRC tumor (Directional -log.q-value)") + ylab("Regulation over KIRC stroma (-log.q-value)") + 
    ylim(1,10) + xlim(-3,17)
g    
ggsave("./Fig4a_Upstrm_KIRC.jpg", dpi = 800, width = 110, height = 110, units = "mm")      
