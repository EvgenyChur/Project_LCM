# Sensitivity of convection-permitting regional climate simulations to changes in land cover input data: role of land surface characteristics for temperature and climate extremes

### Authors:
<p align="justify">
Merja H. Tölle<sup>1</sup>, Evgenii Churiulin<sup>1</sup>

- Center for Environmental Systems Research, University of Kassel, Wilhelmshöher 5 Allee 47, D-34117 Kassel, Germany

<em><strong>Correspondence to: Merja H. Tölle (merja.toelle@uni-kassel.de)</strong></em>

## Project description:
<p align="justify">  
In regional climate models, characterization of climate uncertainties due to different land cover maps is essential for adaptation strategies. The spatiotemporal heterogeneity in surface characteristics is considered to play a key role in terrestrial surface processes. Here, we quantified the sensitivity of model results to changes in land cover input data (<a href="http://due.esrin.esa.int/page_globcover.php">GlobCover2009</a>, <a href="https://forobs.jrc.ec.europa.eu/products/glc2000/glc2000.php">GLC2000</a>, <a href="http://maps.elie.ucl.ac.be/CCI/viewer/download.php">CCI</a>, and <a href="http://www.umrcnrm.fr/spip.php?rubrique87&lang=en">ECOCLIMAP</a>) in the regional climate model (RCM) <a href="https://wiki.coast.hzg.de/clmcom ">COSMO-CLM</a> (<strong>v5.0_clm16</strong>). We investigated land cover changes due to the retrieval year, number, fraction and spatial distribution of land cover classes by performing convection-permitting simulations driven by <a href="https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5">ERA5</a> reanalysis data over Germany from 2002 to 2011. The role of the surface parameters on the surface turbulent fluxes and temperature is examined, which is related to the land cover classes. The annual temperature bias of all the simulations compared with observations is larger than the differences between simulations. The latter is well within the uncertainty of the observations. The land cover class fractional differences are small among the land cover maps. However, some land cover types, such as croplands and urban areas, have greatly changed over the years. These changes can be seen in the temperature differences. Simulations based on the CCI retrieved in 2000 and 2015 revealed no accreditable difference in the climate variables as the land cover changes that occurred between these years are marginal, and thus, the influence is small over Germany. Increasing the land cover types as in ECOCLIMAP leads to higher temperature variability. The largest differences among the simulations occur in maximum temperature and from spring to autumn, which is the main vegetation period. The temperature differences seen among the simulations relate to changes in the leaf area index, plant coverage, roughness length, latent and sensible heat fluxes due to differences in land cover types. The vegetation fraction was the main parameter affecting the seasonal evolution of the latent heat fluxes based on linear regression analysis, followed by roughness length and leaf area index. If the same natural vegetation or pasture grid cells changed into urban types in another land cover map, daily maximum temperatures changed accordingly. Similarly, differences in climate extreme indices are strongest for any land cover type change to urban areas. The uncertainties in regional temperature due to different land cover datasets were overall lower than the uncertainties associated with climate projections. Although the impact and their implications are different on different spatial and temporal scales as shown for urban area differences in the land cover maps. For future development, more attention should be given to land cover classification in complex areas, including more land cover types or single vegetation species and regional representative classification sample selection. Including more sophisticated urban and vegetation modules in RCMs would improve the underestimation of the urban and vegetation effect on local climate
</p>

![Figure07](https://github.com/EvgenyChur/LU_stat_system/blob/main/Fig07.JPG) 

<p align="justify">
<em>Distribution of latent heat flux (A) to (E), LAI (F) to (J), and plant cover (K) to (O) differences between the experimental simulation based on the GLC land cover map (first column), the CCI38 land cover map (second column), the CCI2015 land cover map (third column), the CCI land cover map (fourth column), the ECO land cover map (fifth column) and the control simulation based on the GC land cover map over the vegetation period (May to September) from 2002 to 2011.</em>
</p>

 ## Project contains:
 
1. The main program for statistical analysis:
    * ***STAT_project***, moreover project is related to 3 additional modules: ***DAV_metric***, ***KGE_RMSD***, ***taylorDiagram***


1. The ***DAV_metric*** is a module for the distribution added value (DAV) index [Soares and Cardoso, 2017][1] calulations:
<img src="https://render.githubusercontent.com/render/math?math=DAV =\frac{S_{EXP}-S_{CTR}}{S_{CTR}}">
  
2. The ***KGE_RMSD*** is a module for the root-mean-square error (RMSE), the Pearson correlation coefficient (ρ) and the Kling-Gupta-Efficiency (KGE) index [Gupta et al., 2009][2] calculations  

<img src="https://render.githubusercontent.com/render/math?math=KGE =1-\sqrt{(\rho-1)^{2}+(\frac{\sigma_{EXP}}{\sigma_{OBS}}-1)^{2}+(\frac{\mu_{EXP}}{\mu_{OBS}}-1)^{2}}">
 


![temp](https://github.com/EvgenyChur/LU_stat_system/blob/main/Temp_diff.JPG?raw=true)



3. The ***taylorDiagram*** is a module for Taylor diagram vizualization based on work [Taylor., 2001][3] and [Copin., 2018][4]













[1]: https://doi.org/10.1002/joc.5261
[2]: https://doi.org/10.1016/j.jhydrol.2009.08.003 
[3]: https://doi.org/10.1029/2000JD900719
[4]: https://gist.github.com/ycopin/3342888
