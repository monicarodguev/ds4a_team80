###
### TEAM 80 - OMNIVIDA
### med: monthly consolidation
###

# Parameters
modulo = 'Medicamentos'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
base = gf.letra_codigo( base, 'Codigo_Diagnostico_EPS_Op' )

base_ = base.groupby(['id','year','month','Codigo_Diagnostico_EPS_Op_cod'])['Numero_Cantidad_Prestaciones'].sum().reset_index( name = 'num_doses' )
base_['num_dis'] = 1

## all diagnoses different form j will be in the same category
base_['diag'] = base_['Codigo_Diagnostico_EPS_Op_cod'].apply( lambda x : 'j' if x == 'j' else 'otra' )

## pivot table to have separate variables, nans replaced with zero
base_p = base_.pivot_table(index=['id','year','month'], columns='diag', values=['num_doses','num_dis'], aggfunc=np.sum).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.fillna( 0 , inplace = True)

## flag variables
base_p['num_dis'] = base_p['num_dis_otra'] + base_p['num_dis_j']
base_p['flag_otra'] = base_p['num_dis_otra'].apply( lambda x : 0 if x == 0 else 1 )
base_p.rename( columns={ 'num_dis_j':'flag_j' }, inplace=True)

prefijo = dcc[modulo]['prefi'] + '_'
base_p.columns = [ prefijo + s for s in base_p.columns]
base_p.rename( columns={ prefijo + 'id_':'id', prefijo + 'year_':'year', prefijo + 'month_':'month' }, inplace=True)

# Merge
base_final_med = ids_mensual.merge( base_p, how='left')
