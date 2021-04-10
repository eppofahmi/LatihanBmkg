library(tidyverse)
# EKSPLORASI DATA
df0 = data_frame(alamat = c("jakarta", "jakarta", "jakarta", "jogja", "jogja",
                            "jogja", "jogja", "jogja", "bali", "bali", 
                            "bali", "bali", "bali", "bali", "bali", 
                            "bali", "bali", "bali", "bandung", "bandung"))
df1 = df0 %>% 
  count(alamat)

# menghitung persentase ------------------------------------
df1 %>% 
  mutate(porsi = round(prop.table(df1$n)*100, 2)) 

# menghitung derajat ---------------------------------------
df2 = df1 %>% 
  mutate(porsi = round(prop.table(df1$n)*100, 2)) %>% 
  arrange(desc(alamat)) %>% 
  mutate(derajat = cumsum(porsi) - 0.5*porsi)

warna = c("red", "green", "blue", "black")

# membuat plot 
df2 %>% 
  ggplot(aes(x = "", y = porsi, fill = alamat)) + 
  geom_bar(width = 1, stat = "identity") + 
  coord_polar('y', start = 0) + 
  geom_text(aes(y = derajat, label = n), color = "white") + 
  scale_fill_manual(values = warna) + 
  theme_minimal()

# jumlah data yang dimiliki 
mydata = diamonds
glimpse(mydata)
summary(mydata)

library(skimr) # untuk membuat observasi awal
skimr::skim(mydata)

# melakukan observasi relation antar variabel 
plot(mtcars)
glimpse(mtcars)

# membagi variabel/kolom (diskrit atau kontinyu)
glimpse(mydata)

mydata %>% 
  count(cut) %>% 
  ggplot(aes(x = cut, y = n)) + 
  geom_col() + 
  geom_text(aes(label = n))

mydata %>% 
  ggplot(aes(x = cut)) + 
  geom_bar() 

# histogram 
mydata %>% 
  ggplot(aes(x = carat)) + 
  geom_histogram()

# handling NA 
# imputasi / mengisi nilai yang kosong 
skim(mydata)
library(missForest)

mydata2 = prodNA(mydata, noNA = 0.2)
skim(mydata2)
mydata2$cut = as.character(mydata2$cut)

mydata2$cut[is.na(mydata2$cut)] = "KOSONG"
mydata2$depth[is.na(mydata2$depth)] = 0

rerata = round(mean(mydata2$depth), 2)

mydata2 = mydata2 %>% 
  mutate(depth = case_when(
    depth == 0 ~ rerata,
    TRUE ~ depth
  ))

# Mengisi NA dengan imputasi package 
mydata3 = prodNA(iris, noNA = 0.1)
skim(mydata3)

mydata4 = missForest(xmis = mydata3)
mydata5 = mydata4[["ximp"]]
skim(mydata5)

# variabel kontinyu
glimpse(mydata)

mydata %>% 
  ggplot(aes(x = carat, y = depth)) + 
  geom_line()

geom_tile()
mydata %>% 
  count(color, cut)

mydata %>%
  group_by(color) %>% 
  count(cut) %>% 
  ggplot(aes(x = color, y = cut, fill = n)) + 
  geom_tile()