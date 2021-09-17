#!/bin/bash

#-------------------------------------------------------------------------------
#
# Current code owner:
#
#   Center Enviroment System Research (CESR)
#
# Authors:
#
#   CESR, 2021
#   Evgenii Churiulin, Merja Toelle
#   phone:  +49 170-261-51-04
#   email:  evgenychur@uni-kassel.de
#
#-------------------------------------------------------------------------------

#source ~/.profile


#========================= Settings ============================================
# The main parameters for analysis
#params

# ds_6 don't have parameter TOT_PREC
params1=("T_2M" "TMAX_2M" "TMIN_2M" "TOT_PREC")
params2=("tas" "tmax" "tmin" "pr")
paramscount=3

#params1=("T_2M" "TMAX_2M" "TMIN_2M")
#params2=("tas" "tmax" "tmin")
#paramscount=2

# The time period for T2m_mean, T2m_max, T2m_min
period="20020101"_"20111231"_"dayC"."nc"

# The time period for TOT_PREC
period_prec="20020101"_"20111231"_"day"."nc"

# The name of dataset:
#ds_name=("LU_E2015" "LU_E38" "LU_E" "LU_G" "LU_GC" "LU_ECO")
#datacount=5

ds_name=("LU_E2015" "LU_E38" "LU_E" "LU_G" "LU_GC")
datacount=4




#========================= Paths ===============================================
DIR=/work/bb1112
DIR_IN=${DIR}/STAT
DIR_OUT=${DIR}/b381275/results/STAT
DIR_RESULT=/pf/b/b381275/COSMO_results/STAT

#========================= Generation operations ===============================

for (( i=0; i<=datacount ; i++ ));
do
    # Dataset: The model data
    for (( j=0; j<=paramscount ; j++ ));
    do
        # Filename of HYRAS data
        hyras_fn="${params2[${j}]}"_"hyras_5_2002-2011_LU"."nc"
        echo 'Observation_name '$hyras_fn

        # Filename of MODEL data
        if [ "${params1[${j}]}" == "TOT_PREC" ]; then
            model_ds="${ds_name[${i}]}"_"${params1[${j}]}"_"${period_prec}"
        else
            model_ds="${ds_name[${i}]}"_"${params1[${j}]}"_"${period}"
        fi
        echo 'Dataset_name '$model_ds

        # Paths for input and output HYRAS data
        h_in=${DIR_IN}/"${hyras_fn}"
        h_out_std=${DIR_OUT}/"hyras"_"${params1[${j}]}"_"std_obs"
        h_out_mean=${DIR_OUT}/"hyras"_"${params1[${j}]}"_"mean_obs"
        h_out_dav=${DIR_OUT}/"hyras"_"${params1[${j}]}"_"mean_dav_obs"

        # Path + name for model output (KGE and RMSD)
        mod_in=${DIR_IN}/"${model_ds}"
        mod_out_std=${DIR_OUT}/"${ds_name[${i}]}"_"${params1[${j}]}"_"std_mod"
        mod_out_mean=${DIR_OUT}/"${ds_name[${i}]}"_"${params1[${j}]}"_"mean_mod"
        mod_out_dav=${DIR_OUT}/"${ds_name[${i}]}"_"${params1[${j}]}"_"mean_dav_mod"

        # Path for correlation
        cor_out=${DIR_OUT}/"Corr_HYRAS"_"${ds_name[${i}]}"_"${params1[${j}]}"
        #---------------------------------------------------------------------------



        # Calculations for KGE and RMSD

        # Calculate std, mean for HYRAS dataset
        cdo timstd "${h_in}" "${h_out_std}"."nc"
        cdo timmean "${h_in}" "${h_out_mean}"."nc"

        # Calculate std, mean for MODEL dataset
        cdo timstd "${mod_in}" "${mod_out_std}"."nc"
        cdo timmean "${mod_in}" "${mod_out_mean}"."nc"

        # Calculate correlation coefficient between reference and dataset
        cdo timcor "${h_in}" "${mod_in}" "${cor_out}"."nc"
        #-----------------------------------------------------------------------
        # Output NetCDF > csv for HYRAS dataset
        cdo -outputtab,date,lon,lat,value "${h_out_std}"."nc" > "${h_out_std}"."csv"
        cdo -outputtab,date,lon,lat,value "${h_out_mean}"."nc" > "${h_out_mean}"."csv"
        # Output NetCDF > csv for MODEL dataset
        cdo -outputtab,date,lon,lat,value "${mod_out_std}"."nc" > "${mod_out_std}"."csv"
        cdo -outputtab,date,lon,lat,value "${mod_out_mean}"."nc" > "${mod_out_mean}"."csv"
        # Output NetCDF > csv for correletion
        cdo -outputtab,date,lon,lat,value "${cor_out}"."nc" > "${cor_out}"."csv"


        #Calculations for DAV

        # Calculate std, mean for HYRAS dataset
        cdo fldmean "${h_in}" "${h_out_dav}"."nc"
        # Calculate std, mean for MODEL dataset
        cdo fldmean "${mod_in}" "${mod_out_dav}"."nc"

        #-----------------------------------------------------------------------
        # Output NetCDF > csv for HYRAS dataset
        cdo -outputts "${h_out_dav}"."nc" > "${h_out_dav}"."csv"
        # Output NetCDF > csv for MODEL dataset
        cdo -outputts "${mod_out_dav}"."nc" > "${mod_out_dav}"."csv"


    done
done
cp -R ${DIR_OUT}/*."csv" ${DIR_RESULT}
rm -r ${DIR_OUT}/*





