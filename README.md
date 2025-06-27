# Chld_Chlf_in_soybean
Simulate the light distribution and photosynthesis in a soybean canopy

Model description
===
Using a 3D canopy model of soybean, reconstructed from a field crop, the potential for Chl-d and Chl-f utilization was assessed by simulating their effects on photon absorption and CO2 assimilation. 

Contact Author
---
Yu Wang - https://github.com/yuwangcn

Reference
---
Wang Y., Oliver T. J., Croce R., Long S. P., Addition of longer wavelength absorbing chlorophylls into crops could increase their photosynthetic productivity up to 26%. A theoretical evaluation. (2025)

Software
---
Simulations were conducted in MATLAB 2019a (Mathworks, , Inc., Natick, MA, USA.https://uk.mathworks.com) on a Windows-based system

Users must have MATLAB (R2019a or a later release) installed to utilize the provided code.

No non-standard hardware required.


Step 1   Reconstruct a soybean canopy 
===
**Folder**

SoyCanopy

**Run**

1) Open matlab

2) Change the work path to the SoyCanopy folder

3) Run SoybeanCanopy('M_mean.txt', 'M_Vx.txt', 231, 1, true) in the command window

**Output**

CM_V231_rep1_M_mean.txt

**RUN Time**

about 1-5 mins


**References**

Song, Q. F., Srinivasan, V., Long, S. P. & Zhu, X. G. Decomposition analysis on soybean productivity increase under elevated CO2 using 3-D canopy model reveals synergestic effects of CO2 and light in photosynthesis. Annals of Botany 126, 601-614 (2020). 
Wang, Y., Burgess, S. J., de Becker, E. M. & Long, S. H. P. Photosynthesis in the fleeting shadows: an overlooked opportunity for increasing crop productivity? Plant Journal 101, 874-884 (2020).

Step 2   Simulate the light distribution in the soybean canopy
===
Photon fluxes in different wavelengths at each leaf piece was predicted using a forward ray-tracing algorithm (FastTracer, https://github.com/PlantSystemsBiology/fastTracerPublic)

**Folder**

FastTracer

**Run**

1) Open Windows PowerShell

2) Change the work path to the FastTracer folder

3) Commands can be find in 'Sim.txt'

**Input soybean canopy:**

V231_rep1.txt

(The file was converted from the file 'CM_V231_rep1_M_mean.txt' to meet the requirement of the FastTracer, column 1-9 in 'CM_V231_rep1_M_mean.txt' to column 6-14 in 'V231_rep1.txt', column 10 in 'CM_V231_rep1_M_mean.txt' to column 1 in 'V231_rep1.txt')

**Output** 

light profile with different leaf transmittance and reflectance settings (Check the 'Sim.txt' for simulation details)

PPFD_V231_*.txt

**RUN Time**

about about 5 hours (time changes with the different transmittance and reflectance settings)

**Reference**

Song Q, Zhang G, Zhu X-G. 2013. Optimal crop canopy architecture to maximise canopy photosynthetic CO2 uptake under elevated CO2- a theoretical study using a mechanistic model of canopy photosynthesis. Functional Plant Biology 40, 109–124.


Step 3   Canopy photosynthesis estimation
===

**Folder**

CanopyPhotosynhesis

**3.1**

The leaf photosynthesis and transpiration were estimated by a leaf energy balance module (Drewry, et al., 2010)

**Run**

Use' CalPhotosynthesis_*.m' to run the simulations for each leaf transmittance and reflectance setting

for example:

1) Open matlab

2) Change the work path to the CanopyPhotosynhesis folder

3) Run 'CalPhotosynthesis_chld_con.m' in the command window

**Input:** 

'PPFD_V231_*.txt'

**Output:** 

'CanopyAT_*.txt'


**3.2**

Net canopy CO2 assimilation was calculated by summing the A of all leaf pieces over the daylight hours.

**Run**

Use 'CanopyAT_*.m' to calculate the canopy CO2 uptake, light absorption, and generate figures.

**Input:**  

'CanopyAT_*.txt'

**Output：**

'CanopyAT_* outA,txt', 'CanopyAT_* outPAR,txt' and figures.


**3.3**

All the data from 'CanopyAT_* outA,txt', 'CanopyAT_* outPAR,txt' has been organized and documened in 'Results_all_2404.elsx'

**RUN Time**

about 10 mins

**Reference** 

Drewry, D. T. et al. Ecohydrological responses of dense canopies to environmental variability: 1. Interplay between vertical structure and photosynthetic pathway. Journal of Geophysical Research-Biogeosciences 115 (2010).
