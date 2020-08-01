###
### TEAM 80 - OMNIVIDA
### Consolidation File
### Runs everything (that's right!!) from reading files, compute features, predict non-ahderence probability, specify risk group
### Author: monicarodguev
###

####################################################################################################################
#################################################### PARAMETERS ####################################################
####################################################################################################################

ruta_archivos = 'C:/Users/monic/documentos/ds4a/project/datos/'
run_year = 2020
run_month = 2

####################################################################################################################
##################################################### GENERIC ######################################################
####################################################################################################################

# Libreries
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import datetime
import numpy as np

import generic_funcions as gf
import adherence_functions as af

import lightgbm as lgb
from joblib import dump, load

# Generic
calculos = gf.diccionario_agg_functions()
dcc = gf.diccionario_llaves()

# execute initial file
file_0 = ruta_archivos + '0_initial.py'
exec(open(file_0).read())


####################################################################################################################
######################################### BASIC FUNCTIONS DEFINITION ###############################################
####################################################################################################################

##################################################################
# Support functions to feature computation
##################################################################

### The following function renames the variables according to the computation and the window of months (6, 12, etc.) was used to compute them
#   This function receives a dataframe, the aggregation that was done and the number of months
#   Returns: dataframe with renamed variables
#   Author: monicarodguev
def renombre_variables_nmeses( bx, calculo, nmeses ):
    sufi = '_' + calculo + '_' + str(nmeses)
    bx.columns = [ s + sufi for s in bx.columns]
    bx.rename( columns={ 'id' + sufi :'id','year_obs' + sufi :'year_obs', 'month_obs' + sufi :'month_obs' }, inplace=True)

    return bx

### The following function renames the variables according to the computation
#   This function receives a dataframe and the aggregation that was done
#   Returns: dataframe with renamed variables
#   Author: monicarodguev
def renombre_variables( bx, calculo ):
    sufi = '_' + calculo
    bx.columns = [ s + sufi for s in bx.columns]
    bx.rename( columns={ 'id' + sufi :'id','year_obs' + sufi :'year_obs', 'month_obs' + sufi :'month_obs' }, inplace=True)

    return bx

### The following function merge data with adherence consolidated dataframe
#   Returns: merged dataframe
#   Author: monicarodguev
def cruza_adfeat( bx, base_ad_features):
    bx = base_ad_features.merge( bx , how = 'left',
                                 left_on = ['id','year','month'], right_on = ['id','year_obs','month_obs'] )
    bx = bx.drop(['year_obs', 'month_obs'], axis=1)
    return bx

##################################################################
# Feature computation functions
##################################################################
### The following function do the sum computations
#   Returns: dataframe with sum aggregations
#   Author: monicarodguev
def variables_sum( variables, idx, base_1, calculo, nmeses ):
    bx = base_1.groupby( idx )[variables].sum().reset_index()

    bx = renombre_variables_nmeses( bx, calculo, nmeses )
    return bx

### The following function do the avg computations
#   Returns: dataframe with avg aggregations
#   Author: monicarodguev
def variables_avg( variables, idx, base_1, calculo, nmeses ):
    bx = base_1.groupby( idx )[variables].mean().reset_index()
    bx = renombre_variables_nmeses( bx, calculo, nmeses )

    return bx

### The following function computes the variables with a snapshot from the last month
#   Returns: dataframe with snapshot
#   Author: monicarodguev
def variables_foto( variables, base_cruce, calculo ):
    # Limita el número de meses al último mes
    bx = base_cruce[base_cruce['d_meses'] == 1]
    bx = bx[ variables]
    bx = renombre_variables( bx, calculo )

    return bx

### The following function computes the using all past history available
#   Returns: dataframe with maximum over all hitory
#   Author: monicarodguev
def variables_flag( variables, idx, base_cruce, calculo ):
    # No limita el número de meses
    bx = base_cruce
    bx = bx.groupby( idx )[variables].max().reset_index()
    bx = renombre_variables( bx, calculo )

    return bx

