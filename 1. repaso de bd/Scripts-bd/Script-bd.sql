-- creación de la bd
create database kwik_e_mart;

-- creación de tabla de empleado
create table employee (
	employee_id int primary key,
	last_name varchar(40) not null,
	first_name varchar(20) not null,
	birth_date date,
	hire_date date,
	address varchar(128),
	city varchar(30),
	country varchar(30),
	reports_to int,
	foreign key (reports_to) references employee(employee_id)
);

-- creación de tabla de cliente
create table customer  (
	customer_id int primary key,
	contact_name varchar(30) not null,
	company_name varchar(40),
	contact_email varchar(128) not null,
	address varchar(120),
	city varchar(30),
	country varchar(30)
);

-- creación de tabla de compra
create table purchase (
	purchase_id int primary key,
	customer_id int not null,
	employee_id int not null,
	total_price decimal(10,2) not null,
	purchase_date timestamp,
	shipped_date timestamp,
	ship_address varchar(60),
	ship_city varchar(15),
	ship_country varchar(15),
	foreign key (customer_id) references customer(customer_id),
	foreign key (employee_id) references employee(employee_id)
);

-- creacipon de tabla de categoría
create table category (
	category_id int primary key,
	name varchar(60) not null,
	description text,
	parent_category_id int,
	foreign key (parent_category_id) references category(category_id)
);

--creación de tabla de producto
create table product (
	product_id int primary key,
	product_name varchar(40) not null,
	category_id int not null,
	quantity_per_unit int,
	unit_price decimal(10,2),
	units_in_stock int,
	discontinued boolean,
	foreign key (category_id) references category(category_id)
);

-- creación de tabla intermedia entre compra y producto
create table purchase_item (
	purchase_id int,
	product_id int,
	primary key (purchase_id, product_id),
	unit_price decimal(10,2),
	quantity int not null,
	foreign key (purchase_id) references purchase(purchase_id),
	foreign key (product_id) references product (product_id)
);

-- datos para la tabla de categoría
INSERT INTO category (category_id, name, description, parent_category_id) VALUES
(1, 'Cleaning', 'Household cleaning products', NULL),
(2, 'Beverages', 'Juices, sodas and water', NULL),
(3, 'Dairy', 'Milk, cheese, yogurt', NULL),
(4, 'Meat', 'Fresh and frozen meat products', NULL),
(5, 'Fruits and Vegetables', 'Fresh natural products', NULL),
(6, 'Snacks', 'Cookies, chips and similar', NULL),
(7, 'Technology', 'Electronic devices and accessories', NULL),
(8, 'Computer Accessories', 'PC peripherals and accessories', 7);

-- datos para la tabla de empleados
INSERT INTO employee (employee_id, last_name, first_name, birth_date, hire_date, address, city, country, reports_to) VALUES
(1, 'Smith', 'John', '1985-06-12', '2010-03-01', '123 Main St', 'New York', 'USA', NULL),
(2, 'Johnson', 'Emily', '1990-09-20', '2015-07-15', '456 Oak St', 'Los Angeles', 'USA', 1),
(3, 'Garcia', 'Luis', '1982-02-10', '2008-11-03', '789 Pine Ave', 'Chicago', 'USA', 1);

-- datos para la tabla de clientes
INSERT INTO customer (customer_id, contact_name, company_name, contact_email, address, city, country) VALUES
(1, 'Alice Brown', 'Fresh Market', 'alice@fresh.com', '321 Maple Rd', 'Miami', 'USA'),
(2, 'Robert Miller', 'Health Foods', 'robert@hf.com', '654 Elm St', 'Orlando', 'USA'),
(3, 'Sofia Lopez', 'Green Valley', 'sofia@greenvalley.com', '987 Palm St', 'Knoxville', 'USA'),
(4, 'Daniel Kim', 'Global Trade', 'daniel@gt.com', '741 Cedar Ave', 'Houston', 'USA'),
(5, 'Laura White', 'Tech World', 'laura@techworld.com', '852 Birch St', 'Dallas', 'USA'),
(6, 'Carlos Ramirez', 'Eco Market', 'carlos@ecomarket.com', '963 Walnut Ave', 'Stockton', 'USA'),
(7, 'Marta Gonzalez', 'Fruit Express', 'marta@fruitexpress.com', '147 Spruce Rd', 'Atlanta', 'USA'),
(8, 'Alejandro Gutierrez', 'National Tech', 'alejo@gmail.com', '256 Spruce GG', 'Atlanta', 'USA');

