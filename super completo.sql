create database PROYECTO_BETA3;
use PROYECTO_BETA3;
;
# TABLAS DE LA BASE

-- TABLA GENERO (ES UNA SEGMENTACION QUE USA EL  AREA DE MARKETING PARA EL DESARROLLO DE OFERTAS)
create table Genero(
id_genero int auto_increment primary key,
Genero varchar(30)
)
;
-- TABLA TIPO DE CLIENTE (ES UNA SEGMENTACION QUE USA EL AREA DE MARKETING PARA EL DESARROLLO DE OFERTAS)

create table Tipo_Cliente(
id_Tipo int auto_increment primary key,
Tipo_Cl varchar(30)
)
;
-- TABLA  CLIENTE (ES DONDE SE CONCETRAN LOS DATOS DE LO CLIENTES DEL NEGOCIO)
create table Cliente(
id_cliente int auto_increment primary key,
Nombre varchar(50) not null,
Apellido varchar(50) not null,
edad int,
id_genero int not null,
id_Tipo int not null
)
;

-- CLAVES FORANEAS DE LA RELACION DE LA TABLA CLIENTE CON GENERO Y TIPO DE CLIENTE

alter table cliente add constraint genero_cl foreign key(id_genero) references genero(id_genero);
alter table cliente add constraint tipo_cl foreign key(id_Tipo) references Tipo_Cliente(id_Tipo);

-- TABLA FORMA DE PAGO (PERMITE VER LOS DISTINTOS MEDIOS DE PAGOS QUE SE USAN)
create table Forma_Pago (
id_Forma int auto_increment primary key,
forma_pago varchar(25)
)
;

-- TABLA PAGO (PERMITE LOS PAGOS QUE SE REALIZAN POR DIA Y TIPO DE PAGO)
create table pago (
id_pago int auto_increment primary key,
Fecha_pago datetime,
id_Forma int not null
)
;

-- CLAVES FORANEAS DE LA RELACION DE LA TABLA CLIENTE CON GENERO Y TIPO DE CLIENTE
alter table pago add constraint for_Pago foreign key(id_Forma) references Forma_Pago(id_Forma);
;

-- TABLA CON LOS DATOS DE LAS SUCURSALES

create table Establecimiento (
id_sucursal int auto_increment primary key,
Nombre varchar(50) not null,
Direccion varchar(100)
)
;

-- TABLA CON  LAS CATEGORIAS QUE TIENE EL NEGOCIO

create table categoria(
id_cat int auto_increment primary key,
nombre_cat varchar(50),
cant_prod int
)
;

-- TABLA  DE ECHOS CON LOS DATOS DE LA COMPRAS REALIZADAS POR LOS CLIENTES EN LAS DISTINTAS SUCURSALES Y CATEGORIAS DEL LOS MISMOS

create table compra(
id_venta int auto_increment primary key,
id_cliente int not null,
id_sucursal int not null,
precio_un decimal(9,2) null,
cantidad int not null,
monto decimal(9,2) null,
id_pago int not null,
id_cat int not null
)
;

-- CLAVES FORANEAS DE LA RELACION DE LA TABLA COMPRA CLIENTE, ESTABLECIMIENTO, PAGO Y CATEGORIA.

alter table compra add constraint cliente_compra foreign key(id_cliente) references Cliente(id_cliente);
alter table compra add constraint suc_compra foreign key(id_sucursal) references Establecimiento(id_sucursal);
alter table compra add constraint pago_compra foreign key(id_pago) references pago(id_pago);
alter table compra add constraint cat_compra foreign key(id_cat) references categoria(id_cat);

#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA CATEGORIA
#----------------------------------------------------------------------------------------------------------------
insert into categoria (id_cat, nombre_cat, cant_prod)
values
('300001','ALIMENTOS Y BEBIDAS','100'),
('300002','SALUD Y BELLEZA','100'),
('300003','HOGAR Y ESTILO DE VIDA','100'),
('300004','ACCESORIOS ELECTRONICOS','100'),
('300005','VIAJES Y DEPORTES','100'),
('300006','MODA','100');
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA GENERO
#----------------------------------------------------------------------------------------------------------------
insert into genero (id_genero, Genero)
values
('500001','MASCULINO'),
('500002','FEMENINO');
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA TIPO DE CLIENTE
#----------------------------------------------------------------------------------------------------------------
insert into tipo_cliente (id_tipo, Tipo_Cl)
values
('10001','HABITUAL'),
('10002','OCASIONAL');
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA FORMA DE PAGO
#----------------------------------------------------------------------------------------------------------------
insert into forma_pago(id_Forma, forma_pago)
values
('700001','Efectivo'),
('700002','Tarjeta'),
('700003','CodigoQR');
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA CATEGORIA ESTABLECIMIENTO
#----------------------------------------------------------------------------------------------------------------
insert into establecimiento(id_sucursal, nombre,direccion)
values
('800001','PALERMO-CABA','calle23'),
('800002','TBALVANERA-CABA','calle25'),
('800003','CABALLITO-CABA','calle25');
select * from compra;
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA COMPRA - SE CARGA DESDE EL CSV "CLIENTES"
#----------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA PAGO - SE CARGA DESDE EL CSV "PAGO"
#----------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------
# INSERTANDO DATOS DE LA TABLA COMPRA - SE CARGA DESDE EL CSV "COMPRAS"
#----------------------------------------------------------------------------------------------------------------
#-------------------#
#      VISTAS 
#-------------------#
-- ventas  totales por categoria --
create view
ventas_x_categoria as
select id_cat, sum(monto)
from compra
group by id_cat
;