### The following function computes the variables for sum and average aggregations
#   Returns: dictionary and dataframe with computed variables
#   Author: monicarodguev
def cal_variables( base_features, base_ad_12, idx, nmeses, calculos, cc, dc_n, base_ad_features  ):

    # Cruza con adherencia
    base_cruce = base_ad_12.merge( base_features , how = 'inner',
                            left_on=['id','year_c','month_c'], right_on = ['id','year','month'] )

    # Limita el número de meses
    base_1 = base_cruce[base_cruce['d_meses'] <= nmeses]

    # Realiza agrupaciones de acuerdo al cálculo
    for calculo in calculos[ cc ]:

        variables = calculos[ cc ][calculo]

        if calculo == 'sum' :

            #print( "Ejecutando modulo " + cc  + " y calculo " + calculo)

            # Realiza el cálculo
            base_12 = variables_sum( variables, idx, base_1, calculo, nmeses )

            # Guarda base
            dc_n[cc][ calculo + '_' + str(nmeses) ] = base_12

            # Cruza con base total
            base_ad_features = cruza_adfeat( base_12, base_ad_features)


        elif calculo == 'avg' :

            #print( "Ejecutando modulo " + cc  + " y calculo " + calculo)

            # Realiza el cálculo
            base_12 = variables_avg( variables, idx, base_1, calculo, nmeses )

            # Guarda base
            dc_n[cc][ calculo + '_' + str(nmeses) ] = base_12

            # Cruza con base total
            base_ad_features = cruza_adfeat( base_12, base_ad_features)

    return dc_n, base_ad_features

### The following function computes the variables for foto and flag aggregations
#   Returns: dictionary and dataframe with computed variables
#   Author: monicarodguev
def cal_variables_f( base_features, base_ad_12, idx, calculos, cc, dc_n, base_ad_features  ):

    # Cruza con adherencia
    base_cruce = base_ad_12.merge( base_features , how = 'inner',
                            left_on=['id','year_c','month_c'], right_on = ['id','year','month'] )

    # Realiza agrupaciones de acuerdo al cálculo
    for calculo in calculos[ cc ]:

        variables = calculos[ cc ][calculo]

        if calculo == 'foto' :

            # print( "Ejecutando modulo " + cc  + " y calculo " + calculo)

            # Realiza el cálculo
            variables = variables + idx
            base_12 = variables_foto( variables, base_cruce, calculo )

            # Guarda base
            dc_n[cc][ calculo ] = base_12

            # Cruza con base total
            base_ad_features = cruza_adfeat( base_12, base_ad_features)


        elif calculo == 'flag' :

            # print( "Ejecutando modulo " + cc  + " y calculo " + calculo)

            # Realiza el cálculo
            variables = variables
            base_12 = variables_flag( variables, idx, base_cruce, calculo )

            # Guarda base
            dc_n[cc][ calculo ] = base_12

            # Cruza con base total
            base_ad_features = cruza_adfeat( base_12, base_ad_features)

    return dc_n, base_ad_features


### The following function preprocess data to be in the format the model expects
#   Returns: formated dataframe
#   Author: monicarodguev
def preprocesar( base, ids, ruta_archivos ):

    # Variables
    vec2 = ['bio_benralizumab_avg_12', 'med_num_doses_otra_avg_6', 'anf_j_sum_12', 'acd_uso_inhal_avg_12', 'epo_4_sum_6', 'bio_omalizumab_avg_6', 'urg_j_total_sum_12', 'cal_psi_avg_12', 'med_num_dis_avg_12', 'far_des_no_flag', 'far_rea_total_sum_6', 'far_cau_def_sum_12', 'inc_inc_sum_12', 'med_flag_j_avg_12', 'adh_sum_6']
    base_nueva = base[ids + vec2]

    # Imputación
    base_nueva.fillna(-1,inplace = True)

    # Carga Datos Básicos
    datosbasicos = pd.read_csv( 'DatosBasicos.csv', sep='|' )
    datosbasicos.drop_duplicates( inplace = True )
    datosbasicos.dropna( inplace = True )

    # Se dejan sólo ids únicos
    ids_count = datosbasicos.groupby('id').count()['year_n'].reset_index(name='cuenta')
    ids_unicos = ids_count[ids_count['cuenta']==1]
    datosbasicos = datosbasicos.merge(ids_unicos, how = 'inner')

    # Cruce datos básicos
    Agregada = base_nueva.merge(datosbasicos, on="id", how ='inner')


    # Procesamiento variables
    Agregada['edad'] = round((Agregada['year'] - Agregada['year_n']) + (Agregada['month'] - Agregada['month_n'])/12,0)
    Agregada.drop(columns=['Unnamed: 0', 'cuenta', 'fecha_n', 'year_n', 'month_n'], inplace= True)

    ### Variables categoricas
    categorias = ['genero', 'zona', 'ciudad']

    for var in categorias:
        Agregada[var] = Agregada[var].astype('category')
        Agregada[var]=Agregada[var].cat.codes

    # Escolaridad
    letras = ['ANALFABETA', 'EDAD PREESCOLAR', 'PRIMARIA', 'SECUNDARIA', 'TECNICO', 'TECNOLOGO', 'UNIVERSITARIO', 'POSGRADO']
    valor = [0,1,2,3,4,5,6,7]
    Agregada.replace(letras, valor,inplace = True)

    # Estado civil
    letras = ['SOLTERO (A)', 'UNIÓN LIBRE', 'CASADO (A)', 'SEPARADO (A)', 'VIUDO (A)']
    valor = [0,1,2,3,4]
    Agregada.replace(letras, valor,inplace = True)

    # Nivel socioeconomico
    letras = ['NIVEL 0 DEL SISBEN', 'NIVEL 1 DEL SISBEN', 'NIVEL 2 DEL SISBEN', 'A', 'B', 'C']
    valor = [0,1,2,3,4,5]
    Agregada.replace(letras, valor,inplace = True)

    # Ocupacion
    letras = ['SIN DEFINIR', 'ESTUDIANTE', 'DESEMPLEADO', 'AMA DE CASA', 'INDEPENDIENTE', 'EMPLEADO', 'JUBILADO', 'PENSIONADO']
    valor = [0,1,2,3,4,5,6,7]
    Agregada.replace(letras, valor,inplace = True)

    Agregada = Agregada.drop('departamento', axis=1 )

    return Agregada