-- datos para la tabla de productos
INSERT INTO product (product_id, product_name, category_id, quantity_per_unit, unit_price, units_in_stock, discontinued) VALUES
(1, 'Bar Soap', 1, 10, 2.50, 50, false),
(2, 'Broom', 1, 5, 4.00, 100, false),
(3, 'Red Apple', 5, 20, 3.80, 200, false),
(4, 'Banana', 5, 25, 2.20, 180, false),
(5, 'Mozzarella Cheese', 3, 2, 5.50, 80, false),
(6, 'Whole Milk', 3, 6, 3.00, 120, false),
(7, 'Beef Meat', 4, 3, 10.00, 60, false),
(8, 'Chocolate Cookies', 6, 12, 4.20, 150, true),
(9, 'Carrot', 5, 15, 1.80, 90, false),
(10, 'Orange', 5, 20, 3.60, 110, false),
(11, 'HP Pavilion Laptop', 7, 1, 750.00, 25, false),
(12, 'Samsung Galaxy Smartphone', 7, 1, 600.00, 40, false),
(13, 'Bluetooth Headphones', 7, 1, 55.00, 100, true),
(14, 'Wireless Mouse', 7, 1, 20.00, 150, false),
(15, 'Mechanical Keyboard', 8, 1, 85.00, 70, false),
(16, 'SSD 1TB Drive', 8, 1, 120.00, 50, true),
(17, 'Chocolate Wonka', 6, 12, 6.20, 90, true),
(18, 'Potato Chips', 6, 20, 2.80, 200, true),
(19, 'Salted Crackers', 6, 30, 3.20, 150, true),
(20, 'Pineapple', 5, 10, 3.90, 90, true),
(21, 'Lettuce', 5, 15, 2.10, 120, true),
(22, 'Grapes', 5, 12, 4.80, 100, true),
(23, 'Greek Yogurt', 3, 6, 5.00, 80, true),
(24, 'Butter', 3, 4, 4.20, 50, true);

-- datos para la tabla de compras
INSERT INTO purchase (purchase_id, customer_id, employee_id, total_price, purchase_date, shipped_date, ship_address, ship_city, ship_country) VALUES
(1, 1, 2, 15.60, '2023-11-20 10:00:00', '2023-11-21 14:00:00', '321 Maple Rd', 'Miami', 'USA'),
(2, 2, 1, 20.40, '2023-12-05 15:30:00', '2023-12-06 09:00:00', '654 Elm St', 'Orlando', 'USA'),
(3, 3, 1, 45.00, '2024-01-10 11:15:00', '2024-01-11 13:00:00', '987 Palm St', 'Knoxville', 'USA'),
(4, 4, 3, 1360.00, '2024-02-02 16:00:00', '2024-02-03 09:30:00', '741 Cedar Ave', 'Houston', 'USA'),
(5, 5, 2, 675.00, '2024-02-15 14:20:00', '2024-02-16 10:00:00', '852 Birch St', 'Dallas', 'USA'),
(6, 7, 3, 27.20, '2024-03-05 12:00:00', '2024-03-06 08:15:00', '147 Spruce Rd', 'Atlanta', 'USA');

-- datos de la tabla intermedia entre compras y productos
INSERT INTO purchase_item (purchase_id, product_id, unit_price, quantity) VALUES
(1, 2, 4.00, 2), -- Arroz Blanco
(1, 3, 3.80, 2), -- Manzana Roja
(2, 7, 10.00, 1), -- Carne de Res
(2, 5, 5.50, 2),  -- Queso Mozzarella
(3, 8, 4.20, 5),   -- Galletas de Chocolate
(3, 6, 3.00, 2),   -- Leche Entera
(4, 11, 750.00, 1),-- Laptop HP Pavilion
(4, 12, 600.00, 1),-- Smartphone Samsung
(4, 14, 20.00, 2), -- Mouse Inalámbrico
(5, 12, 600.00, 1),-- Smartphone Samsung
(5, 13, 55.00, 3), -- Auriculares Bluetooth
(6, 3, 3.80, 2),   -- Manzana Roja
(6, 10, 3.60, 2);  -- Naranja
