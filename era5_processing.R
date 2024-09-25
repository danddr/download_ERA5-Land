# Set working directory
setwd("/your/working/directory/")

# Load required libraries
library(terra)
library(lubridate)

# Define the bounding box for spatial cropping (xmin, xmax, ymin, ymax)
bbox <- terra::ext(0.95, 20.05, 36, 49.05)

# ---- Temperature Data Processing ----
# Load temperature data from the NetCDF file
temp_rast <- terra::rast("your_temperature_file.nc")

# Extract the time dimension from the temperature raster
temp_dates <- terra::time(temp_rast)

# Crop the raster to reduce its spatial extent using the bounding box
temp_rast <- terra::crop(temp_rast, bbox)

# Rename the raster layers using date information
names(temp_rast) <- paste0("tas_", temp_dates)

# Plot the temperature for a specific date
plot(temp_rast$`tas_2018-01-01`)

# Save cropped temperature data as a new NetCDF file
temp_output <- "tas_daily_2018_2023.nc"
writeCDF(temp_rast, temp_output, overwrite = TRUE, 
         varname = "t2m", 
         longname = "2 metre temperature", 
         unit = "K")

# Convert temperature from Kelvin to Celsius
temp_rast <- terra::app(temp_rast, fun = function(x) { x - 273.15 }, cores = 5)
terra::time(temp_rast) <- temp_dates

# Calculate weekly average temperature for each year
temp_weekly <- terra::tapp(temp_rast, index = "yearweek", fun = "mean", cores = 5)
plot(temp_weekly$yw_201801)

# ---- Precipitation Data Processing ----

# Note: ERA5-Land "hourly total precipitation" refers to the accumulated total precipitation per hour.
# To get the daily cumulative precipitation for day i, use only the total at midnight (hour == 0).
# See more information here:
# - https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-land?tab=overview
# - https://forum.ecmwf.int/t/total-precipitation-values-not-in-range-era5-land-hourly-data-from-1981-to-present/1128/7

# Load precipitation data from the NetCDF file
precip_rast <- terra::rast("your_precipitation_file.nc")

# Extract only the layers corresponding to midnight observations (hour == 0)
time_info <- data.frame(id = 1:terra::nlyr(precip_rast),
                        date = terra::time(precip_rast),
                        hour = lubridate::hour(terra::time(precip_rast)))

midnight_info <- subset(time_info, hour == 0)
precip_rast <- precip_rast[[midnight_info$id]]

# Crop the raster to the same spatial extent as before
precip_rast <- terra::crop(precip_rast, bbox)

# Convert precipitation from meters to millimeters
precip_rast <- terra::app(precip_rast, fun = function(x) { x * 1000 }, cores = 5)
terra::time(precip_rast) <- midnight_info$date
terra::units(precip_rast) <- "mm"

# Save the processed precipitation data as a new NetCDF file
precip_output <- "tp_daily_2018_2023.nc"
writeCDF(precip_rast, precip_output, overwrite = TRUE, 
         varname = "tp", 
         longname = "Total precipitation", 
         unit = "mm")

# Calculate weekly total precipitation for each year
precip_weekly <- terra::tapp(precip_rast, index = "yearweek", fun = "sum", cores = 5)
plot(precip_weekly$yw_201801)