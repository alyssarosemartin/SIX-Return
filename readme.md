# Spring Index Return Interval

This repository contains the code to calculate Return Intervals for Early and Late Springs for leaf out and bloom using the USA-NPN's Gridded Spring Index Anomaly Layers.

## Current Year Return Interval

The file SIXV_RI_Dynamic_2019_leaf.R produces three rasters. The first shows only pixels where leaf out occurs on the date of 30 year average(on time). The second raster shows how often the Extended Spring Indices, Leaf Index (more info: https://pubs.usgs.gov/of/2017/1003/ofr20171003.pdf) was as early or earlier than 2019, over the period 1981-2018. The third raster shows how often the Leaf Index was as late or later than 2019, over the period 1981-2018. In both rasters, each grid cell has a value between 1 (meaning we see a spring as early/late as 2019 for this pixel every year) and 38 (meaning only once in the 38 year record have we seen a spring this early/late).

The file SIXV_RI_Dynamic_2019_bloom.R produces the same three rasters as SIXV_RI_Dynamic_2019_leaf.R, but in this case based on the bloom index.

The code runs in R, with rnpn, curl, rgdal, sp, raster libraries loaded.

The imput rasters are the Spring Index Leaf anomaly layers for 1981-2019. The code downloads and names these files in your working directory.
