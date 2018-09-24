# Aim: import calendar from web
library(rvest) # for webscraping
# u = "http://timetable.leeds.ac.uk/teaching/201819/reporting/textspreadsheet;?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21"
# other version
u = "http://timetable.leeds.ac.uk/teaching/201819/reporting/individual;?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21"
w14_start = as.Date("2019-01-28")
week_num = c(14:22, paste0("E", 1:4), 23:30)
n_weeks = length(w14_30)
week_commencing = seq(from = w14_start, by = "week", length.out = n_weeks)
weeks = data.frame(week_num, week_commencing)
weeks_teaching = c(15:17, 19:22, 23:25)
weeks = weeks[weeks$week_num %in% weeks_teaching, ]
readr::write_csv(weeks, "data/timetable-dates.csv")
# edit manually

# scraping contents:
# timetable_scraped = xml2::read_html(u) %>% 
#   html_nodes("td:nth-child(9)") %>% 
#   html_text()
  # html_table(header = TRUE, trim = TRUE, fill = TRUE)
