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
personal_data = data.frame(person_name, n_coffee, like_bus_travel)
personal_data

sum(personal_data$n_coffee)
