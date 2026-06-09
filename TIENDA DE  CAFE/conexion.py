import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from sqlalchemy import create_engine

# 1. CONEXIÓN LIVE A LA BASE DE DATOS 'CAFETERIA'
usuario = "root"
contrasena = "22307706GAS"  
host = "localhost"
base_datos = "cafeteria"

# Armamos el puente de conexión relacional
engine = create_engine(f"mysql+pymysql://{usuario}:{contrasena}@{host}/{base_datos}")

# 2. CONSULTA ANALÍTICA (Mismos nombres exactos de tu SQL)
query = """
SELECT  
    m.nombre AS Marca,
    m.tipo_cafe AS Tipo_Cafe,
    COUNT(v.id_venta) AS Total_Ventas,
    SUM(p.precio * v.cantidad_vendida) AS Total_Facturado
FROM ventas v
JOIN productos p ON v.id_producto = p.id_producto 
JOIN marcas m ON p.id_marca = m.id_marca
GROUP BY m.nombre, m.tipo_cafe
ORDER BY Total_Facturado DESC;
"""

# 3. EXTRACCIÓN DIRECTA A PANDAS
print("☕ Conectando al motor MySQL de la Cafetería...")
df_coffee = pd.read_sql(query, con=engine)

print("\n--- DATOS PROCESADOS DESDE REPOSITORIO SQL ---")
print(df_coffee)

# 4. TABLERO VISUAL DE NEGOCIO 
plt.figure(figsize=(8, 5))
sns.set_theme(style="whitegrid")

# Graficamos con un color café fijo para evitar problemas de paletas
sns.barplot(
    x="Marca", 
    y="Total_Facturado", 
    data=df_coffee, 
    color="saddlebrown"
)

# Configuración estética de títulos y fuentes
plt.title("Reporte BI: Ingresos Totales por Marca de Café", fontsize=13, fontweight="bold")
plt.xlabel("Marcas de Especialidad", fontsize=11)
plt.ylabel("Facturación Acumulada ($)", fontsize=11)

plt.tight_layout()
print("\n Desplegando gráfico analítico...")
plt.show()