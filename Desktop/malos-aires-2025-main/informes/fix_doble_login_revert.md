# Fix: Guard doble login en OnContinueCharacterLoad

**Archivo afectado:** `gamemodes/marp_core.pwn`
**Commit:** `dba5975`
**Severidad si se revierte incorrectamente:** Crítica — SIGSEGV en producción

---

## Qué hace este fix

Agrega dos líneas al inicio de `OnContinueCharacterLoad` en `marp_core.pwn`:

```pawn
if(gPlayerLogged[playerid])
    return 1;
```

Esto previene que el callback de carga de personaje se ejecute dos veces para el mismo jugador cuando hace `/q` y reconecta antes de que terminen las queries async del login anterior.

---

## Cómo revertirlo si falla producción

### Prompt para Claude Code

```
Emergencia: el servidor de producción crashea con SIGSEGV y nadie puede entrar.
Hay que revertir UN fix específico en gamemodes/marp_core.pwn.

Buscá la función `public OnContinueCharacterLoad(playerid)` y eliminá estas dos líneas
que están justo después del `if(!IsPlayerConnected(playerid)) return 1;`:

    if(gPlayerLogged[playerid])
        return 1;

Usá Python en modo binario (rb/wb) para editar el archivo, NO uses el tool Edit.
Después corré sampctl build y confirmá que compiló sin errores.
Luego commiteá solo marp_core.pwn y marp_core.amx con mensaje:
"revert: sacar guard doble login OnContinueCharacterLoad"
Y pusheá a gitlab HEAD:main.
```

---

## Pasos manuales si no hay acceso a Claude Code

1. En el VPS, editar directamente:
```bash
cd /home/ubuntu/malosaires/malos-aires-2025
nano gamemodes/marp_core.pwn
```
Buscar `OnContinueCharacterLoad` y eliminar las dos líneas del guard.

2. Compilar y reiniciar:
```bash
sudo sampctl build
sudo systemctl restart samp-prod
```

---

## Por qué existe este fix

Cuando un jugador hace `/q` y reconecta en menos de ~200ms (mismo ID de slot),
hay dos cadenas de queries async en vuelo para el mismo playerid. Ambas pasan
`IsPlayerConnected` porque el jugador SÍ está conectado (reconectó). Ambas ejecutan
el load completo (ítems, job, containers, etc.) en el mismo slot. La doble
inicialización corrompe la memoria y produce SIGSEGV cuando el jugador se desconecta.

El guard usa `gPlayerLogged` como semáforo: el primer callback termina y setea
`gPlayerLogged[playerid] = 1`, el segundo lo detecta y se descarta.
Funciona porque SA-MP es single-threaded — los callbacks no se ejecutan en paralelo.
