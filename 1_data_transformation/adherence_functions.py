###
### TEAM 80 - OMNIVIDA
### Functions to compute adherence
###
import pandas as pd
import generic_funcions as gf


### This function gets the table with patients' adherence observation at month = 0.
#   Returns: dataframe with id, observerd adherence, (observation date) year and month, (join dates) year_d and month_d, and diference of months in dates
#   Author: monicarodguev
def base_features_adeherencia0( ruta, diccionario, ids ):
    # Load adherence file
    modulo = 'Adherencia'

    base = gf.carga_datos( ruta = ruta, diccionario = diccionario, modulo = modulo )
    base_ = base.dropna()
    # If adherent: 1, else: 0
    base_['adherencia_cat'] = base_['Cualitativo_ponderado'].apply( lambda x : 0 if 'NO' in x else 1 )
    base_p = base_.groupby( ids )['adherencia_cat'].min().reset_index( name='adeherencia_0' )

    dy = pd.DataFrame.from_dict( {'year_c': list(range(2016,2021))} )
    dm = pd.DataFrame.from_dict({'month_c': list(range(1,13) )})

    base_p['key'] = 1
    dy['key'] = 1
    dm['key'] = 1

    base_c = base_p.merge(dy, on ='key').merge(dm, on ='key')
    base_c['d_meses'] = ( base_c['year']*12 + base_c['month'] ) - ( base_c['year_c']*12 + base_c['month_c'] )
    base_d = base_c[base_c['d_meses'] > 0 ]

    base_d.rename(columns={'year':'year_obs', 'month':'month_obs'}, inplace=True)

    return base_d, base_p
