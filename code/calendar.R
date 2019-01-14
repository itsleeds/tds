# Aim: create ical of all lectures and practicals of TDS

# install required package:
devtools::install_github("ATFutures/calendar")
# First thought was to capture the data hosted at:
# http://timetable.leeds.ac.uk/teaching/201819/reporting/individual;?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21
# However, eventually I opted for a simpler approach: to create a .csv from a spreadsheet
# This can be read-in as follows:
timetable = readr::read_csv("timetable.csv")
timetable$date = timetable$week_commencing + 1

# identify and create ical columns (on just one event):
ical::properties_core
names(timetable)

# start times for practicals
start_time = "12:30"
start_dt = paste0(timetable$date, start_time)
DTSTART = lubridate::ymd_hm(start_dt)

# end times for practicals
end_time = "13:30"
end_dt = paste0(timetable$date, end_time)
DTEND = lubridate::ymd_hm(end_dt)

SUMMARY = paste("TDS:", timetable$name, "lecture")
DESCRIPTION = paste0(timetable$description, ". Taught by ", timetable$Person, ". Week number ", timetable$week_num)
UID = sapply(1:nrow(timetable), function(x) ical::ic_guid())

ic = data.frame(UID, DTSTART, DTEND, SUMMARY, DESCRIPTION)

# should be able to write it directly:
# ical::ic_write(ic[1, ], "timetable.ics")

# temp fix (to comment-out when ical is updated):
ic_char = ical::ic_character(ic)
ic_cal_begin = c("BEGIN:VCALENDAR", "PRODID:ical R package", "VERSION:2.0", 
                 "CALSCALE:GREGORIAN", "METHOD:PUBLISH")
ic_char = c(ic_cal_begin, ic_char)
writeLines(ic_char, "timetable-lectures.ics")

# issues: does not have these prefixes (added manually): 
# "BEGIN:VCALENDAR" 
# "PRODID:-//Google Inc//Google Calendar 70.9054//EN"
# "PRODID:ical R package"
# "VERSION:2.0"
# "CALSCALE:GREGORIAN"
# "METHOD:PUBLISH"    - should comment-out:
ic_cal_begin = c("BEGIN:VCALENDAR", "PRODID:ical R package", "VERSION:2.0", 
  "CALSCALE:GREGORIAN", "METHOD:PUBLISH")

# Aim: import calendar from web
# library(rvest) # for webscraping
# u = "http://timetable.leeds.ac.uk/teaching/201819/reporting/textspreadsheet;?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21"
# other version
# u = "http://timetable.leeds.ac.uk/teaching/201819/reporting/individual;?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21"
# w14_start = as.Date("2019-01-28")
# week_num = c(14:22, paste0("E", 1:4), 23:30)
# n_weeks = length(w14_30)
# week_commencing = seq(from = w14_start, by = "week", length.out = n_weeks)
# weeks = data.frame(week_num, week_commencing)
# weeks_teaching = c(15:17, 19:22, 23:25)
# weeks = weeks[weeks$week_num %in% weeks_teaching, ]
# readr::write_csv(weeks, "data/timetable-dates.csv")
# edit manually

# scraping contents:
# timetable_scraped = xml2::read_html(u) %>% 
#   html_nodes("td:nth-child(9)") %>% 
#   html_text()
  # html_table(header = TRUE, trim = TRUE, fill = TRUE)
