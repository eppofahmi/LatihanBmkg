library(tidyverse)
library(lubridate)

datacuaca_aus = readr::read_csv(file = "data/mentah/weather AUS.csv")
glimpse(datacuaca_aus)

# PR
obj9 <- datacuaca_aus %>% 
  # pilih kolom 1:5
  dplyr::select(1:5) %>% 
  # pilih baris yang bulan ke 5 saja
  dplyr::filter(month(Date) == 5) %>%  
  dplyr::filter(!is.na(MinTemp)) %>% 
  # membuat kolom baru berdasarkan kolom lokasi
  dplyr::group_by(Location) %>% 
  mutate(Rerata = mean(MinTemp))
  
summary(obj9)

# Day-3 --------------------------------------------------
## Row names to column
data1 = mtcars
data1 = data1 %>% 
  rownames_to_column("NamaMobil")

## Memisah dan Menggabungkan Kolom
### Memisahkan separate()
obj8 = obj9 %>% 
  tidyr::separate(Date, into = c("Tahun", "Bulan", "Tanggal"), sep = "-", remove = FALSE)

obj8$Tahun = as.double(obj8$Tahun)
obj8$Bulan = as.double(obj8$Bulan)
obj8$Tanggal = as.double(obj8$Tanggal)
glimpse(obj8)
obj8$DateNum = as.integer(obj8$Date)

# Boleh minta contoh cara filter nilai dengan kriteria tertentu menjadi NA? Misalkan MinTemp > 20 jadi NA

obj7 = obj8 %>% 
  dplyr::filter(MinTemp > 20) %>% 
  dplyr::mutate(MinTemp = NA)

obj7 = obj8 %>% 
  mutate(MinTemp = case_when(
    MinTemp > 20 ~ 100, 
    TRUE ~ MinTemp
  ))

### Menggabungkan kolom -> unite()
obj6 = obj7 %>% 
  ungroup() %>% 
  # dplyr::select(Tahun, Bulan, Tanggal) %>% 
  tidyr::unite(col = "Tanggal", Tahun:Tanggal, sep = "/")

# paste()
# paste0()
obj7 = obj7 %>% 
  ungroup() %>% 
  select(-c(Tanggal2, Tanggal))

obj7$Tanggal2 = paste0(obj7$Tahun, "-",obj7$Bulan)

## Merangkum data
obj5 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  group_by(Location, Rainfall) %>% 
  count(Tahun) 

obj5a = obj5 %>% 
  head(100)

for (i in seq_along(1:nrow(obj5a))) {
  print(paste0("Baris ke-", i))
  if(obj5a$n[i] <= 150){
    obj5a$koreksi[i] = obj5a$n[i] + 1000
  } else {
    obj5a$koreksi[i] = obj5a$n[i]
  }
}

## Visualisasi dengan GGPLOT2
# 1. Menunjukkan Hubungan (scatter)
# 2. Menunjukkan Distribusi (line plot/diagram balok)
# 3. Menunjukkan Komposisi (Pie/diagram balok)
# 4. Menunjukkan Perbandingan (Digaram balok)

## data

### Distribusi
datavis1 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  count(Tahun)

datavis1

datavis1 %>% 
  ggplot(aes(x = Tahun, y = n)) +
  geom_line()

datavis1 %>% 
  ggplot(aes(x = Tahun, y = n)) +
  geom_col()

p1 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  count(Tahun) %>% 
  ggplot(aes(x = Tahun, y = n)) +
  geom_col() +
  ggtitle("Distribusi Data") + 
  labs(x = "Year", y = "Total")
p1

ggsave("plot/plot-dist1.png", width = 15, height = 8, units = "cm", dpi = 300)

# membuat boxplot
p2 = datacuaca_aus %>% 
  ggplot(aes(x = Location, y = MaxTemp)) + 
  geom_boxplot(fill = "grey") +
  theme(axis.text.x = element_text(angle = 90))
p2

# menyimpan plot 
# ggsave(filename = "tes", path = "plot")
ggsave("plot/plot-dist1.png", width = 15, height = 8, units = "cm", dpi = 300)
?ggsave
ggsave(plot = p1, "plot/plot-dist1.jpg", width = 8, height = 5, units = "cm", dpi = 72)

# menggunakan tiga variabel 
datacuaca_aus %>% 
  count(Location, WindGustDir) %>% 
  head(100) %>% 
  ggplot(aes(x = WindGustDir, y = n, fill = Location)) + 
  geom_col(position = "dodge")

## ggplot() membuat
## aes() sumbu x dan y, z
## geom() jenis plot

### Mebuat Plot Hubungan 
p3 = datacuaca_aus %>% 
  head(1000) %>% 
  ggplot(aes(x = MinTemp, y = Rainfall)) + 
  geom_point() + 
  geom_smooth()

### Komparasi 
# geom_bar -> observais
?geom_bar

obj5 %>% 
  filter(str_detect(Location, "Woomera|Adelaide")) %>% 
  ggplot(aes(Tahun,)) + 
  geom_bar()

obj5 %>% 
  ungroup() %>% 
  filter(str_detect(Location, "Woomera|Adelaide")) %>% 
  group_by(Location, Tahun) %>% 
  summarise(total = sum(n)) %>% 
  ggplot(aes(x = Tahun, y = total, fill = Location)) + 
  geom_col(position = "dodge") + 
  facet_wrap(~Location, scales = "free")

### gabungan geom_
data1 %>% 
  ggplot(aes(x = NamaMobil, y = log(mpg))) +
  geom_col() + 
  geom_line(data=data1, aes(x = NamaMobil, y = log(disp)), group = 1) + 
  theme(axis.text.x = element_text(angle = 90))

library(dataplot)

# Visualisasi map
data_hujan = read_csv("data/mentah/pch_ensMean.2021.08_ver_2021.02.01.csv")
library(ggmap)
library(dplyr)
?ggmap

library(dataplot)
library(ggplot2)

df <- data.frame("brand" = c("Samsung", "Huawei", "Apple", "Xiaomi", "OPPO"),
                 "share" = c(10, 30, 20, 35, 5)
                 )
df %>% 
  mutate(total = sum(share)) %>% 
  mutate(persen = share/total * 100)

df1 = obj4 %>% 
  filter(Location == "Adelaide") %>% 
  mutate(total = sum(n)) %>% 
  mutate(persen = n/total * 100)

mycolor <- c("#55DDE0", "#33658A", "#2F4858", "#F6AE2D", "#F26419", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219")

plot_pie(
  data = df1, x = "WindGustDir", y = "n", color = mycolor,
  title = "Lorem Ipsum is simply dummy text",
  subtitle = "Contrary to popular belief, Lorem Ipsum is not simply random text",
  data_source = "Sumber: www.kedata.online")