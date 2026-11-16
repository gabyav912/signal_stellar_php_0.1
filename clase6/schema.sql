-- ==========================================================
-- SCRIPT DDL: CREACIÓN DE ESQUEMA - SEÑAL-STELLAR (CLASE 6)
-- ==========================================================

CREATE DATABASE IF NOT EXISTS senal_stellar_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE senal_stellar_db;

-- 1. Tabla Maestra: Roles
CREATE TABLE IF NOT EXISTS roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 2. Tabla de Usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rol_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);

-- 3. Tabla Maestra: Categorías de Notas/Módulos
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    color_hex VARCHAR(7) DEFAULT '#FFD700'
);

-- 4. Tabla Principal de Negocio: Notas Estelares / Bitácora
CREATE TABLE IF NOT EXISTS notas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    categoria_id INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- 5. Tabla Secundaria: Etiquetas
CREATE TABLE IF NOT EXISTS etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 6. Tabla Intermedia (Relación N:M): Nota - Etiqueta
CREATE TABLE IF NOT EXISTS nota_etiqueta (
    nota_id INT NOT NULL,
    etiqueta_id INT NOT NULL,
    PRIMARY KEY (nota_id, etiqueta_id),
    FOREIGN KEY (nota_id) REFERENCES notas(id) ON DELETE CASCADE,
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE CASCADE
);

-- 7. Optimización con Índices B-Tree explícitos
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_notas_categoria ON notas(categoria_id);