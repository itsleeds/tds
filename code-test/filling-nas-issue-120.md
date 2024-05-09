

``` r
d = c("Road A", NA, NA, "Road B")
zoo::na.locf(d)
```

    [1] "Road A" "Road A" "Road A" "Road B"
