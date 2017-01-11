rm(list=ls());
setwd('/Users/Qihong/Dropbox/github/data_carpentry/src');
library(ggplot2);library(dplyr);
# read data 
dataURL = 'http://kbroman.org/datacarp/portal_data_reduced.csv'
data = read.csv(dataURL)
names(data)
head(data)

## Overall idea 
# ggplot:   creates a R object 
# aes:      map FROM feature (in the data) TO attribute (of the plot)
# geom:     FOR EVERY row (obs), MAKE something (e.g. point) 


## Scatter plot 
# make a plot directly  
ggplot(data, aes(x = weight, y = hindfoot_length)) + geom_point()

# build a plot incrementally
p1 = ggplot(data, aes(x = weight, y = hindfoot_length)) # this doesn't make a plot 
p2 = p1 + geom_point() 

# transform x
p2 + scale_x_log10()
p2 + scale_x_sqrt()

# General Framework: preprocess the data with PIPE, then do GGPLOT
# e.g. PIPE the data to ggplot
data %>% filter(species_id =='DM')  %>% 
    ggplot(aes(x = weight, y = hindfoot_length)) + geom_point()


## Other aestjetocs
# opacity - alpha
ggplot(data, aes(x = weight, y = hindfoot_length)) + geom_point(alpha = .05)
# color and size 
ggplot(data, aes(x = weight, y = hindfoot_length)) +
    geom_point(color = 'slateblue', size = .5)

# user defined aestjetocs, using aes map
ggplot(data, aes(x = weight, y = hindfoot_length)) +
    geom_point(aes(color = species_id))

# plot weight by hindfoot_length, size = species counts 
data_reduced = data %>% group_by(species) %>% 
    summarize(wt_mean = mean(weight, na.rm = T), 
              hfl_mean = mean(hindfoot_length, na.rm = T),
              sample_size = n()) 
data_reduced %>%  ggplot(aes(x = wt_mean, y = hfl_mean)) + 
    geom_point(aes(color = sample_size, size = sample_size))

# plot data count by year 
data_count_by_year = data %>% group_by(year) %>% tally()
# line then point 
p = data_count_by_year %>% ggplot(aes(x = year, y = n)) 
p + geom_line(size = 1, color = "#000000") + geom_point(size = 2, color = 'slateblue')
# point then line  
p + geom_point(size = 2, color = 'slateblue') + geom_line(size = 1, color = "#000000") 
# color code year 
p + geom_point(aes(color = year)) + geom_line(aes(color = year))
p + geom_point() + geom_line() + aes(color = year) # same as above 

# practice: plot the counts of 2 species over time 
data_reduced = data %>% filter(species_id %in% c("DM","DS")) %>%
    group_by(year, species_id) %>% tally() 

data_reduced %>% ggplot(aes(x = year, y = n)) + 
    geom_line(aes(color = species_id)) + 
    geom_point(aes(color = species_id)) + 
    labs(title = "Species counts over time") +      # add x label, ylabel, title
    xlab('Year') + ylab('Counts')

data_reduced %>% ggplot(aes(x = year, y = n)) + 
    geom_line(aes(group = species_id)) +            # group aesthetics
    geom_point(aes(color = species_id)) 

data_reduced %>% ggplot(aes(x = year, y = n)) + 
    geom_line() +   # WRONG: line doesn't know there are 2 groups 
    geom_point(aes(color = species_id)) 


## Other plots 
# histogram
ggplot(data, aes(x = weight)) + geom_histogram(bins = 100)
# box plot 
ggplot(data, aes(x = species_id, y = hindfoot_length)) + geom_boxplot()
# violin plot (provides density estimation, instead of a box)
ggplot(data, aes(x = species_id, y = hindfoot_length)) + geom_violin()


## Faceting: break data into many subsets then make subplots
# yearly counts by species 
yearly_counts = data %>% group_by(year, species_id) %>% tally()
yearly_counts %>% 
    ggplot(aes(x = year, y = n, group = species_id, color = species_id)) +
    geom_line() + facet_wrap(~species_id)

# yearly weights by sex for selected species 
yearly_weight = data %>% 
    filter(species_id %in% c('DM','DS','DO')) %>% 
    group_by(year, species_id, sex ) %>% 
    summarize(wt_mean = mean(weight))

yearly_weight

yearly_weight %>% ggplot(aes(x = year, y = wt_mean, group = species_id, color = species_id)) + 
    geom_line() + facet_grid(~species_id)

yearly_weight %>% ggplot(aes(x = year, y = wt_mean, group = species_id, color = species_id)) + 
    geom_line() + facet_grid(sex ~.)

yearly_weight %>% ggplot(aes(x = year, y = wt_mean, group = species_id, color = species_id)) + 
    geom_line() + facet_grid(sex ~species_id)



## Save a plot to a file 
p_temp = ggplot(data, aes(x = weight, y = hindfoot_length)) +
    geom_point(color = 'slateblue', size = .5)

ggsave("myplot.jpg",p_temp)
ggsave("myplot.png",p_temp)
ggsave("myplot.pdf",p_temp, height = 7.5, width = 10, dpi = 600)
