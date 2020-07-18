###
### TEAM 80 - OMNIVIDA
### Functions to compute adherence
###
import pandas as pd
import generic_funcions as gf


### This function adds previous periods to an observation date. This is necesary to compute features.
#   Returns: dataframe with year_d and month_d, and diference of months in dates.
#   Author: monicarodguev
def periods_aderence( base_p ):
    dy = pd.DataFrame.from_dict( {'year_c': list(range(2016,2021))} )
    dm = pd.DataFrame.from_dict({'month_c': list(range(1,13) )})

    base_p['key'] = 1
    dy['key'] = 1
    dm['key'] = 1

    base_c = base_p.merge(dy, on ='key').merge(dm, on ='key')
    base_c['d_meses'] = ( base_c['year']*12 + base_c['month'] ) - ( base_c['year_c']*12 + base_c['month_c'] )
    base_d = base_c[base_c['d_meses'] > 0 ]

    base_d.rename(columns={'year':'year_obs', 'month':'month_obs'}, inplace=True)

    return base_d


### This function adds future periods to an observation date. This is necesary to compute adherence in the future.
#   Returns: dataframe with year_d and month_d, and diference of months in dates.
#   Author: monicarodguev
def periods_aderence_futuro( base_p ):
    dy = pd.DataFrame.from_dict( {'year_c': list(range(2016,2021))} )
    dm = pd.DataFrame.from_dict({'month_c': list(range(1,13) )})

    base_p['key'] = 1
    dy['key'] = 1
    dm['key'] = 1

    base_c = base_p.merge(dy, on ='key').merge(dm, on ='key')
    base_c['d_meses'] = ( base_c['year']*12 + base_c['month'] ) - ( base_c['year_c']*12 + base_c['month_c'] )
    base_d = base_c[base_c['d_meses'] <= 0 ]

    base_d.rename(columns={'year':'year_obs', 'month':'month_obs'}, inplace=True)

    return base_d


### This function gets the table with patients' adherence observation at month = 0.
#   Returns: dataframe with id, observerd adherence, (observation date) year and month, (join dates) year_d and month_d, and diference of months in dates
#   Author: monicarodguev
def base_features_adeherencia0( ruta, diccionario, ids ):
    # Load adherence file
    modulo = 'Adherencia'

    base = gf.carga_datos( ruta = ruta, diccionario = diccionario, modulo = modulo )
    base_ = base.dropna()

    # If NO adherent: 1, else: 0
    def adhere( x ):
        y = 2
        if x == 'NO ADHERENTE' :
            y = 1
        elif x == 'ADHERENTE' :
            y = 0
        return y

    base_['adherencia_cat'] = base_['Cualitativo_ponderado'].apply( adhere )
    base_ = base_[base_['adherencia_cat'] < 2]

    base_p = base_.groupby( ids )['adherencia_cat'].max().reset_index( name='adeherencia_0' )

    base_d = periods_aderence( base_p )

    return base_d, base_p



### This function gets the table with patients' adherence observation from month = 0 to month=11 (one year).
#   Returns: dataframe with id, observerd adherence, (observation date) year and month, (join dates) year_d and month_d, and diference of months in dates
#   Author: monicarodguev
def base_features_adeherencia_meses( ruta, diccionario, ids, n_meses ):
    # Load adherence file
    _ , base_p = base_features_adeherencia0( ruta, diccionario, ids )

    base_x = periods_aderence_futuro( base_p )
    base_x = base_x[['id', 'year_obs', 'month_obs','year_c','month_c', 'd_meses']]

    base_merge = base_x.merge( base_p , how='left', left_on = ['id', 'year_c', 'month_c'], right_on = ['id', 'year', 'month'] )
    base_merge.dropna(inplace = True)
    base_merge = base_merge[base_merge['d_meses']>=(1-n_meses)]

    base_consolidada = base_merge.groupby(['id','year_obs','month_obs'])[['adeherencia_0','key']].sum().reset_index()
    base_consolidada.columns = ['id', 'year', 'month', 'adeherencia_'+str(n_meses), 'cantidad']

    base_d = periods_aderence( base_consolidada )

    return base_d, base_consolidada
