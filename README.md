# Uncertainty of different land cover maps on regional climate in convection-permitting climate simulations: role of land-surface characteristics

The repository contains the main algorithms for statistical analysis of datasets for the research.

The main program for this research is ***STAT_project***, moreover project is related to 3 additional modules: ***DAV_metric***, ***KGE_RMSD***, ***taylorDiagram***



1. The ***DAV_metric*** is a module for the distribution added value (DAV) index [Soares and Cardoso, 2017][1] calulations:
\begin{align}
    (1 - \alpha)R_{S}^\downarrow + \varepsilon_{g}R_{T}^\downarrow - \varepsilon_{g}\sigma T^4 + H + \lambda E = G \label{eq2}\tag{2}
\end{align}
<br>
  
2. The ***KGE_RMSD*** is a module for the root-mean-square error (RMSE), the Pearson correlation coefficient (ρ) and the Kling-Gupta-Efficiency (KGE) index [Gupta et al., 2009][2] calculations  
<img src="https://render.githubusercontent.com/render/math?math=KGE = 1 - sgrt{ (\rho - 1)^{2} + (\frac{\sigma_{EXP}}{\sigma_OBS} - 1)^{2} + (\frac{\mu_EXP}{\mu_OBS} - 1)^{2} } G \label{eq2}\tag{2}">



3. The ***taylorDiagram*** is a module for Taylor diagram vizualization based on work [Taylor., 2001][3] and [Copin., 2018][4]

![taylorDiagram](https://github.com/EvgenyChur/LU_stat_system/blob/main/taylor_diagram.png?raw=true)




v






[1]: https://doi.org/10.1002/joc.5261
[2]: https://doi.org/10.1016/j.jhydrol.2009.08.003 
[3]: https://doi.org/10.1029/2000JD900719
[4]: https://gist.github.com/ycopin/3342888
