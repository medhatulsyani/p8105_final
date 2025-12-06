library(tidyverse)
library(stringr)
library(leaflet)
library(tigris)
options(tigris_use_cache = TRUE)
library(sf)
library(RColorBrewer)
library(flexdashboard)
library(shiny)
library(here)

#import data, to run in rstudio, use read.csv(here("shiny_app", "traffic_clean.csv")), to deploy use read.csv("traffic_clean.csv")
traffic_shiny = read.csv("traffic_clean.csv") %>% 
  group_by(segment_id, yr) %>% 
  summarize(
    total_volume = round(sum(vol, na.rm = TRUE), digits = 2), 
    avg_volume = round(mean(vol, na.rm = TRUE), digits = 2), 
    across(everything(), ~first(.)),
    .groups = "drop"
  ) %>% 
  st_as_sf(wkt = "wkt_geom", crs = 2263) %>%  #convert WKT to sf
  st_transform(4326) %>% 
  rename("borough" = boro) %>% 
  mutate(
    lon = st_coordinates(wkt_geom)[,1],
    lat = st_coordinates(wkt_geom)[,2]
  )

#to run in rstudio, use read.csv(here("shiny_app", "aed_clean.csv")), to deploy use read.csv("aed_clean.csv")
aed_inventory_df <- read.csv("aed_clean.csv")

aed_clean = aed_inventory_df %>%
  mutate(location = str_replace(location_point,"^POINT\\s*", "")
  )
ui <- fluidPage(
  titlePanel("AED and Traffic Volume Map"),
  
  sidebarLayout(
    sidebarPanel(
      #borough Select Input
      checkboxGroupInput(
        "borough_choice", 
        label = h3("Select Borough(s)"),
        choices = traffic_shiny %>% distinct(borough) %>% pull(),
        selected = "Manhattan"
      ),
      
      #traffic Volume Slider Input
      sliderInput(
        "volume_range", 
        label = h3("Choose Traffic Volume Range"), 
        min = min(traffic_shiny$avg_volume), 
        max = max(traffic_shiny$avg_volume), 
        value = c(100, 400)
      ),
      
      #year check box
      checkboxGroupInput(
        "year_choice",
        label = h3("Select Year(s)"),
        choices = traffic_shiny %>% distinct(yr) %>% pull(),
        selected = "2019"
      )
    ),
    
    mainPanel(
      leafletOutput("map")
    )
  )
)

#server logic
server <- function(input, output, session) {
  
  #to filter traffic and aed data based on user inputs
  filtered_traffic <- reactive({
    traffic_shiny %>%
      filter(
        borough %in% input$borough_choice,
        avg_volume >= input$volume_range[1],
        avg_volume <= input$volume_range[2],
        yr %in% as.integer(input$year_choice)
      )
  })
  
  filtered_aed <- reactive({
    aed_clean %>%
      filter(borough == input$borough_choice)
  })
  
  output$map <- renderLeaflet({
    #filtered traffic and aed data setup for map
    filtered_traffic_data = filtered_traffic()
    filtered_aed_data = filtered_aed()
    
    leaflet() %>% 
      addProviderTiles(providers$CartoDB.Positron) %>%
      addAwesomeMarkers(
        data = filtered_aed_data, 
        lng = ~longitude, 
        lat = ~latitude, 
        icon = ~icons,
        popup = ~paste0(
          "<b>Location Name: </b>", entity_name, "<br>",
          "<b>Number of AEDs: </b>", aed_num_aeds, "<br>",
          "<b>Location: </b>", location, "<br>",
          "<b>Borough: </b>", borough, "<br>",
          "<b>Trained Personnel: </b>", aed_num_person_trained),
        clusterOptions = markerClusterOptions(),
        group = "AED_locations"
      ) %>% 
      addCircleMarkers(
        data = filtered_traffic_data,
        lng = ~lon,
        lat = ~lat,
        radius = 3,
        color = ~colorNumeric("RdYlBu", avg_volume)(avg_volume),
        fillOpacity = 0.7,
        popup = ~paste0(
          "<b>Street: </b>", street, "<br>",
          "<b>Total Volume: </b>", total_volume, "<br>",
          "<b>Average Volume: </b>", avg_volume, "<br>"), 
        group = "traffic_volume"
      ) %>%
      addLayersControl(
        overlayGroups = c("AED_locations", "traffic_volume"),
        options = layersControlOptions(collapsed = FALSE)
      )
  })
}

# run shiny
shinyApp(ui = ui, server = server)
