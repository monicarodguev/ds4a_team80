###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Biologicos Asma'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

# rename columns
base.rename( columns={ 'Nom_Generico':'generico'}, inplace=True)
# Elimina columnas sobran
base = base.drop(columns=['Nombre_Producto_Mvto'])
# Cambiar texto a minuscula.
base = gf.letra_lower(base,'generico')
# Elimina dplicados
base = base.drop_duplicates()

base['vez'] = 1
base['Cantidad'] = abs(base['Cantidad']) # error negative cuantities

base_ = base.groupby(['id','year','month','generico'])['Cantidad','vez'].sum().reset_index()
base_.rename( columns={ 'Cantidad':'bio'}, inplace=True)

# pivot table to have separate variables, nans replaced with zero
base_p = base_.pivot_table(index=['id','year','month'], columns='generico', values=['bio','vez']).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
# base_p.fillna( 0 , inplace = True)

base_p.rename( columns={ 'id_':'id', 'year_':'year', 'month_':'month' }, inplace=True)

# totales 
base_p['bio_total'] = base_p['bio_benralizumab']+base_p['bio_dupilumab']+base_p['bio_mepolizumab']+base_p['bio_omalizumab']
base_p['bio_veces'] = base_p['vez_benralizumab']+base_p['vez_dupilumab']+base_p['vez_mepolizumab']+base_p['vez_omalizumab']
base_p = base_p.drop(columns=['vez_benralizumab','vez_dupilumab','vez_mepolizumab','vez_omalizumab'])


# Merge
base_final_bio = ids_mensual.merge( base_p, how='left')
