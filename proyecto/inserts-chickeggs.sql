-- ==========================
-- Granjeros (5)
-- ==========================
INSERT INTO Granjero (id_granjero, primer_nombre, segundo_nombre, primer_apellido, segundo_apellido, email, password_hash, numero_telefono)
VALUES
(1, 'Juan', 'Carlos', 'Pérez', 'López', 'juan@example.com', 'hash123', '3101234567'),
(2, 'Ana', NULL, 'Gómez', 'Martínez', 'ana@example.com', 'hash456', '3119876543'),
(3, 'Luis', 'Fernando', 'Ramírez', 'Castro', 'luis@example.com', 'hash789', '3124567890'),
(4, 'María', 'Elena', 'Rodríguez', 'Hernández', 'maria@example.com', 'hash321', '3136547890'),
(5, 'Pedro', NULL, 'Jiménez', 'Ortiz', 'pedro@example.com', 'hash654', '3141239876');

-- ==========================
-- Granjas (5)
-- ==========================
INSERT INTO Granja (id_granja, id_granjero, nombre, ubicacion)
VALUES
(1, 1, 'Granja El Progreso', 'Zona Rural Norte'),
(2, 2, 'Granja Los Pinos', 'Vereda La Esperanza'),
(3, 3, 'Granja Santa Clara', 'Finca La Palma'),
(4, 4, 'Granja Villa Luz', 'Corregimiento San José'),
(5, 5, 'Granja Buenavista', 'Camino Real');

-- ==========================
-- Corrales (10)
-- ==========================
INSERT INTO Corral (id_corral, id_granja, codigo_corral, nombre, capacidad, ubicacion)
VALUES
(1, 1, 'C001', 'Corral A', 50, 'Sector 1'),
(2, 1, 'C002', 'Corral B', 40, 'Sector 2'),
(3, 2, 'C003', 'Corral Principal', 60, 'Entrada'),
(4, 2, 'C004', 'Corral Extra', 30, 'Patio'),
(5, 3, 'C005', 'Corral Norte', 45, 'Zona A'),
(6, 3, 'C006', 'Corral Sur', 35, 'Zona B'),
(7, 4, 'C007', 'Corral Este', 55, 'Sector Este'),
(8, 4, 'C008', 'Corral Oeste', 50, 'Sector Oeste'),
(9, 5, 'C009', 'Corral Central', 70, 'Centro'),
(10, 5, 'C010', 'Corral Auxiliar', 25, 'Esquina');

-- ==========================
-- Gallinas (20)
-- ==========================
INSERT INTO Gallina (id_gallina, id_corral, codigo_gallina, raza, peso, fecha_ingreso)
VALUES
(1, 1, 'G001', 'Rhode Island Red', 2.50, '2025-01-10'),
(2, 1, 'G002', 'Leghorn', 2.20, '2025-01-12'),
(3, 1, 'G003', 'Plymouth Rock', 2.70, '2025-01-15'),
(4, 2, 'G004', 'Sussex', 2.60, '2025-01-20'),
(5, 2, 'G005', 'Orpington', 2.80, '2025-01-22'),
(6, 3, 'G006', 'Leghorn', 2.10, '2025-01-25'),
(7, 3, 'G007', 'Rhode Island Red', 2.55, '2025-01-28'),
(8, 3, 'G008', 'Plymouth Rock', 2.65, '2025-01-30'),
(9, 4, 'G009', 'Sussex', 2.40, '2025-02-01'),
(10, 4, 'G010', 'Orpington', 2.95, '2025-02-02'),
(11, 5, 'G011', 'Leghorn', 2.30, '2025-02-05'),
(12, 5, 'G012', 'Rhode Island Red', 2.60, '2025-02-06'),
(13, 6, 'G013', 'Sussex', 2.70, '2025-02-07'),
(14, 6, 'G014', 'Plymouth Rock', 2.80, '2025-02-08'),
(15, 7, 'G015', 'Orpington', 3.00, '2025-02-09'),
(16, 7, 'G016', 'Leghorn', 2.15, '2025-02-10'),
(17, 8, 'G017', 'Rhode Island Red', 2.45, '2025-02-11'),
(18, 9, 'G018', 'Sussex', 2.75, '2025-02-12'),
(19, 9, 'G019', 'Plymouth Rock', 2.65, '2025-02-13'),
(20, 10, 'G020', 'Leghorn', 2.20, '2025-02-14');

