-- =============================================
-- OLIST SQL BUSINESS ANALYTICS PROJECT
-- Archivo: 01_exploration.sql
-- Autor: Agustín Hansen
-- Descripción:
-- Exploración inicial del dataset Olist.
-- Validación de volumen, estructura, clientes e integridad de datos.
-- =============================================


-- =====================================================
-- 1. Volumen de registros por tabla
-- Objetivo: entender el tamaño del negocio y las entidades principales
-- =====================================================

SELECT 'orders' AS tabla, COUNT(*) AS cantidad FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews;

-- Insight:
-- Este bloque permite dimensionar el tamaño del marketplace.
-- Orders representa el volumen transaccional principal (~99k registros).


-- =====================================================
-- 2. Estados de los pedidos
-- Objetivo: analizar la distribución operativa del marketplace
-- =====================================================

SELECT 
    order_status, 
    COUNT(*) AS total_pedidos
FROM orders
GROUP BY order_status
ORDER BY total_pedidos DESC;

-- Insight:
-- Permite identificar la proporción de pedidos entregados, cancelados
-- y otros estados operativos. Es clave para evaluar eficiencia logística.


-- =====================================================
-- 3. Identificación de clientes reales vs IDs transaccionales
-- Objetivo: entender la diferencia entre customer_id y customer_unique_id
-- =====================================================

SELECT 
    (SELECT COUNT(DISTINCT customer_unique_id) FROM customers) 
        AS clientes_unicos_reales,
    (SELECT COUNT(DISTINCT customer_id) FROM orders) 
        AS ids_generados_por_orden;

-- Insight:
-- customer_unique_id representa la identidad real del cliente.
-- customer_id se genera por cada orden.
-- Esto indica que el dataset utiliza un modelo transaccional
-- donde cada compra genera un snapshot del cliente.


-- =====================================================
-- 4. Hipótesis: clientes con múltiples compras
-- Objetivo: validar si un mismo cliente puede tener múltiples órdenes
-- =====================================================

SELECT 
    customer_unique_id,
    COUNT(DISTINCT customer_id) AS cantidad_compras
FROM customers
GROUP BY customer_unique_id
HAVING cantidad_compras > 1
ORDER BY cantidad_compras DESC
LIMIT 10;

-- Insight:
-- Se confirma que un mismo cliente puede tener múltiples compras.
-- Esto es fundamental para futuros análisis de recurrencia y RFM.


-- =====================================================
-- 5. Pedidos con múltiples productos
-- Objetivo: analizar si las órdenes contienen más de un ítem
-- =====================================================

SELECT 
    order_id, 
    COUNT(*) AS cantidad_items
FROM order_items
GROUP BY order_id
ORDER BY cantidad_items DESC
LIMIT 10;

-- Insight:
-- Existen pedidos con múltiples productos.
-- Esto será relevante para el cálculo correcto del revenue
-- y del ticket promedio (AOV).


-- =====================================================
-- 6. Validación de integridad referencial
-- Objetivo: confirmar que todas las órdenes tienen cliente asociado
-- =====================================================

SELECT COUNT(*) AS total_orders_con_cliente
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

-- Insight:
-- El total coincide con la cantidad de órdenes,
-- lo que confirma integridad referencial correcta.
-- No existen órdenes huérfanas sin cliente asociado.