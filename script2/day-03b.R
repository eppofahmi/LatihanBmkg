library(tidyverse)
library(lubridate)

datacuaca_aus = readr::read_csv(file = "data/mentah/weather AUS.csv")
glimpse(datacuaca_aus)

# PR 3 ------
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
has_rownames(data1) # TRUE

data1 = data1 %>% 
  rownames_to_column("NamaMobil")
has_rownames(data1) # FALSE

?rownames_to_column

## Memisah dan Menggabungkan Kolom
### Memisahkan separate()
Sys.Date() # ymd
Sys.time() # ymd hms

obj1a = datacuaca_aus %>% 
  tidyr::separate(col = Date, into = c("Tahun", "Bulan", "Tanggal"), sep = "-", remove = FALSE)

t1 = data.frame(Date = as.character(Sys.time()))
class(t1)

separate(t1, Date, into = c("Tanggal", "Jam"), sep = " ")
glimpse(obj1a)

obj1a$Tahun = as.double(obj1a$Tahun)
obj1a$Bulan = as.double(obj1a$Bulan)
obj1a$Tanggal = as.double(obj1a$Tanggal)
glimpse(obj1a)

obj1a$DateNum = as.integer(obj1a$Date)
glimpse(obj1a)

# Boleh minta contoh cara filter nilai dengan kriteria tertentu menjadi NA? Misalkan MinTemp > 20 jadi NA

obj1b = obj1a %>% 
  dplyr::filter(MinTemp > 20) %>% 
  dplyr::mutate(MinTemp = NA)

obj1b = obj1a %>% 
  mutate(MinTemp = case_when(
    MinTemp > 20 ~ 100, 
    TRUE ~ MinTemp
  ))

### Menggabungkan kolom -> unite()
obj1c = obj1a %>% 
  ungroup() %>% 
  tidyr::unite(col = "Date2", Tahun:Tanggal, sep = " dan ")

obj1c$newVar = paste(obj1c$RainTomorrow, "dan", obj1c$DateNum)
glimpse(obj1c)

# paste()
# paste0()
obj1d = obj1c %>% 
  ungroup() %>% 
  select(-c(DateNum, newVar))

## Merangkum data
obj5 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  group_by(Location, RainTomorrow) %>% 
  count(Tahun) 

obj6 = datacuaca_aus %>% 
  filter(year(Date) == 2008) %>% 
  filter(Rainfall >= 50)

# ambil data teratas sejumlah n
obj7 = obj6 %>% 
  head(2)

# ambil data terbawah sejumlah n
obj7 = obj6 %>% 
  tail(2)

# sorting/mengurutkan dari besar/kecil atau sebaliknya
obj6 = obj6 %>% 
  arrange(desc(Rainfall))

obj6 = obj6 %>% 
  arrange(Rainfall)

for (i in seq_along(1:nrow(obj6))) {
  print(paste0("Baris ke-", i))
  if(obj6$MinTemp[i] <= 15){
    obj6$koreksiMinTemp[i] = obj6$MinTemp[i] + 100
  } else {
    obj6$koreksiMinTemp[i] = obj6$MinTemp[i]
  }
}

# Hal di atas bisa juga dikerjakan dengan case_when. Tapi tidak bisa dengan cara membuat kolom langsung
obj6$koreksiMinTemp = obj6$MinTemp + 100

## Visualisasi dengan GGPLOT2 ----
# GG = grammar of graphic (sumbu x,y + z, tipe plot)

# 1. Menunjukkan Hubungan (scatter)
# 2. Menunjukkan Distribusi (line plot/diagram balok)
# 3. Menunjukkan Komposisi (Pie/diagram balok)
# 4. Menunjukkan Perbandingan (Digaram balok)

### Distribusi

### Tujuan: memberikan informasi tentang distribusi data dalam tahun tertentu
## data
datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  count(Tahun)

datavis1 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  count(Tahun)

datavis1$Tahun = as.character(datavis1$Tahun)

datavis1a = datavis1 %>% 
  filter(n == min(n) | n == max(n))

datavis1 %>% 
  ggplot(aes(x = Tahun, y = n)) + 
  geom_col()

personal_theme = theme(plot.title = element_text(hjust = 0.5))

datavis1 %>% 
  ggplot(aes(x = Tahun, y = n, group = 1)) + 
  geom_line() + 
  geom_text(data = datavis1a, aes(x = Tahun, y = n, label = n)) + 
  theme(plot.title = element_text(hjust = 0.5)) + 
  labs(title = "Judul Plot")

p1 = datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  count(Tahun) %>% 
  ggplot(aes(x = Tahun, y = n)) +
  geom_col() +
  ggtitle("Distribusi Data") + 
  labs(x = "Year", y = "Total")

class(p1)

# https://bbc.github.io/rcookbook/#how_to_create_bbc_style_graphics
datavis1

datavis1 %>% 
  ggplot(aes(x = Tahun, y = n)) + 
  geom_line() + 
  geom_text(aes(label = n)) +
  labs(title = "Distribusi observasi pertahun", x = "Year", y = "Total", 
       caption = "Source: NOAA")

dv1 = datacuaca_aus %>% 
  count(Date)