-- ==========================
-- Clasificación de peso (3)
-- ==========================
INSERT INTO Clasificacion_peso (id_clasificacion_peso, nombre, peso_min, peso_max)
VALUES
(1, 'Pequeño', 45.00, 52.00),
(2, 'Mediano', 53.00, 60.00),
(3, 'Grande', 61.00, 70.00);

-- ==========================
-- Producción (10)
-- ==========================
INSERT INTO Produccion (id_produccion, id_corral, fecha, observacion)
VALUES
(1, 1, '2025-02-15', 'Producción normal'),
(2, 2, '2025-02-15', 'Menor cantidad por clima'),
(3, 3, '2025-02-16', 'Producción estable'),
(4, 4, '2025-02-16', 'Producción baja'),
(5, 5, '2025-02-17', 'Producción en aumento'),
(6, 6, '2025-02-17', 'Producción normal'),
(7, 7, '2025-02-18', 'Producción con algunas bajas'),
(8, 8, '2025-02-18', 'Producción estable'),
(9, 9, '2025-02-19', 'Producción abundante'),
(10, 10, '2025-02-19', 'Producción moderada');

-- ==========================
-- Detalles de producción (20)
-- ==========================
INSERT INTO Detalles_produccion (id_detalle, id_produccion, id_clasificacion_peso, cantidad, cantidad_quebrados)
VALUES
(1, 1, 2, 100, 5),
(2, 1, 3, 80, 3),
(3, 2, 1, 60, 2),
(4, 2, 2, 50, 1),
(5, 3, 3, 90, 4),
(6, 3, 2, 70, 3),
(7, 4, 1, 40, 1),
(8, 4, 2, 30, 2),
(9, 5, 3, 85, 3),
(10, 5, 2, 60, 2),
(11, 6, 1, 55, 1),
(12, 6, 2, 65, 3),
(13, 7, 3, 100, 5),
(14, 7, 1, 45, 2),
(15, 8, 2, 70, 3),
(16, 8, 3, 95, 4),
(17, 9, 1, 80, 2),
(18, 9, 2, 100, 5),
(19, 10, 3, 60, 3),
(20, 10, 2, 75, 2);

-- ==========================
-- Inventario de huevos (10)
-- ==========================
INSERT INTO Inventario_huevos (id_inventario, id_clasificacion_peso, cubetas, sueltos)
VALUES
(1, 1, 5, 7),
(2, 2, 10, 5),
(3, 3, 8, 12),
(4, 1, 4, 6),
(5, 2, 9, 3),
(6, 3, 7, 8),
(7, 1, 6, 10),
(8, 2, 11, 2),
(9, 3, 5, 9),
(10, 2, 12, 4);

-- ==========================
-- Movimiento de huevos (10)
-- ==========================
INSERT INTO Movimiento_huevos (id_movimiento, id_inventario, id_detalle, tipo_movimiento, cubetas, sueltos, observacion)
VALUES
(1, 1, 1, 'fresco', 2, 3, 'Entrada producción'),
(2, 2, 2, 'fresco', 5, 1, 'Entrada producción'),
(3, 3, 5, 'fresco', 3, 4, 'Entrada producción'),
(4, 4, 7, 'en_transito', 2, 0, 'Traslado a bodega'),
(5, 5, NULL, 'vendido', 4, 2, 'Venta mayorista'),
(6, 6, 12, 'fresco', 6, 1, 'Producción diaria'),
(7, 7, NULL, 'vendido', 3, 0, 'Venta mercado local'),
(8, 8, 15, 'fresco', 5, 2, 'Entrada producción'),
(9, 9, NULL, 'en_transito', 4, 3, 'Traslado bodega central'),
(10, 10, NULL, 'vendido', 6, 1, 'Venta supermercado');

