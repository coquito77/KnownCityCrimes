library(shiny)
library(RCurl)
library(ggplot2)
library(tidyr)
library(dplyr)
library(scales)
library(data.table)
library(RColorBrewer)
library(benford.analysis)
library(mapproj)
library(DT)

## This code loads in the data. the data is in the data file
# globla.r

comboCities <-  fread("./data/comboCities.txt",
                      sep = "\t",
                      showProgress = FALSE)

frtfCaCounties <-  fread("./data/frtfCaCounties.txt",
                         sep = "\t",
                         showProgress = FALSE)

suspects <-  fread("./data/suspects.txt",
                   sep = "\t",
                   showProgress = FALSE)

califCitiesWithLabels <-  fread("./data/califCitiesWithLabels.txt",
                   sep = "\t",
                   showProgress = FALSE)

colourCount = length(unique(comboCities$Type))
getPalette = colorRampPalette(brewer.pal(8, "Accent"))

YCrimes <- select(comboCities, ends_with("Rate")) %>% names()