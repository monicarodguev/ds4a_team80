###
### TEAM 80 - OMNIVIDA
### urg: monthly consolidation
###

# Parameters
modulo = 'Urgencias'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
## kind of service
variable = 'service_cat'
base[variable] = base['Descripcion_Prestacion'].apply( lambda x : 'otra' if 'CONSULTA' in x else 'urg' )

## kind of disease
base = gf.letra_codigo( base, 'Codigo_Diagnostico_EPS_Op' )

base_ = base[base['Cantidad_Autorizada'] != '?']
base_['cant'] = base_['Cantidad_Autorizada'].astype( int )
base_['diag'] = base_['Codigo_Diagnostico_EPS_Op_cod'].apply( lambda x : 'j' if x == 'j' else 'otra' )

variables = ['service_cat','diag','cant']
base_ = base_[ ids + variables]

## pivot table to have separate variables, nans replaced with zero
## total
base_p = base_.pivot_table(index=ids, columns=['service_cat'], values='cant', aggfunc=np.sum).reset_index().fillna(0)
base_p['total'] = base_p['urg'] + base_p['otra']
base_p = base_p[ ids  + ['urg','total'] ]
pre = dcc[modulo]['prefi'] + '_'
base_p.columns = [ pre + s for s in base_p.columns]
base_p.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Related with athsma
base_j = base_[base_['diag']=='j']
base_p_j = base_j.pivot_table(index=ids, columns=['service_cat'], values='cant', aggfunc=np.sum).reset_index().fillna(0)
base_p_j['total'] = base_p_j['urg'] + base_p_j['otra']
base_p_j = base_p_j[ ids  + ['urg','total'] ]
pre = dcc[modulo]['prefi'] + '_j_'
base_p_j.columns = [ pre + s for s in base_p_j.columns]
base_p_j.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## join
base_t = base_p.merge( base_p_j, how = 'left' )
base_t = base_t.fillna( 0 )

# Merge
base_final_hos = ids_mensual.merge( base_t, how='left')
