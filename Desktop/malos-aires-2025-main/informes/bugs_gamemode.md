# Bugs del Gamemode

## Bug 1 — Skin cambia después de la cinemática de compra de negocio

**Archivo:** `gamemodes/system/marp_scenes.pwn:757`

**Descripción:**
Al comprar un negocio se reproduce una cinemática (`StartPlayerScene`). Al terminar, la skin del jugador cambia a una incorrecta.

**Causa:**
`SavePlayerStatsForScene` guarda la skin actual con `GetPlayerSkin()` y la pisa en `PlayerInfo[pSkin]`. Durante el toggle de spectating, `GetPlayerSkin()` puede devolver un valor incorrecto (0 u otro). Cuando la cinemática termina y `OnPlayerSpawn` se ejecuta (consecuencia de `TogglePlayerSpectating(false)`), aplica ese valor incorrecto.

**Fix:**
Eliminar la línea:
```pawn
PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
```
de `SavePlayerStatsForScene`. El campo `pSkin` ya está correcto desde que el jugador eligió su skin.

---

## Bug 2 — `/negocioradio` no reproduce para todos los jugadores dentro del negocio

**Archivo:** `gamemodes/business/marp_biz_user.pwn:94-103`

**Descripción:**
Al activar o apagar la radio con `/negocioradio`, el stream solo se actualiza para el jugador que ejecutó el comando. Los demás jugadores que ya estén adentro del negocio no escuchan nada.

**Causa:**
`Radio_Set(playerid, radio, RADIO_TYPE_BIZ)` y `Radio_StopIfOnType(playerid, RADIO_TYPE_BIZ)` se llaman solo con `playerid` (el dueño). No hay broadcast a los demás jugadores dentro.

**Fix:**
Reemplazar las llamadas únicas por un loop:
```pawn
// Al activar
Biz_SetRadio(bizid, radio);
foreach(new i : Player) {
    if(Biz_IsPlayerInsideId(i, bizid))
        Radio_Set(i, radio, RADIO_TYPE_BIZ);
}

// Al apagar
Biz_SetRadio(bizid, 0);
foreach(new i : Player) {
    if(Biz_IsPlayerInsideId(i, bizid))
        Radio_StopIfOnType(i, RADIO_TYPE_BIZ);
}
```
