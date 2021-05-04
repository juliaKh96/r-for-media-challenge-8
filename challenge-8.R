# Challenge #8: Inzidenzzahlen der Hamburger Bezirke

# Lade den Datensatz stadtteile_wsg84.RDS **(vllt. bezirke_wsg84.rds(?))**
# Recherchiere die Fallzahlen der letzten sieben Tage für die Hamburger Bezirke
# https://www.hamburg.de/corona-zahlen/
# Erstelle eine leaflet Map und visualisiere die Inzidenzzahlen (Achtung: Nicht die Fallzahlen)
# Nutze dafür Shapes, Legende, Hovereffekte und Labels
# Exportiere die Map als HTML file

library(tidyverse)
library(leaflet)
library(purrr)
library(plotly)
library(sf)
library(htmltools)

getwd()

profil <- readRDS("data/stadtteil_profil.rds")

stadtteile <- stadtteile %>% 
  rename(stadtteil = Stadtteil,bezirk=Bezirk)



bezirke <- readRDS("data/bezirke_wsg84.RDS")

bezirke<-bezirke %>% 
  st_as_sf() %>% 
  st_transform('+proj=longlat +datum=WGS84')

inzidenz <- c(31.7, 16.5, 13.2, 13.8, 25.3, 7.8, 13.1)

stadtteile <- stadtteile %>% 
  left_join(profil) %>% 
  st_as_sf()

bins <- c(0, 5, 10, 20, 30, 40, 50)
pal <- colorBin("BuPu", domain = inzidenz, bins = bins2)
labels <- sprintf("<strong>%s</strong><br>Inzidenz: %g", 
                   bezirke$Bezirk_Name, inzidenz) %>% 
  map(HTML) 

leaflet(data = bezirke) %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  setView(lng = 9.993682, lat = 53.551086, zoom = 9) %>% 
  addPolygons(
    fillColor = ~pal(inzidenz),
    weight = 1.7,
    opacity = 0.7,
    color = "#E1FDFE",
    fillOpacity = 0.7,
    highlight = highlightOptions(
      weight = 3,
      color = "#29426F",
      bringToFront = TRUE,
      fillOpacity = 0.5),
    label = labels) %>% 
  addLegend(pal = pal, values = ~inzidenz, 
            opacity = 0.6, title = "Inzidenz der letzten 7 Tage", position = "bottomleft")
