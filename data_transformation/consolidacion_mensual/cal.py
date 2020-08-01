###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Calidad de vida relacioada en salud'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
base_p = base.pivot_table(index=ids, columns=['Dimensiones'], values='0_100', aggfunc=np.sum).reset_index().fillna(0)

pre = dcc[modulo]['prefi'] + '_'
base_p.columns = [ pre + s for s in base_p.columns]
base_p.rename( columns={ pre + 'id'   :'id',
                         pre + 'year' :'year',
                         pre + 'month':'month',
                         pre + 'Entorno' : pre + 'ent',
                         pre + 'Psicologico' : pre + 'psi',
                         pre + 'Relaciones interpersonales' : pre + 'rel',
                         pre + 'Salud fisica' : pre + 'fis'
                       }, inplace=True)

# Merge
base_final_cal = ids_mensual.merge( base_p, how='left')
