###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Incosistencias en reclamacion'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

# Cambiar texto a minuscula.
base = gf.letra_lower(base,'TIPO EVENTO')
# Elimina dplicados
base = base.drop_duplicates()
# Elimina columnas sobran
base = base.drop(columns=['TIPO NOVEDAD','OBSERVACIONES','NOVEDAD'])

# Diccionary for inconsiente or not
dic = {'confirmacion de cita' : 'conciente',
        'se agenda cita de aplicacion': 'inconciente',
        'paciente no contactado' : 'inconciente',
        'paciente no inconsistente reclamo medicamento' : 'inconciente',
        'inconvenientes personales para reclamarlo' : 'conciente',
        'sin mx por falta de oportunidad de cita' : 'inconciente',
        'olvido del paciente': 'inconciente',
        'inconvenientes con la autorizacion del medicamento' : 'inconciente',
        'cambio de tratamiento' : 'inconciente',
        'desconocimiento de tramites' : 'inconciente',
        'paciente reclama por intervención previa' : 'inconciente',
        'medico lo suspende' : 'inconciente',
        'olvido de paciente' : 'inconciente',
        'se remite a consulta de sft' : 'inconciente',
        'paciente ya reclamo medicamento' : 'inconciente',
        'paciente con factor de riesgo para recibir el mx' : 'conciente',
        'envio de medicamento a domicilio' : 'inconciente',
        'desafiliacion de eps' : 'inconciente',
        'paciente no inconsistente:mx finalizado ya reportado' : 'inconciente',
        'desconocimiento de trámites' : 'inconciente',
        'inconvenientes personales para reclamarlo: trabajo' : 'conciente',
        'hospitalizado' : 'inconciente',
        'paciente con datos desactualizados' : 'inconciente',
        'medicamento agotado' : 'inconciente',
        'autorizan mx para otro proveedor' : 'inconciente',
        'aun no le corresponde entrega' : 'inconciente',
        'fin de tratamiento' : 'inconciente',
        'tiene medicamento por inhaderencia' : 'inconciente',
        'paciente no inconsistente:cambio de marca' : 'inconciente',
        'remitido a qf por ruptura de tratamiento' : 'inconciente',
        'suspende por voluntad propia' : 'conciente',
        'formula medica vencida' : 'inconciente',
        'sin examen de control vigente' : 'inconciente',
        'inconvenientes personales para reclamarlo: acompañante' : 'inconciente',
        'se remite paciente para agendamiento' : 'inconciente',
        'inconvenientes personales para reclamarlo: dinero' : 'inconciente',
        'paciente suspende por ram' : 'inconciente',
        'medico disminuye dosis' : 'inconciente',
        'reclama personalmente' : 'inconciente',
        'se agenda cita previa' : 'inconciente',
        'tiene medicamento por error de autorizacion' : 'inconciente',
        'medicamento suspendido' : 'inconciente',
        'tiene medicamento por orden verbal del medico' : 'inconciente',
        'cambio de eps' : 'inconciente',
        'se ordena examen por parte de helpharma' : 'inconciente',
        'paciente no desea usar el medicamento' : 'conciente',
        'paciente con datos desactualizados'  : 'inconciente',
        'remision farmaceutico' : 'inconciente',
        'paciente fallecido' : 'inconciente',
        'paciente compra medicamento' : 'inconciente'
      }
base = base.replace(list(dic.keys()), list(dic.values()))
base_ = base.groupby(['id','year','month','TIPO EVENTO'])["id"].count().\
    reset_index( name = dcc[modulo]['prefi'] )
# inconsiente o consiente
base_['culpa'] = base_['TIPO EVENTO'].apply( lambda x : 'inc' if x == 'inconciente' else 'con' )

# pivot table to have separate variables, nans replaced with zero
base_p = base_.pivot_table(index=['id','year','month'], columns='culpa', values=[dcc[modulo]['prefi']], aggfunc=np.sum).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.fillna( 0 , inplace = True)
base_p.rename( columns={ 'id_':'id', 'year_':'year', 'month_':'month' }, inplace=True)

# Merge
base_final_inc = ids_mensual.merge( base_p, how='left')