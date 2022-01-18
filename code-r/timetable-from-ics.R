
library(tidyverse)
ics = calendar::ic_read("tds-calendar-2022.ics")
names(ics)
names(ics) = gsub(pattern = ";TZID=GMT Standard Time", replacement = "", x = names(ics))
head(ics$DTSTART)
calendar::ic_date(.Last.value)

tt_csv = ics %>% 
  mutate_at(vars(matches("DT")), calendar::ic_date) %>% 
  mutate(date = as.Date(DTSTART), duration = DTEND - DTSTART) %>% 
  select(SUMMARY, DESCRIPTION, date, duration)
names(tt_csv) = tolower(names(tt_csv))

readr::write_csv(tt_csv, "timetable.csv")
readLines("timetable.ics")
