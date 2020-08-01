###
### TEAM 80 - OMNIVIDA
### far: monthly consolidation
###

# Parameters
modulo = 'Farmacovigilancia RAM'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform
#### initial transform
## kind of reaction
base['indicacion_cat'] = base['INDICACION'].apply( lambda x : 'asma' if 'ASMA' in x else 'otra' )

## evolution
def evolution_category( x ):
    category = ''
    if x == 'RECUPERADO SIN SECUELAS' :
        category = 'sin'
    elif x == 'RECUPERADO CON SECUELAS' :
        category = 'con'
    else :
        category = 'aun'
    return category

base['evolution_cat'] =  base['EVOLUCION'].apply( evolution_category )

## disminuir
variable = 'desaparece_cat'
base[variable] = base['EVENTO_DESAPARECIO_DISMINUIR_SUSP_MED'].apply( lambda x : str(x).lower() )

## before
base['misma_cat'] = base['PACIENTE_HABIA_PRESENTADO_MISMA_REACION_MEDIC'].apply( lambda x : str(x).lower() )

## causalidad
def causalidad_category( x ):
    category = ''
    if x == 'DEFINIDA' :
        category = 'def'
    else :
        category = 'otra'
    return category

base['causalidad_cat'] =  base['CAUSALIDAD_SEGUN_ALGORITMO_DE_NARANJO'].apply( causalidad_category )

## gravedad
def gravedad_category( x ):
    category = ''
    if x == 'LEVE' :
        category = 'leve'
    else :
        category = 'mod'
    return category

base['gravedad_cat'] =  base['GRAVEDAD'].apply( gravedad_category )

#### consolidation
variables = ['indicacion_cat','evolution_cat','desaparece_cat','misma_cat','causalidad_cat','gravedad_cat']
base_ = base[ ids + variables]
base_['dum'] = 1

def pivot_var( df, col ):
    df_pivot = df.pivot_table(index=ids, columns=[col], values='dum', aggfunc=np.sum).reset_index().fillna(0)
    return df_pivot

## Indicacion
base_ind = pivot_var( base_, 'indicacion_cat' )
base_ind['total'] = base_ind['asma'] + base_ind['otra']
base_ind = base_ind[ ids  + ['asma','total'] ]
pre = dcc[modulo]['prefi'] + '_' + 'rea_'
base_ind.columns = [ pre + s for s in base_ind.columns]
base_ind.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Evolucion
base_evo = pivot_var( base_, 'evolution_cat' )
base_evo = base_evo[ ids  +['aun','con'] ]
pre = dcc[modulo]['prefi'] + '_' + 'evo_'
base_evo.columns = [ pre + s for s in base_evo.columns]
base_evo.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Desaparece
base_des = pivot_var( base_, 'desaparece_cat' )
base_des = base_des[ ids  +['no','si'] ]
pre = dcc[modulo]['prefi'] + '_' + 'des_'
base_des.columns = [ pre + s for s in base_des.columns]
base_des.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Misma
base_mis = pivot_var( base_, 'misma_cat' )
base_mis = base_mis[ ids  +['si'] ]
pre = dcc[modulo]['prefi'] + '_' + 'mis_'
base_mis.columns = [ pre + s for s in base_mis.columns]
base_mis.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Causalidad
base_cau = pivot_var( base_, 'causalidad_cat' )
pre = dcc[modulo]['prefi'] + '_' + 'cau_'
base_cau.columns = [ pre + s for s in base_cau.columns]
base_cau.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)

## Gravedad
base_gra = pivot_var( base_, 'gravedad_cat' )
pre = dcc[modulo]['prefi'] + '_' + 'gra_'
base_gra.columns = [ pre + s for s in base_gra.columns]
base_gra.rename( columns={ pre + 'id':'id', pre + 'year':'year', pre + 'month':'month' }, inplace=True)


# Merge
submodulos = {'ind': { 'base' : base_ind},
              'evo': { 'base' : base_evo},
              'des': { 'base' : base_des},
              'mis': { 'base' : base_mis},
              'cau': { 'base' : base_cau},
              'gra': { 'base' : base_gra}}

base_final_far = ids_mensual
for key in submodulos:
    base_final_far = base_final_far.merge( submodulos[key]['base'] , how='left')
