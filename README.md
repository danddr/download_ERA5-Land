### Download_ERA5-Land

This repo contains Python scripts to download and process ERA5-Land climatic reanalysis data using the CDS API. These scripts allow users to easily retrieve temperature and precipitation data over a specified geographic region. You can .

**Key Resources:**
- **How to use the CDS API**: [CDS API Guide](https://cds.climate.copernicus.eu/api-how-to)
- **Bounding Box Coordinates**: retrieve the coordinates of a bounding box using the [Bounding Box Tool](https://boundingbox.klokantech.com/)
- **For Loops in Python for Downloading Reanalysis Data**: [Video Tutorial](https://www.youtube.com/watch?v=EIe7IBMqhsw)

### R Postprocessing Script

The folder also includes an R script that shows how to post-process the downloaded temperature and precipitation data. The R script covers:
- Loading and cropping data to a specific bounding box.
- Converting temperature from Kelvin to Celsius and precipitation from meters to millimeters.
- Calculating weekly averages for temperature and weekly totals for precipitation.
- Saving the processed data in NetCDF format for future analysis.
