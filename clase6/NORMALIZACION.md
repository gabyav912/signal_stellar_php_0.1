# Parte 1: Normalización Aplicada a Señal-Stellar

## 1. Entidad / Tabla Principal sin Normalizar (`bitacora_sin_normalizar`)
En esta tabla hipotética inicial, se mezclan datos del tripulante, su rol, el reporte de la bitácora, la categoría de la nota y múltiples etiquetas en una sola celda:

| id_nota | tripulante_nombre | tripulante_email | rol_id | rol_nombre | titulo_nota | categoria_nombre | etiquetas |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | Esteban Avendaño | esteban@stellar.com | R1 | Comandante | Rutina Pomodoro | Productividad | enfoque, estudio, php |
| 102 | Ezequiel | gab@hotmail.com | R2 | Tripulante | Pistas Lo-Fi | Música | audio, relajación |

**Problemas detectados:**
* El campo `etiquetas` contiene múltiples valores separados por coma (viola la atomicidad).
* `tripulante_nombre`, `tripulante_email` y `rol_nombre` se repiten cada vez que el mismo usuario crea una nota.
* `rol_nombre` depende de `rol_id` (dependencia transitiva).

---

## 2. Proceso de Normalización

### Primera Forma Normal (1FN) — Atributos atómicos
Se eliminan las listas en `etiquetas` dividiendo cada etiqueta en una fila individual. La clave primaria pasa a ser compuesta: `(id_nota, etiqueta)`[cite: 30, 31].

| id_nota (PK) | etiqueta (PK) | tripulante_nombre | tripulante_email | rol_id | rol_nombre | titulo_nota | categoria_nombre |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | enfoque | Esteban Avendaño | esteban@stellar.com | R1 | Comandante | Rutina Pomodoro | Productividad |
| 101 | estudio | Esteban Avendaño | esteban@stellar.com | R1 | Comandante | Rutina Pomodoro | Productividad |
| 101 | php | Esteban Avendaño | esteban@stellar.com | R1 | Comandante | Rutina Pomodoro | Productividad |
| 102 | audio | Ezequiel | gab@hotmail.com | R2 | Tripulante | Pistas Lo-Fi | Música |
| 102 | relajación | Ezequiel | gab@hotmail.com | R2 | Tripulante | Pistas Lo-Fi | Música |

### Segunda Forma Normal (2FN) — Dependencia funcional completa
Los datos de la nota y del tripulante dependen únicamente de `id_nota` y no de `etiqueta`[cite: 32]. Se separa la relación muchos-a-muchos (N:M) de las etiquetas en sus propias tablas[cite: 25, 32]:
* **`notas`:** `(id_nota [PK], tripulante_nombre, tripulante_email, rol_id, rol_nombre, titulo_nota, categoria_nombre)`
* **`etiquetas`:** `(id_etiqueta [PK], nombre)`
* **`nota_etiqueta`:** `(nota_id [PK, FK], etiqueta_id [PK, FK])`

### Tercera Forma Normal (3FN) — Sin dependencias transitivas
Se extraen los atributos que dependen de otros campos no-clave (`rol_nombre` depende de `rol_id`, los datos del tripulante pertenecen a su propia entidad y `categoria_nombre` es una entidad maestra)[cite: 25, 33]:
* **`roles`:** `(id [PK], nombre)`
* **`usuarios`:** `(id [PK], rol_id [FK], nombre, email, password, created_at, updated_at)`
* **`categorias`:** `(id [PK], nombre, color_hex)`
* **`notas`:** `(id [PK], usuario_id [FK], categoria_id [FK], titulo, contenido, created_at, updated_at)`
* **`etiquetas`:** `(id [PK], nombre)`
* **`nota_etiqueta`:** `(nota_id [PK, FK], etiqueta_id [PK, FK])`

---

## 3. Listado de Tablas Resultante (Esquema 3FN)
1. **`roles` (Maestra):** `id` (PK), `nombre`
2. **`usuarios` (Usuarios):** `id` (PK), `rol_id` (FK -> `roles.id`), `nombre`, `email`, `password`, `created_at`, `updated_at`
3. **`categorias` (Maestra):** `id` (PK), `nombre`, `color_hex`
4. **`notas` (Principal):** `id` (PK), `usuario_id` (FK -> `usuarios.id`), `categoria_id` (FK -> `categorias.id`), `titulo`, `contenido`, `created_at`, `updated_at`
5. **`etiquetas` (Secundaria):** `id` (PK), `nombre`
6. **`nota_etiqueta` (Relación N:M):** `nota_id` (PK, FK -> `notas.id`), `etiqueta_id` (PK, FK -> `etiquetas.id`)