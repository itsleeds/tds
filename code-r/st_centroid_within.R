

#' Return features the centroids of which are inside another object
#' 
#' 
#' 
sf::st_within
polygons = spData::lnd
polygons_central = polygons[polygons$NAME == "City of London", ]
study_region = polygons[polygons_central, ]
study_region = sf::st_union(study_region)
subset_touching = polygons[study_region, ]
plot(polygons$geometry)
plot(subset_touching, col = "grey", add = TRUE)
plot(study_region, col = "red", add = TRUE)

# Function to return only polygons whose centroids are inside
x = polygons
y = study_region
filter_polygon_centroids = function(x, y) {
  x_centroids = sf::st_centroid(x)
  x_in_y = sf::st_intersects(x_centroids, y)
  x_in_y_logical = lengths(x_in_y) > 0
  x[x_in_y_logical, ]
}

subset_test = filter_polygon_centroids(x = polygons, y = study_region)
plot(subset_test, col = "green", add = TRUE)

# Test output of st_intersects..
