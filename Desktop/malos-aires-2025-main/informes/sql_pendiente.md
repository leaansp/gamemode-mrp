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

## 4. Columnas `rot_x` y `rot_y` en tabla `graffiti`

> **La tabla `graffiti` ya existe en produccion. Solo agregar las columnas.**

```sql
ALTER TABLE `graffiti` ADD COLUMN `rot_x` FLOAT NOT NULL DEFAULT 0 AFTER `angle`;
ALTER TABLE `graffiti` ADD COLUMN `rot_y` FLOAT NOT NULL DEFAULT 0 AFTER `rot_x`;
```

Agrega soporte para rotacion completa en los 3 ejes al editar grafitis con `/editargrafiti`.
Sin estas columnas, el UPDATE al guardar la posicion editada falla y la rotacion en X/Y se pierde al relog.
Los grafitis existentes quedaran con `rot_x=0, rot_y=0` (default correcto para grafitis planos contra pared).

---

## 5. Columnas `pMuteTW` y `pMuteTWReason` en tabla `accounts`

> **La tabla `accounts` ya existe. Solo agregar las columnas.**

```sql
ALTER TABLE `accounts` ADD COLUMN `pMuteTW` INT NOT NULL DEFAULT 0;
ALTER TABLE `accounts` ADD COLUMN `pMuteTWReason` VARCHAR(80) NOT NULL DEFAULT '';
```

- `pMuteTW = 0` → no muteado
- `pMuteTW = -1` → muteado indefinidamente
- `pMuteTW = N` → segundos restantes de mute

Sistema: `/muteartw` y `/desmuteartw` (admin nivel 3+). Bloquea el uso de `/tw`.
Sin estas columnas el servidor crashea al intentar cargar/guardar la cuenta.

---

---

## 6. Sistema de negocios mejorado

> **La tabla `business` ya existe. La tabla `biz_employees` ya existe. Crear tabla nueva `biz_reviews`.**

```sql
-- Descripcion en negocios
ALTER TABLE `business` ADD COLUMN `bDescription` VARCHAR(128) NOT NULL DEFAULT '';

-- Rangos y salario en empleados
ALTER TABLE `biz_employees` ADD COLUMN `bizEmpRankName` VARCHAR(32) NOT NULL DEFAULT 'Empleado';
ALTER TABLE `biz_employees` ADD COLUMN `bizEmpRankLevel` TINYINT NOT NULL DEFAULT 0;
ALTER TABLE `biz_employees` ADD COLUMN `bizEmpSalary` INT NOT NULL DEFAULT 0;

-- Tabla de reseñas (una por jugador por negocio)
CREATE TABLE IF NOT EXISTS `biz_reviews` (
  `bizid`  SMALLINT(6) NOT NULL,
  `pID`    INT(11)     NOT NULL,
  `rating` TINYINT(4)  NOT NULL DEFAULT 0,
  PRIMARY KEY (`bizid`, `pID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

**Importante:** Si se deploya el codigo antes de ejecutar estos ALTERs:
- `bDescription` falla silenciosamente en el SELECT (columna desconocida)
- Los rangos de empleados no se guardan/cargan correctamente
- `/resena` falla al intentar insertar en `biz_reviews`

---

## 7. Tabla `biz_rank_names` (nueva)

> **Requiere que el sistema de negocios (paso 6) ya esté ejecutado.**

```sql
CREATE TABLE IF NOT EXISTS `biz_rank_names` (
  `bizid`      SMALLINT(6) NOT NULL,
  `rank_level` TINYINT     NOT NULL,
  `rank_name`  VARCHAR(32) NOT NULL DEFAULT '',
  PRIMARY KEY (`bizid`, `rank_level`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

Sistema: `/modificarnombrerangos` — permite al dueño del negocio cambiar el nombre de cada rango (1-6).
Sin esta tabla, el comando falla con error MySQL y los nombres custom no se persisten entre reinicios.

---

## Resumen

| # | Accion | Archivo |
|---|---|---|
| 1 | CREATE TABLE holster | `database/holster.sql` |
| 2 | ALTER TABLE holster ADD COLUMN mode | `database/holster_mode.sql` |
| 3 | CREATE TABLE twitter | `database/twitter.sql` |
| 4 | ALTER TABLE graffiti ADD COLUMN rot_x, rot_y | — (ejecutar directo) |
| 5 | ALTER TABLE accounts ADD COLUMN pMuteTW, pMuteTWReason | — (ejecutar directo) |
| 6 | Sistema negocios: ALTER business + biz_employees + CREATE biz_reviews | — (ejecutar directo) |
| 7 | CREATE TABLE biz_rank_names | — (ejecutar directo) |

Los tres primeros usan `IF NOT EXISTS` o `DEFAULT` seguros — no rompen datos existentes si se ejecutan dos veces (excepto los ALTER, que darian error si la columna ya existe, pero no perderian datos).
