here::i_am("code/plot_genotypes.R")

data.cat <- read.table(here::here("data", "genotypes.txt"), comment.char = "", sep =  "\t",
                       header = TRUE, na.strings = "./.",
                       check.names = FALSE)

sites <- paste0(data.cat$`#CHROM`, "_", data.cat$POS)

data.mat <- as.matrix(data.cat[, -(1:2)])
rownames(data.mat) <- sites

data.mat[which(! data.mat %in% c("0/0", "0/1", "1/1"), arr.ind = TRUE)] <- NA

data.int <- matrix(data = NA_integer_, nrow = nrow(data.mat), ncol = ncol(data.mat),
                   dimnames = dimnames(data.mat))
data.int[data.mat == "0/0"] <- 0L
data.int[data.mat == "0/1"] <- 1L
data.int[data.mat == "1/1"] <- 2L

data.int <- data.int[rowSums(is.na(data.int)) < 0.50*ncol(data.int), ]

# remove individuals with too much missing data

data.int <- data.int[, colSums(is.na(data.int)) < 0.50*nrow(data.int)]

pheatmap::pheatmap(data.int, cluster_rows = FALSE, cluster_cols = TRUE, 
                   fontsize_col = 6)

pheatmap::pheatmap(data.int[1:8, ], cluster_rows = FALSE, cluster_cols = TRUE, 
                   fontsize_col = 6)
