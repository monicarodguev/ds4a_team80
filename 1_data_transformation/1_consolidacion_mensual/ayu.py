###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Ayudas_diagnosticas'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

base = base.drop_duplicates()

base = base.groupby(['id','year','month'])["id"].count().\
    reset_index( name = dcc[modulo]['prefi']+'_exa' )


# Merge
base_final_ayu = ids_mensual.merge( base, how='left')
