library(tidyverse)
library(readxl)
library(scales)

df_hujan_day <- read_excel("data/bersih/edi/edi-g_wanagama.xlsx")
df_hujan_day <- df_hujan_day %>% 
  filter(tahun == "2017")
df_hujan_day$id = seq_along(1:nrow(df_hujan_day)) 

df_hujan_month <- df_hujan_day %>% 
  filter(nchar(hari) >= 3)

set.seed(101)
x <- df_hujan_day$id
y <- df_hujan_day$edi
## second data set on a very different scale
z <- df_hujan_day$g_wanagama

## second data set on a very different scale
x1 = df_hujan_month$tanggal
y1 = df_hujan_month$edi

par(mar = c(5, 4, 4, 4) + 0.3)  # Leave space for z axis
plot(x, y, type = "l", pch=16, col = "red", xaxt="n",
     ylab = "Daily Edi and Monthly SPI", xlab = "Days since 01 Jan 2010") # first plot
axis(1, at = seq(0, 365, by = 30), las=1, cex.axis = .7)
par(new = TRUE)
plot(x, z, type = "o", pch=19, axes = FALSE, bty = "n", xlab = "", ylab = "", col = "green") # 2nd plot
axis(side=4, at = pretty(range(z)))
mtext("Daily Precipitation, P(mm)", side=4, line=3)
# Add a legend
legend("topleft", legend=c("Daily EDI", "Daily P", "Monthly SPI"),
       col=c("red", "green", "black"), lty=1:4, cex=0.8)
par(new = TRUE)
plot(x1, y1, type = "o", pch=18, axes = FALSE, bty = "n", xlab = "", ylab = "", col = "black") # 3rd plot
axis(3, x1, format(x1, "%b"), cex.axis = .7)