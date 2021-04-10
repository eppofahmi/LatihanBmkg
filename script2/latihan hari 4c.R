library(echarts4r)

df <- data.frame(
  x = seq(50),
  y = rnorm(50, 10, 3),
  z = rnorm(50, 11, 2),
  w = rnorm(50, 9, 2)
)

glimpse(df)

df %>% 
  e_charts(x) %>% 
  e_line(z) %>% 
  e_bar(w) %>% 
  e_title("Line and area charts") %>% 
  e_tooltip(trigger = "axis") %>% 
  # e_color(c("#ffa700", "#d62d20"), "#0057e7")
  e_theme("dark-bold")


# pie chart di echart
eplot1 = mtcars %>% 
  head() %>% 
  dplyr::mutate(model = row.names(.)) %>% 
  e_charts(model) %>% 
  e_pie(carb) %>% 
  e_title("Pie chart") %>% 
  e_theme("dark") %>% 
  e_tooltip(trigger = "item")

htmltools::save_html(eplot1, "plot/piechrrt1.html")

df <- data.frame(
  x = c(
    rnorm(100),
    runif(100, -5, 10),
    rnorm(100, 10, 3)
  ),
  grp = c(
    rep(LETTERS[1], 100),
    rep(LETTERS[2], 100),
    rep(LETTERS[3], 100)
  )
)

df %>% 
  group_by(grp) %>% 
  # ungroup() %>% 
  e_charts() %>% 
  e_boxplot(x) %>% 
  e_tooltip("axis")
