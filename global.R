library(shiny)
library(shinydashboard)
library(mapview)
library(sp)
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

startTime <- Sys.time()

frtfCitiesInterset <-  fread("./data/frtfCitiesInterset.txt",
                             sep = "\t",
                             showProgress = FALSE) %>% setDT(key = 'City')

comboRecs <-  fread("./data/comboRecs.txt",
                    sep = "\t",
                    showProgress = FALSE)  %>% setDT(key = 'City')

comboCities <- merge(frtfCitiesInterset, comboRecs,
                     by.x = c('City'), by.y = c('City'), all.x = TRUE,
                     allow.cartesian = TRUE)

frtfCaCounties <-  fread("./data/frtfCaCounties.txt",
                         sep = "\t",
                         showProgress = FALSE)

countyLimits <-  fread("./data/countyLimits.txt",
                       sep = "\t",
                       showProgress = FALSE)

suspects <-  fread("./data/suspects.txt",
                   sep = "\t",
                   showProgress = FALSE)

califCitiesWithLabels <-  fread("./data/califCitiesWithLabels.txt",
                                sep = "\t",
                                showProgress = FALSE)

RateLimits <-  fread("./data/RateLimits.txt",
                                sep = "\t",
                                showProgress = FALSE)

Sys.time() - startTime

colourCount = length(unique(comboCities$year))
getPalette = colorRampPalette(brewer.pal(8, "Accent"))

YCrimes <- select(comboCities, ends_with("rate")) %>% names()