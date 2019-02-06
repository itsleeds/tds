# group 1
person_name = c(
  "robin",
  "malcolm",
  "richard"
)
n_coffee = c(
  5,
  1,
  0
)
like_bus_travel = c(
  TRUE,
  FALSE,
  TRUE
)
personal_data1 = data.frame(
  person_name, 
  n_coffee, 
  like_bus_travel
  )

#Group 2
person_name = c(
  "Zi", 
  "Ignacio")
n_coffee = c(
  4, 
  0)
like_bus_travel = c(
  FALSE, 
  TRUE)
personal_data2 = data.frame(
  person_name, 
  n_coffee, 
  like_bus_travel
)

#Group 3
person_name = c("Caroline", "Tatjana")
n_coffee = c(6, 8)
like_bus_travel = c(FALSE, FALSE)

personal_data3 = data.frame(person_name,
                           n_coffee,
                           like_bus_travel)


# Group 4
person_name = c(
  "Hawah",
  "Colin",
  "Eugeni")

n_coffee = c(
  2,0,7
) 

like_bus_travel= c(FALSE, TRUE, FALSE)
person_data4 = data.frame(
  person_name, 
  n_coffee, 
  like_bus_travel
)

everyone = rbind(
  personal_data1,
  personal_data2,
  personal_data3,
  person_data4
  )

mean(everyone$n_coffee)

readr::write_csv(everyone, "sample-data/everyone.csv")
