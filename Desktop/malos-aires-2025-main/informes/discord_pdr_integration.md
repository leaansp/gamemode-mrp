# Integración Discord — PDR y Ranking

## Descripción

Integración del sistema de Puntos de Rol (PDR) con Discord usando el plugin
`samp-discord-connector`. Sin bot externo, todo desde Pawn.

**Canales Discord:**
- `#felicitaciones-pdr` — notificación cada vez que alguien recibe/pierde un PDR
- `#ranking-pdr` — top 10 actualizado en tiempo real

**Eventos que disparan notificaciones:**
- Admin usa `/darpuntoderol`
- Admin usa `/quitarpuntoderol`
- Jugador acumula elogios suficientes (conversión automática en `ElogiarCallback`)

---

## Setup en el VPS (hacer una sola vez)

### 1. Crear el bot de Discord
- https://discord.com/developers/applications → New Application → Bot
- Reset Token → copiar el token
- Activar en "Privileged Gateway Intents":
  - Server Members Intent
  - Message Content Intent
- Invitar al servidor con permisos: `Send Messages`, `Read Messages`, `Manage Messages`

### 2. Crear canales en Discord
- `#felicitaciones-pdr`
- `#ranking-pdr`

### 3. Instalar el plugin en el VPS
```bash
wget https://github.com/maddinat0r/samp-discord-connector/releases/download/v0.3.6/discord-connector-v0.3.6-linux.tar.gz
tar -xzf discord-connector-v0.3.6-linux.tar.gz
cp discord-connector.so ~/malosaires-test/malos-aires-2025/plugins/
```

Agregar a `server.cfg`:
```
plugins discord-connector
```

Configurar el token (variable de entorno en el VPS):
```bash
export DCC_BOT_TOKEN="tu_token_aqui"
```

---

## Plan de código

### Archivo nuevo
`gamemodes/system/marp_discord.pwn`

Funciones a implementar:
- `Discord_Init()` — encuentra los canales por nombre al iniciar el server
- `Discord_NotifyPDR(nombre[], admin[], razon[], total, bool:isGiven)` — embed a #felicitaciones-pdr + anuncio in-game a todos
- `Discord_NotifyPDRElogios(nombre[], total)` — mismo canal, origen elogios
- `Discord_UpdateRanking()` — query top 10 MySQL → manda/edita mensaje en #ranking-pdr

### Archivos a modificar

**`marp_rolepoints.pwn`** — después del update inmediato a DB:
```pawn
// En /darpuntoderol
Discord_NotifyPDR(PlayerInfo[targetid][pName], PlayerInfo[playerid][pName], reason, PlayerInfo[targetid][pRolePoints], true);

// En /quitarpuntoderol
Discord_NotifyPDR(PlayerInfo[targetid][pName], PlayerInfo[playerid][pName], reason, PlayerInfo[targetid][pRolePoints], false);
```

**`marp_elogios.pwn`** — línea 90 (dentro del if de conversión a PDR):
```pawn
Discord_NotifyPDRElogios(PlayerInfo[targetid][pName], PlayerInfo[targetid][pRolePoints]);
```

---

## Dependencias

| Recurso | Link |
|---|---|
| Plugin releases | https://github.com/maddinat0r/samp-discord-connector/releases |
| Ejemplo de uso | https://pastebin.com/4LLMnWXH |
| Include file | `discord-connector.inc` (viene en el release) |

---

## Estado
- [ ] Bot creado en Discord Developer Portal
- [ ] Canales creados en Discord
- [ ] Plugin instalado en VPS
- [ ] Token configurado
- [ ] `marp_discord.pwn` implementado
- [ ] `marp_rolepoints.pwn` modificado
- [ ] `marp_elogios.pwn` modificado
- [ ] Testeado en servidor test
