## ---- include=FALSE-----------------------------------------------------------
## Input parameters:
##  * d: data, obtained after dropEst run.
##  * mit_genes: list of mitochondrion genes. Optional.
##  * tags_data: list of data, obrained after dropTag run. Optional.

## ---- include=FALSE-----------------------------------------------------------
library(ggplot2)
library(dplyr)
library(dropestr)
knitr::opts_chunk$set(fig.width=5, fig.height=3, echo=FALSE, warning=FALSE, message=FALSE)
ggplot2::theme_set(ggplot2::theme_bw(base_size = 16) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)))

PrintVectorAsTibble <- function(vector, col.names, top.print.size=10) {
  df.func <- if (require(tibble)) tibble else data.frame
  vector <- sort(vector, decreasing=T)
  res <- df.func(names(vector[1:top.print.size]), as.vector(vector[1:top.print.size]))
  colnames(res) <- col.names
  return(res)
}

## -----------------------------------------------------------------------------
d <- lq_cells_data$pipeline
umi_counts <- sort(Matrix::colSums(d$cm), decreasing=TRUE)

## ---- fig.width=5.5, fig.height=3.5, warning=FALSE----------------------------
PlotIntergenicFractionByChromosomes(d$reads_per_chr_per_cells, d$nonex_cells_chr_counts) # TODO: not run for pseudoaligners

## ---- fig.width=3.5, fig.height=3.5-------------------------------------------
PlotUmisDistribution(d$reads_per_umi_per_cell$reads_per_umi)

## ---- fig.width=4.5, fig.height=3.5-------------------------------------------
par(mar = c(4, 4, 0.5, 0))
PlotReadsPerUmiByCells(d$mean_reads_per_umi, umi_counts, cex.lab=1.4)

## ---- fig.width=4.5, fig.height=3.5-------------------------------------------
PlotGenesPerCell(d$cm)

## ---- fig.width=4.5, fig.height=3.5-------------------------------------------
smoothScatter(x=Matrix::colSums(d$cm > 0), y=Matrix::colSums(d$cm), 
              xlab="#Genes per cell", ylab="#UMIs per cell", las=1)

## ---- fig.width=4.5, fig.height=3.5-------------------------------------------
PlotCellsNumberLine(d$aligned_umis_per_cell, breaks=80, title=NULL, estimate.cells.number=T)

## ---- fig.width=4.5, fig.height=3.5-------------------------------------------
PlotCellsNumberHist(d$aligned_umis_per_cell, breaks=60, estimate.cells.number=T, show.legend=F)

## ---- fig.width=5, fig.height=3-----------------------------------------------
PlotCellsNumberLogLog(d$aligned_umis_per_cell, T, show.legend=F)

## -----------------------------------------------------------------------------
scores <- ScorePipelineCells(d, mitochondrion.genes = if (exists("mit_genes")) mit_genes else NULL,
                             tags.data = if (exists("tags_data")) tags_data else NULL)

## ---- fig.width=4.5, fig.height=4---------------------------------------------
PlotCellScores(scores, main=paste0('Cell scores (', sum(scores > 0.9), ' cells > 0.9)'), y.threshold=0.9)

## ---- fig.width=4.5, fig.height=4---------------------------------------------
if (exists("mit_genes")) {
  FractionSmoothScatter(GetGenesetFraction(d$cm, mit_genes), plot.threshold=T, main='Mirochondrial fraction')
}

## ---- message=FALSE, warning=FALSE, fig.width=4.5, fig.height=4---------------
data(saturation_srr1784312)
## saturation <- EstimateSaturation(d$saturation_info$reads, d$saturation_info$cbs, sort(Matrix::colSums(d$cm), decreasing=TRUE))
## PlotSaturationEstimates(list(this=saturation, `mouse ES`=saturation_srr1784312))

## ---- fig.width=4.5, fig.height=4---------------------------------------------
umi_per_gene_probs <- dropestr::ValueCounts(d$cm@x, return_probs=T) %>%
  tibble(UmiProb=., NUmis=as.integer(names(.))) %>% arrange(NUmis) %>%
  filter(UmiProb > 5e-4)

ggplot(umi_per_gene_probs) + geom_bar(aes(x=NUmis, y=1 - cumsum(UmiProb)), stat="identity", width=0.7) +
  labs(x='#UMIs per gene', y='Fraction of genes\nwith larger #UMIs')

## -----------------------------------------------------------------------------
PrintVectorAsTibble(Matrix::rowSums(d$cm), c('Gene', '#Molecules'))

## -----------------------------------------------------------------------------
PrintVectorAsTibble(GetUmisDistribution(d$reads_per_umi_per_cell$reads_per_umi), c('UMI', '#Molecules'), 10)

## -----------------------------------------------------------------------------
# sum(d$requested_reads_per_cb[colnames(d$cm)]) / sum(d$aligned_reads_per_cell)
# sum(d$requested_reads_per_cb[colnames(d$cm)]) / sum(d$aligned_reads_per_cell[colnames(d$cm)])
# sum(d$requested_umis_per_cb[colnames(d$cm)]) / sum(d$aligned_umis_per_cell)
# sum(d$requested_umis_per_cb[colnames(d$cm)]) / sum(d$aligned_umis_per_cell[colnames(d$cm)])

