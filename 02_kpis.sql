-- =============================================
-- OLIST SQL BUSINESS ANALYTICS PROJECT
-- Archivo: 02_kpis.sql
-- Autor: Agustín Hansen
-- Descripción:
-- Cálculo de métricas financieras principales del marketplace.
-- Revenue, ticket promedio y porcentaje de cancelaciones.
-- =============================================


-- =====================================================
-- 1. Revenue total del marketplace
-- Objetivo: dimensionar el volumen total generado
-- =====================================================

SELECT 
    ROUND(SUM(price), 2) AS revenue_total
FROM order_items;

-- Insight:
-- Representa el volumen bruto generado por todos los pedidos.
-- Incluye pedidos entregados y cancelados.
-- Sirve como referencia general del tamaño del negocio.



-- =====================================================
-- 2. Revenue real (solo pedidos entregados)
-- Objetivo: calcular ingresos efectivamente concretados
-- =====================================================

SELECT 
    ROUND(SUM(oi.price), 2) AS revenue_delivered
FROM order_items oi
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- Insight:
-- Representa el ingreso real del marketplace.
-- Excluye cancelaciones y pedidos no completados.
-- Es la métrica financiera más importante.



-- =====================================================
-- 3. Ticket promedio por orden (AOV)
-- Objetivo: medir el gasto promedio por pedido
-- =====================================================

SELECT 
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT 
        order_id,
        SUM(price) AS order_total
    FROM order_items
    GROUP BY order_id
);

-- Insight:
-- Indica cuánto gasta en promedio un cliente por pedido.
-- Es una métrica clave para estrategias comerciales.



-- =====================================================
-- 4. Porcentaje de pedidos cancelados
-- Objetivo: medir nivel de fricción operativa
-- =====================================================

SELECT 
    ROUND(
        SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
    2) AS porcentaje_cancelados
FROM orders;

-- Insight:
-- Permite evaluar qué proporción de pedidos no se concretan.
-- Un valor bajo indica buena eficiencia operativa.