-- ventas  totales por sucursales --

create view
ventas_x_sucursal as
select id_sucursal, sum(monto)
from compra
group by id_sucursal
;

-- cantidad de ventas totales por sucursales --

create view
cantidad_vendida_sucursal as
select id_sucursal, sum(cantidad)
from compra
group by id_sucursal
;

-- clientes mayores de 59 años --

create view
clientes_mayores as
select id_cliente, nombre, edad
from cliente
where edad > 59
;

#-------------------#
#      FUNCIONES 
#-------------------#

delimiter //

-- funcione que traer el nombre del cliente ingresando un parametro el id_cliente

create function nombre_cl_2(param_nombre int)
returns char(60)
reads sql data
not deterministic
begin
	declare nombre_de_cliente char(60);
	
    select Nombre into nombre_de_cliente
    from cliente
    where id_cliente = param_nombre;
    
    return nombre_de_cliente;
end//

delimiter ;
#-------------------------#
#          PRUEBA
#-------------------------#

-- COMPRAS POR CLIENTE --

 select * from compra;
 select nombre_cl_2(400001);
 
 select c.id_venta, c.monto, nombre_cl_2(id_cliente)
 from compra as c;
 
 -- funcione que trae a la sucursal
delimiter //
create function nombre_sucursal(param_nombre int)
returns char(60)
reads sql data
not deterministic
begin
	declare nombre_de_suc char(60);
	
    select Nombre into nombre_de_suc
    from establecimiento
    where id_sucursal = param_nombre;
    
    return nombre_de_suc;
end//
delimiter ;
#-------------------------#
#          PRUEBA
#-------------------------#

select nombre_sucursal(id_sucursal) as sucursal, sum(monto)
from compra
group by nombre_sucursal(id_sucursal);

#-------------------------#
#    Stored Procedures    #
#-------------------------#
delimiter //
-- permite el odenamiento de la tabla cliente asc o desc selecionando un campo de la tabla
CREATE PROCEDURE ordenamiento_empleado(IN campo_a_ordenar VARCHAR(50), IN orden BOOLEAN)
BEGIN
	IF campo_a_ordenar <> '' AND orden = 1 THEN 
		SET @ordenar = concat('ORDER BY ',campo_a_ordenar);
	ELSEIF campo_a_ordenar <> '' AND orden = 0 THEN
		SET @ordenar = concat('ORDER BY ',campo_a_ordenar,' DESC');
	ELSEIF campo_a_ordenar <> '' AND orden NOT IN (0,1) THEN
		SET @ordenar = 'NO VALIDO';
        SELECT 'parametro de ornamiento ingesado no valido' as mensaje;
	ELSE
		SET @ordenar = '';
	END IF;
    IF @ordenar <> 'NO VALIDO' THEN
		SET @clausula_select = concat('SELECT * FROM cliente ',@ordenar);
        PREPARE ejecucion FROM @clausula_select;
        EXECUTE ejecucion;
        DEALLOCATE PREPARE ejecucion;
	END IF;
END //
delimiter;
#-------------------------#
#          PRUEBA
#-------------------------#

call ordenamiento_empleado('nombre',0);

-- permite el ingreso de un cliente nuevo
DROP PROCEDURE IF EXISTS Cliente_Nuevo;
DELIMITER //
CREATE PROCEDURE Cliente_Nuevo(IN Nombre VARCHAR(50), IN Apellido VARCHAR(50), IN edad INT, IN id_genero INT, IN id_tipo INT)
BEGIN
	INSERT INTO cliente VALUES(DEFAULT,Nombre,Apellido,edad,id_genero,id_tipo);
END//

DELIMITER ;

#-------------------------#
#          TRIGGERS
#-------------------------#
-- SE REGISTRA CUANDO SE AGREGA UN CLEINTE NUEVO
CREATE TABLE log_cliente(
id_log INT PRIMARY KEY auto_increment,
id_cliente int not null,
Nombre varchar(50),
Apellido varchar(50),
edad int,
id_genero int not null,
id_Tipo int not null,
usuario varchar(50),
fecha_hora datetime

);

CREATE TRIGGER log_cliente
AFTER INSERT ON cliente
FOR EACH ROW
INSERT INTO log_cliente VALUES (DEFAULT, new.id_cliente, new.Nombre, new.Apellido, new.edad, new.id_genero, new.id_Tipo, user(),now());

#TABLA LOG PARA REGISTRAR INSERCION EN LA TABLA GENERO
create table agregar_genero(
id_log INT PRIMARY KEY auto_increment,
id_genero INT NOT NULL,
genero varchar(50),
usuario varchar(50),
fecha_hora DATETIME
);

#TRIGER PARA EL REGISTRO DE LA INSERCION 
CREATE TRIGGER agregar_genero
AFTER INSERT ON genero
FOR EACH ROW
INSERT INTO agregar_genero VALUES(DEFAULT,default, new.genero, user(), now());
