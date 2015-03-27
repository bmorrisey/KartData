# KartData
GoKart Race Data Acquisition and Plotting

Project can be classified into two primary capabilities:

1.  Data Acquisition
2.  Data Visualization

## Data Acquisition
File (MATLAB function): [kart_data_master.m](https://github.com/bmorrisey/KartData/blob/master/kart_data_master.m)
Call the function with a minimum of 3 arguments:
*  Beginning Heat ID, e.g., 150002
*  Ending Heat ID, e.g., 151563
*  Output data filename, e.g., 'March_Laptimes.mat'

You must discover your heat IDs on your own, it is a generally annoying process. These are heat IDs that bracket the timespan you are interested in, and can be found by guess-and-testing the following URL structure. It seems that not all heat IDs are valid, and in some cases not monotonic and/or continuous.
http://mb21000oaks.clubspeedtiming.com/sp_center/HeatDetails.aspx?HeatNo=150002

## Data Visualization
File (MATLAB script): [kart_plotting_all.m](https://github.com/bmorrisey/KartData/blob/master/kart_plotting_all.m)

A .mat file must be specified in the first block of kart_plotting_all.m. This is a .mat file that was created by kart_data_master.m.

Other parameters may be specified in the first block of the plotting script, including the racers you wish to highlight, and whether to create png files of the three primary visualizations (shown below).

### Racer Performance
Compares known racers to all other racers on a per-kart basis.
![Racer Performance](/images/RacerPerformance.png)

### Kart Ranking
Ranks the karts by the average of the best [selectable] percentage of lap times.
![Kart Ranking](/images/KartTiers.png)

### Kart Rank Sensitivity Analysis
Evaluates how the kart rank results change if we use different sample sizes of best times.
![Rank Sensitivity](/images/KartRankingSensitivity.png)
