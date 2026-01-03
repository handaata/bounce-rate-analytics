# bounce-rate-analytics
This project explores user engagement and bounce rates in web analytics using R and R Markdown

## Project Structure

- `raw_data/` – Original Excel file with 5 sheets containing raw session data.  
- `data/` – Cleaned and feature-engineered CSV datasets, each representing a different level of analysis:
  - user_data: metrics per user, including session counts, bounce rate, average session duration, and other engagement indicators
  - engagement_data: session durations categorized into meaningful time intervals  
  - page_data: page-specific metrics such as page views and bounce rates  
  - referrer_data: traffic source performance and engagement  
  - affinity_summarydata: aggregated metrics for user affinity groups   
  
- `preparation/` – R script for cleaning, feature engineering, and saving each dataset as a CSV.  
- `analysis/` – R Markdown document containing visualizations, interpretations, and recommendations.  

## Key Analyses

- Explored engagement patterns across **different levels** (user, page, source, affinity, and session-duration) to derive actionable insights.  
- Provided recommendations for improving early-session engagement through improving landing pages and referral alignment and designing user engagement metrics.

## Tools & Methods

- **R**: Data cleaning, transformation, and visualization (`tidyverse`, `ggplot2`)  
- **R Markdown**: Reproducible workflow integrating code, plots, and interpretation  

