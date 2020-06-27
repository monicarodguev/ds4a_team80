###
### TEAM 80 - OMNIVIDA
### vac: monthly consolidation
###

# Parameters
modulo = 'Vacunacion'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
## pivot table to have separate variables, nans replaced with zero
base_p = base.groupby(ids)['Cantidad_Autorizada'].sum().reset_index(name='cant')
pre = dcc[modulo]['prefi'] + '_'
base_p.columns = [ pre + s for s in base_p.columns]
base_p.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

# Merge
base_final_vac = ids_mensual.merge( base_p, how='left')
