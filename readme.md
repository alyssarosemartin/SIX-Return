# Spring Index Return Interval

This repository contains the code to calculate Return Intervals for Early and Late Springs using the USA-NPN's Gridded Spring Index Anomaly Layers.

## Current Year Return Interval

The file SIXV_RI_Dynamic_2019.R produces two rasters, one which shows how often the Extended Spring Indices, Leaf Index (more info: https://pubs.usgs.gov/of/2017/1003/ofr20171003.pdf) was as early or earlier than 2019, over the period 1981-2018. The second shows how often the Leaf Index was as late or later than 2019, over the period 1981-2018. In both rasters, each grid cell has a value between 1 (meaning we see a spring as early/late as 2019 for this pixel every year) and 38 (meaning only once in the 38 year record have we seen a spring this early/late).

The code runs in R, with rgdal, sp and raster libraries loaded.

The imput rasters are the Spring Index Leaf anomaly layers for 1981-2019. These can be downloaded from the USA-NPN Geoserver Request builder (https://www.usanpn.org/geoserver-request-builder). The requests to Geoserver are formatted like this example for 2005: https://geoserver.usanpn.org/geoserver/wcs?service=WCS&version=2.0.1&request=GetCoverage&coverageId=si-x:leaf_anomaly_prism&SUBSET=time("2005-01-01T00:00:00.000Z")&format=geotiff
