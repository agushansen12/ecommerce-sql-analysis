-- =============================================
-- OLIST SQL BUSINESS ANALYTICS PROJECT
-- Archivo: 03_logistics_analysis.sql
-- Autor: Agustín Hansen
-- Descripción:
-- Análisis básico de performance logística.
-- Evaluación de tiempos de entrega y cumplimiento de promesas.
-- =============================================


-- =====================================================
-- 1. Promedio de días reales de entrega
-- Objetivo: medir eficiencia logística general
-- =====================================================

SELECT 
    ROUND(AVG(
        JULIANDAY(order_delivered_customer_date) -
        JULIANDAY(order_purchase_timestamp)
    ), 2) AS dias_promedio_entrega
FROM orders
WHERE order_status = 'delivered';

-- Insight:
-- Representa el tiempo promedio desde la compra hasta la entrega.
-- Permite evaluar la eficiencia del proceso logístico.



-- =====================================================
-- 2. Diferencia entre fecha estimada y fecha real
-- Objetivo: medir cumplimiento de promesa de entrega
-- =====================================================

SELECT 
    ROUND(AVG(
        JULIANDAY(order_delivered_customer_date) -
        JULIANDAY(order_estimated_delivery_date)
    ), 2) AS diferencia_promedio_dias
FROM orders
WHERE order_status = 'delivered';

-- Insight:
-- Si el valor es negativo, los pedidos se entregan antes de lo prometido.
-- Si es positivo, existen retrasos promedio.
-- Es clave para evaluar experiencia del cliente.



-- =====================================================
-- 3. Porcentaje de pedidos entregados con retraso
-- Objetivo: medir nivel de incumplimiento logístico
-- =====================================================

SELECT 
    ROUND(
        SUM(
            CASE 
                WHEN JULIANDAY(order_delivered_customer_date) >
                     JULIANDAY(order_estimated_delivery_date)
                THEN 1 ELSE 0
            END
        ) * 100.0 / COUNT(*),
    2) AS porcentaje_retrasos
FROM orders
WHERE order_status = 'delivered';

-- Insight:
-- Indica qué porcentaje de pedidos fueron entregados fuera del plazo prometido.
-- Impacta directamente en la satisfacción del cliente.