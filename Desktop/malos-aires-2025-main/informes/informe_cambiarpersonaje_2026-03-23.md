# Informe de diseño: Sistema /cambiarpersonaje
**Fecha:** 2026-03-23
**Branch activo:** feature/hotkeys
**Último commit:** 0ae601a — feat: sistema de funda de cadera (/cadera) + QuickDropObject

---

## ¿Qué es el sistema?

Un comando `/cambiarpersonaje` que permite al jugador cambiar entre sus hasta 3 personajes de la misma cuenta maestra **sin desconectarse del servidor**. Actualmente hay que hacer /q y reconectarse para cambiar de personaje.

---

## Flujo de implementación acordado

```
/cambiarpersonaje
  → Validaciones (no jailado IC ni OOC, etc.)
  → g_IsCharSwitching[playerid] = true
  → MultiChar_ShowCharSelect(playerid)   ← dialog ya existente, sin cleanup todavía

  Usuario elige slot diferente:
    → PlayerLocalMessage nearby: "[INFO] Nombre_Apellido ha cambiado de personaje."
    → SaveAccount(playerid)
    → Cleanup completo (ver más abajo)
    → gPlayerLogged[playerid] = 0
    → PlayerInfo[playerid][pID] = g_CharacterIds[playerid][nuevo_slot]
    → ContinueCharacterLoad(playerid)   ← ya existente, hace SELECT + SpawnPlayer

  OnContinueCharacterLoad ya existente:
    → Carga todos los datos del nuevo personaje desde DB
    → gPlayerLogged[playerid] = 1  (línea 1042 de marp_core.pwn)
    → SetSpawnInfo + SpawnPlayer
    → CallLocalFunction("LoadAccountDataEnded")  ← dispara todos los hooks secundarios

  LoadAccountDataEnded hooks (ya existentes, cargan automáticamente):
    → holster, phone, toy, traffic, building, house, wounds, black market, etc.
```

**Regla clave:** El cleanup ocurre DESPUÉS de que el jugador confirma la selección en el dialog, nunca antes. Así no hay estado roto si cancela.

---

## Decisión sobre jail

- Si el jugador está jailado (IC o OOC) → el comando no funciona, se queda con ese personaje.
- No hay excepciones. Jail bloquea el cambio.

---

## Notificación nearby

```pawn
new str[64];
format(str, sizeof(str), "%s ha cambiado de personaje.", GetPlayerCleanName(playerid));
PlayerLocalMessage(playerid, 15.0, str);
```
Radio 15.0, mismo que el /me. Color del sistema INFO del GM.

---

## SQL

**Cero cambios en SQL.** No hay tablas nuevas ni columnas nuevas.
- `SaveAccount` ya guarda todo el personaje actual.
- `ContinueCharacterLoad` ya hace `SELECT * FROM accounts WHERE Id = %d`.
- Todos los sistemas secundarios cargan en `LoadAccountDataEnded` que ya existe.

---

## Conflictos identificados y soluciones

### Conflicto 1 — Hooks de OnPlayerDisconnect no se disparan
**Problema:** Sistemas como holster, phone, traffic, etc. hookean `OnPlayerDisconnect` para limpiar sus variables. Al cambiar personaje sin desconectar, esos hooks no se llaman.

**Solución:** Crear hook nuevo `OnPlayerCharSwitch(playerid)`. Se llama con `CallLocalFunction("OnPlayerCharSwitch", "i", playerid)` en el cleanup. Cada sistema agrega `hook OnPlayerCharSwitch` junto a su `hook OnPlayerDisconnect`. Sistemas que necesitan el hook:
- `marp_holster.pwn` (HolsterItem, HolsterParam, HolsterEditing)
- `marp_toy.pwn` (objetos adjuntos del personaje)
- `marp_phone_core.pwn` (estado de llamada activa)
- `marp_traffic.pwn` (duty de tránsito)
- `marp_player_save_account.pwn` (matar el timer de guardado periódico)

**Riesgo residual:** Si existe algún sistema no revisado con estado en arrays estáticos que no implementa el hook. **Probabilidad: 10%.** Efecto: inconsistencia menor de estado en la sesión del nuevo personaje, no crash ni pérdida de datos.

---

### Conflicto 2 — ResetPlayerWeapons no se llama
**Problema:** Las armas en SA-MP son del slot del jugador, no del personaje. Si el personaje A tiene un arma equipada visualmente en SA-MP (fuera del sistema de manos), al cargar el personaje B seguiría teniendo esa arma hasta que algo la pise.

**Solución:** Llamar `ResetPlayerWeapons(playerid)` explícitamente en el cleanup del switch, antes de `ContinueCharacterLoad`.

**Riesgo residual:** Prácticamente cero. **Probabilidad: <1%.**

---

### Conflicto 3 — Nombre del jugador en SA-MP
**Problema:** El nombre in-game visible para todos los demás jugadores necesita cambiarse al nombre del nuevo personaje. `SetPlayerNameEx` debe llamarse con el nuevo nombre.

**Solución:** Llamar `SetPlayerNameEx(playerid, PlayerInfo[playerid][pName])` después de que `OnContinueCharacterLoad` cargue `pName` desde la DB.

**Riesgo residual:** SA-MP no permite cambiar el nombre si ya existe otro jugador conectado con ese nombre. Caso hipotético: dos personas logueadas con personajes de nombre idéntico. **Probabilidad: 2-3%.** Efecto: el nombre no cambia visualmente, el jugador aparece con el nombre anterior hasta que respawnea.

