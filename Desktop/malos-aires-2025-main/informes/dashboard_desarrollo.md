# Dashboard de Desarrollo — Malos Aires RP
**Período:** 23/03/2026 — 02/04/2026 (11 días)
**Ramas:** feature/hotkeys → Test (GitLab) → main (producción)

---

## Resumen ejecutivo

| Métrica | Valor |
|---|---|
| Commits totales | ~48 |
| Features nuevas | 15 |
| Bugs corregidos | 18 |
| Archivos .pwn modificados | 20+ |
| Crashes resueltos | 2 (SIGSEGV doble login + bug vehículos) |
| Sistemas nuevos | 5 (ropero, elogios, /bp, solidchat, hotkeys) |

---

## Línea de tiempo

### 23/03 — Arranque
- Setup del entorno de desarrollo, corrección de encoding Windows-1252 en archivos .pwn, creación de carpeta `informes/`

---

### 24/03 — Sesión grande inicial
- **Hotkeys** — sistema de teclas rápidas para acciones de roleplay
- **Holster mode** — animación/estado de funda de arma
- **Twitter** — sistema de red social in-game
- **Graffitis** — fix de rotación, mejoras generales
- **Cooldown cambio de personaje** — evitar spam de `/cambiarpersonaje`
- **Rebalanceo de precios de vehículos** — primera pasada de ajuste de concesionaria
- **Precios de motos** — ajuste específico por categoría

---

### 25/03
- Fix `/cadera` — aviso cuando se usa por primera vez sin configurar

---

### 26/03
- **Sistema de elogios** — los jugadores pueden recibir elogios que se convierten en PDR (puntos de reputación)
- Fix bug `SaveServerInfo` — `sElogiosPorPDR` se guardaba con valor incorrecto, default ajustado a 35
- Rebalanceo final de precios de autos en concesionaria

---

### 27/03
- Fix encoding en mensajes de acción (teléfono y número)
- **Mostrar cadera en `/revisar` y `/checkinv`** — los admins y jugadores ven el contenido de la cadera al revisar
- Fix color de `/ao` — cambiado a naranja suave para mejor legibilidad
- **`/muteartw` y `/desmuteartw`** — comandos para admins nivel 3+ para silenciar el artway
- Fix `sElogiosPorPDR` — corrección de bug de guardado en DB

---

### 29/03 — Sistema de skins custom
- **Pack skins1, skins2, skins3** — modelos .dff/.txd custom para SA-MP 0.3DL
- **Sistema `/ropero`** — menú de selección de skins custom (IDs 20001–20092)
- Fix artconfig.txt — rango de skins extendido correctamente hasta 20092
- Fix include de `marp_ropero.pwn` en `marp_core.pwn`

---

### 30/03 — Deploy a producción (main)
- Integración de todas las sesiones anteriores a la rama main via cherry-pick
- Sistemas deployados: hotkeys, holster, twitter, elogios, ropero, skins, grafitis, rebalanceo vehículos, muteartw

---

### 31/03
- Fix cooldowns rotos — timer leak al cambiar de personaje dejaba cooldowns activos para siempre
- Fix encoding en `marp_thiefjob` y `marp_toy` — caracteres especiales corrompidos
- Fix formato mensajes de toy — unificado a `[INFO]` con `COLOR_INFO`

---

### 01/04 — Sesión de nuevas features y fixes
- **`/solidchat` mejorado** — colores ampliados (negro, verde, azul, violeta, gris, blanco, amarillo), comando `/solidchat apagar`
- **Sistema `/bp` (botón de pánico)** — exclusivo PMA/GNA/SAME en servicio, icono rojo + secuencia de sonidos, `/finalizarbp` para cancelar
- **`/ref` mejorado** — nombres de facción dinámicos, icono que sigue al jugador, recordatorio cada 3 minutos
- **Pack skins4** — nuevos modelos de personaje (chino1–6, wuzimu, triadb, omyst, suzie, lsv1, lsv2)
- Fix encoding completo en `marp_phone` — mensajes de policía, médica y atención al cliente
- Fix doble icono en `/ref` y `/bp` post-cancelación
- Fix KeyChain al cambiar de personaje — el nuevo personaje heredaba llaves de casas/negocios/vehículos del anterior
- Fix hospital al morir con crack — el jugador iba directo al hospital sin pasar por lecho de muerte; el médico ya puede salvarlo

