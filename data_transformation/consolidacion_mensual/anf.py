###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Antecedentes_familiares'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
base = gf.letra_codigo( base, 'CodDiagnostico' )
base_ = base.groupby(['id','year','month','CodDiagnostico_cod'])["id"].count().\
    reset_index( name = dcc[modulo]['prefi'] )

# all diagnoses different form j will be in the same category
base_['diag'] = base_['CodDiagnostico_cod'].apply( lambda x : 'j' if x == 'j' else 'otra' )

# pivot table to have separate variables, nans replaced with zero
base_p = base_.pivot_table(index=['id','year','month'], columns='diag', values=[dcc[modulo]['prefi']], aggfunc=np.sum).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
# base_p.fillna( 0 , inplace = True)
base_p.rename( columns={ 'id_':'id', 'year_':'year', 'month_':'month' }, inplace=True)



# Merge
base_final_anf = ids_mensual.merge( base_p, how='left')
