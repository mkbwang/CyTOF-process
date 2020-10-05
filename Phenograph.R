# Phenograph

library(data.table)
library(Rphenograph)

combined_fcs_20200909 <- fread('/net/wonderland/home/wangmk/CyTOF/data/combined_fcs_20200909.csv')

tsne_20200909 <- combined_fcs_20200909[, c("TSNE1", "TSNE2")]

nneighbour <- 500

phenos <- Rphenograph(tsne_20200909, k=nneighbour)

classifications <- matrix(as.vector(membership(phenos[[2]])), ncol=1)
phenos_20200909 <- as.data.table(classificiations)

setnames(phenos_20200909, "V1", "Phenotype")

new_combined_fcs <- cbind(combined_fcs_20200909, phenos_20200909)

filename = paste0("/net/wonderland/home/wangmk/CyTOF/data/phenotyping/", "Phenograph_20200909_", 
                  as.character(nneighbour), ".csv")

fwrite(new_combined_fcs, filename)
