# -*- coding: utf-8 -*-
"""
The KGE_RMSD metric is the program for calculation the root-mean-square error (RMSE)
and the Kling-Gupta-Efficiency (KGE) index (Gupta et al., 2009) 
Gupta, H.V. Kling, H. Yilmaz, K.K. Martinez, G.F.: Decomposition of the mean 
squared error and NSE performance criteria: Implications for improving 
hydrological modelling. J. Hydrol. 2009, 377, 80–91. 
https://doi.org/10.1016/j.jhydrol.2009.08.003                
                                      
The progam contains several subroutine:
    get_data          ---> The subroutine needs for getting actual COSMO data
    get_grid          ---> The subroutine needs for getting probability density function
    KGE_RMSD_analysis ---> The subroutine needs for statistical analysis of the datasets
    
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
    1.1    2021-03-25 Evgenii Churiulin, Center for Enviromental System Research (CESR)
           Initial release
                 
"""


import math
import numpy as np
import pandas as pd

#------------------------------------------------------------------------------
# Subroutine: get_data
#------------------------------------------------------------------------------
# The subroutine needs for getting actual information from dataset
# 
# Input parameters : path     - path for data
#                    par_name - name of columns   
# Output parameters: df       - the data frame with information about interesting 
#                               parameter
#------------------------------------------------------------------------------

def get_data(path, par_name):
    df = pd.read_csv(path, skiprows = 0, sep=' ', skipinitialspace = True, 
                     na_values = ['-999','-1','***','******'])
    df = df.drop(['#', 'value', 'Unnamed: 5'], axis = 1 )
    df.columns = ['lon', 'lat', par_name]     
    df = df.drop(['lon', 'lat'], axis = 1 )   
    return df
# end Subroutine get_data
#------------------------------------------------------------------------------


#------------------------------------------------------------------------------
# Subroutine: get_grid
#------------------------------------------------------------------------------
# The subroutine needs for getting actual information about longitude and
# latitude for current grid
# 
# Input parameters : path     - path for data
#                    par_name - name of columns    
#
# Output parameters: lat - latitude
#                    lon - longitude
#------------------------------------------------------------------------------
def get_grid(path, par_name):
    df = pd.read_csv(path, skiprows = 0, sep=' ', skipinitialspace = True, 
                     na_values = ['-999','-1','***','******'])
    df = df.drop(['#', 'value', 'Unnamed: 5'], axis = 1 )
    df.columns = ['lon', 'lat', par_name]      
    df = df.drop([par_name], axis = 1 ) 
    lon = df['lon']
    lat = df['lat']  
    return lon, lat
# end Subroutine get_grid
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Subroutine: KGE_RMSD_analysis
#------------------------------------------------------------------------------
# The subroutine needs for statistical analysis of the datasets
# Input parameters : mf_com      - the main path to folder
#                    sf_data_ref - subfolder for reference data
#                    sf_data_ds  - subfolder for model data
#                    par_list    - the list with parameters
#                    refer       - the name of reference data set 
#                    ds_name     - the name of model dataset  
#                    mode        - type of data for work 
#
# Output parameters: ref_kge, ref_rmsd, ref_corr - statistical parameters
#------------------------------------------------------------------------------

def KGE_RMSD_analysis(mf_com, sf_data_ref, sf_data_ds, par_list, refer, ds_name, mode):
    
    # FileNames for data
    m_obs  = refer           + '_' + par_list + '_mean_obs.csv'
    s_obs  = refer           + '_' + par_list + '_std_obs.csv'
    m_mod  = 'LU_' + ds_name + '_' + par_list + '_mean_mod.csv'
    s_mod  = 'LU_' + ds_name + '_' + par_list + '_std_mod.csv'   
    if mode == 1:
        c_name = 'Corr_' + 'GC_LU_' + ds_name + '_' + par_list + '.csv'       # mode 1
    elif mode == 2:
        c_name = 'Corr_' + 'G_LU_' + ds_name + '_' + par_list + '.csv'        # mode 2
    else:
        c_name = 'Corr_' + refer + '_LU_' + ds_name + '_' + par_list + '.csv' # mode 3
    
    path_m_obs = mf_com + sf_data_ref + m_obs
    path_s_obs = mf_com + sf_data_ref + s_obs
    path_m_mod = mf_com + sf_data_ds  + m_mod
    path_s_mod = mf_com + sf_data_ds  + s_mod
    path_c     = mf_com + sf_data_ds  + c_name        
        
    # Get data    
    df_mean_obs = get_data(path_m_obs, 'M_obs' )
    df_std_obs  = get_data(path_s_obs, 'S_obs' )
    df_mean_mod = get_data(path_m_mod, 'M_mod' )
    df_std_mod  = get_data(path_s_mod, 'S_mod' )
    df_corr     = get_data(path_c    , 'P'     )
                           
    # Get coordinates
    lon,lat     = get_grid(path_m_obs, 'M_obs' )   
     
    # Combine in one dataframe
    df_data = pd.concat([lon, lat, df_mean_obs, df_std_obs, df_mean_mod, 
                                    df_std_mod, df_corr  ], axis = 1)
    
    # Delete nan values
    df_data = df_data.dropna()
    # Reset index
    df_data = df_data.reset_index()
    # Delete previous index
    df_data = df_data.drop(['index'], axis = 1 )

    # Create two zero timeseries
    kge  = pd.Series(np.nan, index = df_data.index, name = 'KGE' )
    rmsd = pd.Series(np.nan, index = df_data.index, name = 'RMSD')
        
    # Get correlation values
    ref_corr = np.mean(df_data['P'])
    print('CORR ' + ds_name + '_' + par_list + ' - ',  
              "{:.3f}".format(ref_corr), '\n')    
 
    # Get KGE and RMSD
    for row in range(len(df_data)):          
        kge[row] = 1.0 - math.sqrt((df_data['P'][row] - 1.0 )**2.0 + 
                                   (df_data['S_mod'][row] / df_data['S_obs'][row] - 1.0 )**2.0 +
                                   (df_data['M_mod'][row] / df_data['M_obs'][row] - 1.0 )**2.0 ) 
        #print (row, '-', len(kge))        
        if row == (len(kge) - 1):
            print ('hel')
            if kge[row] < -1.5:
                kge[row] = kge[row - 1]
        else:
            if kge[row] < -1.5:
                kge[row] = (kge[row-1] + kge[row+1]) / 2.0
                
        try:
            rmsd[row] = math.sqrt((df_data['S_obs'][row])**2.0 + 
                                  (df_data['S_mod'][row])**2.0 -
                                  2.0 * df_data['S_obs'][row] * 
                                        df_data['S_mod'][row] * 
                                        df_data['P'][row])  
            
        except ValueError as error:
            #print ( 'Line: ', row, 'Parameter ', par, 'sqrt(0) ', error , '\n')
            rmsd[row] = -1.0 * math.sqrt( abs((df_data['S_obs'][row])**2.0 + 
                                              (df_data['S_mod'][row])**2.0 -
                                              2.0 * df_data['S_obs'][row] * 
                                                    df_data['S_mod'][row] * 
                                                    df_data['P'][row]))        
        
    ref_kge  = np.mean(kge)
    ref_rmsd = np.mean(rmsd)
    
    return ref_kge, ref_rmsd, ref_corr  
  
