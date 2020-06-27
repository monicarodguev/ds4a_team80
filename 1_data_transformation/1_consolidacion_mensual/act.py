###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'ACT'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

base.rename( columns={ 'DS_NOMBRE':'nombre', 'NM_PUNTAJE':'punt_control', 'DS_RESULTADO':'resultado' }, inplace=True)
# Cambiar texto a minuscula.
base = gf.letra_lower(base,'nombre')
# Elimina dplicados
base = base.drop_duplicates()
# Elimina columnas sobran
base = base.drop(columns=['nombre','resultado'])

base_ = base.groupby(['id','year','month'])['punt_control'].mean().\
    reset_index( name = 'punt_control' )

pre = dcc[modulo]['prefi'] + '_'

base_.columns = [pre + s for s in base_.columns]
base_.rename( columns={ pre+'id':'id', pre+'year':'year', pre+'month':'month' }, inplace=True)


# Merge
base_final_act = ids_mensual.merge( base_, how='left')
