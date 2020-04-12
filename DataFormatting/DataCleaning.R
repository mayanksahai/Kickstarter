# Title     : TODO
# Objective : TODO
# Created by: mayank
# Created on: 10/4/2020

library(dplyr)
library(lubridate)
library(stringr)
library(rebus)
library(ggplot2)
library(rebus)
library(stringr)
library(readxl)
library(caret)
library(tidyverse)
library(dplyr)
library(editrules)
library(lubridate)
library(tidyr)
library(plyr)

source("DateTimeUtils.R")
setwd("C:/Mtech/Sem1Project/Kickstarter/DataFormatting")

df <- read.csv("KickstarterMerged.csv", sep=",",comment.char = "", stringsAsFactor = F)
fctr.cols <- sapply(df, is.factor)
df[, fctr.cols] <- sapply(df[, fctr.cols], as.character)
sapply(df,class)
# head(df)
# dim(df)

# colnames(df)

# incomplete = df[!complete.cases(df),]
# proportion = nrow(incomplete)/nrow(df)
colMeans(is.na(df)) # tells to drop column is_starred and is_backing 99% missing
sapply(df, function(x) sum(x == '')) # tells to drop column friends, permissions max empty values


missing_val_columns <- c('friends','permissions','is_starred','is_backing')
#df <- df[ , !(names(df) %in% missing_val_columns)]
df_truncated <- select(df,-c('friends','permissions','is_starred','is_backing'))
colnames(df_truncated)



count(df_truncated, 'disable_communication')  # all values are false to drop it

not_useful_columns <- c('creator', 'currency', 'currency_symbol', 'currency_trailing_code','state_changed_at', 'urls_project', 'urls_rewards','disable_communication')

df_truncated$created_at <- as.POSIXct(df_truncated$created_at, origin="1970-01-01",tz="GMT")
df_truncated$deadline <- as.POSIXct(df_truncated$deadline, origin="1970-01-01",tz="GMT")
df_truncated$launched_at <- as.POSIXct(df_truncated$launched_at, origin="1970-01-01",tz="GMT")
#df_truncated <- as.Date(as.POSIXct(df_truncated$created_at, origin="1970-01-01"))
head(df_truncated$launched_at)
head(df_truncated$created_at)


df_truncated$campaign_launch_delay <-  as.Date(df_truncated$launched_at, format="%Y/%m/%d")- as.Date(df_truncated$created_at, format="%Y/%m/%d")
df_truncated$campaign_run_duration <- as.Date(df_truncated$deadline, format="%Y/%m/%d")- as.Date(df_truncated$launched_at, format="%Y/%m/%d")
head(df_truncated$campaign_launch_delay)
head(df_truncated$campaign_run_duration)


df_truncated$launch_day <- wday(as.Date(df_truncated$launched_at, format="%A"), label=TRUE)
df_truncated$deadline_day <- wday(as.Date(df_truncated$deadline, format="%A"),label=TRUE)

head(df_truncated$launch_day)
df_truncated$launch_month <- month(as.Date(df_truncated$launched_at, format="%A"), label=TRUE)
df_truncated$deadline_month <- month(as.Date(df_truncated$deadline, format="%A"),label=TRUE)
head(df_truncated$launch_month)

df_truncated$launch_year <- format(as.Date(df_truncated$launched_at, format="%d/%m/%Y"),"%Y")
df_truncated$deadline_year <- format(as.Date(df_truncated$deadline, format="%d/%m/%Y"),"%Y")
head(df_truncated$launch_year)

df_truncated$launch_hour <- hour(ymd_hms(df_truncated$launched_at))
df_truncated$deadline_hour <- hour(ymd_hms(df_truncated$deadline))
head(df_truncated$launch_hour)

df_truncated$launch_time_window <- sapply(df_truncated[,'launch_hour'],two_hour_deadline)
df_truncated$deadline_time_window <- sapply(df_truncated[,'deadline_hour'],two_hour_deadline)

head(df_truncated$launch_time_window)
head(df_truncated$deadline_time_window)

category_extract_pattern = '"slug":"(\\w*/\\w*\\s*\\w*)'
df_truncated$category_details <- str_match(df_truncated$category,category_extract_pattern)[,2]
#str_split(category_sub_value, "/")
head(df_truncated$category_details)
df_truncated <- df_truncated %>% tidyr::separate(category_details,c("category_type","sub_category_type"))
head(df_truncated$category_type)

# converting funding targets form native curreny to usd
df_truncated$usd_goal <- round(df_truncated$goal * df_truncated$fx_rate,digits=2)
df_truncated$usd_pledged <- round(df_truncated$pledged * df_truncated$static_usd_rate,digits=2)
head(df_truncated$usd_goal)
head(df_truncated$usd_pledged)

# take out city/state/country from location column
city_name_regex = '"name":"(\\w*)'
df_truncated$city_code <- str_match(df_truncated$location,city_name_regex)[,2]

state_name_regex = '"state":"(\\w*)'
df_truncated$state_code <- str_match(df_truncated$location,state_name_regex)[,2]

country_name_regex = '"country":"(\\w*)'
df_truncated$country_code <- str_match(df_truncated$location,country_name_regex)[,2]
head(df_truncated)

df_truncated$pledge_per_backer = round(df_truncated$usd_pledged/df_truncated$backers_count,digits = 2)
head(df_truncated$pledge_per_backer)

# should be remove projects with state = cancelled/live/suspended as we are ding analysis for success/failure only
#   state           n
#   <chr>       <int>
# 1 canceled     8896
# 2 failed      75732
# 3 live         7260
# 4 successful 124089
df_truncated %>%
  group_by(state) %>%
  tally()

# remove duplicates
# TODDO : will do it properly
duplicates <- df_truncated %>% filter(duplicated(id) | duplicated(id, fromLast = TRUE))
sprintf("our of total number of projects:%s duplicate entries are:%s",nrow(df_truncated),nrow(duplicates))

# write to cleaned.csv
write.csv(df_truncated,"KickstarterCleaned.csv", row.names = FALSE)

sprintf("SUCCESS :: Data cleaning and transformation finished.. Please run analytics")

