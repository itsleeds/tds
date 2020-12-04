# Aim: create ical of all lectures and practicals of TDS

library(tidyverse)
# devtools::install_github("ATFutures/calendar")
remotes::install_cran("calendar")

# Manual input ----
# get dates -----
# See https://ses.leeds.ac.uk/info/21630/timetabling/1004/teaching_week_patterns
# browseURL("https://ses.leeds.ac.uk/download/1557/1920_teaching_week_pattern")
w_start = as.Date("2020-09-28")
week_num = c(1:11, paste0("C", 1:4), 12:22, paste0("E", 1:4), 23:30)
n_weeks = length(week_num)
week_commencing = seq(from = w_start, by = "week", length.out = n_weeks)
weeks = tibble::tibble(week_num, week_commencing)
# View(weeks)
# browseURL("~/onedrive/modules/tds/2020-21/ITS PGR REQ 20-21-rl-tds.xlsx")
tt_url = "http://timetable.leeds.ac.uk/teaching/202021/reporting/Individual?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21"
# download.file(tt_url, "~/onedrive/modules/tds/2020-21/timetable-uol.html")
# browseURL("~/onedrive/modules/tds/2020-21/timetable-uol.html")

# lectures ------------------------------------------------------

lecture_description = c(
  "Introduction to transport data science",
  "The structure of transport data and data cleaning",
  "Routing",
  "Visualisation",
  "Project work"
)

lecture_ids = c(
  "intro",
  "structure",
  "routing",
  "viz",
  "project"
)

lecture_day_of_week = 1
lecture_start_time = "09:00"
lecture_end_time = "10:00"
lecture = tibble::tibble(week_num = as.character(c(15:17, 21:22)))
lecture = dplyr::inner_join(lecture, weeks)
lecture$date = lecture$week_commencing + (lecture_day_of_week - 1)
lecture$DTSTART = lubridate::ymd_hm(paste(lecture$date, lecture_start_time)) 
lecture$DTEND = lubridate::ymd_hm(paste(lecture$date, lecture_end_time))
lecture$duration = (lecture$DTEND - lecture$DTSTART)
lecture$type = "Lecture"
lecture$SUMMARY = paste0("TDS Lecture ", 1:nrow(lecture), ": ", lecture_ids)
lecture$LOCATION = "Online - Teams"
lecture$DESCRIPTION = paste0(lecture_description, " in ", lecture$LOCATION)
nrow(lecture)

# practical sessions ------------------------------------------------------

practical_ids = c(
  "structure",
  "getting",
  "routing",
  "modelling",
  "project"
)

practical_descriptions = c(
  "The structure of transport data",
  "Getting transport data",
  "Routing",
  "Modelling",
  "Project work"
)

practical_day_of_week = 4
practical_start_time = "14:00"
practical_end_time = "16:30"
practical = tibble::tibble(week_num = as.character(c(15:16, 18, 21, 23)))
practical = dplyr::inner_join(practical, weeks)
practical$date = practical$week_commencing + (practical_day_of_week - 1)
practical$DTSTART = lubridate::ymd_hm(paste(practical$date, practical_start_time)) 
practical$DTEND = lubridate::ymd_hm(paste(practical$date, practical_end_time))
practical$duration = (practical$DTEND - practical$DTSTART)
practical$type = "Computer practical"
practical$SUMMARY = paste0("TDS Practical ", 1:nrow(practical), ": ", practical_ids)
practical$LOCATION = "Online - Teams"
practical$DESCRIPTION = paste0(practical_descriptions, " in ", practical$LOCATION)
nrow(practical) # there are 5 practicals

# seminars ------------------------------------------------------

seminar_ids = c(
  "mapping",
  "planning"
)
seminar_descriptions = c(
  "Mapping large datasets",
  "Data science in transport planning"
)

seminar_day_of_week = 4
seminar_start_time = "14:00"
seminar_end_time = "16:30"
seminar = tibble::tibble(week_num = as.character(c(17, 19)))
seminar = dplyr::inner_join(seminar, weeks)
seminar$date = seminar$week_commencing + (seminar_day_of_week - 1)
seminar$DTSTART = lubridate::ymd_hm(paste(seminar$date, seminar_start_time)) 
seminar$DTEND = lubridate::ymd_hm(paste(seminar$date, seminar_end_time))
seminar$duration = (seminar$DTEND - seminar$DTSTART)
seminar$type = "Seminar"
seminar$SUMMARY = paste0("TDS seminar ", 1:nrow(seminar))
seminar$LOCATION = "Online - Teams"
seminar$DESCRIPTION = paste0(seminar_descriptions, "")
nrow(seminar) # there is 1 seminar

# deadlines ------------------------------------------------------

deadline_ids = c(
  "computer setup",
  "portfolio draft",
  "portfolio deadline"
)
deadline_descriptions = c(
  "Computer set-up",
  "Practical: visualising transport data",
  "Draft portfolio",
  "Deadline: coursework, 2pm"
)

# Deadline is 15th May: https://minerva.leeds.ac.uk/webapps/blackboard/content/listContentEditable.jsp?content_id=_629207_1&course_id=_504933_1&mode=reset

deadline_day_of_week = 5
deadline_start_time = "13:00"
deadline_end_time = c("13:01", "15:30", "13:01", "13:01")
deadline = tibble::tibble(week_num = as.character(c(14, 17, 22, 25)))
deadline = dplyr::inner_join(deadline, weeks)
deadline$date = deadline$week_commencing + (deadline_day_of_week - 1)
deadline$DTSTART = lubridate::ymd_hm(paste(deadline$date, deadline_start_time)) 
deadline$DTEND = lubridate::ymd_hm(paste(deadline$date, deadline_end_time))
deadline$duration = (deadline$DTEND - deadline$DTSTART)
deadline$type = "Deadline"
deadline$SUMMARY = paste0("TDS deadline ", 1:nrow(deadline))
deadline$LOCATION = "Online - Teams"
deadline$DESCRIPTION = deadline_descriptions

timetable = bind_rows(lecture, practical, seminar, deadline) 

# timetable %>% 
#   mutate(duration = difftime(DTEND, DTSTART, units = "hours")) %>% 
#   select(week_num, type, duration, SUMMARY, DESCRIPTION) %>% 
#   arrange(week_num) %>% 
#   View()

timetable$UID = purrr::map_chr(1:nrow(timetable), ~ calendar::ic_guid())
timetable = timetable %>% 
  arrange(DTSTART) 
units(timetable$duration) = "hours"

sum(timetable$duration) # 20 - up to 25.05 hours of contact time
# xlsx::write.xlsx(timetable, "tds-timetable-2020.xlsx")

ic = calendar::ical(timetable) 
calendar::ic_write(ic[1], "/tmp/test-tds.ics")

# file.edit("/tmp/test-tds.ics")
tt_min = dplyr::select(timetable, SUMMARY, DESCRIPTION, DTSTART, DTEND, LOCATION, UID)
# ic = calendar::ical(tt_min[1:2, ])
ic = calendar::ical(tt_min)


calendar::ic_write(ic, "timetable-2020.ics") # note: generates faulty calendar with ic[1, ]: bug in ic_read?
readLines("timetable-2020.ics")
readr::write_csv(tt_min, "timetable-2020.csv")

