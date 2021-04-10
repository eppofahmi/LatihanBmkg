library(tidyverse)
library(janitor)
library(readxl)
library(zoo)

df1 <- read_excel("data/mentah/Data Hujan Harian 2010-2019.xlsx")
df1 = janitor::clean_names(df1)
colnames(df1)

# select station 
df2 = df1 %>% 
  select(tahun, hari, s_angin_angin) 

# calculate ep
x = df2$s_angin_angin
ep <- rollapplyr(x, 2, function(x) sum(cumsum(x) / seq_along(x)), fill = NA)

# calculate mean of ep per 5 days
mean_mep = rollmean(ep, 5)

# make sure length of mean mep same with ep
t1 = length(ep) - length(mean_mep)
t2 = c(paste0(0,seq_along(1:t1)))
for (i in seq_along(1:length(t2))) {
  print(t2[i])
  t2[i] = 0
}
t2=as.numeric(t2)

# append data
mean_mep = append(mean_mep, t2)

dep = ep - mean_mep
sd_dep = stats::sd(dep, na.rm = TRUE)

df3 = tibble(ep = ep, dep = dep)
df3$edi = df3$dep/sd_dep

df2 = bind_cols(df2, df3)
df2
