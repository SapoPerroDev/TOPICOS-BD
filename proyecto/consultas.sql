---------------------------------------------------------- SUBCONSULTAS --------------------------------------------------------
-- cantidad de gallinas que están por debajo del peso y en qué corral están
select
    g.codigo_gallina,
    g.peso,
    c.codigo_corral
from
    gallina g
    join corral c on g.id_corral = c.id_corral
where
    g.peso < (
        select
            avg(peso)
        from
            gallina
    )
order by
    g.peso asc;

-- Producción promedio y corrales por debajo del promedio
select
    c.codigo_corral,
    sum(dp.cantidad) as total_huevos
from
    produccion p
    join detalles_produccion dp on p.id_produccion = dp.id_produccion
    join corral c on p.id_corral = c.id_corral
group by
    c.codigo_corral
having
    sum(dp.cantidad) < (
        select
            avg(total)
        from
            (
                select
                    sum(dp2.cantidad) as total
                from
                    produccion p2
                    join detalles_produccion dp2 on p2.id_produccion = dp2.id_produccion
                group by
                    p2.id_corral
            )
    )
order by
    total_huevos asc;

--Productos de tipo alimento que han comprado las granjas
SELECT
    g.nombre AS granja,
    p.nombre AS alimento,
    m.cantidad,
    p.descripcion,
    p.volumen,
    p.unidad_medida
FROM
    Granja g
    JOIN Granjero gr ON g.id_granjero = gr.id_granjero
    JOIN Movimiento m ON gr.id_granjero = m.id_granjero
    JOIN Producto p ON m.id_producto = p.id_producto
WHERE
    m.tipo_movimiento = 'Entrada'
    AND p.id_categoria = (
        SELECT
            id_categoria
        FROM
            Categoria
        WHERE
            nombre = 'Alimentos'
    )
ORDER BY
    g.nombre,
    p.nombre;

