
shinyUI(fluidPage(

  titlePanel("California cities crime rates"),

  sidebarLayout(

    sidebarPanel(width = 2,

      selectInput('x','County Name', unique(frtfCaCounties$id)),
      " ",

      selectInput('y', 'Crime Type', YCrimes, YCrimes)

    ),
    mainPanel(
      tabsetPanel(
        tabPanel("City rates map", plotOutput("counts", height = "1000px")),
        tabPanel("City rate graph", plotOutput("graph", height = "1000px")),
        tabPanel("Benford's Law deviations", DT::dataTableOutput('mytable3')),

        tabPanel("Data Source and other information",
                 p("This report uses data from the FBI UCR tables to get known crimes rates by year for different cities in California."),
                 br(),
                 strong("Data souces for this analysis:"),
                 br(),
                 p("[City crimes rates from FIB table 8](http://www.fbi.gov/about-us/cjis/ucr/crime-in-the-u.s/)"),
                 p("[City of California shapefile](http://www.dot.ca.gov/hq/tsip/gis/datalibrary/Metadata/cities.html)"),
                 p("[Counties shape file from U.S. Census](https://www.census.gov/geo/maps-data/data/cbf/cbf_counties.html)"),

                 p("[Benford's law](https://en.wikipedia.org/wiki/Benford's_law)"),

                 br(),
                 p("The FBI data has the following disclaimer:"),

                 p("Caution against ranking"),
                 p("Figures used in this Report were submitted voluntarily by law enforcement agencies throughout the country. Individuals using these tabulations are cautioned against drawing conclusions by making direct comparisons between cities. Comparisons lead to simplistic and/or incomplete analyses that often create misleading perceptions adversely affecting communities and their residents. Valid assessments are possible only with careful study and analysis of the range of unique conditions affecting each local law enforcement jurisdiction. It is important to remember that crime is a social problem and, therefore, a concern of the entire community. In addition, the efforts of law enforcement are limited to factors within its control. The data user is, therefore, cautioned against comparing statistical data of individual agencies. Further information on this topic can be obtained in Uniform Crime Reporting Statistics:  Their Proper Use."),

                 p("Note: if you can not locate a city it is because there is no FBI UCR data for it, or it is not on the shapefile for cities"))

      )
    )
  )
))