# https://ourcodingclub.github.io/tutorials/maps/
  
library(tidyverse)
library(echarts4r) # baidu
library(rworldmap) # map besar dunia
library(mapview)
library(raster) # map
library(sf) # map sf file
library(sp)

install.packages("echarts4r")

# cara 1 ----
ina = getData('GADM', country = 'Indonesia', level = 2, type = "sp")
data_hujan <- read_csv("data/mentah/pch_ensMean.2021.08_ver_2021.02.01.csv")
class(data_hujan)

locations_sf <- st_as_sf(data_hujan, coords = c("LON", "LAT"), crs = 4326)
class(locations_sf)
mapview(locations_sf)

# cara 2 ----
world <- getMap(resolution = "low")
saf_countries <- c("Indonesia")
world_saf <- world[world@data$ADMIN %in% saf_countries, ]
class(world_saf)

(with_world <- ggplot() +
    geom_polygon(data = world_saf, 
                 aes(x = long, y = lat, group = group),
                 fill = NA, colour = "black") + 
    geom_point(data = data_hujan,  # Add and plot species data
               aes(x = LON, y = LAT, color = VAL)) +
    coord_quickmap() +  # Prevents stretching when resizing
    theme_classic() +  # Remove ugly grey background 
    xlab("Longitude") +
    ylab("Latitude") + 
    guides(colour=guide_legend(title="Value")))

with_world

ggplot() +
  geom_polygon(data = world_saf, 
               aes(x = long, y = lat, group = group),
               fill = NA, colour = "black") + 
  geom_point(data = data_hujan,  # Add and plot species data
             aes(x = LON, y = LAT, color = log10(VAL))) + 
  scale_color_continuous(type = "viridis") + 
  theme_minimal() +
  labs(title = "Map 1")

ggsave("plot/plot-maps1.png", width = 15, height = 8, units = "cm", dpi = 300)

# Visualisasi Menggunakan Echar
# Berdasar api js echart dari baidu
library(echarts4r)

# maps per negara
cns <- countrycode::codelist$country.name.en
cns <- data.frame(country = cns, value = runif(length(cns), 1, 100))

cns %>%
  e_charts(country) %>% # kolom country
  e_map(value) %>% 
  e_visual_map(value)

# maps by lines
flights <- read_csv(
  paste0("https://raw.githubusercontent.com/plotly/datasets/",
         "master/2011_february_aa_flight_paths.csv")
  )

flights %>% 
  e_charts() %>% 
  e_geo() %>% 
  e_lines(start_lon, 
          start_lat, 
          end_lon, 
          end_lat,
          name = "flights",
          lineStyle = list(normal = list(curveness = 0.3))
          ) %>% 
  e_tooltip(trigger = "item")

# install.packages("remotes")
remotes::install_github('JohnCoene/echarts4r.maps')
library(echarts4r.maps)

df <- data.frame(region = c("Indonesia"), 
                 value = c(50)
                 )

df %>% 
  e_charts(region) %>%
  em_map("Indonesia") %>% 
  e_map(value, map = "Indonesia") %>% 
  e_visual_map(value) %>% 
  e_theme("infographic")

# GeoJSON support
json <- jsonlite::read_json("https://raw.githubusercontent.com/shawnbot/topogram/master/data/us-states.geojson")

USArrests = USArrests 
USArrests = USArrests %>% 
  rownames_to_column("states")

USArrests %>%
  e_charts(states) %>%
  e_map_register("USA", json) %>%
  e_map(Murder, map = "USA") %>% 
  e_visual_map(Murder)

# DIY
json1 <- jsonlite::read_json("https://gist.githubusercontent.com/ardianzzz/f8b3392d2c75ef71daa5c0e75bdc14f2/raw/e255ecde29f59b5b3c733dccc054ba3e3d892d01/yogyakarta.geojson")

# json1[["features"]][[1]][["properties"]]$name = "Sleman"
# json1[["features"]][[2]][["properties"]]$name = "Yogyakarta"
# json1[["features"]][[3]][["properties"]]$name = "Gunungkidul"
# json1[["features"]][[4]][["properties"]]$name = "Kulonprogo"
# json1[["features"]][[5]][["properties"]]$name = "Bantul"

tes <- read_csv("data/bersih/tes.csv", trim_ws = FALSE)
tes %>%
  e_charts(kab_kot) %>%
  e_map_register("id", json1) %>%
  e_map(total, map = "id", nameProperty = "region") %>% 
  e_visual_map(total)

# provinsi Indonesia
json2 <- jsonlite::read_json("https://raw.githubusercontent.com/ans-4175/peta-indonesia-geojson/master/indonesia-prov.geojson")

prov = data_frame()
for(i in seq_along(1:33)){
  print(json2[["features"]][[i]][["properties"]][["Propinsi"]])
  
  json2[["features"]][[i]][["properties"]][["name"]] = json2[["features"]][[i]][["properties"]][["Propinsi"]]
  json2[["features"]][[i]][["properties"]][["region"]] = json2[["features"]][[i]][["properties"]][["Propinsi"]]
  
  prov[i, "prop_baru"] = json2[["features"]][[i]][["properties"]][["Propinsi"]]
}

# zona musim
json3 <- jsonlite::read_json("data/bersih/ZOM81-00.json")
for (i in seq_along(1:407)) {
  print(i)
  json3[["features"]][[i]][["properties"]][["name"]] = json3[["features"]][[i]][["properties"]][["PULAU"]]
}

library(readxl)
indo_12_12 <- read_excel("data/bersih/indo_12_12.xlsx")
indo_12_12 <- indo_12_12 %>% 
  rename(Propinsi = Provinsi) %>% 
  mutate(Propinsi = toupper(Propinsi)) %>% 
  filter(Propinsi %in% prov$prop)

indo_12_12 %>%
  e_charts(Propinsi) %>%
  e_map_register("id", json3) %>%
  e_map(T2035, map = "id") %>% 
  e_visual_map(T2035)

# leaflet
url <- "https://echarts.apache.org/examples/data-gl/asset/data/population.json"
data <- jsonlite::fromJSON(url)
data <- as.data.frame(data)

names(data) <- c("lon", "lat", "value")
data$value <- log(data$value)

data_hujan %>%
  e_charts(LON) %>%
  e_leaflet() %>%
  e_leaflet_tile() %>%
  e_scatter(LAT, size = VAL, coord_system = "leaflet")