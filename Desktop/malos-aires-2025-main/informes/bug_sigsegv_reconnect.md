# Bug: SIGSEGV al reconectar — Race condition en async callbacks de login

**Fecha de análisis:** 2026-04-02
**Branch afectado:** Test (GitLab)
**Severidad:** Crítica — crashea el servidor al conectarse jugadores

---

## Síntoma

El servidor crashea con `fatal signal '11' (SIGSEGV)` cuando un jugador se desconecta y reconecta rápidamente. Los jugadores quedan trabados en "joining the game" y reciben "server closed the connection".

---

## Log del crash (Apr 01 23:05:36)

```
[join] santog33 has joined the server (0:24.232.197.53)
[DEBUG] MasterAccount_PopulateForPlayer: masterId=27, idx=26, adminLevel=20
[DEBUG] PopulateForPlayer result=1, masterId=27, accAdminLevel=20, pAdmin=20
[connection] incoming connection: 45.178.1.153:63476 id: 1
[join] China has joined the server (1:45.178.1.153)
[DEBUG] MasterAccount_PopulateForPlayer: masterId=10, idx=9, adminLevel=21
[DEBUG] PopulateForPlayer result=1, masterId=10, accAdminLevel=21, pAdmin=21
[part] Ulysses_Joyce has left the server (1:1)         ← China se desconecta
[connection] incoming connection: 45.178.1.153:59179 id: 1
[join] China has joined the server (1:45.178.1.153)    ← China reconecta
[DEBUG] MasterAccount_PopulateForPlayer: masterId=10, idx=9, adminLevel=21
[DEBUG] PopulateForPlayer result=1, masterId=10, accAdminLevel=21, pAdmin=21
[part] Juan_Gomez has left the server (0:1)            ← santog33 se desconecta
[connection] incoming connection: 24.232.197.53:51266 id: 0
[join] santog33 has joined the server (0:24.232.197.53) ← santog33 reconecta
[DEBUG] MasterAccount_PopulateForPlayer: masterId=27, idx=26, adminLevel=20
[DEBUG] PopulateForPlayer result=1, masterId=27, accAdminLevel=20, pAdmin=20
[DEBUG] MasterAccount_PopulateForPlayer: masterId=27, idx=26, adminLevel=20  ⚠️ SEGUNDA VEZ
[DEBUG] PopulateForPlayer result=1, masterId=27, accAdminLevel=20, pAdmin=20
[part] Ulysses_Joyce has left the server (1:1)
[part] Juan_Gomez has left the server (0:1)
[log-core] fatal signal '11' (SIGSEGV) catched
```

---

## Causa raíz

### Race condition: query async pendiente de una conexión anterior

Cuando santog33 se desconecta (Juan_Gomez parte, id:0) y reconecta inmediatamente, el sistema de login dispara una nueva query async de carga de cuenta. Sin embargo, **la query de la conexión anterior no fue cancelada** — todavía estaba en vuelo en el thread de MySQL.

Ambas queries resuelven y ejecutan `MasterAccount_PopulateForPlayer` para `playerid=0`, como confirma el log (dos ejecuciones consecutivas para `masterId=27`).

```
santog33 conecta (1ra vez)
  → mysql_tquery: SELECT master_account WHERE id=27
  → santog33 se desconecta antes de que el callback resuelva

santog33 reconecta (2da vez, mismo id: 0)
  → mysql_tquery: SELECT master_account WHERE id=27 (segunda query)

[callback 1ra query resuelve] → MasterAccount_PopulateForPlayer(playerid=0)  ← OK aparente
[callback 2da query resuelve] → MasterAccount_PopulateForPlayer(playerid=0)  ← DOBLE ESCRITURA
```

La doble ejecución del callback escribe dos veces sobre las mismas estructuras de datos del jugador (`pPlayerInfo[0]`, arrays de permisos, etc.), dejándolas en estado inconsistente.

### Detonante: desconexión simultánea de ambos jugadores

Inmediatamente después del doble callback, ambos jugadores se desconectan. `OnPlayerDisconnect` corre para `playerid=0` e `id=1` casi simultáneamente. El código de cleanup accede a la memoria corrompida por la doble inicialización → SIGSEGV.

---

## Archivos involucrados

| Archivo | Función | Rol en el bug |
|---|---|---|
| `gamemodes/player/marp_master_account.pwn` | `MasterAccount_PopulateForPlayer` | Se ejecuta dos veces para el mismo playerid |
| `gamemodes/player/marp_master_account.pwn` | Callback de query de login | No cancela queries pendientes al desconectarse |
| `gamemodes/player/marp_player.pwn` | `OnPlayerDisconnect` | Accede a datos corrompidos por la doble inicialización |

---

## Fix necesario

### Opción A: Guard de IsPlayerConnected al inicio del callback (mínimo)

En el callback que ejecuta `MasterAccount_PopulateForPlayer`, agregar como primera línea:

```pawn
// Al inicio del callback async que llama a MasterAccount_PopulateForPlayer:
if(!IsPlayerConnected(playerid)) return;
```

Esto descarta el resultado de queries que resolvieron para un jugador ya desconectado. Es la solución más simple pero **no cubre el caso donde el jugador reconectó con el mismo ID** — el callback de la primera conexión sigue ejecutándose sobre el slot del nuevo jugador.

### Opción B: Session token por conexión (fix completo)

Asignar un token único a cada conexión y verificarlo en el callback:

```pawn
// En OnPlayerConnect:
pLoginToken[playerid] = GetTickCount(); // o un contador incremental

// En la query async de login, pasar el token:
mysql_f_tquery(MYSQL_HANDLE, 64, "OnMasterAccountLoad", "SELECT ... WHERE id=%d", masterId);
// (pasar playerid Y el token como extra params)

// Al inicio del callback:
if(!IsPlayerConnected(playerid)) return;
if(pLoginToken[playerid] != tokenRecibido) return; // conexión vieja, descartar
```

Con esto, si el jugador se reconecta y genera un nuevo token, el callback de la conexión anterior se descarta aunque el playerid sea el mismo.

### Opción C: Resetear el slot en OnPlayerDisconnect

Asegurarse de que `OnPlayerDisconnect` resetea `pLoginToken[playerid] = -1` y que todos los callbacks async verifican que el token sea válido (>= 0) antes de ejecutar.

---

## Cómo confirmar

1. Reproducir conectando dos clientes, desconectando uno rápidamente y reconectando
2. Buscar en el log `MasterAccount_PopulateForPlayer` ejecutándose dos veces para el mismo `masterId`/`playerid`
3. Si aparece doble → bug confirmado

---

## Estado

- [ ] Fix implementado en Test
- [ ] Fix implementado en feature/hotkeys
- [ ] Testeado en local
- [ ] Desplegado a producción

---

## Notas adicionales

- El crash ocurre en el arranque del servidor (23:05:36) porque los jugadores se reconectaron inmediatamente al reinicio, lo que comprimió todas las conexiones/desconexiones en el mismo segundo
- El `reason:1` en los `[part]` indica desconexión voluntaria (quit), no timeout — los jugadores probablemente se desconectaron porque el servidor les cerró la conexión al detectar el estado corrupto o porque el cliente crasheó por el estado inconsistente
- El crashdetect.log no registró este crash porque el SIGSEGV ocurrió antes de que el plugin pudiera capturarlo, o el log no fue flusheado antes del crash
