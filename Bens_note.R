# read in the data
library(plyr)
library(dplyr)
library(knitr)
library(readxl)
# install.packages("readxl")
file_name <- "../data/artefacts (27 Jul 2016).xls" 
flakes <- read_excel(file_name, sheet = "flake basics")
cores <- read_excel(file_name, sheet = "core basics")
debris <- read_excel(file_name, sheet = "chunk&debris")
retouch <- read_excel(file_name, sheet = "retouch")

# are the artefact numbers really unique?
sum(duplicated(flakes$number))
# extract duplicated flakes 
flakes_duplicated <- flakes[ duplicated(flakes$number), ]

# remove from original data
flakes <- flakes[!duplicated(flakes$number), ]

# update the artefact ID so it's not duplicate
flakes_duplicated$number <- paste0(flakes_duplicated$number, "a")

# put back into original data 
flakes <- rbind(flakes, flakes_duplicated)

# do the same for the retouch...

# are the arteact numbers really unique?
sum(duplicated(retouch$number))

# extract duplicated retouch 
retouch_duplicated <- retouch[ duplicated(retouch$number), ]

# remove from original data
retouch <- retouch[!duplicated(retouch$number), ]

# update the artefact ID so it's not duplicate
retouch_duplicated$number <- paste0(retouch_duplicated$number, "a")

# put back into original data 
retouch <- rbind(retouch, retouch_duplicated)

############
# basic details of the dataset
artefact_ids <- list(flake_ids = flakes$number,
                     core_ids = cores$number,
                     debris_ids = debris$number,
                     retouch_ids = retouch$number)



# how many unique artefacts?
totals_of_each_type <- lapply(artefact_ids, function(i) length(unique(i)))
count_unique_artefacts <- sum(unlist(totals_of_each_type))
# debris pieces that are  retouch pieces
debris_with_retouch <- intersect(artefact_ids$retouch_ids, artefact_ids$debris_ids)
proportion_debris_retouched <- length(debris_with_retouch) / count_unique_artefacts 
# proportion of each type
library(knitr)
type_table <- data.frame(type = names(as.data.frame(totals_of_each_type)),
                         count = as.numeric(as.data.frame(totals_of_each_type)),
                         proportion = round(as.numeric(prop.table(as.data.frame(totals_of_each_type))),3))
