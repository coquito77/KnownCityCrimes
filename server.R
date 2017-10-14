# library(shiny)
# library(mapview)
# library(sp)

# server.R

## Define server logic required to generate and plot

shinyServer(function(input,output,session) {

  set <- reactive({
    subset(comboCities, County == input$x)

  })
#
#   data(meuse)
#   coordinates(meuse) <- ~x+y
#   proj4string(meuse) <- CRS("+init=epsg:28992")
#
#   data(meuse.grid)
#   coordinates(meuse.grid) <- ~x+y
#   proj4string(meuse.grid) <- CRS("+init=epsg:28992")
#   gridded(meuse.grid) <- TRUE
#
#   m <- mapview(meuse.grid, zcol = "dist") + meuse
#
#   output$mapplot <- renderMapview(m)
#
#   })


  output$plotCitiesCounties <- renderPlot({

    setCities <- subset(comboCities, County == input$x)

    countyLimitsFiltered <- subset(countyLimits, id == input$x)

    CrimeLimits <- RateLimits %>%
      filter( County == input$x,
              Crime == input$y) %>%
      ungroup() %>%
      select(CrimLimit)

    CrimeLimits <- CrimeLimits$CrimLimit


    califCitiesWithLabelsFiltered <- subset(califCitiesWithLabels, County == input$x)

    longMax <- countyLimitsFiltered$longMax*-1
    LongMin <- countyLimitsFiltered$LongMin*-1
    latMax <- countyLimitsFiltered$latMax
    LatMin <- countyLimitsFiltered$LatMin

    environment <- environment()

    ranges <- reactiveValues(x = NULL, y = NULL)

    setCities %>%
      ggplot( environment = environment) +
      geom_polygon(aes(long, lat, group = group, fill = get(input$y)),
                   # fill="grey40",
                   colour = "grey90",
                   alpha = .7,
                   size = .05) +
      scale_fill_gradientn(name = "Crime Rate \nper 100,000 \nresidents ",
                           colours = rainbow(7),
                           limits = c(0, CrimeLimits)) +
      # geom_text(aes(label = Names, x = Longitude, y = Latitude), size = 1) +
      geom_polygon(data = frtfCaCounties, aes(long,
                                              lat,
                                              group = group),
                   fill = "khaki",
                   color = "red",
                   alpha = .2,
                   size = 0.1) +
      coord_map(xlim = -c(longMax, LongMin), ylim = c(latMax, LatMin)) +
      theme_minimal() +
      facet_wrap(~ year,  ncol = 3) +
      theme(axis.title.x = element_text(size = 8,
                                        angle = 00),
            axis.text.x = element_text(colour = "black",
                                       size = 5,
                                       angle = 00,
                                       vjust = 1),
            axis.title.y = element_text(size = 8,
                                        angle = 90),
            axis.text.y = element_text(colour = "black",
                                       size = 5,
                                       angle = 00,
                                       vjust = .5),
            #axis.title.y = element_blank(),
            #axis.title.x = element_blank(),    # remove axis titles
            # panel.grid.major = element_blank(),
            # panel.grid.minor = element_blank(),   # remove gridlines
            panel.border = element_rect(fill = NA,
                                        colour = "grey50"),
            # axis.text.x = element_blank(),
            # axis.ticks.x = element_blank(),   # remove x-axis labels and ticks
            # plot.margin = unit(c(0,0,0,0), "cm"),  #T, R, B, L
            # legend.margin = unit(-.5, "cm"),
            legend.position = "top",
            legend.title = element_text(size = 8,
                                        colour = "blue", angle = 00),
            legend.text = element_text(size = 8,
                                       colour = "red", angle = 00))


  })


  output$graph <- renderPlot({

    setCities <- subset(comboCities, County == input$x)

    environment <- environment()

    setCities %>%
      distinct() %>%
      ggplot(aes(get(input$y), City),
             environment = environment) +
      geom_point(aes(colour = factor(year),
                     shape = factor(year)),
                 size = 5) +
      scale_x_continuous(trans = log_trans(),
                         breaks = c(5, 10, 100, 1000, 10000, 50000),
                         labels = comma_format())+
      scale_shape_manual(name = "Rate",
                         values = c(0:6)) +
      scale_color_manual(values = getPalette(colourCount),
                         name = "Rate",
                         guide = guide_legend(keywidth = .5,
                                              keyheight = .5,
                                              direction = "vertical",
                                              title.position = "left",
                                              label.position = "right",
                                              label.hjust = 0,
                                              label.vjust = 0,
                                              ncol = 3,
                                              byrow = TRUE,
                                              title.theme = element_text(size = 5,
                                                                         colour = "black",
                                                                         angle = 00),
                                              label.theme = element_text(size = 6,
                                                                         colour = "black",
                                                                         angle = 00))) +
      theme_minimal() +
      xlab("Crime Rate per 100,000 residents (log scale)") +
      ylab("City") +
      theme(axis.text.x = element_text(angle = 00,
                                       vjust = 0.5,
                                       size = 10),
            axis.title.y = element_text(size = 12,
                                        colour = "blue",
                                        face = "bold",
                                        angle = 90),
            axis.text.y = element_text(colour = "black",
                                       size = 12,
                                       angle = 00,
                                       vjust = .5),
            legend.position = "top") +
      guides(colour = guide_legend(override.aes = list(alpha = 1)))


  })

  output$mytable3 <- DT::renderDataTable({

    setSuspects <- subset(suspects, County == input$x,
                          select = -County)

    DT::datatable(setSuspects,
                  caption = 'Table 1: Known crime counts that deviate from Benford`s law.',
                  options = list(lengthMenu = c(5, 30, 50), pageLength = 30))
  })

  output$downloadData <- downloadHandler(

    # This function returns a string which tells the client
    # browser what name to use when saving the file.
    filename = function() {
      paste("DownloadFile", Sys.time(), input$filetype, sep = ".")
    },

    # This function should write data to a file given to it by
    # the argument 'file'.
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")

      # Write to a file specified by the 'file' argument
      write.table(setSuspects(), file, sep = sep,
                  row.names = FALSE)
    })

})