-- ==========================
-- Categorías (4)
-- ==========================
INSERT INTO Categoria (id_categoria, nombre, descripcion)
VALUES
(1, 'Alimentos', 'Insumos para gallinas'),
(2, 'Medicamentos', 'Fármacos avícolas'),
(3, 'Materiales', 'Material de uso diario'),
(4, 'Otros', 'Productos adicionales');

-- ==========================
-- Productos (10)
-- ==========================
INSERT INTO Producto (id_producto, nombre, descripcion, volumen, id_categoria, unidad_medida, stock_actual, ubicacion)
VALUES
(1, 'Maíz Amarillo', 'Saco de 40kg', 40, 1, 'kg', 500.00, 'Bodega 1'),
(2, 'Soya Molida', 'Saco de 50kg', 50, 1, 'kg', 350.00, 'Bodega 1'),
(3, 'Vacuna Newcastle', 'Vacuna para gallinas', 1, 2, 'dosis', 80.00, 'Refrigerador'),
(4, 'Vitamina A', 'Suplemento vitamínico', 100, 2, 'ml', 120.00, 'Bodega 2'),
(5, 'Bebedero Plástico', 'Bebedero 5 litros', 5, 3, 'litros', 30.00, 'Almacén'),
(6, 'Comedero Metálico', 'Comedero 10 kg', 10, 3, 'kg', 25.00, 'Almacén'),
(7, 'Guantes de Trabajo', 'Par de guantes resistentes', 1, 4, 'par', 60.00, 'Depósito'),
(8, 'Botas de Caucho', 'Par de botas', 1, 4, 'par', 40.00, 'Depósito'),
(9, 'Vitamina D', 'Suplemento en polvo', 500, 2, 'gr', 90.00, 'Bodega 2'),
(10, 'Saco de Trigo', 'Saco de 30kg', 30, 1, 'kg', 200.00, 'Bodega 1');


-- ==========================
-- Movimientos de productos (10)
-- ==========================
INSERT INTO Movimiento (id_movimiento, id_producto, id_granjero, tipo_movimiento, cantidad, observacion)
VALUES
(1, 1, 1, 'Entrada', 200.00, 'Compra de maíz'),
(2, 1, 1, 'Salida', 20.00, 'Consumo corral A'),
(3, 2, 2, 'Entrada', 150.00, 'Compra de soya'),
(4, 2, 2, 'Salida', 30.00, 'Consumo corral B'),
(5, 3, 3, 'Entrada', 50.00, 'Ingreso vacunas'),
(6, 3, 3, 'Salida', 10.00, 'Aplicación vacunas'),
(7, 5, 4, 'Entrada', 20.00, 'Compra bebederos'),
(8, 6, 4, 'Entrada', 15.00, 'Compra comederos'),
(9, 7, 5, 'Entrada', 40.00, 'Compra guantes'),
(10, 8, 5, 'Entrada', 30.00, 'Compra botas');

-- ==========================
-- Auditoría (10)
-- ==========================
INSERT INTO Auditoria (id_auditoria, id_granjero, accion, tabla_afectada, id_registro_afectado, valores_anteriores, valores_nuevos)
VALUES
(1, 1, 'insert', 'Granjero', 1, NULL, '{"primer_nombre":"Juan"}'),
(2, 2, 'insert', 'Granja', 2, NULL, '{"nombre":"Granja Los Pinos"}'),
(3, 3, 'insert', 'Producto', 3, NULL, '{"nombre":"Vacuna Newcastle"}'),
(4, 4, 'update', 'Inventario_huevos', 5, '{"cubetas":8}', '{"cubetas":9}'),
(5, 5, 'delete', 'Gallina', 10, '{"estado":"Activa"}', '{"estado":"Muerta"}'),
(6, 1, 'insert', 'Movimiento', 1, NULL, '{"cantidad":200}'),
(7, 2, 'insert', 'Movimiento_huevos', 2, NULL, '{"cubetas":5}'),
(8, 3, 'update', 'Producto', 2, '{"precio_unitario":2000}', '{"precio_unitario":2100}'),
(9, 4, 'insert', 'Categoria', 4, NULL, '{"nombre":"Otros"}'),
(10, 5, 'login', 'Sistema', NULL, NULL, '{"usuario":"pedro@example.com"}');

