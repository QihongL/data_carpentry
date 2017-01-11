rm(list=ls());
# init 
library(dplyr); library(ggplot2);
rawDataPath = '../data_carpentry/data/raw/'
fname = 'portal_data_joined.csv'
surveys = read.csv(paste(rawDataPath,fname,sep=''))

# SQL SELECT = select: select rows
names(surveys)
cols = select(surveys, species_id, plot_type, weight)
head(cols)

# SQL WHERE = filter: select rows by criterion 
surveys2002 = filter(surveys, year == 2002)
head(surveys2002)

# filter na values
surveys %>% 
    filter(!is.na(weight)) %>% 
    mutate(weights_kg = weight / 1000) %>% 
    head()

# SQL FROM = pipe (cmd+shift+m)
survey_sub = surveys %>% filter(weight == 5)  %>% select(species_id,sex,weight)

# mutate change values 
surveys %>% 
    mutate(weight_kg = weight / 1000) %>% 
    head() 

# SQL GROUP BY = group_by
surveys %>% group_by(genus) %>% tally()
surveys %>% group_by(sex) %>% summarize(mean_wt = mean(weight, na.rm = T))

# SQL ORDER BY = arrange 
surveys %>% group_by(sex,species_id) %>% 
    summarize(mean_wt = mean(weight, na.rm = T), min_wt = min(weight, na.rm = T)) %>% 
    filter(!is.na(mean_wt)) %>% 
    arrange(desc(mean_wt)) %>% 
    head()


# p1: combine mutate, filter, select
surveys_tmp = surveys %>% 
    mutate(hindfoot_length_sqrt = sqrt(hindfoot_length)) %>%
    filter(!is.na(hindfoot_length_sqrt),hindfoot_length_sqrt<3) %>% 
    select(species_id,hindfoot_length_sqrt) 
    
# p2: counts 
surveys %>% group_by(plot_type) %>% tally()

# p3: stats for each species 
surveys %>% group_by(species) %>% 
    summarize(hf_max = max(hindfoot_length, na.rm = T), 
              hf_min = min(hindfoot_length, na.rm = T),
              hf_mean = mean(hindfoot_length, na.rm = T)) %>% 
    head()


# p4: remove NA, ""
surveys_complete = surveys %>% 
    filter(species_id != "", sex != "", !is.na(weight), !is.na(hindfoot_length)) 
dim(surveys_complete)
dim(surveys)

# remove rare rare species 
species_counts = surveys %>% group_by(species_id) %>% tally()
frequent_species = species_counts %>% filter(n >= 10) %>% select(species_id)
surveys_complete = surveys_complete %>% filter(species_id %in% frequent_species$species_id)
dim(surveys_complete)

# save data 
write.csv(surveys_complete, paste('../data_carpentry/data/clean/',"portal_data_reduced.csv",sep=''))
