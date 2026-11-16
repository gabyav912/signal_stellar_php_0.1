-- ==========================================================
-- SCRIPT DML: OPERACIONES CRUD DE PRUEBA - SEÑAL-STELLAR
-- ==========================================================

USE senal_stellar_db;

-- 1. CREATE (Inserciones iniciales)
-- Inserciones en tablas maestras
INSERT INTO roles (nombre) VALUES 
('Comandante'),
('Tripulante');

INSERT INTO categorias (nombre, color_hex) VALUES 
('Productividad', '#FFD700'),
('Música Estelar', '#29b6f6'),
('Soporte Técnico', '#2ecc71');

-- Inserciones en tabla de usuarios
INSERT INTO usuarios (rol_id, nombre, email, password) VALUES 
(1, 'Esteban Avendaño', 'esteban@stellar.com', '$2y$10$hashDeEjemploSeguro123456'),
(2, 'Ezequiel', 'gab@hotmail.com', '$2y$10$hashDeEjemploSeguro789012');

-- Inserciones en tabla principal (notas) vinculando FKs
INSERT INTO notas (usuario_id, categoria_id, titulo, contenido) VALUES 
(1, 1, 'Configuración de Ciclos Pomodoro', 'Ajustar bloques de enfoque de 25 minutos y descansos de 5 minutos.'),
(2, 2, 'Pistas Ambientales IndexedDB', 'Cargar melodías Lo-Fi en el reproductor local para sesiones de estudio.'),
(1, 3, 'Verificación de Seguridad XSS', 'Sanitizar todas las entradas $_POST y $_GET con htmlspecialchars.');

-- Inserciones en etiquetas y tabla intermedia N:M
INSERT INTO etiquetas (nombre) VALUES ('php'), ('pomodoro'), ('audio'), ('seguridad');
INSERT INTO nota_etiqueta (nota_id, etiqueta_id) VALUES (1, 2), (2, 3), (3, 1), (3, 4);

-- 2. READ (Consultas con filtrado, ordenamiento y uniones)
-- Filtro con WHERE y ordenamiento con ORDER BY
SELECT id, titulo, created_at 
FROM notas 
WHERE usuario_id = 1 
ORDER BY id DESC;

-- Unión relacional con INNER JOIN (Notas + Autor + Categoría)
SELECT 
    n.id AS id_nota,
    n.titulo AS nota,
    u.nombre AS autor,
    r.nombre AS rol,
    c.nombre AS categoria,
    n.created_at AS fecha_creacion
FROM notas n
INNER JOIN usuarios u ON n.usuario_id = u.id
INNER JOIN roles r ON u.rol_id = r.id
INNER JOIN categorias c ON n.categoria_id = c.id
ORDER BY n.id ASC;

-- 3. UPDATE (Actualización controlada con WHERE)
UPDATE notas 
SET titulo = 'Configuración de Ciclos Pomodoro (Actualizado)', 
    categoria_id = 3 
WHERE id = 1;

-- 4. DELETE (Eliminación controlada con WHERE)
DELETE FROM notas 
WHERE id = 2;