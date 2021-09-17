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
#prec="yes"
prec="no"

if [ "${prec}" == "yes" ]; then
    # The main parameters for analysis
    params=("T_2M" "TMAX_2M" "TMIN_2M" "TOT_PREC")
    paramscount=3
    # The name of dataset:
    ds_name=("LU_E2015" "LU_E38" "LU_E" "LU_GC" )
    datacount=3
else
    # The main parameters for analysis
    params=("T_2M" "TMAX_2M" "TMIN_2M")
    paramscount=2
    # The name of dataset:
    ds_name=("LU_E2015" "LU_E38" "LU_E" "LU_GC" "LU_ECO")
    datacount=4
fi

# The time period for T2m_mean, T2m_max, T2m_min
period="20020101"_"20111231"_"dayC"."nc"
# The time period for TOT_PREC
period_prec="20020101"_"20111231"_"day"."nc"

refer="LU_G"

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
        # Filenames of REFER and MODEL data
        name_ref="${refer}"_"${params[${j}]}"
        name_mod="${ds_name[${i}]}"_"${params[${j}]}"

        if [ "${params[${j}]}" == "TOT_PREC" ]; then
            ref_pref="${period_prec}"
            mod_pref="${period_prec}"
        else
            ref_pref="${period}"
            mod_pref="${period}"
        fi
        # Final names
        fn_refer="${name_ref}"_"${ref_pref}"
        fn_model="${name_mod}"_"${mod_pref}"
        # Print filenames for datasets
        #echo 'Dataset_lr '$fn_refer
        #echo 'Dataset_hr '$fn_model
        #---------------------------------------------------------------------------

        # Paths for input and output REFER data
        iRefer=${DIR_IN}/"${fn_refer}"
        oRefer_std=${DIR_OUT}/"${refer}"_"${params[${j}]}"_"std_obs"
        oRefer_mean=${DIR_OUT}/"${refer}"_"${params[${j}]}"_"mean_obs"
        oRefer_dav=${DIR_OUT}/"${refer}"_"${params[${j}]}"_"mean_dav_obs"

        # Paths for input and output MODEL data
        iModel=${DIR_IN}/"${fn_model}"
        oModel_std=${DIR_OUT}/"${ds_name[${i}]}"_"${params[${j}]}"_"std_mod"
        oModel_mean=${DIR_OUT}/"${ds_name[${i}]}"_"${params[${j}]}"_"mean_mod"
        oModel_dav=${DIR_OUT}/"${ds_name[${i}]}"_"${params[${j}]}"_"mean_dav_mod"

        # Path for correlation
        cor_out=${DIR_OUT}/"Corr_G"_"${ds_name[${i}]}"_"${params[${j}]}"
        #-----------------------------------------------------------------------

        # Calculations for KGE and RMSD

        # Calcuate std, mean for REFER dataset
        cdo timstd "${iRefer}" "${oRefer_std}"."nc"
        cdo timmean "${iRefer}" "${oRefer_mean}"."nc"
        # Calcuate std, mean for model dataset
        cdo timstd "${iModel}" "${oModel_std}"."nc"
        cdo timmean "${iModel}" "${oModel_mean}"."nc"
        # Calculate correlation coefficient between REFER and MODEL
        cdo timcor "${iRefer}" "${iModel}" "${cor_out}"."nc"
        #-----------------------------------------------------------------------
        # Output NetCDF > csv for REFER dataset
        cdo -outputtab,date,lon,lat,value "${oRefer_std}"."nc" > "${oRefer_std}"."csv"
        cdo -outputtab,date,lon,lat,value "${oRefer_mean}"."nc" > "${oRefer_mean}"."csv"
        # Output NetCDF > csv for MODEL dataset
        cdo -outputtab,date,lon,lat,value "${oModel_std}"."nc" > "${oModel_std}"."csv"
        cdo -outputtab,date,lon,lat,value "${oModel_mean}"."nc" > "${oModel_mean}"."csv"
        # Output NetCDF > csv for correletion
        cdo -outputtab,date,lon,lat,value "${cor_out}"."nc" > "${cor_out}"."csv"

        #Calculations for DAV

        # Calcuate mean for REFER dataset
        cdo fldmean "${iRefer}" "${oRefer_dav}"."nc"
        # Calcuate mean for model dataset
        cdo fldmean "${iModel}" "${oModel_dav}"."nc"
        #-----------------------------------------------------------------------
        # Output NetCDF > csv for REFER dataset
        cdo -outputts "${oRefer_dav}"."nc" > "${oRefer_dav}"."csv"
        # Output NetCDF > csv for MODEL dataset
        cdo -outputts "${oModel_dav}"."nc" > "${oModel_dav}"."csv"

    done
done
cp -R ${DIR_OUT}/*."csv" ${DIR_RESULT}
rm -r ${DIR_OUT}/*