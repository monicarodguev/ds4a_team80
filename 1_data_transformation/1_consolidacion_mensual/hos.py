###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Hospitalizaciones'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )
base.columns = ['id', 'Sexo', 'EDAD (Años)', 'Id Diagnostico Egreso','Descripción diagnostico (egreso)', 'Dias Uci', 'Dias Uce','Dias de Estancia (Calculada)', 'fecha', 'Fecha Egreso', 'year', 'month', 'year_month']

# Transform
base = gf.letra_codigo( base, 'Id Diagnostico Egreso' )

base_ = base.groupby(['id','year','month','Id Diagnostico Egreso_cod'])[['Dias Uci','Dias Uce','Dias de Estancia (Calculada)']].sum().reset_index()
base_['num'] = 1
base_['diag'] = base_['Id Diagnostico Egreso_cod'].apply( lambda x : 'j' if x == 'j' else 'otra' )
base_.rename( columns={ 'Dias Uci':'uci', 'Dias Uce':'uce',  'Dias de Estancia (Calculada)':'est' }, inplace=True)

# pivot table to have separate variables, nans replaced with zero
base_p = base_.pivot_table(index=['id','year','month'], columns='diag', values=['uci','uce','est','num'], aggfunc=np.sum).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.fillna( 0 , inplace = True)

base_p['num'] = base_p['num_otra'] + base_p['num_j']
base_p['uci'] = base_p['uci_otra'] + base_p['uci_j']
base_p['uce'] = base_p['uce_otra'] + base_p['uce_j']
base_p['est'] = base_p['est_otra'] + base_p['est_j']

base_p = base_p[['id_', 'year_', 'month_','num','num_j','est','est_j','uci','uci_j','uce','uce_j']]
pre = dcc[modulo]['prefi'] + '_'
base_p.columns = [ pre + s for s in base_p.columns]
base_p.rename( columns={ pre + 'id_':'id', pre + 'year_':'year', pre + 'month_':'month' }, inplace=True)

# Merge
base_final_hos = ids_mensual.merge( base_p, how='left')
