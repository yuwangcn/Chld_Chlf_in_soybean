1
The leaf photosynthesis and transpiration were estimated by a leaf energy balance module (Drewry, et al., 2010)
Use' CalPhotosynthesis_*.m' to run the simulation for each leaf transmittance and reflectance settings
Input:  'PPFD_V231_*.txt'
Output: 'CanopyAT_*.txt'

2
Net canopy CO2 assimilation was calculated by summing the A of all leaf pieces over the daylight hours.
Use 'CanopyAT_*.m' to calculate the canopy CO2 uptake, light absorption, and generate figures.
Input:  'CanopyAT_*.txt'
Output：'CanopyAT_* outA,txt', 'CanopyAT_* outPAR,txt' and figures.

3
All the data from 'CanopyAT_* outA,txt', 'CanopyAT_* outPAR,txt' has been organized and documened in 'Results_all_2404.elsx'

Reference 
Drewry, D. T. et al. Ecohydrological responses of dense canopies to environmental variability: 1. Interplay between vertical structure and photosynthetic pathway. Journal of Geophysical Research-Biogeosciences 115 (2010).