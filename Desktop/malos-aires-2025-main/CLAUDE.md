# CLAUDE.md — Malos Aires Roleplay (SA-MP 0.3DL)

## Contexto general

Servidor de SA-MP (San Andreas Multiplayer) modo Roleplay. El código está escrito en **Pawn**, un lenguaje tipado estático parecido a C. Los archivos `.pwn` se compilan a `.amx` con sampctl.

## Comandos esenciales

```bash
sampctl build          # Compilar el gamemode (siempre antes de reiniciar)
sampctl run test       # Levantar servidor en modo local (puerto 7779)
sampctl run prod       # Levantar servidor en modo producción
```

El servidor NO lee `.pwn` directamente — lee el `.amx` compilado. Siempre buildear después de editar.

## Estructura del proyecto

```
marp_core.pwn          # Entry point principal del gamemode
marp_database.pwn      # Lógica de conexión y helpers de MySQL
marp_missions.pwn      # Sistema de misiones

gamemodes/
  components/          # Componentes reutilizables
  admin/               # Comandos y lógica de administración
  building/            # Sistema de edificios
  business/            # Sistema de negocios
  container/           # Contenedores
  faction/             # Facciones
  garage/              # Garajes
  house/               # Casas
  item/                # Sistema de items
  job/                 # Trabajos
  map/                 # Mapeo y objetos
  player/              # Lógica del jugador (login, registro, stats)
  system/              # Sistemas generales
  util/                # Utilidades
  vehicle/             # Sistema de vehículos

include/               # Includes propios del proyecto
filterscripts/         # Scripts secundarios cargados aparte
models/                # Modelos custom (.dff/.txd) para SA-MP 0.3DL
database/              # Archivos SQL y db.cfg
plugins/               # DLLs de plugins compilados
dependencies/          # Librerías externas (ver stack)
```

## Stack de dependencias

| Plugin/Lib | Versión | Uso |
|---|---|---|
| SA-MP-MySQL (pBlueG) | R41-4 | Base de datos MySQL |
| samp-streamer-plugin | v2.9.4 | Objetos/pickups/labels dinámicos |
| sscanf | v2.13.8 | Parseo de parámetros en comandos |
| PawnPlus | v1.5.1 | Programación asincrónica en Pawn |
| YSI-Includes | 5.10.0006 | Framework de utilidades (y_hooks, y_commands, etc.) |
| zcmd | latest | Procesador de comandos |
| easyDialog | latest | Wrapper para diálogos |
| crashdetect | 4.19.4 | Debug de crashes |
| cstl | latest | Standard template library para Pawn |

## Base de datos

- Motor: **MySQL** vía XAMPP (local) o servidor remoto (producción)
- Config: `database/db.cfg` (no se versiona en git — cada entorno tiene el suyo)
- Charset: `latin1`
- Handle global: `MYSQL_HANDLE` definido en `marp_database.pwn`
- Helper principal: macro `mysql_f_tquery` para queries con formato

```pawn
// Ejemplo de query con callback
mysql_f_tquery(MYSQL_HANDLE, 256, "OnCargarJugador", "SELECT * FROM accounts WHERE id=%d", playerid);
```

## Convenciones del código

- Callbacks propias siguen el patrón `Sistema_OnEvento` (ej: `Player_OnConnect`, `House_OnLoad`)
- Comandos definidos con `zcmd` o `YCMD` de YSI
- Variables de jugador generalmente en arrays indexados por `playerid`
- Prefijos comunes: `g_` para globales, `p` para campos de jugador en DB, `marp_` para archivos core
- Hash de contraseñas: **Whirlpool** (no MD5)
- Los IDs de modelos custom van de 20000 a 30000 (SA-MP 0.3DL)

## Flujo de login

1. `OnPlayerConnect` → chequeo de ban por IP en tabla `bans`
2. Verificación contra `master_accounts` (cuenta maestra)
3. Login/Registro → carga de datos desde tabla `accounts`
4. Admin level leído desde `master_accounts.admin_level`

## Notas importantes

- **El .sql del repo puede estar desactualizado** — la DB en producción puede tener tablas/columnas extra
- Los archivos `server.cfg` y `db.cfg` tienen configuraciones distintas para `test` y `prod` (definidas en `pawn.json`)
- `dependencies/omp-stdlib/` debe estar **vacía** (conflicto conocido entre OMP y SAMP stdlib)
- Los modelos custom se registran con `AddSimpleModel` en `OnGameModeInit`
- El servidor corre en puerto **7779** en modo test
