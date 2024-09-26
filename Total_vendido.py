import sqlite3 as sq
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


with sq.connect("Northwind.db") as conn :
    
    query = """ 
    
 SELECT ProductID,
sum(Quantity) as Total_sold,
       (SELECT ProductName from Products WHERE OD.ProductID = ProductID) as ProductName,
	     
		round(sum (Quantity) *  (SELECT Price from Products WHERE OD.ProductID = ProductID)) as Ttal_Purchase
 from [OrderDetails]OD
WHERE (SELECT Price from Products WHERE OD.ProductID = ProductID) > 40 
 group by ProductID
 ORDER by Ttal_Purchase DESC
LIMIT 5
    
     
    """
    
    top_ventas = pd.read_sql_query(query,conn)
    
    print(top_ventas)
    
    
    my_palette = ["#0000FF", "#008000", "#FF0000", "#00BFBF","#BF00BF"]

# Creando el gráfico 
sns.barplot(x="ProductName", y="Ttal_Purchase", data= top_ventas ,palette= my_palette )

plt.title(" Top 5 Productos de mayor recaudación")
plt.xlabel("Producto")
plt.ylabel("Total")
plt.xticks(rotation = 45)
plt.show()