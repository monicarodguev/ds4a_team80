CREATE TABLE act(
act_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
ds_nombre TEXT,
nm_puntaje INTEGER,
ds_resultado TEXT,
fe_resultado DATE,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE act_desagregado(
act_desagregado_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
nombre_encuesta TEXT,
pregunta TEXT,
respuesta TEXT,
fe_resultado DATE,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE adherencia(
adherencia_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fe_entrevista DATE,
morisky_green TEXT,
smaq1 TEXT,
smaq2 TEXT,
espa TEXT,
nm_espa FLOAT,
cualitativo_ponderado TEXT,
cuantitativo_ponderado TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE antecedentes_familiares(
antecedentes_familiares_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
eps TEXT,
fe_alta DATE,
fe_inicio DATE,
fe_fin DATE,
diagnostico TEXT,
coddiagnostico TEXT,
parentesco TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE antecedentes_patologicos(
antecedentes_patologicos_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
eps TEXT,
fe_actualiza DATE,
fe_inicio DATE,
fe_fin DATE,
ds_observaciones TEXT,
diagnostico TEXT,
coddiagnostico TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE ayudas_diagnosticas(
ayudas_diagnosticas_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_orden DATE,
manual_proced_desc TEXT,
result_ayuda_diag_txt FLOAT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE biologicos_asma(
biologicos_asma_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_dcto DATE,
nombre_producto_mvto TEXT,
nom_generico TEXT,
cantidad INTEGER,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE calidad_de_vida_relacioada_en_salud(
calidad_de_vida_relacioada_en_salud_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fe_alta DATE,
dimensiones TEXT,
0_100 FLOAT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE disnea(
disnea_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fe_alta DATE,
examen TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE farmacovigilancia_ram(
farmacovigilancia_ram_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_notificacion DATE,
departamento TEXT,
municipio TEXT,
eps TEXT,
etnia TEXT,
fecha_nacimiento DATE,
edad INTEGER,
tipo_identificacion TEXT,
sexo TEXT,
peso FLOAT,
estatura INTEGER,
diagnostico_ppal_condiciones_clinicas TEXT,
medicamento_sospechoso TEXT,
indicacion TEXT,
fecha_inicio_tratamiento DATE,
fecha_fin_tratamiento DATE,
comercial TEXT,
fecha_inicio_reaccion DATE,
ram_sospechada TEXT,
sistema_comprometido TEXT,
analisis TEXT,
evolucion TEXT,
seriedad TEXT,
evento_presento_despues_administrar_medicamento TEXT,
existen_otros_factores_puedan_explicar_evento TEXT,
evento_desaparecio_disminuir_susp_med TEXT,
paciente_habia_presentado_misma_reacion_medic TEXT,
causalidad_segun_algoritmo_de_naranjo TEXT,
evitabilidad TEXT,
gravedad TEXT,
ds_plan_intervencion TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE habitos(
habitos_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
tipo TEXT,
habito2 TEXT,
habito3 TEXT,
fe_inicio DATE,
fe_fin DATE,
ds_observacion TEXT,
fe_registro DATE,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE hospitalizaciones(
hospitalizaciones_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
sexo TEXT,
edad__anos INTEGER,
id_diagnostico_egreso TEXT,
descripcion_diagnostico__egreso TEXT,
dias_uci INTEGER,
dias_uce INTEGER,
dias_de_estancia__calculada INTEGER,
fecha_ingreso DATE,
fecha_egreso DATE,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE incosistencias_en_reclamacion(
incosistencias_en_reclamacion_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
tipo_novedad TEXT,
tipo_evento TEXT,
novedad FLOAT,
fe_registro DATE,
observaciones TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE medicamentos(
medicamentos_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_emision DATE,
regional_eps_desc TEXT,
codigo_prestacion_op TEXT,
descripcion_prestacion TEXT,
codigo_diagnostico_eps_op TEXT,
diagnostico_eps_desc TEXT,
numero_cantidad_prestaciones FLOAT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE mediciones_de_peso_y_talla(
mediciones_de_peso_y_talla_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fe_alta DATE,
nm_imc FLOAT,
nm_peso FLOAT,
nm_talla INTEGER,
clasificacion_imc TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE urgencias(
urgencias_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_emision DATE,
regional_eps_desc TEXT,
codigo_prestacion_op TEXT,
descripcion_prestacion TEXT,
codigo_diagnostico_eps_op TEXT,
diagnostico_eps_desc TEXT,
cantidad_autorizada TEXT,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

CREATE TABLE vacunacion(
vacunacion_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
patient_id INTEGER,
fecha_emision DATE,
regional_eps_desc TEXT,
codigo_prestacion_op TEXT,
descripcion_prestacion TEXT,
codigo_diagnostico_eps_op TEXT,
diagnostico_eps_desc TEXT,
cantidad_autorizada INTEGER,
FOREIGN KEY (patient_id) references datos_basicos(patient_id));

