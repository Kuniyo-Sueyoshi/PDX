# function to sort columns of expression dataframe according to tumor-type (primary) and passages (NXIDs)

fn_anno_sort <- function(d.hg = d.hg, d.mm = d.mm, types=types){ 
    # check if samples in cancer data correspond samples in stroma data 
    ann_sm.hg <- str_split(colnames(d.hg), pattern = "_")  # sample annotation
    ann_sm.mm <- str_split(colnames(d.mm), pattern = "_")  # sample annotation
    if(all(unlist(ann_sm.hg) != unlist(ann_sm.mm))){
        stop("sampleName(hg) is not compatible with sampleName(mm)")
    }else{
    ann_sm <- ann_sm.hg
    }
    
    # sample annotation 
    primary <- sapply(ann_sm, function(x) return(x[[1]]))
    primary <- factor(primary, levels = types)
    NXIDs <- sapply(ann_sm, function(x) return(x[[2]]))
    order <- order(primary, NXIDs)

    # sort data 
    d.hg.s <- d.hg[ ,order]
    d.mm.s <- d.mm[ ,order]
    primary　<- factor(primary[order], levels = types) 
    NXIDs <- factor(NXIDs[order])

    # color of tumor types
    library(RColorBrewer)
    n <- length(types)
    type9_order <- c('KIRC','PAAD','STAD','NSCLC','COAD','EWS','BRCA','GBM','GIST')
    if(n==9){
	ann_colors <- brewer.pal(n, "Set1")
    	names(ann_colors) <- type9_order} # make pairs of color & Type
    if(n>9){
	ann_colors <- c(brewer.pal(9, "Set1"), rep('black', n-9)) 
	names(ann_colors) <- c(type9_order, types[!types %in% type9_order])} # Extra types -> 'black'
    if(n<9){
	stop("length(types) should be equal or larger than 9")}
    ann_colors <- ann_colors[types] # re-order
    return(list(d.hg=d.hg.s, d.mm=d.mm.s, primary=primary, NXIDs=NXIDs, ann_colors=ann_colors))
}
