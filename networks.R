library(surveillance)
library(tidyverse)
library(statnet)
library(ggraph)
library(tidygraph)
library(igraph)
library(ggplot2)
library(ggforce)
data("hagelloch")
# head(hagelloch.df)

edges <- hagelloch.df %>% 
  select(IFTO, PN) %>%  # edge lists take the source of the connection first
  filter(!is.na(IFTO)) # not every patient has a known source of infection

measles_net <- network(edges, matrix.type = "edgelist")

my_arrow <- arrow(length = unit(.1, "inches"), type = "closed")
ggraph(measles_net, layout = 'kk') +
  geom_edge_link(arrow = my_arrow, end_cap = circle(1, "mm")) +
  geom_node_point(color = "red") +
  theme_no_axes()

vertex_attrs <- hagelloch.df %>% 
  select(AGE, SEX, CL) %>% 
  mutate(SEX = as.character(SEX), CL = as.character(CL))

measles_net %v% names(vertex_attrs) <- vertex_attrs

plot_base = ggraph(measles_net, layout = 'kk') +
  geom_edge_link(arrow = my_arrow, end_cap = circle(1, "mm")) +
  theme_no_axes()

plot_base + geom_node_point(aes(color = SEX), size = 3)
plot_base + geom_node_point(aes(color = AGE), size = 3)
plot_base + geom_node_point(aes(color = CL), size = 3)
