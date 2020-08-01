###
### TEAM 80 - OMNIVIDA
### cal: monthly consolidation
###

# Parameters
modulo = 'ACT_DESAGREGADO'

# Extract
base = gf.carga_datos( ruta = ruta_archivos, diccionario = dcc, modulo = modulo )

# Transform

base.rename(columns={ 'NOMBRE ENCUESTA\n':'nombre', 'PREGUNTA\n':'pregunta', 'RESPUESTA': dcc[modulo]['prefi'] }, inplace=True)
# Cambiar texto a minuscula.
base = gf.letra_lower(base,'nombre')
# Elimina dplicados
base = base.drop_duplicates()
# Elimina columnas sobran
base = base.drop(columns=['nombre'])

# lista de preguntas seleccionadas
lista = pd.DataFrame(base["pregunta"].value_counts()).reset_index().iloc[:5,0]
# cambiar nombre de las preguntas:
corto = np.array(['uso_inhal','ef_sueno','ef_act_usu','cont_asma','falta_aire'])

for j in range(len(lista)):
    base = base.replace(to_replace =lista[j], value =corto[j]) 

# Quedandonos solo con las 5 preguntas
df_list = []
for i in corto: 
    temp_df = base[base['pregunta'] == i]
    df_list.append(temp_df)  # store for later concatenation

# si hay varios factores solo toca los distintos
base = pd.concat(df_list, axis=0).reset_index(drop=True)

# Conversión escala categorica a numerica
corta = [1, 2, 3, 4, 5]

falta = ['nunca','1 o 2 veces a la semana','de 3 a 6 veces a la semana','una vez al dia','mas de una vez al dia']

uso = ['nada controlada','mal controlada','algo controlada','bien controlada','totalmente controlada']

control = ['nunca','una vez a la semana','una o dos veces','de 2 a 3 noches en a la semana','mas de 4 noches a la semana']

sueno = ['nunca','pocas veces','algunas veces','casi siempre','siempre']

usual = ['nunca','1 vez a la semana o menos','2 o 3 veces a la semana','1 o 2 veces al dia','mas de 3 veces al dia']

listado = [falta, uso, control, sueno, usual]

for i in listado:
    base = base.replace(i, corta)

base_p = base.pivot_table(index=['id','year','month'], columns='pregunta', values= [dcc[modulo]['prefi']]).reset_index()
base_p.columns = ['_'.join(col).strip() for col in base_p.columns.values]
base_p.rename( columns={ 'id_':'id', 'year_':'year', 'month_':'month' }, inplace=True)


# Merge
base_final_acd = ids_mensual.merge( base_p, how='left')
