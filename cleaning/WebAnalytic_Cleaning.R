
## -------------------------------
## 1. Open libraries
## -------------------------------
library(readxl)
library(dplyr)
library(tidyr)

## -------------------------------
## 2. Import data
## -------------------------------

## Import Data <input type=button class=hideshow></input>
{r import include=TRUE, results = FALSE}


fname = "/Users/daeunhan/Box Sync/UIUC (daeuneh2@illinois.edu)/Career/UXstudy/UXResearchAtScale/Assignment/web_data_.xlsx"

#get the list of sheets
sheets <-readxl::excel_sheets(fname)

#read the sheets into a list of table
tibble <- lapply(sheets, function(x) readxl::read_excel(fname, sheet = x))

#Make a User data table
Userdata <- as.data.frame(tibble[[2]])

#Make an Engagement data table
engdata <- as.data.frame(tibble[[3]])

engdata <- engdata[-c(8),c(1:4)] # delete row 8 where session duration is NA

#Make a page data table
pagedata <- as.data.frame(tibble[[5]])
pagedata <- pagedata[c(-11),] # delete row 11 where Page is NA


#Make a referrer data table
referdata <- as.data.frame(tibble[[10]])
referdata  <- referdata[c(-11), ] # delete row 11 where Source is NA


#Make an affinity data table
affinitydata <- as.data.frame(tibble[[4]])
affinitydata  <- affinitydata[c(-102), ] # delete row 102 where Affinity Category is NA

# separate affinity column into three columns
affinitydata <- affinitydata %>%
  separate(`Affinity Category (reach)`, into = c("Aff1", "Aff2", "Aff3"), sep = "/", fill = "right")
## Preview of data ### Preveiw User data <input type=button class=hideshow></input>
{r include=TRUE}
head(Userdata)
### Preveiw Engagement data <input type=button class=hideshow></input>
{r include=TRUE}
head(engdata)
### Preveiw Page data <input type=button class=hideshow></input>
{r include=TRUE}
head(pagedata)
### Preview of Referral data <input type=button class=hideshow></input>
{r include=TRUE}
head(referdata)
### Preveiw Affinity data <input type=button class=hideshow></input>
{r include=TRUE}
head(aaffinitydata)

affinity_summarydata <- affinity_data %>%
  +   group_by(affinity_level_1) %>%
  +   summarise(
    +     total_sessions = sum(Sessions, na.rm = TRUE),
    +     bounce_rate = weighted.mean(`Bounce.Rate`, Sessions, na.rm = TRUE)
    +   )
> write.csv(
  +   affinity_summarydata,
  +   "data/processed/affinity_summarydata_clean.csv",
  +   row.names = FALSE
  + )s