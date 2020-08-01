###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'Habitos'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

# rename columns
base.rename( columns={ 'Tipo':'tipo', 'Habito2':'hab'}, inplace=True)
# Elimina columnas sobran
base = base.drop(columns=['Habito3','FE_INICIO','FE_FIN','DS_OBSERVACION'])
# Cambiar texto a minuscula.
base = gf.letra_lower(base,'tipo')
# Elimina dplicados
base = base.drop_duplicates()

base = base[(base['tipo'].str.contains('alcohol'))\
                 | (base['tipo'].str.contains('ejercicio'))\
                 | (base['tipo'].str.contains('cigarrillo'))].reset_index(drop=True)

# escalas numericas y categoricas para los habitos
cortaeje = np.round(np.linspace(1, 5, 6), 2)
cortacig = np.round(np.linspace(1, 5, 4), 2)
cortaalc = np.round(np.linspace(1, 5, 5), 2)

ejercicio = ['no realiza ejercicio',
            '1 vez por semana',
            '2 veces por semana',
            '3 veces por semana',
            '4 veces por semana',
            'gimnasio varias veces a la semana']

cigarrillo = ['diario',
            'si',
            'fumador pasivo',
            'no']

alcohol = ['bebedor abusivo sin dependencia',
         'bebedor moderado',
         'bebedor social',
         'bebedor excepcional',
         'abstemio']


listalag = [ejercicio, cigarrillo, alcohol]
listacor = [cortaeje, cortacig, cortaalc]

for i in range(3):
    base = base.replace(listalag[i], listacor[i])

base_p = base.pivot_table(index=['id','year','month'], columns='tipo', values=[dcc[modulo]['prefi']]).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.rename( columns={ 'id_':'id', 'year_':'year', 'month_':'month' }, inplace=True)   


# Merge
base_final_hab = ids_mensual.merge( base_p, how='left')