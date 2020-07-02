###
### TEAM 80 - OMNIVIDA
### Generic functions to data transformation
###

import pandas as pd

### The following function load table for module *modulo* from path *ruta*.
#   This function uses a dictionary *diccionario* which has the name of id and date columns.
#   This function computes variables 'year' and 'yearmonth', which will be used in monthly consolidation.
#   Returns: dataframe with renamed keys
#   Author: monicarodguev
def carga_datos( ruta, diccionario, modulo ) :
    df = pd.read_excel( ruta + modulo + '.xlsx')
    df.rename(columns={diccionario[modulo]['id']:'id', diccionario[modulo]['fecha']:'fecha'}, inplace=True)
    df[ 'fecha' ] = pd.to_datetime(df["fecha"])
    df['year'] = df[ 'fecha' ].apply( lambda x : x.year )
    df['month'] = df[ 'fecha' ].apply( lambda x : x.month )
    df['year_month'] = df[ 'fecha' ].apply( lambda x : x.year * 100 + x.month )

    return df


### The following function gets the first character from specified column from a dataframe.
#   Returns: dataframe with new code column
#   Author: monicarodguev
def letra_codigo( df, columna ):
    df[ columna + '_cod' ] = df[ columna ].apply( lambda x : str(x)[0].lower() )
    return df


### The following function change all the strings to lower using the name of one string column.
#   Returns: dataframe with new code column
#   Author: monicarodguev
def letra_lower( df, columna ):
    a = df[columna].dtype
    for col in df.columns:
        if df[col].dtype == a:
            df[col] = df[col].str.lower()
    return df



### This function gets the "initial" table. That is all the ids in periods from 201601 to 202012
#   Returns: dataframe with id, year and month columns
#   Author: monicarodguev
def base_ids_mensual( ruta ):
    # All ids
    ids = pd.read_excel( ruta + 'Datos basicos.xlsx')
    ids.drop_duplicates( subset = 'ID', inplace= True )
    ids.rename(columns={'ID':'id'}, inplace=True)

    # All periods
    dy = pd.DataFrame.from_dict( {'year': list(range(2016,2021))} )
    dm = pd.DataFrame.from_dict({'month': list(range(1,13) )})

    # Cross join
    ids['key'] = 1
    dy['key'] = 1
    dm['key'] = 1

    ndf = ids.merge(dy, on ='key').merge(dm, on ='key')[['id','year','month']]
    return ndf

### This function returns dictionary with keys information about tables
#   Returns: dictionary with name of column of id and date from all tables
#   Author: monicarodguev
def diccionario_llaves():
    dccio = {
        'ACT' : { 'id': 'ID', 'fecha': 'FE_RESULTADO', 'fecha_no_ok': False, 'prefi':'act' },
        'ACT_DESAGREGADO' : { 'id': 'NUMERO IDENTIFICACION', 'fecha': 'FE_RESULTADO', 'fecha_no_ok': False, 'prefi':'acd' },
        'Adherencia' : { 'id': 'ds_identificacion', 'fecha': 'FE_ENTREVISTA', 'fecha_no_ok': False, 'prefi':'adh' },
        'Antecedentes_familiares' : { 'id': 'Id', 'fecha': 'FE_ALTA', 'fecha_no_ok': False, 'prefi':'ant' },
        'Antecedentes_patologicos' : { 'id': 'DS_IDENTIFICACION', 'fecha': 'FE_ACTUALIZA' , 'fecha_no_ok': False, 'prefi':'ant' },
        'Ayudas_diagnosticas' : { 'id': 'Numero_Identificacion', 'fecha': 'Fecha_Orden', 'fecha_no_ok': False, 'prefi':'ayu' },
        'Biologicos Asma' : { 'id': 'Identificacion', 'fecha': 'Fecha_Dcto', 'fecha_no_ok': False, 'prefi':'bio' },
        'Calidad de vida relacioada en salud' : { 'id': 'Identificacion', 'fecha': 'FE_ALTA', 'fecha_no_ok': False, 'prefi':'cal' },
        #'Datos basicos' : { 'id': 'ID', 'fecha': '', 'fecha_no_ok': False, 'prefi': },
        'Disnea' : { 'id': 'id', 'fecha': 'FE_ALTA', 'fecha_no_ok': False, 'prefi':'epo' },
        'Farmacovigilancia RAM' : { 'id': 'NRO_IDENTIFICACION', 'fecha':'FECHA_NOTIFICACION' , 'fecha_no_ok': False, 'prefi':'far' },
        'Habitos' : { 'id': 'DS_IDENTIFICACION', 'fecha': 'Fe_Registro', 'fecha_no_ok': False, 'prefi':'hab' },
        'Hospitalizaciones' : { 'id': 'Id', 'fecha': 'Fecha Ingreso', 'fecha_no_ok': False, 'prefi':'hos' },
        'Incosistencias en reclamacion' : { 'id':'IDENTIFICACIÓN' , 'fecha':'FE_REGISTRO' , 'fecha_no_ok': True, 'formato_fecha': '%Y-%m-%d', 'prefi':'inc' },
        'Medicamentos' : { 'id':'Id' , 'fecha': 'Fecha_Emision', 'fecha_no_ok': False, 'prefi':'med' },
        'Mediciones de peso y talla' : { 'id':'DS_IDENTIFICACION' , 'fecha': 'FE_alta' , 'fecha_no_ok': False, 'prefi':'imc' },
        'Urgencias' : { 'id':'Numero_Identificacion' , 'fecha':'Fecha_Emision' , 'fecha_no_ok': False, 'prefi':'urg' },
        'Vacunacion' : { 'id':'Numero_de_documento' , 'fecha':'Fecha_Emision' , 'fecha_no_ok': False, 'prefi':'vac' }
        }
    return dccio


### This function returns dictionary with the aggrupation function that need to be use to compute features
#   Returns: dictionary variables per aggregation functions
#   Author: monicarodguev
def diccionario_agg_functions():
    dccio = {
    'far' : { 'mod' : 'Farmacovigilancia RAM',
              'sum' : ['far_rea_asma', 'far_rea_total','far_evo_aun','far_cau_def', 'far_cau_otra','far_gra_leve','far_gra_mod'],
              'flag' : ['far_rea_asma', 'far_rea_total','far_rea_asma', 'far_rea_total','far_rea_asma', 'far_rea_total','far_evo_con','far_des_si','far_des_no','far_mis_si']
            },

    'hos' : { 'mod' : 'Hospitalizaciones',
              'sum' : ['hos_num','hos_num_j','hos_uci','hos_uci_j','hos_uce','hos_uce_j','hos_est','hos_est_j']
            },

    'med' : { 'mod' : 'Medicamentos',
              'sum' : ['med_num_dis','med_flag_j','med_flag_otra'],
              'avg' : ['med_num_doses_j', 'med_num_doses_otra'],
              'flag' : ['med_flag_j','med_flag_otra'],
              'var' : ['med_num_doses_j', 'med_num_doses_otra']
            },

    'urg' : { 'mod' : 'Urgencias',
              'sum' : ['urg_urg', 'urg_total','urg_j_urg', 'urg_j_total']
            },

    'vac' : { 'mod' : 'Vacunacion',
              'sum' : ['vac_cant'],
              'flag' : ['vac_cant'],
            },

    'cal' : { 'mod' : 'Calidad de vida relacioada en salud',
              'avg' : ['cal_ent','cal_psi', 'cal_rel', 'cal_fis'],
              'var' : ['cal_ent','cal_psi', 'cal_rel', 'cal_fis'],
            }
        }
    return dccio