####################################################################################################################
############################################### FEATURE CALCULATIONS ###############################################
####################################################################################################################

# Adherence data
base_ini = gf.base_ids_mensual( ruta_archivos )
_ , base_ad_0 = af.base_features_adeherencia0( ruta_archivos, dcc, ids )
base_ad_12, base_ad = af.base_features_adeherencia_fe( ruta_archivos, run_year, run_month)

# Feature computation
idx = ['id', 'year_obs', 'month_obs']
nmeses = [6,12]
dc_n = {}

base_ad_features = base_ad

for cc in calculos :

    # Ejecuta el modulo
    if cc == 'adh' :
        base_i = base_ad_0[['id','year','month','adeherencia_0']]
        base_i.columns =  ['id','year','month','adh']
        #print( "Ejecutando modulo " + cc )
    else :
        m = calculos[cc]['mod']
        file_i = files + dcc[ m ]['prefi'] + '.py'
        exec(open(file_i).read())
        exec("base_i = base_final_" + dcc[m]['prefi'] )
        #print( "Ejecutando modulo " + cc )

    # Quita los nulls
    cols_i = base_i.columns

    base_i['nuls'] = base_i.isnull().sum(axis = 1)
    todo_null = base_i.shape[1] - 4    #id, month, year, nuls
    base_features = base_i[base_i['nuls'] < todo_null ]
    base_features.reset_index( inplace = True )
    base_features = base_features[cols_i]
    #print(base_features.shape)

    # Calcula las variables
    dc_n[ cc ] = {}

    # Calculos sum, avg
    for mn in nmeses :
        dc_n, base_ad_features = cal_variables( base_features, base_ad_12, idx, mn, calculos, cc, dc_n, base_ad_features  )

    # Calculos foto
    dc_n, base_ad_features = cal_variables_f( base_features, base_ad_12, idx, calculos, cc, dc_n, base_ad_features )

    #print(base_ad_features.shape)


####################################################################################################################
################################################# MODEL PREDICTION #################################################
####################################################################################################################
modelo = load('lgbm.joblib')

covariates = ['bio_benralizumab_avg_12', 'med_num_doses_otra_avg_6', 'anf_j_sum_12',
       'acd_uso_inhal_avg_12', 'epo_4_sum_6', 'bio_omalizumab_avg_6',
       'urg_j_total_sum_12', 'cal_psi_avg_12', 'med_num_dis_avg_12',
       'far_des_no_flag', 'far_rea_total_sum_6', 'far_cau_def_sum_12',
       'inc_inc_sum_12', 'med_flag_j_avg_12', 'adh_sum_6', 'genero',
       'escolaridad', 'estadocivil', 'ciudad', 'estrato', 'zona',
       'nivelsocioeconomico', 'ocupacion', 'edad']

base_calificar = preprocesar( base_ad_features, ['id','year','month'], ruta_archivos )

# Prediction lgbm
pred = modelo.predict_proba(base_calificar[covariates])
prob_ene = [item[1] for item in pred]
base_calificar['prob'] = prob_ene
