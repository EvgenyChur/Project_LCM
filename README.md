# Sensitivity of convection-permitting regional climate simulations to changes in land cover input data: role of land surface characteristics for temperature and climate extremes

### Authors:
<p align="justify">
Merja H. Tölle<sup>1</sup>, Evgenii Churiulin<sup>1</sup>

- Center for Environmental Systems Research, University of Kassel, Wilhelmshöher 5 Allee 47, D-34117 Kassel, Germany

<em><strong>Correspondence to: Merja H. Tölle (merja.toelle@uni-kassel.de)</strong></em>

## Project description:
<p align="justify">  
 Characterization of climate uncertainties due to different land cover maps in regional climate models is essential for adaptation strategies. The spatiotemporal heterogeneity in surface characteristics is considered to play a key role in terrestrial surface processes. Here, we quantified the sensitivity of model results to changes in land cover input data (<a href="http://due.esrin.esa.int/page_globcover.php">GlobCover2009</a>, <a href="https://forobs.jrc.ec.europa.eu/products/glc2000/glc2000.php">GLC2000</a>, <a href="http://maps.elie.ucl.ac.be/CCI/viewer/download.php">CCI</a>, and <a href="http://www.umrcnrm.fr/spip.php?rubrique87&lang=en">ECOCLIMAP</a>) in the regional climate model (RCM) <a href="https://wiki.coast.hzg.de/clmcom ">COSMO-CLM</a> (<strong>v5.0_clm16</strong>). We investigated land cover changes due to the retrieval year, number, fraction and spatial distribution of land cover classes by performing convection-permitting simulations driven by <a href="https://www.ecmwf.int/en/forecasts/datasets/reanalysis-datasets/era5">ERA5</a> reanalysis data over Germany from 2002 to 2011.The role of the surface parameters on the surface turbulent fluxes and temperature is examined, which is related to the land cover classes. The bias of the annual temperature cycle of all the simulations compared with observations is larger than the differences between simulations. The latter is well within the uncertainty of the observations. The land cover class fractional differences are small among the land cover maps. However, some land cover types, such as croplands and urban areas, have greatly changed over the years. These distribution changes can be seen in the temperature differences. Simulations based on the CCI retrieved in 2000 and 2015 revealed no accreditable difference in the climate variables as the land cover changes that occurred between these years are marginal, and thus, the influence is small over Germany. Increasing the land cover types as in ECOCLIMAP leads to higher temperature variability. The largest differences among the simulations occur in maximum temperature and from spring to autumn, which is the main vegetation period. The temperature differences seen among the simulations relate to changes in the leaf area index, plant coverage, roughness length, latent and sensible heat fluxes due to differences in land cover types. The vegetation fraction was the main parameter affecting the seasonal evolution of the latent heat fluxes based on linear regression analysis, followed by roughness length and leaf area index. If the same natural vegetation (e.g. forest) or pasture grid cells changed into urban types in another land cover map, daily maximum temperatures increased accordingly. Similarly, differences in climate extreme indices are strongest for any land cover type change to urban areas. The uncertainties in regional temperature due to different land cover datasets were overall lower than the uncertainties associated with climate projections. Although the impact and their implications are different on different spatial and temporal scales as shown for urban area differences in the land cover maps. For future development, more attention should be given to land cover classification in complex areas, including more land cover types or single vegetation species and regional representative classification sample selection. Including more sophisticated urban and vegetation modules with synchronized input data in RCMs would improve the underestimation of the urban and vegetation effect on local climate.
</p>

## Keywords:
<p align="justify"> 
Land cover input data, land cover change, urban area, climate uncertainty quantification, regional climate model COSMO-CLM, climate indices, land cover classes fraction and distribution 
</p>

## Project contains:
1. The postprocessing scripts for work with COSMO-CLM results:
    * [HYRAS_refer.sh][HYRAS] - analysed data in comparison with HYRAS dataset (main data for article)  
    * [GC_refer.sh][GC] - analysed data in comparison with GlobCover2009 experiment (test) 
    * [G_refer.sh][G] - analysed data in comparison with GLC2000 experiment (test) 
2. The new Python project with statistical and visualization modules:
    * [STAT_project.py][stat] - the main programm for statistical analysis and visualization of COSMO-CLM data
        + [DAV_metric.py][dav] - personal module for the distribution added value (DAV) index
        + [KGE_RMSD.py][kge] - personal module for the root-mean-square error (RMSE), the Pearson correlation coefficient (ρ) and the Kling-Gupta-Efficiency (KGE) index
        + [taylorDiagram.py][tay] - personal module for Taylor diagram

## Author Contributions:
<p align="justify"> 
MHT acquired the funding, designed and conducted the experiments. MHT performed the analysis and obtained the statistical results. EC helped with evaluation statistics. MHT wrote the manuscript. EC contributed to writing about the performance indices and GitHub page. All authors helped in revising the manuscript. All authors agree to be accountable for the content of the work.
</p>

## Conflicts of Interest: 
<p align="justify"> 
The authors declare that the research was conducted in the absence of any commercial or financial relationships that could be construed as a potential conflict of interest.
</p>

## Funding:
<p align="justify">
This research was funded by the German Research Foundation (DFG) through grant number 401857120 and MAPPY. The MAPPY project is part of AXIS, an ERA-NET initiated by JPI Climate, and funded by FFG (Austria), F.R.S.-FNRS and BELSPO (Belgium), DLR/BMBF (Germany), NWO (Netherlands) and AEI (Spain) with co-funding by the European Union (Grant No. 776608, Funding reference No. 01LS1903C) with co-funding from the Horizon 2020 - the Framework Programme for Research and Innovation of the European Union. Computational resources were made available by the German Climate Computing Center (DKRZ) through support from the German Federal Ministry of Education and Research (BMBF). This research was conducted in collaboration with the CLM-community.
</p>



[HYRAS]: https://github.com/EvgenyChur/LU_stat_system/blob/main/HYRAS_refer.sh
[GC]: https://github.com/EvgenyChur/LU_stat_system/blob/main/GC_refer.sh
[G]: https://github.com/EvgenyChur/LU_stat_system/blob/main/G_refer.sh
[stat]: https://github.com/EvgenyChur/LU_stat_system/blob/main/STAT_project.py
[dav]: https://github.com/EvgenyChur/LU_stat_system/blob/main/DAV_metric.py
[kge]: https://github.com/EvgenyChur/LU_stat_system/blob/main/KGE_RMSD.py
[tay]: https://github.com/EvgenyChur/LU_stat_system/blob/main/taylorDiagram.py


[1]: https://doi.org/10.1002/joc.5261
[2]: https://doi.org/10.1016/j.jhydrol.2009.08.003 
[3]: https://doi.org/10.1029/2000JD900719
[4]: https://gist.github.com/ycopin/3342888
