# Phenograph

library(data.table)
library(Rphenograph)

tsne_20200909 <- fread('/net/wonderland/home/wangmk/CyTOF/plots/20200909_combined_fcs_TSNE.csv')

nneighbour <- as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))

phenos <- Rphenograph(tsne_20200909, k=nneighbours)

classifications <- matrix(as.vector(membership(phenos[[2]])), ncol=1)
phenos_20200909 <- cbind(tsne_20200909, classifications)
phenos_20200909 <- as.data.table(phenos_20200909)

setnames(phenos_20200909, c("V1", "V2", "V3"), c("TSNE1", "TSNE2", "Phenotype"))

filename = paste0("/net/wonderland/home/wangmk/CyTOF/data/phenotyping/", "Phenograph_20200909_", 
                  as.character(nneighbour), ".csv")

fwrite(phenos_20200909, filename)
