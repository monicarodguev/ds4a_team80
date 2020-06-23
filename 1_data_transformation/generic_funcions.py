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
    df['yearmonth'] = df[ 'fecha' ].apply( lambda x : x.year * 100 + x.month )

    return df


### The following gets the first character from specified column from a dataframe.
#   Returns: dataframe with new code column
#   Author: monicarodguev
def letra_codigo( df, columna  ):
    df[ columna + '_cod' ] = df[ columna ].apply( lambda x : str(x)[0] )
    return df
