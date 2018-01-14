library(igraph)
library(readr)

# plot network ----
"#BD0026"

qual_filtered_components_labeled <-
  read_rds("data/census/qual_filtered_components_labeled.rds")

g <- read_rds("data/census/geometry_graph_strict_nd.rds")

g_components <- components(g)$membership

g <- 
  g %>%
  set_vertex_attr(name = "component", value = g_components)

V(g)$color <- 
  ifelse(V(g)$component %in% qual_filtered_components_labeled$component, 
         "#dc322f", 
         "#eee8d5")

# "#BD0026", # dark red
# "#d33682", # magenta
# "#839496" # gray

# TODO: Fix white space at the bottom!
set.seed(20180109)
png(filename = file.path(here::here(), "output", "figures", "network.png"), 
    width = 6, height = 5, units = "in", res = 300)
plot(g, 
     vertex.size = 2, 
     vertex.color = V(g)$color, 
     vertex.label = NA, 
     vertex.frame.color = adjustcolor("#839496", alpha.f = .7),
     layout = layout_with_fr #, 
     # main = "Clusters of adjacent Census tracts with gay bars", 
     # sub = "Nodes shaded red are included as gay neighborhoods"
     )
dev.off()
