#download 2m temperature from CDS toolbox
import cdstoolbox as ct

@ct.application(title='Download data')
@ct.output.download()

def download_application():
    all_data_daily = []
    
    for i in ['2018', '2019', '2020', '2021', '2022', '2023']:
        data = ct.catalogue.retrieve(
            'reanalysis-era5-land',
            {
                'variable': '2m_temperature',
                'year': [i],
                'month': [
                    '01', '02', '03',
                    '04', '05', '06',
                    '07', '08', '09',
                    '10', '11', '12',
                ],
                'day': [
                    '01', '02', '03',
                    '04', '05', '06',
                    '07', '08', '09',
                    '10', '11', '12',
                    '13', '14', '15',
                    '16', '17', '18',
                    '19', '20', '21',
                    '22', '23', '24',
                    '25', '26', '27',
                    '28', '29', '30',
                    '31',
                ],
                'time': [
                    '00:00', '01:00', '02:00',
                    '03:00', '04:00', '05:00',
                    '06:00', '07:00', '08:00',
                    '09:00', '10:00', '11:00',
                    '12:00', '13:00', '14:00',
                    '15:00', '16:00', '17:00',
                    '18:00', '19:00', '20:00',
                    '21:00', '22:00', '23:00',
                ],
                'area': [
                    49, 1, 40, 20,  # ymax, xmin, ymin, xmax
                ],
            }
        )

        data_daily = ct.climate.daily_mean(data, keep_attrs=True)
        all_data_daily.append(data_daily)
    
    # Combine all the daily data if needed, otherwise return the list
    return all_data_daily
