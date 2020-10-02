# TSNE analysis

library(data.table)
library(Rtsne)
library(ggplot2)

# load the csv file with selected columns

cols <- c('file','CD66b', 'CD16', 'CD15', 'CD19', 'CD20', 'CD27', 'CD3', 'CD127', 'CD25',
          'CD4', 'CD8', 'CD56', 'CD123', 'CD11c', 'CD14', 'CD45RA', 'CCR7', 'CXCR3')

combined_fcs <- fread('/home/wangmk/UM/Biostatistics/CyTOF/data/20200909/Combined_fcs.csv',
                      header = TRUE, select = cols)
markers <- as.matrix(combined_fcs[,-"file", with=F])

# fit TSNE on the markers
tsne_result <- Rtsne(markers)

tsne_20200909 <- tsne_result$Y
tsne_20200909 <- as.data.table(tsne_20200909)
setnames(tsne_20200909, c("V1", "V2"), c("TSNE1", "TSNE2"))

# add the two columns of TSNE into the original combined datasheet
combined_fcs <- cbind(combined_fcs, tsne_20200909)

# Color the TSNE plots with marker intensity (CD4, CD8 and CD3)
combined_fcs_CD4 <- combined_fcs[order(CD4)]
CD4_tsne <- ggplot(combined_fcs_CD4, aes(x=TSNE1, y=TSNE2)) + geom_point(size = 0.001, aes(colour = CD4)) + xlab("TSNE1")+
  ylab("TSNE2") +  coord_cartesian(xlim = c(-31, 31), ylim = c(-31, 31))+
  scale_colour_gradient(limits = c(0, 400), low = "steelblue", high = "red")

combined_fcs_CD8 <- combined_fcs[order(CD8)]
CD8_tsne <- ggplot(combined_fcs_CD8, aes(x=TSNE1, y=TSNE2)) + geom_point(size = 0.001, aes(colour = CD8)) + xlab("TSNE1")+
  ylab("TSNE2") +  coord_cartesian(xlim = c(-31, 31), ylim = c(-31, 31))+
  scale_colour_gradient(limits = c(0, 150), low = "steelblue", high = "red")

combined_fcs_CD3 <- combined_fcs[order(CD3)]
CD3_tsne <- ggplot(combined_fcs_CD3, aes(x=TSNE1, y=TSNE2)) + geom_point(size = 0.001, aes(colour = CD3)) + xlab("TSNE1")+
  ylab("TSNE2") +  coord_cartesian(xlim = c(-31, 31), ylim = c(-31, 31))+
  scale_colour_gradient(limits = c(0, 150), low = "steelblue", high = "red")

pdf("/home/wangmk/UM/Biostatistics/CyTOF/data/plots/marker_intensity.pdf")
print(CD4_tsne)
print(CD8_tsne)
print(CD3_tsne)
dev.off()


# Display the points from individual files
files <- unique(combined_fcs[, file])
plot_list = list()
i=1

for (fname in files){
  subset_tsne <- ggplot(combined_fcs[file==fname,], aes(x=TSNE1, y=TSNE2)) + geom_point(size = 0.001) + xlab("TSNE1")+
    ylab("TSNE2") +  coord_cartesian(xlim = c(-31, 31), ylim = c(-31, 31)) + ggtitle(fname)
  plot_list[[i]] <- subset_tsne
  i = i+1
}

pdf("/home/wangmk/UM/Biostatistics/CyTOF/data/plots/indv_fcs.pdf")
for (j in 1:length(files)) {
  print(plot_list[[j]])
}
dev.off()

# save the new combined fcs file
combined_fcs <- combined_fcs[order(file)]
fwrite(combined_fcs, '/home/wangmk/UM/Biostatistics/CyTOF/data/20200909_Combined_fcs_TSNE.csv')
