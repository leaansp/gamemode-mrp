# SQL Pendiente — Migracion a base de datos de produccion

Cambios de codigo que requieren ejecucion manual de SQL antes de deployar.
**Ejecutar siempre en el orden indicado.**

---

## 1. Tabla `holster` (nueva)

**Archivo:** `database/holster.sql`

```sql
CREATE TABLE IF NOT EXISTS `holster` (
	`playerid` INT UNSIGNED NOT NULL,
	`itemid`   INT UNSIGNED NOT NULL DEFAULT 0,
	`param`    INT UNSIGNED NOT NULL DEFAULT 0,
	`pos_x`    FLOAT NOT NULL DEFAULT 0.08,
	`pos_y`    FLOAT NOT NULL DEFAULT 0.07,
	`pos_z`    FLOAT NOT NULL DEFAULT -0.10,
	`rot_x`    FLOAT NOT NULL DEFAULT 0.0,
	`rot_y`    FLOAT NOT NULL DEFAULT 0.0,
	`rot_z`    FLOAT NOT NULL DEFAULT 0.0,
	`sc_x`     FLOAT NOT NULL DEFAULT 0.8,
	`sc_y`     FLOAT NOT NULL DEFAULT 0.8,
	`sc_z`     FLOAT NOT NULL DEFAULT 0.8,
	PRIMARY KEY (`playerid`)
);
```

Sistema: `/cadera` — guarda qué arma tiene el jugador en la cintura y su posicion personalizada.

---

## 2. Columna `mode` en tabla `holster`

**Archivo:** `database/holster_mode.sql`

> **Requiere que la tabla `holster` ya exista (paso 1 primero).**

```sql
ALTER TABLE `holster` ADD COLUMN `mode` TINYINT UNSIGNED NOT NULL DEFAULT 0;
```

Agrega el modo de attachment del holster:
- `0` = muslo derecho (se mueve con la pierna al caminar) — comportamiento original
- `1` = columna/pecho (estatico, no sigue animaciones)

El `DEFAULT 0` garantiza que los registros existentes queden en modo 0 sin migracion de datos.

**Importante:** Si se deploya el codigo antes de ejecutar este ALTER, el SELECT de carga del holster falla silenciosamente (`Unknown column 'mode'`) y el jugador no vera su arma en la cadera aunque los datos en DB no se pierden.

---

## 3. Tabla `twitter` (nueva)

**Archivo:** `database/twitter.sql`

```sql
CREATE TABLE IF NOT EXISTS `twitter` (
    `id`         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `pID`        INT UNSIGNED NOT NULL,
    `pName`      VARCHAR(24)  NOT NULL DEFAULT '',
    `username`   VARCHAR(20)  NOT NULL,
    `created_at` TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uq_pID`      (`pID`),
    UNIQUE KEY `uq_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

Sistema: Twitter in-game. Sin esta tabla, `/registrarsetwitter` y `/tw` fallan.

---

## Resumen

| # | Accion | Archivo |
|---|---|---|
| 1 | CREATE TABLE holster | `database/holster.sql` |
| 2 | ALTER TABLE holster ADD COLUMN mode | `database/holster_mode.sql` |
| 3 | CREATE TABLE twitter | `database/twitter.sql` |

Los tres usan `IF NOT EXISTS` o `DEFAULT` seguros — no rompen datos existentes si se ejecutan dos veces (excepto el ALTER, que daria error si la columna ya existe, pero no perderia datos).
