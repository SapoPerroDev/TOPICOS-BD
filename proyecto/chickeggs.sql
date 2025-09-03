-- Creación de la bd
CREATE DATABASE chickeggs;

-- tabla de granjero
CREATE TABLE Granjero (
    id_granjero int primary key,
    primer_nombre varchar(30) not null,
    segundo_nombre varchar(30),
    primer_apellido varchar(30) not null,
    segundo_apellido varchar(30),
    email varchar(255) unique not null,
    password_hash text not null,
    numero_telefono varchar(20) not null, 
    estado boolean default true,
    fecha_registro TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

create table Granja (
	id_granja int primary key,
	id_granjero int not null,
	nombre varchar(60) not null,
	ubicacion varchar(255),
	foreign key (id_granjero) references Granjero (id_granjero)
);

-- tabla de corral
CREATE TABLE Corral (
    id_corral int primary key,
    id_granja int not null,
    codigo_corral varchar(20) unique not null,
    nombre varchar(30) not null,
    capacidad int not null,
    ubicacion varchar(30),
    foreign key (id_granja) references Granja (id_granja)
);

CREATE TABLE Gallina (
    id_gallina int primary key,
    id_corral int not null,
    codigo_gallina varchar(20) unique not null,
    raza varchar(40),
    peso decimal(5, 2),
    fecha_ingreso date not null,
    estado varchar(20) default 'Activa',
    foreign key (id_corral) references Corral (id_corral)
);

CREATE TABLE Produccion (
    id_produccion int primary key,
    id_corral int not null,
    fecha date not null,
    observacion text,
    foreign key (id_corral) references Corral (id_corral)
);

create table Clasificacion_peso (
	id_clasificacion_peso int primary key,
	nombre varchar(40) not null,
	peso_min decimal(5, 2),
	peso_max decimal(5, 2)
);

CREATE TABLE Detalles_produccion (
    id_detalle int primary key,
    id_produccion int not null,
    id_clasificacion_peso int not null,
    cantidad int not null,
    cantidad_quebrados int default 0 not null,
    foreign key (id_produccion) references Produccion (id_produccion),
    foreign key (id_clasificacion_peso) references Clasificacion_peso (id_clasificacion_peso)
);

create table Inventario_huevos (
    id_inventario int primary key,
    id_clasificacion_peso int not null,
    cubetas int not null default 0,       -- número de cubetas completas (30 huevos)
    sueltos int not null default 0,       -- huevos que no completan cubeta
    stock_total int generated always as (cubetas * 30 + sueltos) stored,
    foreign key (id_clasificacion_peso) references Clasificacion_peso(id_clasificacion_peso)
);

create table Movimiento_huevos (
    id_movimiento int primary key,
    id_inventario int not null,
    id_detalle int null,
    tipo_movimiento VARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('fresco', 'en_transito', 'vendido')),
    cubetas int not null default 0,
    sueltos int not null default 0,
    fecha timestamp default current_timestamp,
    observacion text,
    foreign key (id_inventario) references Inventario_huevos(id_inventario),
    foreign key (id_detalle) references Detalles_produccion(id_detalle)
);

CREATE TABLE Categoria (
    id_categoria int primary key ,
    nombre varchar(50) not null,   -- Ej: Alimentos, Medicamentos, Materiales, Otros
    descripcion varchar(200)
);

CREATE TABLE Producto (
    id_producto int primary key,
    nombre varchar(100) not null,
    descripcion text,
    volumen int not null,
    id_categoria int not null,
    unidad_medida varchar(20) not null,   -- ej: kg, litros, cajas, dosis
    stock_actual decimal(10,2) DEFAULT 0 not null,
    ubicacion varchar(40),
    foreign key (id_categoria) references Categoria(id_categoria)
);


CREATE TABLE Movimiento (
    id_movimiento int primary key,
    id_producto int not null,
    id_granjero int not null,
    tipo_movimiento VARCHAR(10) NOT NULL CHECK (tipo_movimiento IN ('Entrada', 'Salida')),
    cantidad decimal(10,2) not null,
    fecha timestamp default CURRENT_TIMESTAMP,
    observacion text,
    foreign key (id_granjero) references granjero (id_granjero),
    foreign key (id_producto) references Producto (id_producto)
);

-- Tabla para registrar todos los cambios que se den en las tablas
CREATE TABLE auditoria (
    id_auditoria int primary key,
    id_granjero int null,                           -- usuario que hizo la acción
    accion varchar(50) not null,                    -- acción: insert, update, delete, login, logout, acceso, error
    tabla_afectada varchar(100) not null,           -- tabla o módulo afectado
    id_registro_afectado int null,                  -- id del registro que cambió
    valores_anteriores jsonb null,                  -- si aplica, estado previo
    valores_nuevos jsonb null,                      -- si aplica, estado nuevo
    fecha timestamp default current_timestamp,
    foreign key (id_granjero) references granjero(id_granjero)
);