# add total row at the bottom
type_table$type <- as.character(type_table$type)
type_table <- rbind(type_table, c("total", count_unique_artefacts, round(sum(type_table$proportion),2)))
# print pretty table                         
kable(type_table)
```

A total of `r type_table$count[2]` cores, `r type_table$count[1]` flakes, `r type_table$count[4]` retouched pieces and `r type_table$count[3]` peices of debris were identified 

# clean data to help with analysis
pattern <- c("ret", "leva")
flakes$retouched <- ifelse(grepl(paste0(pattern, collapse = "|"), flakes$type), "retouched", "unretouched")
flakes <- flakes[!flakes$material %in% c('qutz', 'quartz', 'sandstone', 'basalt') , ]

# how many levallois?
unique(flakes$type)
leva <- flakes %>% 
  filter(grepl("leva", type))
non_leva <- flakes %>% 
  filter(!grepl("leva", type))

flakes_L <-  
  mutate(flakes, L = ifelse(grepl("leva", type), "L", "N"))

# are the levallois pieces bigger by mass?
library(ggplot2)
ggplot(flakes_L, aes(x = L, 
                     y = mass)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.2) +
  scale_y_log10()

# is it significant?
t.test(data = flakes_L, mass ~ L)
# no


# explore variation in thickness in these groups
thick_plot <- ggplot(flakes_L) +
  geom_density(aes(`Thickness at 25% max dim`), 
               colour = "red", 
               alpha = 0.3) +
  geom_density(aes(`Thickness at 50% max dim`), 
               colour = "green", 
               alpha = 0.3) +
  geom_density(aes(`Thickness at 75% max dim`), 
               colour = "blue", 
               alpha = 0.3) +
  xlab("Thickness (mm)")

# draw plot
thick_plot

# by size class that we identified earlier
thick_plot +
  facet_wrap(~ L, ncol = 1)

# need a test of uniformity (peak width)

# check the CVs
CV <- function(the_vector){
  mean_ <- mean(the_vector, na.rm = TRUE)
  sd_ <- sd(the_vector, na.rm = TRUE)
  cv <- (sd_/mean_) * 100
  round(cv, 3)
}

cvs_flakes_lev <- 
  flakes_L %>% 
  group_by(L) %>% 
  dplyr::summarise(cv_25_thick = CV(`Thickness at 25% max dim`),
                   cv_50_thick = CV(`Thickness at 50% max dim`),
                   cv_75_thick = CV(`Thickness at 75% max dim`),
                   cv_25_width = CV(`Width at 25% max dim`), 
                   cv_50_width = CV(`Width at 50% max dim`),
                   cv_75_width = CV(`Width at 75% max dim`), 
                   n = n()) 

retouch$`NA` <-  NULL

library(ggplot2)
library(tidyr)

library(purrr)
# remove spaces from all coloumns 
retouch <- dmap(retouch, function(x) gsub("\\s", "", x))
# convert many cols to numeric
retouch[ , 5:39 ] <- dmap(retouch[ , 5:39 ], as.numeric)


# function to compute frequencies and make a plot
f <-  function(the_data, the_column) {
  data.frame(table(the_data[the_column])) %>% 
    ggplot(aes(x = reorder(Var1, Freq), y = Freq)) +
    geom_bar(stat = "identity") +
    ylab("n") +
    xlab(the_column) + 
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
}
str(retouch)

# inspect the distributions of discrete things
f(retouch, "number of layers")
f(retouch, "number of edge")
f(retouch, "edge shape")

edge_shapes <-  paste(retouch$`edge shape`, collapse = ",") %>% 
  gsub("\\.", ",", .) %>% 
  strsplit(split = ',') %>% 
  unlist() 

table(edge_shapes)
unique(edge_shapes)


retouch$strt <-   as.numeric(ifelse(grepl("strt", retouch$`edge shape`), 1, 0)    )
retouch$cvx <-    as.numeric(ifelse(grepl("cvx", retouch$`edge shape`), 1, 0))
retouch$ccv <-    as.numeric(ifelse(grepl("ccv", retouch$`edge shape`), 1, 0))
retouch$dent <-   as.numeric(ifelse(grepl("dent", retouch$`edge shape`), 1, 0))
retouch$notch <-  as.numeric(ifelse(grepl("notch", retouch$`edge shape`), 1, 0))
retouch$end <-    as.numeric(ifelse(grepl("end", retouch$`edge shape`), 1, 0))

retouch %>% 
  filter(notch == 1) %>% 
  select(strt, cvx, ccv, dent, notch, end) %>% 
  summarise_each(funs(sum))

# inspect the distributions of continuous things about curvature (diameter and depth)
ggplot(retouch) +
  geom_density(aes(`retouch_diameter (for curvature)`),
               colour = "red") +
  geom_density(aes(`retouch_depth (for curvature)`),
               colour = "blue") +
  theme_minimal()

#http://what-when-how.com/metrology/to-find-out-the-radius-of-a-concave-surface-metrology/

retouch$radius  <- (retouch$`retouch_diameter (for curvature)`)^2 / 8 * retouch$`retouch_depth (for curvature)`

ggplot(retouch, aes(radius)) +
  geom_density() +
  scale_x_log10()

ggplot(retouch,
       aes(`retouch_diameter (for curvature)`, 
           `retouch_depth (for curvature)`)) +
  geom_point(aes(colour = as.character(cvx)))


# retouch sections, compute GIUR

retouch <- 
  retouch %>% 
  mutate(s1_t_T = section_1_t / section_1_T,
         s2_t_T = section_2_t / section_2_T,
         s3_t_T = section_3_t / section_3_T,
         s4_t_T = section_4_t / section_4_T,
         s5_t_T = section_5_t / section_5_T,
         s6_t_T = section_6_t / section_6_T,
         s7_t_T = section_7_t / section_7_T,
         s8_t_T = section_8_t / section_8_T) 

retouch$GIUR <- 
  retouch %>% 
  dplyr::select(dplyr::contains("_t_T")) %>% 
  rowSums(na.rm = TRUE)

# average GIUR per zone
retouch_zones <- 
  retouch %>% 
  summarise(s1_t_T_mean = mean(s1_t_T, na.rm = TRUE),
            s2_t_T_mean = mean(s2_t_T, na.rm = TRUE),
            s3_t_T_mean = mean(s3_t_T, na.rm = TRUE),
            s4_t_T_mean = mean(s4_t_T, na.rm = TRUE),
            s5_t_T_mean = mean(s5_t_T, na.rm = TRUE),
            s6_t_T_mean = mean(s6_t_T, na.rm = TRUE),
            s7_t_T_mean = mean(s7_t_T, na.rm = TRUE),
            s8_t_T_mean = mean(s8_t_T, na.rm = TRUE))


ggplot(retouch, aes(GIUR)) +
  geom_density() 

# get basic flake variables
retouch <- left_join(retouch, flakes, by = 'number')

# how may with GIUR
length(retouch$GIUR)

retouch$platform_area <-  with(retouch, `platform width` *  `platform thickness`)

ggplot(retouch, aes(GIUR, mass)) +
  geom_point() +
  scale_y_continuous( limits = c(0,100)) +
  stat_smooth()


retouch %>% 
  group_by(type2) %>% 
  dplyr::summarize(GIUR_mean = mean(GIUR)) %>% 
  
  ggplot(aes(y = GIUR_mean, 
             x = reorder(type2, 
                         GIUR_mean))) +
  geom_bar(stat = "identity")  +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
5/
  
  
  outline <- 
  data.frame(
    x = c(-1.8,  0,   1.8,   2,        1.75,  1.5,  1.25,      0,   -1.25,     -1.5, -1.75,   -2),
    y = c( 5,    5,   5,     (5/4)*3,  2,     1,    0.25,      0,    0.25,      1,    2,      (5/4)*3),
    g = rep("a", 12)
  )

mirror <- function(poly){
  m <- poly
  m$x <- -m$x
  m
}

zone_one <- 
  data.frame(
    x = c(-1.8,  0,   0,         -2),
    y = c( 5,    5,   (5/4)*3,   (5/4)*3),
    g = rep("a", 4)
  )

zone_eight <- mirror(zone_one)

zone_two <- 
  data.frame(
    x = c(  0,       0,        -2,        -1.81),
    y = c( (5/4)*2, (5/4)*3,   (5/4)*3,   (5/4)*2),
    g = rep("a", 4)
  )

zone_seven <- mirror(zone_two)

zone_three <- 
  data.frame(
    x = c(  0,       0,         -1.81,    -1.5       ),
    y = c( (5/4)*1, (5/4)*2,   (5/4)*2,   (5/4)*1),
    g = rep("a", 4)
  )

zone_six <- mirror(zone_three)

zone_four <- 
  data.frame(
    x = c(  0,       0,         -1.5,    -1.1       ),
    y = c(  0,       (5/4)*1,   (5/4)*1,   0),
    g = rep("a", 4)
  )

zone_five <- mirror(zone_four)



library(ggplot2)
ggplot()  +
  geom_polygon(data = zone_one,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_eight,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_two,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_seven,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_three,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_six,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_four,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  geom_polygon(data = zone_five,
               aes(x,y,
                   group = g),
               colour = "black", 
               fill=NA) +
  coord_equal() +
  theme_minimal()

# explore with some tables and plots
library(ggplot2)
library(tidyr)


# function to compute frequencies and make a plot
f <-  function(the_data, the_column) {
  data.frame(table(the_data[the_column])) %>% 
    ggplot(aes(x = reorder(Var1, Freq), y = Freq)) +
    geom_bar(stat = "identity") +
    ylab("n") +
    xlab(the_column) + 
    theme_bw() +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
}

# some plots of frequencies
f(flakes, "yuanfenlei")
f(flakes, "type")
f(flakes, "type2")
f(flakes, "retouched")
f(flakes, "material")

# mass for all flakes
ggplot(flakes, aes(mass)) +
  geom_histogram(binwidth = 10) 

ggplot(flakes, aes(mass)) +
  geom_density() +
  scale_x_log10()

ggplot(flakes, aes(length, `Width at 50% max dim`, colour = material)) +
  geom_point() +
  geom_smooth(method = "lm")

# mass for all flakes, retouched or not
ggplot(flakes, aes(mass, colour = retouched)) +
  geom_density()

# mass for all flakes, by raw material
ggplot(flakes, aes(mass, colour = material)) +
  geom_density()

# max dim for all flakes
ggplot(flakes, aes(`max dimension`)) +
  geom_histogram(binwidth = 2)

# max dim for all flakes, retouched or not 
ggplot(flakes, aes(`max dimension`, colour = retouched)) +
  geom_density()

# max dim for all flakes, by raw material
ggplot(flakes, aes(`max dimension`, colour = material)) +
  geom_density()

# scar counts for all flakes, by raw material
ggplot(flakes, aes(`scar number`)) +
  geom_histogram()

flakes$scar_group <- ifelse(flakes$`scar number` > 5, "more_than_5", "less_than_5")
ggplot(flakes, aes(mass, x = scar_group)) +
  geom_boxplot() +
  scale_y_log10()

# facetted plaforms
flakes$facetted_platform <- ifelse(grepl("fac", flakes$platform), "fac", "no")
ggplot(flakes, aes(`max dimension`, colour = facetted_platform)) +
  geom_density()