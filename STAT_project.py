# -*- coding: utf-8 -*-

"""
The STAT_project is the main program for statistical analysis of different
land cover maps on regional climate in convection-permitting climate simulations.

The progam contains several additional modules:
    DAV_metric       ---> module with algoritms for DAV metrci analysis
    KGE_RMSD         ---> module with KGE and RMSD metrci analysis
    taylorDiagram    ---> module with Taylor diagram visualization and analysis
    
    
Autors of project: Evgenii Churiulin, Merja Tölle, Huan Zhang, 
                                                Center for Enviromental System
                                                Research (CESR) 

                                                   
Current Code Owner: CESR, Evgenii Churiulin
phone:  +49  561 804-6142
fax:    +49  561 804-6116
email:  evgenychur@uni-kassel.de


History:
Version    Date       Name
---------- ---------- ----                                                   
    1.1    2021-03-23 Evgenii Churiulin, Center for Enviromental System Research (CESR)
           Initial release
                 

"""

#------------------------------------------------------------------------------
# Import liblararies and personal modules
#------------------------------------------------------------------------------
import numpy as np
import DAV_metric as dav
import KGE_RMSD   as kge 
import matplotlib.pyplot as plt
from taylorDiagram import TaylorDiagram
#------------------------------------------------------------------------------

# Start the main programm

#------------------------------------------------------------------------------
# Section: Can be changed by user
#------------------------------------------------------------------------------ 

# The main path for folder with data
mf_com = 'C:/Users/Churiulin/Desktop/STAT3/'

# path for results
path_exit = mf_com + 'RESULT/'


refer = 'hyras'

'''  
There are several options for ds_name --> should be changed according to dataset
'E2015' - CCL2015
  'E38' - CCL2000
    'E' - 
    'G' - GLC2000
   'GC' - GlobCover2009
'''

ds_name = 'GC'

# Subfolders for KGE and RMSD data
sf_data_ref   = 'DATA/REFERENCE/'                                              # The subfolder for data
sf_data_ds    = 'DATA/' + ds_name + '/'

# Subfolders for DAV data
sf_data_ref_dav   = 'DATA_DAV/REFERENCE/'                                      # The subfolder for data
sf_data_ds_dav    = 'DATA_DAV/' + ds_name + '/'
sf_data_hyras     = 'DATA_DAV/HYRAS/'


# Parameter list
par_list = ['T_2M', 'TMAX_2M', 'TMIN_2M', 'TOT_PREC']



#------------------------------------------------------------------------------
# Section 2: Run KGE and RMSD statistic analysis
#------------------------------------------------------------------------------

kge_list, rmsd_list, kge_field_list, rmsd_field_list, corr_field_list =  kge.KGE_RMSD_analysis(mf_com, 
                                                                                               sf_data_ref,
                                                                                               sf_data_ds,
                                                                                               par_list,
                                                                                               refer,
                                                                                               ds_name)

#------------------------------------------------------------------------------
# Section 3: Run DAV statistic analysis
#------------------------------------------------------------------------------

DAV_data = dav.DAV_analysis(mf_com, sf_data_ds_dav ,
                                    sf_data_hyras  ,
                                    par_list, ds_name)


#------------------------------------------------------------------------------
# Section 4: Plot Taylor diagram based on Yannick Copin example
#------------------------------------------------------------------------------

"""
Example of use of TaylorDiagram. Illustration dataset courtesy of Michael
Rawlins., R. S. Bradley, H. F. Diaz, 2012. Assessment of regional climate
model simulation estimates over the Northeast United States, Journal of
Geophysical Research (2012JGRD..11723112R).
"""

# Reference std
stdrefs = dict(tot_prec = 1.0)

# Sample std,rho: Be sure to check order and that correct numbers are placed!
#                           stddev  corrcoef    name   
samples = dict(tot_prec = [[7.414,   0.604,    "E2015" ],
                           [7.407,   0.606,    "E38"   ],
                           [7.411,   0.605,    "E"     ],
                           [7.417,   0.604,    "G"     ],
                           [7.408,   0.605,    "GC"    ],])


# Colormap (see http://www.scipy.org/Cookbook/Matplotlib/Show_colormaps)
colors = plt.matplotlib.cm.Set1(np.linspace(0, 1, len(samples['tot_prec']) ) )

# Here set placement of the points marking 95th and 99th significance
# levels. For more than 102 samples (degrees freedom > 100), critical
# correlation levels are 0.195 and 0.254 for 95th and 99th
# significance levels respectively. Set these by eyeball using the
# standard deviation x and y axis.

#x95 = [0.01, 0.68] # For Tair, this is for 95th level (r = 0.195)
#y95 = [0.0, 3.45]
#x99 = [0.01, 0.95] # For Tair, this is for 99th level (r = 0.254)
#y99 = [0.0, 3.45]

x95 = [0.05, 13.9] # For Prcp, this is for 95th level (r = 0.195)
y95 = [0.0 , 72.0]
x99 = [0.05, 19.0] # For Prcp, this is for 99th level (r = 0.254)
y99 = [0.0 , 72.0]

rects = dict(tot_prec = 111)

fig = plt.figure(figsize=(11,8))
fig.suptitle("Precipitation (TOT_PREC)", size='x-large')

for season in ['tot_prec']:
    
    dia = TaylorDiagram(stdrefs[season], fig = fig, rect = rects[season],
                        label = 'HYRAS')

    dia.ax.plot(x95, y95, color = 'k')
    dia.ax.plot(x99, y99, color = 'k')

    # Add samples to Taylor diagram
    for i, (stddev, corrcoef, name) in enumerate(samples[season]):
        
        dia.add_sample(stddev, corrcoef,
                       marker ='$%d$' % (i + 1), ms = 16, ls = '',
                       #mfc='k', mec='k', # B&W
                       mfc = colors[i], mec = colors[i], # Colors
                       label = name)

    # Add RMS contours, and label them
    contours = dia.add_contours(levels = 5, colors = '0.5') # 5 levels
    dia.ax.clabel(contours, inline = 1, fontsize = 16, fmt='%.1f')
    # Tricky: ax is the polar ax (used for plots), _ax is the
    # container (used for layout)
    #dia._ax.set_title(season)

# Add a figure legend and title. For loc option, place x,y tuple inside [ ].
# Can also use special options here:
# http://matplotlib.sourceforge.net/users/legend_guide.html

fig.legend(dia.samplePoints,
           [ p.get_label() for p in dia.samplePoints ],
           numpoints = 1, prop = dict(size = 'xx-large'), loc = 'upper right')

fig.tight_layout()


plt.savefig(path_exit + 'taylor_diagram' + '.png', format='png', dpi = 300) 
plt.show()































