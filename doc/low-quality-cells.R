## ---- include=FALSE-----------------------------------------------------------
ggplot2::theme_set(ggplot2::theme_bw(base_size = 14) + ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)))

## -----------------------------------------------------------------------------
library(dropestr)
data('lq_cells_data')
pipeline_data <- lq_cells_data$pipeline
mit_genes <- lq_cells_data$genes

## ---- fig.width=5, fig.height=4-----------------------------------------------
scores <- ScorePipelineCells(pipeline_data)
PlotCellScores(scores, y.threshold=0.9)

## ---- fig.width=4.5, fig.height=3---------------------------------------------
scores_chromosome_filt <- ScorePipelineCells(pipeline_data, mit.chromosome.name='chrM')
scores_geneset_filt <- ScorePipelineCells(pipeline_data, mitochondrion.genes=mit_genes)
PlotCellScores(scores_chromosome_filt, y.threshold=0.9, main='Chromosome')
PlotCellScores(scores_geneset_filt, y.threshold=0.9, main='Geneset')

## -----------------------------------------------------------------------------
lq_cells_df <- PrepareLqCellsDataPipeline(pipeline_data, mitochondrion.genes=mit_genes)

## ---- fig.width=5, fig.height=3-----------------------------------------------
PlotCellsNumberLogLog(pipeline_data$aligned_umis_per_cell, estimate.cells.number=T)
PlotCellsNumberLine(pipeline_data$aligned_umis_per_cell, estimate.cells.number=T)
PlotCellsNumberHist(pipeline_data$aligned_umis_per_cell, estimate.cells.number=T)

## -----------------------------------------------------------------------------
for (n in names(lq_cells_df)) {
  smoothScatter(lq_cells_df[[n]], xlab = "Cell rank", ylab = n, main = n)
}

## -----------------------------------------------------------------------------
lq_cells_df <- lq_cells_df[lq_cells_df$MitochondrionFraction < 0.1, ]
lq_cells_df$MitochondrionFraction <- NULL

## -----------------------------------------------------------------------------
cells_number_manual <- list(min=450, max=800)

## -----------------------------------------------------------------------------
scores <- ScoreQualityData(pipeline_data$aligned_umis_per_cell, lq_cells_df, cells_number_manual)
PlotCellScores(scores, y.threshold=0.9)