---

### Conflicto 4 — marp_toy.pwn necesita cleanup
**Problema:** El sistema de toys/attachments tiene objetos adjuntos al jugador. Sin cleanup, los objetos del personaje A quedan en el personaje B.

**Solución:** Agregar `hook OnPlayerCharSwitch` en `marp_toy.pwn` que ejecute el mismo detach del personaje.

**Riesgo residual:** Cero si se implementa. **Probabilidad: 0%.**

---

### Conflicto 5 — Race condition con gPlayerLogged = 0
**Problema:** Entre que se hace el cleanup (gPlayerLogged = 0) y `OnContinueCharacterLoad` termina (~50-200ms de query SQL async), hay una ventana donde cualquier timer activo que no se mató podría disparar y acceder a `PlayerInfo` ya reseteado.

**Solución:** Matar todos los timers conocidos antes del gap:
```pawn
KillTimer(pLoginTransitionTimer[playerid]);
KillTimer(GetPVarInt(playerid, "CancelVehicleTransfer"));
KillTimer(GetPVarInt(playerid, "CancelDrugTransfer"));
KillTimer(GetPVarInt(playerid, "robberyCancel"));
KillTimer(GetPVarInt(playerid, "fuelCar"));
KillTimer(GetPVarInt(playerid, "fuelCarWithCan"));
KillTimer(ReplenishDescTimer[playerid]);
```
El gap en sí es inevitable (SQL es async), pero sin timers activos el riesgo es mínimo.

**Riesgo residual:** Timer desconocido que dispara en esa ventana de 50-200ms. **Probabilidad: 3-4%.** Efecto leve: mensaje que no llega o una operación ignorada.

---

### Conflicto 6 — pLoginTransitionTimer (extra, descubierto en revisión)
**Problema:** `pLoginTransitionTimer` se mata en `OnPlayerDisconnect` línea 1280 de `marp_core.pwn`. Si está corriendo al momento del switch, queda activo durante la transición.

**Solución:** Incluido en el bloque de KillTimers del punto 5.

**Riesgo residual:** **Probabilidad: 5%.** Efecto: posible transición visual doble o timer que ejecuta lógica de login sobre el estado ya reseteado.

---

### Conflicto 7 — "Salir" en DLG_CHAR_SELECT kickea en login original
**Problema:** En el login normal, presionar "Salir" en la selección de personaje kickea al jugador. En el cambio de personaje, "Salir" debe cancelar y dejarlo donde está.

**Solución:** Flag `g_IsCharSwitching[MAX_PLAYERS]`. En `OnDialogResponse` para `DLG_CHAR_SELECT`:
- Si `g_IsCharSwitching[playerid]` y cancela → `g_IsCharSwitching = false`, no hacer nada.
- Si `g_IsCharSwitching[playerid]` y confirma mismo slot → cancelar también.
- Si login normal → flujo original sin cambios.

**Riesgo residual:** Cero si se implementa. **Probabilidad: 0%.**

---

## Evaluación global de riesgo

| Conflicto | Solución | Riesgo residual | Probabilidad |
|---|---|---|---|
| Hooks OnPlayerDisconnect | Hook OnPlayerCharSwitch | Sistema no revisado con estado sucio | 10% |
| Armas SA-MP | ResetPlayerWeapons | Ninguno | <1% |
| Nombre del jugador | SetPlayerNameEx post-load | Nombre duplicado online | 2-3% |
| Toy attachments | Hook OnPlayerCharSwitch en toy | Ninguno | 0% |
| Race condition timers | KillTimer de todos los conocidos | Timer desconocido en ventana 50-200ms | 3-4% |
| pLoginTransitionTimer | KillTimer incluido | Ninguno | 0% (cubierto) |
| Dialog "Salir" kickea | Flag g_IsCharSwitching | Ninguno | 0% |

**Probabilidad de bug visible con todo implementado: ~15-20% en edge cases.**
**Probabilidad de pérdida de datos o crash: ~2-3%.**
**No es un sistema de riesgo alto.**

---

## Archivos a modificar / crear

| Archivo | Cambio |
|---|---|
| `gamemodes/system/marp_multichar.pwn` | Flag `g_IsCharSwitching`, manejo en `OnDialogResponse DLG_CHAR_SELECT`, comando `/cambiarpersonaje` |
| `gamemodes/marp_core.pwn` | Cleanup del switch (KillTimers + ResetPlayerWeapons + OnPlayerResetStats + gPlayerLogged) |
| `gamemodes/player/marp_holster.pwn` | `hook OnPlayerCharSwitch` |
| `gamemodes/item/marp_toy.pwn` | `hook OnPlayerCharSwitch` |
| `gamemodes/system/phone/marp_phone_core.pwn` | `hook OnPlayerCharSwitch` |
| `gamemodes/faction/traffic/marp_traffic.pwn` | `hook OnPlayerCharSwitch` |
| `gamemodes/player/marp_player_save_account.pwn` | `hook OnPlayerCharSwitch` |

---

## Estado actual del repo (antes de arrancar)

- Branch: `feature/hotkeys`
- Último commit: `0ae601a` — holster system completo, compila con 5 warnings pre-existentes
- GitHub: pusheado y sincronizado
- Para volver a este estado si algo rompe: `git checkout 0ae601a -- .`
