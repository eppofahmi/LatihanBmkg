# exploratory data analytics
library(tidyverse)
library(echarts4r)

# load data
datacuaca_aus = readr::read_csv(file = "data/mentah/weather AUS.csv")

# Rangkuman umum -------------------------
## Mengetahui isi data
glimpse(datacuaca_aus)
summary(datacuaca_aus)

## Memvisualisasikan Distribusi -------------------
## variabel kontinyu ------------------------------
datacuaca_aus %>% 
  ggplot(aes(x = Location)) + 
  geom_bar() + 
  coord_flip()

datacuaca_aus %>% 
  ggplot(aes(x = MinTemp)) + 
  geom_histogram(binwidth = 5)

datacuaca_aus %>% 
  count(cut_width(MinTemp, 5))