---------------------------------------------------------- PROCEDIMIENTOS ALMACENADOS --------------------------------------------------------
-- 1.PROCEDIMIENTO ALMACENADO PARA DISTRIBUIR LOS HUEVOS EN CUBETAS
CREATE OR REPLACE PROCEDURE sp_reubicar_gallinas(
    p_id_corral_origen INT,
    p_id_corral_destino INT,
    p_cantidad INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_capacidad_destino INT;
    v_ocupacion_destino INT;
    v_disponible INT;
BEGIN
    -- Validar capacidad del corral destino
    SELECT capacidad INTO v_capacidad_destino
    FROM Corral
    WHERE id_corral = p_id_corral_destino;

    IF v_capacidad_destino IS NULL THEN
        RAISE EXCEPTION 'El corral destino % no existe', p_id_corral_destino;
    END IF;

    -- Calcular ocupación actual del destino
    SELECT COUNT(*) INTO v_ocupacion_destino
    FROM Gallina
    WHERE id_corral = p_id_corral_destino
      AND estado = 'Activa';

    v_disponible := v_capacidad_destino - v_ocupacion_destino;

    IF v_disponible < p_cantidad THEN
        RAISE EXCEPTION 'El corral destino no tiene espacio suficiente. Disponible: %, requerido: %', v_disponible, p_cantidad;
    END IF;

    -- Reubicar gallinas (las primeras activas del corral origen)
    UPDATE Gallina
    SET id_corral = p_id_corral_destino
    WHERE id_gallina IN (
        SELECT id_gallina
        FROM Gallina
        WHERE id_corral = p_id_corral_origen AND estado = 'Activa'
        LIMIT p_cantidad
    );

END;
$$;

-- 2. PROCEDIMIENTO PARA REGISTRAR REGISTRAR DETALLE DE PRODUCCIÓN Y ACTUALIZAR INVENTARIO
CREATE OR REPLACE PROCEDURE sp_registrar_detalle_produccion(
    p_id_produccion INT,
    p_id_clasificacion_peso INT,
    p_cantidad INT,
    p_cantidad_quebrados INT DEFAULT 0
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_cantidad_validada INT;
    v_cubetas INT;
    v_sueltos INT;
BEGIN
    -- Validar cantidad (no permitir negativos ni inconsistencias)
    IF p_cantidad < 0 OR p_cantidad_quebrados < 0 THEN
        RAISE EXCEPTION 'Las cantidades no pueden ser negativas';
    END IF;

    IF p_cantidad_quebrados > p_cantidad THEN
        RAISE EXCEPTION 'Los huevos quebrados no pueden ser mayores que la cantidad total';
    END IF;

    -- Insertar en Detalles_produccion
    INSERT INTO Detalles_produccion(id_produccion, id_clasificacion_peso, cantidad, cantidad_quebrados)
    VALUES (p_id_produccion, p_id_clasificacion_peso, p_cantidad, p_cantidad_quebrados);

    -- Calcular huevos válidos (descartando quebrados)
    v_cantidad_validada := p_cantidad - p_cantidad_quebrados;
    v_cubetas := v_cantidad_validada / 30;
    v_sueltos := v_cantidad_validada % 30;

    -- Actualizar inventario
    INSERT INTO Inventario_huevos(id_clasificacion_peso, cubetas, sueltos)
    VALUES (p_id_clasificacion_peso, v_cubetas, v_sueltos)
    ON CONFLICT (id_clasificacion_peso) DO UPDATE
    SET cubetas = Inventario_huevos.cubetas + EXCLUDED.cubetas,
        sueltos = Inventario_huevos.sueltos + EXCLUDED.sueltos;
END;
$$;

---------------------------------------------------------- TRIGGER --------------------------------------------------------
--1. Trigger: Actualizar stock de productos después de un movimiento
CREATE
OR REPLACE FUNCTION actualizar_stock_producto() RETURNS TRIGGER AS $$
BEGIN IF NEW.tipo_movimiento = 'Entrada' THEN
UPDATE
    Producto
SET
    stock_actual = stock_actual + NEW.cantidad
WHERE
    id_producto = NEW.id_producto;

ELSIF NEW.tipo_movimiento = 'Salida' THEN
UPDATE
    Producto
SET
    stock_actual = stock_actual - NEW.cantidad
WHERE
    id_producto = NEW.id_producto;

-- Validar que no quede negativo
IF (
    SELECT
        stock_actual
    FROM
        Producto
    WHERE
        id_producto = NEW.id_producto
) < 0 THEN RAISE EXCEPTION 'El stock no puede ser negativo para el producto %',
NEW.id_producto;

END IF;

ELSE RAISE EXCEPTION 'Tipo de movimiento inválido. Use Entrada o Salida';

END IF;

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_stock_producto
AFTER
INSERT
    ON Movimiento FOR EACH ROW EXECUTE FUNCTION actualizar_stock_producto();

--2. Trigger: auditoria sobre movimiento huevos
CREATE
OR REPLACE FUNCTION log_cambios() RETURNS TRIGGER AS $$ BEGIN
INSERT INTO
    auditoria(
        id_granjero,
        accion,
        tabla_afectada,
        id_registro_afectado,
        valores_anteriores,
        valores_nuevos,
		fecha
    )
VALUES
    (
         CURRENT_USER,
        TG_OP,
        TG_TABLE_NAME,
        COALESCE(NEW.id_gallina, OLD.id_gallina),
        row_to_json(OLD)::jsonb,
        row_to_json(NEW)::jsonb,
        CURRENT_TIMESTAMP 
    );

RETURN NEW;

END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_gallinas
AFTER
INSERT
    OR
UPDATE
    OR DELETE ON Gallina FOR EACH ROW EXECUTE FUNCTION log_cambios();

---------------------------------------------------------- REALIZAR PRUEBAS --------------------------------------------------------
--TRIGGER DE STOCK DE PRODUCTOS
-- entradas de producto
INSERT INTO Movimiento (id_movimiento, id_producto, id_granjero, tipo_movimiento, cantidad, observacion)
VALUES
(11, 1, 1, 'Entrada', 25.00, 'Compra de maíz');

-- salidas de producto
INSERT INTO Movimiento (id_movimiento, id_producto, id_granjero, tipo_movimiento, cantidad, observacion)
VALUES
(12, 1, 1, 'Salida', 3.00, 'Venta de maíz');

-- error
INSERT INTO Movimiento (id_movimiento, id_producto, id_granjero, tipo_movimiento, cantidad, observacion)
VALUES (13, 2, 1, 'Salida', 351, 'Soya podrida');

--TRIGGER PARA AUDITORIA DE TABLA DE GALLINAS
INSERT INTO Gallina (id_corral, codigo_gallina, raza, peso, fecha_ingreso)
VALUES
(1, 'G0021', 'Rhode Island Red', 2.50, '2025-01-10');

DELETE FROM Gallina
WHERE id_gallina = 1;

SELECT * FROM auditoria ORDER BY fecha DESC;

-- PROCEDIMIENTO ALMACENADO PARA REUBICAR GALLINAS
-- consultar gallinas de corral a mover
SELECT
    *
FROM
    Gallina
WHERE
    id_corral = 1;

-- llamar a el procedimiento
CALL sp_reubicar_gallinas(1, 2, 1);

-- Ver conteo por corral
SELECT id_corral, COUNT(*) AS total_activos FROM Gallina WHERE estado = 'Activa' GROUP BY id_corral;

-- PROCEDIMIENTO ALMACENADO PARA AUTOMATIZAR LA PRODUCCIÓN DE HUEVOS
CALL sp_registrar_detalle_produccion(1, 1, 50, 5);

SELECT * FROM Detalles_produccion WHERE id_produccion = 1;
SELECT * FROM Inventario_huevos WHERE id_clasificacion_peso = 1;


--INDEX PARA CONSULTAR LAS GALLINAS DE UN CORRAL
CREATE INDEX idx_gallina_corral ON Gallina(id_corral);