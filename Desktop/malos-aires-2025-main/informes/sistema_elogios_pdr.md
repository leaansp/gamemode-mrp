# Sistema de Elogios + PDR Expandido — Plan de desarrollo

## Pendiente testear con otra PC (notebook)
- Validación "no podés darle 2 elogios al mismo jugador en el mismo día" — requiere dos sesiones distintas
- Flujo completo del /elogiar entre dos jugadores reales (donante_id != receptor_id)

---

## Contexto

El sistema de Puntos de Rol (PDR) ya existe en el código pero solo sirve para acceder al job de delincuente.
El objetivo es expandirlo para que sea una "moneda social y de progreso" dentro del servidor.

Los elogios son un sistema complementario: los dan los jugadores entre sí (no los admins), y acumulando suficientes elogios se obtiene 1 PDR automáticamente.

**Archivos existentes relevantes:**
- `gamemodes/system/marp_rolepoints.pwn` — comandos actuales de PDR (darpuntoderol, quitarpuntoderol, verpuntosderol)
- `gamemodes/player/marp_players.pwn` — enum `pInfo` donde está `pRolePoints`
- `gamemodes/marp_core.pwn` — carga de `ServerInfo` desde DB (tabla `server_config`)

---

## SQL — Ejecutar en orden

### 1. Tabla `elogios` (nueva)
```sql
CREATE TABLE IF NOT EXISTS `elogios` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `receptor_id` INT UNSIGNED NOT NULL,
    `donante_id`  INT UNSIGNED NOT NULL,
    `fecha`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_receptor` (`receptor_id`),
    KEY `idx_donante`  (`donante_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
```

### 2. Columnas en `accounts`
```sql
ALTER TABLE `accounts` ADD COLUMN `pElogios` INT UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE `accounts` ADD COLUMN `pElogiosPendientes` INT UNSIGNED NOT NULL DEFAULT 0;
```
- `pElogios` — total acumulado histórico
- `pElogiosPendientes` — los que todavía no se convirtieron en PDR

### 3. Columna en `server_config`
```sql
ALTER TABLE `server_config` ADD COLUMN `sElogiosPorPDR` INT UNSIGNED NOT NULL DEFAULT 30;
```
Valor inicial: 30 elogios = 1 PDR. Configurable desde el juego con `/configuracionelogios`.

---

## Reglas del sistema

- Cada jugador puede dar **máximo 3 elogios por día** (reset cada 24 horas)
- No podés dar **2 elogios al mismo jugador** en el mismo día
- No podés elogiarte **a vos mismo**
- Cuando un jugador acumula X elogios pendientes → recibe 1 PDR automáticamente y el contador de pendientes se resetea
- X es configurable desde `/configuracionelogios` (admin nivel 15+)

---

## Etapas de desarrollo

### Etapa 1 — SQL ✅ (pendiente ejecutar en DB)
- Crear tabla `elogios`
- Agregar columnas en `accounts`
- Agregar columna en `server_config`

### Etapa 2 — `/elogiar` básico
- Comando `/elogiar [ID]`
- Sin cooldowns todavía
- Guarda en tabla `elogios` y suma `pElogiosPendientes`
- Mensaje al receptor: "X te ha dado un elogio."
- Mensaje al donante: "Le diste un elogio a X."
- **Durante desarrollo:** NO poner restricción `targetid == playerid` para poder testear solo

### Etapa 3 — Validaciones y cooldowns
- No podés elogiarte a vos mismo
- Máximo 3 elogios dados por día
- No podés darle 2 elogios al mismo jugador en el mismo día
- Verificación contra tabla `elogios` con WHERE donante_id y fecha (últimas 24h)

### Etapa 4 — Conversión a PDR
- Al sumar un elogio, verificar si `pElogiosPendientes >= sElogiosPorPDR`
- Si se cumple: `pRolePoints++`, `pElogiosPendientes -= sElogiosPorPDR`, guardar en `role_points`
- Mensaje al jugador: "Tus elogios te han otorgado un Punto de Rol."
- **Comando `/testearelogi [ID] [cantidad]`** (admin 15+) — inyecta elogios directo sin cooldown para testing

### Etapa 5 — `/configuracionelogios`
- Solo admin nivel 15+
- Al ejecutar muestra DOS líneas de advertencia en rojo:
  - `[INFO] Recorda que solo podes modificar los elogios si tenes la autorizacion pertinente.`
  - `[INFO] Asegurate que haya consenso colectivo antes de modificar los elogios; este cambio podria modificar la dinamica de juego de los usuarios.`
- Luego abre un dialog tipo lista con opciones:
  1. 35 elogios = 1 PDR
  2. 60 elogios = 1 PDR
  3. 90 elogios = 1 PDR
  4. 120 elogios = 1 PDR
  5. 150 elogios = 1 PDR
  6. 200 elogios = 1 PDR
  7. Desactivar sistema de elogios
- Al seleccionar, pide confirmación antes de aplicar
- Guarda en DB y actualiza `ServerInfo[sElogiosPorPDR]` en memoria

### Etapa 6 — Sonidos y pulido
- Sonido al recibir un elogio
- Sonido al recibir un PDR por elogios
- Agregar restricción `targetid == playerid` (si no se agregó antes)
- Prueba final con dos jugadores reales (notebook)

---

## Notas de testing

- Durante Etapas 2-4: se puede testear solo porque no hay restricción de elogiarse a uno mismo
- Para probar el cooldown y las validaciones entre jugadores distintos: usar notebook con cuenta separada (no bloquea por IP, solo por misma cuenta)
- `/testearelogi` sirve para probar la conversión a PDR sin esperar acumular elogios manualmente

---

## Pendiente decidir

- Beneficios concretos del PDR expandido (paga en jobs, descuentos, desbloqueos)
- Integración con Discord (requiere plugin `samp-requests` — pendiente instalar en VPS)
- `/rankingpdr` y `/verpdr` publicos para todos los jugadores
