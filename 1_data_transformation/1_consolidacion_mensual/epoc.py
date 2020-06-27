###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Disnea'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

base.rename(columns={ 'Examen':'exam'}, inplace=True)
# Elimina dplicados
base = base.drop_duplicates()
# Elimina columnas sobran
base = base.drop(columns=['fecha','year_month'])
base['exam'] = base['exam'].apply( lambda x : str(x)[-1].lower() )

base_ = base.groupby(['id','year','month','exam'])['id'].count().\
    reset_index( name = dcc[modulo]['prefi'] )

base_p = base_.pivot_table(index=['id','year','month'], columns='exam', dcc[modulo]['prefi']).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.fillna( 0 , inplace = True)

base_p.rename(columns={ 'id_':'id', 'month_':'month', 'year_':'year'}, inplace=True)

# Merge
base_final_epoc = ids_mensual.merge( base_p, how='left')