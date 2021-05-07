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
#   Evgenii Churiulin, Vladimir Kopeykin, Merja Toelle
#   phone:  +49 170-261-51-04
#   email:  evgenychur@uni-kassel.de
#
#-------------------------------------------------------------------------------

#source ~/.profile


#========================= Settings ============================================
# The main parameters for analysis
params="T_2M TMAX_2M TMIN_2M TOT_PREC"

# The time period for T2m_mean, T2m_max, T2m_min
period="20020101"_"20111231"_"dayC"."nc"

# The time period for TOT_PREC
period_prec="20020101"_"20111231"_"day"."nc"

# The name of dataset: ds_1 - LU_E2015
#                      ds_2 - LU_E38
#                      ds_3 - LU_E
#                      ds_4 - LU_GC
dataset="ds_4"

refer="LU_G"

# Use dataset
if [ "${dataset}" == "ds_1" ]; then
    ds_name="LU_E2015"

elif [ "${dataset}" == "ds_2" ]; then
    ds_name="LU_E38"

elif [ "${dataset}" == "ds_3" ]; then
    ds_name="LU_E"

elif [ "${dataset}" == "ds_4" ]; then
    ds_name="LU_GC"

else
    echo 'no datasets'
fi


#========================= Paths ===============================================
DIR=/work/bb1112
DIR_IN=${DIR}/STAT
DIR_OUT=${DIR}/b381275/results/STAT
DIR_RESULT=/pf/b/b381275/COSMO_results/STAT

#========================= Generation operations ===============================


for param in ${params}
do
    if [ "${param}" == "TOT_PREC" ]; then
        # Dataset: The reference data
        refer_data="${refer}"_"${param}"_"${period_prec}"
        # Dataset: The model data
        model_ds="${ds_name}"_"${param}"_"${period_prec}"

    else
        # Dataset: The reference data
        refer_data="${refer}"_"${param}"_"${period}"
        # Dataset: The model data
        model_ds="${ds_name}"_"${param}"_"${period}"
    fi

    # Print filenames for our datasets
    echo 'Dataset_lr '$refer_data
    echo 'Dataset_hr '$model_ds

    if [ "${dataset}" == "ds_1" ]; then
        # Calcuate std, mean for reference dataset
        cdo timstd ${DIR_IN}/"${refer_data}" ${DIR_OUT}/"${refer}"_"${param}"_"std_obs"."nc"

        cdo timmean ${DIR_IN}/"${refer_data}" ${DIR_OUT}/"${refer}"_"${param}"_"mean_obs"."nc"

        # NetCDF > csv for reference dataset
        cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${refer}"_"${param}"_"std_obs"."nc" > ${DIR_OUT}/"${refer}"_"${param}"_"std_obs"."csv"

        cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${refer}"_"${param}"_"mean_obs"."nc" > ${DIR_OUT}/"${refer}"_"${param}"_"mean_obs"."csv"
    else
        echo 'Use ds_1'
    fi


    # Calcuate std, mean for model dataset
    cdo timstd ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"${ds_name}"_"${param}"_"std_mod"."nc"
    cdo timmean ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"${ds_name}"_"${param}"_"mean_mod"."nc"

    # NetCDF > csv for model dataset
    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${ds_name}"_"${param}"_"std_mod"."nc" > ${DIR_OUT}/"${ds_name}"_"${param}"_"std_mod"."csv"
    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${ds_name}"_"${param}"_"mean_mod"."nc" > ${DIR_OUT}/"${ds_name}"_"${param}"_"mean_mod"."csv"

    # Calculate correlation coefficient between reference and dataset 1
    cdo timcor ${DIR_IN}/"${refer_data}" ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"Corr_G"_"${ds_name}"_"${param}"."nc"
    # NetCDF > csv for correlation
    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"Corr_G"_"${ds_name}"_"${param}"."nc" > ${DIR_OUT}/"Corr_G"_"${ds_name}"_"${param}"."csv"


done

cp -R ${DIR_OUT}/*."csv" ${DIR_RESULT}
rm -r ${DIR_OUT}/*