# dv1$Date = as.character(dv1$Date)

dv1 %>% 
  ggplot(aes(Date, n, group = 1)) + 
  geom_line()

# menyimpan plot terakhir yang dibuat
ggsave(filename = "plot/plot-observasi.png", width = 15, 
       height = 8, units = "cm", dpi = 300)

# menyimpan plot dari sebuah objek
ggsave(plot = p1, filename = "plot/observasi2.png", width = 10, height = 5, units = "cm", dpi = 100)


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
  count(Location, WindGustDir)

datacuaca_aus %>% 
  count(Location, WindGustDir) %>% 
  head(100) %>% 
  ggplot(aes(x = WindGustDir, y = n, fill = Location)) + 
  geom_col(position = "dodge")

# geom_bar
datacuaca_aus %>% 
  ggplot(aes(x = Location)) + 
  geom_bar() + 
  coord_flip() # digunakan untuk memutar balik x dan y

## ggplot() membuat
## aes() sumbu x dan y, z
## geom() jenis plot

### Mebuat Plot Hubungan
plot3 = datacuaca_aus %>% 
  head(1000) %>% 
  ggplot(aes(x = MinTemp, y = Rainfall)) + 
  geom_point() + 
  geom_smooth(method = "glm")

plot3

### Komparasi 
# geom_bar -> observais
?geom_bar

datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  filter(str_detect(Location, "Woomera|Adelaide")) %>% 
  ggplot(aes(Tahun)) + 
  geom_bar()

datacuaca_aus %>% 
  mutate(Tahun = year(Date)) %>% 
  filter(str_detect(Location, "Woomera|Adelaide")) %>%
  count(Location, Tahun) %>% 
  ggplot(aes(x = as.character(Tahun), y = n, fill = Location)) + 
  geom_col(position = "dodge") + 
  facet_wrap(~Location, scales = "free_y") + # digunakan untuk membuat 1 plot menjadi 2 bagian
  labs(x = "Tahun", y = "Jumlah")

data_bulan = data.frame(
  bulan = c("Februari", "Januari", "Maret", "April"), 
  nilai = c(10, 5, 20, 8), stringsAsFactors = FALSE
)

data_bulan$bulan = as.factor(data_bulan$bulan) # membuat data string menjadi punya urutan/level
levels(data_bulan$bulan) = c("Januari",  "Februari", "Maret", "April")

levels(data_bulan$bulan) # level factor
glimpse(data_bulan)

data_bulan %>% 
  ggplot(aes(x = as.factor(bulan), y = nilai)) + 
  geom_col()

### gabungan geom_
data1 = mtcars
data1 = data1 %>% 
  rownames_to_column("NamaMobil")

data1 %>% 
  ggplot(aes(x = NamaMobil, y = log(mpg))) +
  geom_col()

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

mu <- c(-95.3632715, 29.7632836); nDataSets <- sample(4:10,1)
chkpts <- NULL
for(k in 1:nDataSets){
  a <- rnorm(2); b <- rnorm(2);
  si <- 1/3000 * (outer(a,a) + outer(b,b))
  chkpts <- rbind(
    chkpts,
    cbind(MASS::mvrnorm(rpois(1,50), jitter(mu, .01), si), k)
  )
}

chkpts <- data.frame(chkpts)
colnames(chkpts) <- c("lon", "lat","class")
chkpts$class <- factor(chkpts$class)
levels(chkpts$class)

qplot(lon, lat, data = chkpts, colour = class)

# pie chart 
library(dataplot)
library(ggplot2)

df <- data.frame("brand" = c("Samsung", "Huawei", "Apple", "Xiaomi", "OPPO"),
                 "share" = c(10, 30, 20, 35, 5)
                 )

df %>% 
  mutate(total = sum(share)) %>% 
  mutate(persen = share/total * 100)

df1 = datacuaca_aus %>% 
  filter(str_detect(Location, "Adelaide|Woomera")) %>% 
  count(Location) %>% 
  mutate(total = sum(n)) %>%
  mutate(persen = n/total * 100)

mycolor <- c("red", "green", "green", "#F6AE2D", "#F26419", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219", 
             "#55DDf1", "#33858A", "#2F4859", "#F5AE2D", "#F26219")


plot_pie(data = df1, x = "Location", y = "n", color = mycolor, 
         title = "Lorem Ipsum is simply dummy text",
         subtitle = "Contrary to popular belief, Lorem Ipsum is not simply random text",
         data_source = "Sumber: www.kedata.online")

df1

plot_pie(
  data = df, x = "brand", y = "share", color = mycolor,
  title = "Lorem Ipsum is simply dummy text",
  subtitle = "Contrary to popular belief, Lorem Ipsum is not simply random text",
  data_source = "Sumber: www.kedata.online"
)

# untuk membaca/mengimpor data dalam jumlah sangat besar https://vroom.r-lib.org/

# Create Data
data <- data.frame(
  group=LETTERS[1:5],
  value=c(13,7,9,21,2)
)

# Basic piechart
ggplot(data, aes(x="", y=value, fill=group)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0) + # berfungsi untuk membentuk lingkaran
  theme_minimal()
