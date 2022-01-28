
library(tidyverse)
download.file("https://outlook.office365.com/owa/calendar/63f6c4e85d124df6a20656ade8e71faa@leeds.ac.uk/ce6c20fb9b724845be2e4b8449f111d912766985686605660817/calendar.ics", "tds-calendar-2022.ics")
ics = calendar::ic_read("tds-calendar-2022.ics")
names(ics)
names(ics) = gsub(pattern = ";TZID=GMT Standard Time", replacement = "", x = names(ics))
head(ics$DTSTART)
calendar::ic_date(.Last.value)

tt_csv = ics %>% 
  mutate_at(vars(matches("DT")), calendar::ic_datetime) %>% 
  mutate(date = as.Date(DTSTART), duration = DTEND - DTSTART) %>% 
  select(SUMMARY, DESCRIPTION, date, duration) %>% 
  mutate(Start_time = case_when(
    str_detect(SUMMARY, "Lecture|Prac") ~ "09:00",
    str_detect(SUMMARY, "eminar|Dead") ~ "13:00"
  )) %>% 
  slice(-4) # todo: remove if fixed upstream
# %>% 
#   filter(SUMMARY == "TDS Practical")
names(tt_csv) = tolower(names(tt_csv))
tt_csv

readr::write_csv(tt_csv, "timetable.csv")
