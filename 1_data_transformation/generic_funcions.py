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

    df['year'] = df[ 'fecha' ].apply( lambda x : x.year )
    df['year_month'] = df[ 'fecha' ].apply( lambda x : x.year * 100 + x.month )

    return df


### The following function gets the first character from specified column from a dataframe.
#   Returns: dataframe with new code column
#   Author: monicarodguev
def letra_codigo( df, columna  ):
    df[ columna + '_cod' ] = df[ columna ].apply( lambda x : str(x)[0] )
    return df


### This function gets the "initial" table. That is all the ids in periods from 201601 to 202012
#   Returns: dataframe with id, year and month columns
#   Author: monicarodguev
def base_ids_mensual( ruta ):
    # All ids
    ids = pd.read_excel( ruta + 'Datos basicos.xlsx')
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