---

### 02/04 — Fixes críticos de estabilidad
- **Fix bug vehículos Mesa/mar** (bug de alta severidad):
  - `VehTrunk_Reload` siempre recrea el área dinámica del maletero al recrear vehículo
  - `/avfixmodel` detecta desync del slot SA-MP, informa al admin y recrea con el modelo correcto
  - `/avfixallmodels` con Check 1 (desync SA-MP) + Check 2 (VehicleInfo vs DB)
  - Auto scan 60 segundos después del arranque que corrige automáticamente todos los vehículos afectados
  - `IsValidSkin` extendido de 20070 a 20092

- **Fix crash SIGSEGV en reconexión rápida** (bug crítico):
  - Causa: al hacer `/q` y reconectar en menos de ~200ms, dos cadenas de queries async de login corrían en paralelo para el mismo slot, causando doble inicialización de datos del jugador y SIGSEGV al desconectarse
  - Fix: guard `if(gPlayerLogged[playerid]) return 1;` en `OnContinueCharacterLoad`
  - Documentación de revert en `informes/fix_doble_login_revert.md`

---

## Features nuevas (resumen)

| Feature | Fecha | Archivo principal |
|---|---|---|
| Hotkeys | 24/03 | `marp_core.pwn` |
| Holster mode | 24/03 | `marp_core.pwn` |
| Twitter in-game | 24/03 | `marp_core.pwn` |
| Sistema de elogios + PDR | 26/03 | `marp_elogios.pwn` |
| `/ropero` + skins custom (20001–20092) | 29/03 | `marp_ropero.pwn` |
| Skins packs 1, 2, 3 | 29/03 | `models/player/` |
| `/solidchat` colores | 01/04 | `marp_police.pwn` |
| `/bp` botón de pánico | 01/04 | `marp_police.pwn` |
| `/ref` mejorado | 01/04 | `marp_police.pwn` |
| Skins pack 4 | 01/04 | `models/player/` |
| Cadera en `/revisar` | 27/03 | `marp_acmds.pwn` |
| `/muteartw` / `/desmuteartw` | 27/03 | `marp_acmds.pwn` |

---

## Bugs resueltos (resumen)

| Bug | Severidad | Fecha |
|---|---|---|
| SIGSEGV doble login en reconexión rápida | Crítica | 02/04 |
| Vehículos Mesa/mar (desync SA-MP slots) | Alta | 02/04 |
| Maletero roto después de `/avestacionar` | Media | 02/04 |
| Hospital directo al morir con crack | Media | 01/04 |
| KeyChain heredado al cambiar personaje | Media | 01/04 |
| Cooldowns rotos por timer leak | Media | 31/03 |
| Encoding marp_phone (policía, médica) | Baja | 01/04 |
| Encoding marp_thiefjob y marp_toy | Baja | 31/03 |
| Encoding teléfono en mensajes de acción | Baja | 27/03 |
| SaveServerInfo sElogiosPorPDR incorrecto | Baja | 26/03 |
| Doble icono en /ref y /bp | Baja | 01/04 |
| Aviso `/cadera` primera vez | Baja | 25/03 |

---

## Documentación generada

| Archivo | Contenido |
|---|---|
| `informes/bug_vehiculos_mesa_mar.md` | Análisis completo del bug Mesa/mar (4 bugs encadenados, 5 fixes, queries SQL de diagnóstico) |
| `informes/bug_sigsegv_reconnect.md` | Análisis del crash SIGSEGV por reconexión rápida |
| `informes/fix_doble_login_revert.md` | Guía de revert de emergencia + prompt para Claude Code |
| `informes/guia_custom_buildings.md` | Guía para agregar edificios custom y re-texturas |
| `informes/guia_deploy_vps.pdf` | Guía de deploy al VPS |
| `informes/sistema_parrilla.md` | Documentación del sistema de parrilla |
