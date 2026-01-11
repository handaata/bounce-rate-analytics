## Purpose
# This document prepares raw web analytics data for exploratory and descriptive analysis.
# The goal is to clean and structure datasets at appropriate levels of analysis while documenting key assumptions and exclusions.

## Summary of data preparation
#- Each data is structured by different unit of analysis (user, session duration, page, referrer, affinity group).
#- Rows with missing identifiers or implausible tracking values were excluded.
#- Hierarchical affinity categories were split into interpretable features, and aggregated based on the broadest category for simpler visualization.

## -------------------------------
## 1. Open libraries
## -------------------------------

library(readxl)
library(dplyr)
library(tidyr)


## -------------------------------
## 2. Import data
## -------------------------------

# Excel file contains multiple sheets exported from web analytics platform
data_path = "../data/raw_data/data_web_analytic.xlsx"

sheet_names <- excel_sheets(data_path)

# Read all sheets into a named list for traceability
raw_tables <- lapply(sheet_names, function(s) {
  read_excel(data_path, sheet = s)
})
names(raw_tables) <- sheet_names

## --------------------------------------
## 3. Construct and Clean analytic tables
## --------------------------------------

# 3.1 Make a User-level data
user_data <- as.data.frame(raw_tables[[2]])

# Replace space with _ in variable names
names(user_data) <- gsub(" ", "", names(user_data))

# Check for duplicate user IDs
any(duplicated(user_data$ClientId))

# Check missingness
colSums(is.na(user_data))


# 3.2 Make a session-duration-level engagement data
engagement_data <- as.data.frame(raw_tables[[3]]) %>%
  # Remove rows with missing session duration, which likely indicate logging errors
  filter(!is.na(`Session Duration...1`)) %>%
  # Remove columns that contains variable explanations (only keep the columns with actual data)
  select(c(1:3))

# Change variable name Session_Duration...1 as SessionDuration
names(engagement_data)[1]<- 'SessionDuration'

# Check missingness
colSums(is.na(engagement_data))


# 3.3 Make a page-level interaction data
page_data <- as.data.frame(raw_tables[[5]]) %>%
  # Remove rows with missing page identifiers
  filter(!is.na(Page))

# Replace space with _ in variable names
names(page_data) <- gsub(" ", "", names(page_data))

# Check missingness
colSums(is.na(page_data))


# 3.4 Make a referrer data table
referrer_data <- as.data.frame(raw_tables[[10]]) %>%
  filter(!is.na(Source))

# Replace space with _ in variable names
names(referrer_data) <- gsub(" ", "", names(referrer_data))

# Check missingness
colSums(is.na(referrer_data))


# 3.5 Make an affinity data table (hierarchical)
affinity_data <- as.data.frame(raw_tables[[4]]) %>%
  filter(!is.na(`Affinity Category (reach)`))

# Replace space with _ in variable names
names(affinity_data) <- gsub(" ", "", names(affinity_data))

# Check missingness
colSums(is.na(affinity_data))
# Note: Not all affinity has three levels. Some has only two levels.

## --------------------------------------
## 4. Feature Engineering
## --------------------------------------

# 4.1 For engagement data

engagement_data <- engagement_data %>% 
  mutate(
    # Calculate average page views per session
    AvgViewPerSess = Pageviews/Sessions,
    # calculate percentage of number of sessions
    Sessions_Percent = Sessions/sum(Sessions) * 100, )



# 4.2 For affinity data
# Split hierarchical affinity categories into separate features
affinity_data <- affinity_data %>%
    separate(
    `AffinityCategory(reach)`,
    into = c("AffinityLevel_1", "AffinityLevel_2", "AffinityLevel_3"),
    sep = "/",
    fill = "right"
  ) 

# Aggregate data by affinity level 1 (the broadest affinity group) for simplicity in visualization
affinity_summarydata <- affinity_data %>%
     group_by(AffinityLevel_1) %>%
     summarise(
         total_sessions = sum(Sessions, na.rm = TRUE),
         bounce_rate = weighted.mean(`BounceRate`, Sessions, na.rm = TRUE)
         )
# Note: 
# Sessions were summed to reflect the total user engagement for each affinity group.
# Bounce rate was calculated as session-weighted averages to prevent distortion from low-traffic pages



## --------------------------------------
## 5. Preview of data
## --------------------------------------

# Preview User data 
head(user_data)

# Preview Engagement data 
head(engagement_data)

# Preview Page data 
head(page_data)

# Preview of Referral data 
head(referrer_data)

### Preview of Affinity data 
head(affinity_data)



## --------------------------------------
## 6. Save data
## --------------------------------------

write.csv(
  user_data,
  "../data/processed_data/user_data_clean.csv",
  row.names = FALSE
)

write.csv(
  engagement_data,
  "../data/processed_data/engagement_data_clean.csv",
  row.names = FALSE
)

write.csv(
  page_data,
  "../data/processed_data/page_data_clean.csv",
  row.names = FALSE
)

write.csv(
  referrer_data,
  "../data/processed_data/referrer_data_clean.csv",
  row.names = FALSE
)

write.csv(
     affinity_summarydata,
     "../data/processed_data/affinity_summarydata_clean.csv",
     row.names = FALSE
   )
