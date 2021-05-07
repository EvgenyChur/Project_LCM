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
#params

params1=("T_2M" "TMAX_2M" "TMIN_2M" "TOT_PREC")
params2=("tas" "tmax" "tmin" "pr")
paramscount=3

#hyras_par="tas tmax tmin pr"

# The time period for T2m_mean, T2m_max, T2m_min
period="20020101"_"20111231"_"dayC"."nc"

# The time period for TOT_PREC
period_prec="20020101"_"20111231"_"day"."nc"

# The name of dataset: ds_1 - LU_E2015
#                      ds_2 - LU_E38
#                      ds_3 - LU_E
#                      ds_4 - LU_G
#                      ds_5 - LU_GC
dataset="ds_5"


# Use dataset
if [ "${dataset}" == "ds_1" ]; then
    ds_name="LU_E2015"

elif [ "${dataset}" == "ds_2" ]; then
    ds_name="LU_E38"

elif [ "${dataset}" == "ds_3" ]; then
    ds_name="LU_E"

elif [ "${dataset}" == "ds_4" ]; then
    ds_name="LU_G"

elif [ "${dataset}" == "ds_5" ]; then
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

# Dataset: The model data
for (( j=0; j<=paramscount ; j++ ));
do
    if [ "${params1[${j}]}" == "TOT_PREC" ]; then

        model_ds="${ds_name}"_"${params1[${j}]}"_"${period_prec}"

    else
        model_ds="${ds_name}"_"${params1[${j}]}"_"${period}"

    fi
    echo 'Dataset_name '$model_ds
    # Calcuate std, mean for model dataset
    cdo timstd ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"std_mod"."nc"
    cdo timmean ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"mean_mod"."nc"

    # NetCDF > csv for model dataset
    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"std_mod"."nc" > ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"std_mod"."csv"
    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"mean_mod"."nc" > ${DIR_OUT}/"${ds_name}"_"${params1[${j}]}"_"mean_mod"."csv"

done

if [ "${dataset}" == "ds_1" ]; then


    for (( k=0; k<=paramscount ; k++ ));
    do
        hyras_fn="${params2[${k}]}"_"hyras_5_2002-2011_LU"."nc"

        echo 'Observation_name '$hyras_fn

        cdo timstd ${DIR_IN}/"${hyras_fn}" ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"std_obs"."nc"
        cdo timstd ${DIR_IN}/"${hyras_fn}" ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"mean_obs"."nc"

        # NetCDF > csv for model dataset
        cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"std_obs"."nc" > ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"std_obs"."csv"
        cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"mean_obs"."nc" > ${DIR_OUT}/"hyras"_"${params2[${k}]}"_"mean_obs"."csv"
    done
else
    echo 'Use ds_1'
fi


for (( i=0; i<=paramscount ; i++ ));
do
    if [ "${params1[${i}]}" == "TOT_PREC" ]; then
        model_ds="${ds_name}"_"${params1[${i}]}"_"${period_prec}"
    else
        model_ds="${ds_name}"_"${params1[${i}]}"_"${period}"
    fi

    hyras_fn="${params2[${i}]}"_"hyras_5_2002-2011_LU"."nc"


    echo 'name1 '$hyras_fn
    echo 'name2 '$model_ds

    # Calculate correlation coefficient between reference and dataset
    cdo timcor ${DIR_IN}/"${hyras_fn}" ${DIR_IN}/"${model_ds}" ${DIR_OUT}/"Corr_HYRAS"_"${ds_name}"_"${params1[${i}]}"."nc"

    # NetCDF > csv for correlation

    cdo -outputtab,date,lon,lat,value ${DIR_OUT}/"Corr_HYRAS"_"${ds_name}"_"${params1[${i}]}"."nc" > ${DIR_OUT}/"Corr_HYRAS"_"${ds_name}"_"${params1[${i}]}"."csv"


done

cp -R ${DIR_OUT}/*."csv" ${DIR_RESULT}
rm -r ${DIR_OUT}/*





