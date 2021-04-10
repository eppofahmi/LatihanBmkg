# hari ke 5
# Exploratory data analysis (EDA)

library(tidyverse)
library(skimr) # membuat summary

# eksplorasi data -----
df_diamonds = diamonds
?diamonds

glimpse(df_diamonds)
df_diamonds %>% 
  ggplot(aes(x = clarity)) +
  geom_bar()

?glimpse()
glimpse(df_diamonds)

## rangkuman 
summary(df_diamonds) # rangkuman dg fungsi dasar

?skim()
skimr::skim(df_diamonds)

skim_result = skimr::skim(df_diamonds)
write_csv(skim_result, "data/bersih/hasil-skim.csv")

# Menangangi data NA 
library(missForest)
?missForest

# mengisi NA dengan value yang didefinisikan secara manual
diamonds_na = prodNA(df_diamonds, noNA = 0.1)
skim(diamonds_na)

isi_na_carat = mean(diamonds_na$carat)
isi_na_carat

isi_na_z = mean(diamonds_na$z)
isi_na_z

diamonds_na$carat[is.na(diamonds_na$carat)] = isi_na_carat
diamonds_na$z[is.na(diamonds_na$z)] = isi_na_z
skim(diamonds_na)

# mengisi NA dengan value yang didefinisikan secara otomatis menggunakan package
mydata2 = iris
mydata3 = prodNA(iris, noNA = 0.1)
skim(mydata3)

mydata4 = missForest(xmis = mydata3)
mydata5 = mydata4[["ximp"]]
skim(mydata5)

# observasi data dengan plot()
plot(mydata3)

# eksplorasi variabel/kolom -----
## dalam variabel -----
## Jumlah masing value dari variabel/ eksplrasi distribusi observasi
df_diamonds %>% 
  ggplot(aes(x = clarity)) +
  geom_bar()

df_diamonds %>%
  count(cut) %>% 
  ggplot(aes(x = cut, y = n)) + 
  geom_col()

df_diamonds %>% 
  ggplot(aes(x = carat, binwidth = 0.5)) + 
  geom_histogram(binwidth = 1)

df_diamonds %>% 
  count(carat)

df_diamonds %>% 
  count(cut_width(carat, 0.5)) # menghitung jumlah observas berdasarkan rentang

ggplot(df_diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

# untuk melihat jika ada data yang anomali
df_diamonds %>% 
  ggplot(aes(x = y)) + 
  geom_histogram(binwidth = 0.5) + 
  coord_cartesian(ylim = c(0, 58))

df_anomali = df_diamonds %>% 
  count(y)

# eskplorasi distribusi 
df_diamonds %>% 
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot()

# visualisasi missing values ----
library(naniar)

?airquality
df_air = airquality
skim(df_air)
vis_miss(airquality)

weather_AUS <- read_csv("data/mentah/weather AUS.csv", 
                        trim_ws = FALSE)
weather_AUS = weather_AUS %>% 
  sample_n(1000)

vis_miss(weather_AUS)

## antar variabel -----
df_diamonds %>% 
  ggplot(aes(x = price, y = carat)) + 
  geom_point() + 
  geom_smooth(method = "lm")

df_diamonds %>% 
  ggplot(aes(x = price, y = depth)) + 
  geom_point() + 
  geom_smooth(method = "lm")

# dua variabel kategorik
ggplot(data = df_diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

df_diamonds %>% 
  count(cut, color) %>% 
  arrange(desc(n))

df_diamonds %>% 
  count(cut, color) %>% 
  arrange(desc(n)) %>% 
  ggplot(aes(x = cut, y = n, group = color, color = color)) + 
  geom_line() + 
  facet_wrap(~color, "free")

df_diamonds %>% 
  count(cut, color) %>% 
  arrange(desc(n)) %>% 
  ggplot(aes(x = cut, y = n, fill = color)) + 
  geom_col(position = "dodge")

df_diamonds %>% 
  count(color, cut) %>%  
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n)) + 
  geom_text(aes(label = prettyNum(n, ","))) + 
  ggtitle("Jumlah observasi color berdasar cut")

## 2 variable kontinyu 
df_diamonds %>% 
  ggplot(aes(x = carat, y = price)) + 
  geom_point(alpha = 0.2)

ggplot(data = df_diamonds) +
  geom_bin2d(mapping = aes(x = carat, y = price))

# install.packages("hexbin")
ggplot(data = df_diamonds) +
  geom_hex(mapping = aes(x = carat, y = price))

# secondry axs
library(echarts4r)
mtcars %>%
  e_charts(qsec) %>%
  e_line(mpg, y_index = 1) %>% 
  e_line(cyl, y_index = 0)


# menggunakan 3 axis
library(gridExtra)

p1 = weather_AUS %>% 
  ggplot(aes(x = Date, y = MinTemp)) + 
  geom_line() 

p2 = weather_AUS %>% 
  ggplot(aes(x = Date, y = Rainfall)) + 
  geom_line()

p3 = weather_AUS %>% 
  ggplot(aes(x = Date, y = WindGustSpeed)) + 
  geom_line()

library(gridExtra)
p <- rbind(ggplotGrob(p1), ggplotGrob(p2), size="last")
q <- ggplotGrob(p3)
q$heights <- p$heights
grid.arrange(p,q,widths=c(8,1))

# hasilnya maish belum sesuai

# The data have a common independent variable (x)
x <- 1:10

# Generate 4 different sets of outputs
y1 <- runif(10, 0, 1)
y2 <- runif(10, 100, 150)
y3 <- runif(10, 1000, 2000)
y4 <- runif(10, 40000, 50000)
y <- list(y1, y2, y3, y4)

# Colors for y[[2]], y[[3]], y[[4]] points and axes
colors = c("red", "blue", "black")

# Set the margins of the plot wider
par(oma = c(0, 2, 2, 3))

plot(x, y[[1]], 
     yaxt = "n", 
     xlab = "Common x-axis", 
     main = "A bunch of plots on the same graph", 
     ylab = "")

lines(x, y[[1]])

# We use the "pretty" function go generate nice axes
axis(at = pretty(y[[1]]), side = 2)

# The side for the axes.  The next one will go on 
# the left, the following two on the right side
sides <- list(2, 4, 4) 

# The number of "lines" into the margin the axes will be
lines <- list(2, NA, 2)

for(i in 2:4) {
  par(new = TRUE)
  plot(x, y[[i]], axes = FALSE, col = colors[i - 1], xlab = "", ylab = "")
  axis(at = pretty(y[[i]]), side = sides[[i-1]], line = lines[[i-1]], 
       col = colors[i - 1])
  lines(x, y[[i]], col = colors[i - 1])
}

## Pola dan model 
ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))

library(modelr)
mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))
