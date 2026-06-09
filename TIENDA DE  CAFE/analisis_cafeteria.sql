CREATE DATABASE IF NOT EXISTS cafeteria;
USE cafeteria;

#CREACION DE TABLAS
CREATE TABLE marcas (
    id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    origen VARCHAR(50) NOT NULL,
    tipo_cafe VARCHAR(10) NOT NULL
);
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_marca INT,
    unidad_medida VARCHAR(20) NOT NULL,
    capacidad_unidad DECIMAL(10,2) NOT NULL,    
    precio DECIMAL(10,2) NOT NULL,
    stock_actual INT NOT NULL,
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_producto INT,
    fecha_venta DATE NOT NULL,
    cantidad_vendida INT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

#INSERCIÓN DE DATOS
INSERT INTO marcas (nombre, origen, tipo_cafe) VALUES
('Café de Altura', 'Colombia', 'Arábica'),
('Sabor Intenso', 'Brasil', 'Robusta'),
('Café del Valle', 'Ethiopía', 'Arábica');

INSERT INTO productos (id_marca, unidad_medida, capacidad_unidad, precio, stock_actual) VALUES
(1, 'Gramos', 250.00, 500.00, 100),
(2, 'Gramos', 500.00, 900.00, 50),
(3, 'Gramos', 1000.00, 1700.00, 30);

INSERT INTO ventas (id_producto, fecha_venta, cantidad_vendida) VALUES
(1, '2023-10-01', 20),
(2, '2023-10-15', 10),
(3, '2023-11-05', 5),
(1, '2023-11-20', 15);  

# CONSULTAS DE ANÁLISIS DE DATOS
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
SELECT 
    p.id_producto AS ID_Producto,
    m.nombre AS Marca,
    p.unidad_medida AS Unidad_Medida,
    p.capacidad_unidad AS Capacidad_Unidad,
    p.precio AS Precio_Unitario,
    p.stock_actual AS Stock_Disponible
FROM productos p
JOIN marcas m ON p.id_marca = m.id_marca
WHERE p.stock_actual <= 10
ORDER BY p.stock_actual ASC;
SELECT

    p.id_producto AS ID_Producto,
    m.nombre AS Marca,
    p.unidad_medida AS Unidad_Original,
    p.capacidad_unidad AS Capacidad_Original,
    p.precio AS Precio_Original,
    CASE 
        WHEN p.unidad_medida = 'Gramos' THEN CONCAT(p.capacidad_unidad / 1000, ' Kilogramos')
        ELSE CONCAT(p.capacidad_unidad * 1000, ' Gramos')
    END AS Unidad_Convertida,
    CASE 
        WHEN p.unidad_medida = 'Gramos' THEN CONCAT(p.precio * (p.capacidad_unidad / 1000), ' por Kilogramo')
        ELSE CONCAT(p.precio / (p.capacidad_unidad / 1000), ' por Gramo')
    END AS Precio_Convertido
FROM productos p
JOIN marcas m ON p.id_marca = m.id_marca;

