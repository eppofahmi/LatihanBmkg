library(tidyverse)
# Loading geo json data
library(jsonlite)
json3 <- jsonlite::read_json("data/bersih/ZOM81-00.json")
# zomlite = json3[["features"]][1:30]

zom = data_frame()
for (i in seq_along(1:407)) {
  print(i)
  json3[["features"]][[i]][["properties"]][["name"]] = json3[["features"]][[i]][["properties"]][["NO_ZOM"]]
  zom[i, "zona"] = json3[["features"]][[i]][["properties"]][["NO_ZOM"]]
}

zom$update1 = sample(1:12, 407, replace=T)

# visualiasi dengan echart
library(echarts4r)
plot1 <- zom %>%
  e_charts(zona) %>%
  e_map_register("id", json3) %>%
  e_map(update1, map = "id") %>% 
  e_visual_map(update1)

plot1

htmltools::save_html(plot1, file = "plot/zom2.html")

# membuat bar chart 

df <- data.frame(x = seq(50),
                 y = rnorm(50, 10, 3),
                 z = rnorm(50, 11, 2),
                 w = rnorm(50, 9, 2)
                 )

df %>% 
  e_charts(x) %>% 
  e_line(z) %>% 
  e_area(w) %>% 
  e_title("Line and area charts") %>% 
  e_theme("dark")

df %>% 
  e_chart(x) %>% # sumbu x plot
  e_bar(y, name = "Produk") %>% # jenis plot
  e_line(z, name = "Harga") %>% # jenis plot
  e_area(w, name = "Jumlah") %>% # jenis plot
  e_color(c("#0057e7","red", "grey")) %>%  # mewaranai secara manual
  e_tooltip(trigger = "item") %>%  # memberi tooltip saat di hoover (axis/item) 
  e_legend(left = 0) %>% 
  e_zoom(start = 20, end = 40, dataZoomIndex = 0, btn = "BUTTON") %>%
  e_button("BUTTON", "Zoom in") 
  # e_theme("roma")

# secondary axis
mtcars %>%
  e_charts(qsec) %>%
  e_line(mpg)
points <- mtcars[1:3, ]

mtcars %>%
  e_charts_("qsec") %>%
  e_line(mpg) %>%
  e_data(points, qsec) %>%
  e_scatter(mpg, color = "blue")

cars %>%
  e_charts(dist) %>%
  e_scatter(speed) %>%
  e_datazoom() %>%
  e_zoom(dataZoomIndex = 0,
         start = 20,
         end = 40,
         btn = "BUTTON"
         ) %>%
  e_button("BUTTON", "Zoom in")


# data 3d map 
choropleth <- data.frame(
  countries = c("France", "Brazil", "China", "Russia", "Canada", "India", "United States",
                "Argentina", "Australia"),
  values = round(runif(9, 10, 25))
)

choropleth %>% 
  e_charts(countries) %>% 
  e_map_3d(values, shading = "lambert") %>% 
  e_visual_map(values) # scale to values

# data yang beruhba
df <- data.frame(
  year = c(
    rep(2016, 25),
    rep(2017, 25),
    rep(2018, 25),
    rep(2019, 25)
  ),
  x = rnorm(100),
  y = rnorm(100),
  grp = c(
    rep("A", 50),
    rep("B", 50)
  )
) 

df %>%
  group_by(year) %>% 
  e_charts(x, timeline = TRUE) %>% 
  e_scatter(y, symbol_size = 5)

# Membuat windrose
library(tidyverse)
library(clifro)

# Create some dummy wind data with predominant south to westerly winds, and
# occasional yet higher wind speeds from the NE (not too dissimilar to
# Auckland).

wind_df = data.frame(wind_speeds = c(rweibull(80, 2, 4), rweibull(20, 3, 9)),
                     wind_dirs = c(rnorm(80, 135, 55), rnorm(20, 315, 35)) %% 360,
                     station = rep(rep(c("Station A", "Station B"), 2),
                                   rep(c(40, 10), each = 2)))

# Create custom speed bins, add a legend title, and change to a B&W theme
with(wind_df, windrose(wind_speeds, wind_dirs,
                       speed_cuts = c(3, 6, 9, 12), # klasifikasi 
                       legend_title = "Wind Speed\n(m/s)",
                       legend.title.align = .5,
                       ggtheme = "minimal",
                       col_pal = "Accent"))

# nama warna untuk dimasukkan ke dalam parameter col_pal 
# "Accent", "Dark2", "Paired", "Pastel1", "Pastel2", 
# "Set1", "Set2", "Set3"

# The sequential palettes names are 
# Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd

# All the sequential palettes are available in variations from 3 different values up to 9 different values.

# The diverging palettes are 
# BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
# 
# All the diverging palettes are available in variations from 3 different values up to 11 different values.
# Note that underscore-separated arguments come from the windrose method, and
# period-separated arguments come from ggplot2::theme().

# Save the plot as a png to the current working directory
library(ggplot2)
ggsave("my_windrose.png")