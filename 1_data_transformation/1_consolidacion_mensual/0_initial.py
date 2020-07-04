###
### TEAM 80 - OMNIVIDA
### initial: monthly consolidation
###

# Libraries
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import datetime
import numpy as np
import generic_funcions as gf

# Parameters
ruta_archivos = 'C:/Users/monic/documentos/ds4a/project/datos/'
ids = ['id', 'year', 'month']

# Extract
dcc = gf.diccionario_llaves()
ids_mensual = gf.base_ids_mensual( ruta_archivos )
