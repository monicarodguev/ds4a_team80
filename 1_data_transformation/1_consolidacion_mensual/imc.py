###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Mediciones de peso y talla'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

base.rename(columns={'NM_IMC': dcc[modulo]['prefi']}, inplace=True)
# Elimina dplicados
base = base.drop_duplicates()
# Elimina columnas sobran
base = base.drop(columns=['NM_PESO','NM_TALLA','Clasificacion_IMC'])

base = base.drop(columns=['year_month', 'fecha'])


# Merge
base_final_imc = ids_mensual.merge( base, how='left')